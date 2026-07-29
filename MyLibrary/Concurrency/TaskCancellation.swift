//
//  TaskCancellationExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 29/07/2026.
//

import SwiftUI

struct TaskCancellationExampleDataProvider {
    // Cancellation is cooperative: Task.cancel() only flips a flag on the task. A loop that never
    // reads that flag has no idea it happened, so it runs to completion regardless.

    func countIgnoringCancellation() async -> [Int] {
        var values: [Int] = []
        for value in 1 ... 10 {
            await delayWithNoIdeaAboutCancellation(seconds: 0.5)
            values.append(value)
        }
        return values
    }

    private func delayWithNoIdeaAboutCancellation(seconds: Double) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                continuation.resume()
            }
        }
    }

    // Same loop, but Task.checkCancellation() throws CancellationError the moment cancellation is
    // observed, unwinding immediately instead of finishing the remaining iterations.
    func countCheckingCancellation() async throws -> [Int] {
        var values: [Int] = []
        for value in 1 ... 10 {
            try Task.checkCancellation()
            try await Task.sleep(for: .seconds(0.5))
            values.append(value)
        }
        return values
    }

    // URLSessionDataTask knows nothing about Swift's Task cancellation — it's a separate,
    // non-cooperative API. withTaskCancellationHandler bridges the two: onCancel fires as soon as
    // the surrounding Task is cancelled (even before `operation` starts, or from another thread),
    // so the in-flight network request is actually torn down instead of continuing in the background.
    func downloadCancellably(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let sessionTask = URLSessionTaskBox()

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let task = URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: error ?? URLError(.unknown))
                    }
                }
                sessionTask.task = task
                task.resume()
            }
        } onCancel: {
            sessionTask.task?.cancel()
        }
    }
}

// URLSessionTask isn't Sendable, so it can't be captured directly inside onCancel's @Sendable
// closure; boxing it in a final class lets both closures share the same reference.
private final class URLSessionTaskBox: @unchecked Sendable {
    var task: URLSessionDataTask?
}

@MainActor
class TaskCancellationExampleViewModel: ObservableObject {
    @Published private(set) var uncooperativeStatus = "Not started"
    @Published private(set) var cooperativeStatus = "Not started"
    @Published private(set) var downloadStatus = "Not started"
    @Published private(set) var downloadedImage: UIImage?

    // Drives which button is enabled: Start only makes sense while idle, Cancel only while a task
    // is actually in flight — otherwise "cancel" is either a no-op or, worse, misleading.
    @Published private(set) var isUncooperativeRunning = false
    @Published private(set) var isCooperativeRunning = false
    @Published private(set) var isDownloading = false

    private let dataProvider = TaskCancellationExampleDataProvider()
    private var uncooperativeTask: Task<Void, Never>?
    private var cooperativeTask: Task<Void, Never>?
    private var downloadTask: Task<Void, Never>?

    func startUncooperative() {
        isUncooperativeRunning = true
        uncooperativeStatus = "Running…"
        uncooperativeTask = Task {
            let values = await dataProvider.countIgnoringCancellation()
            uncooperativeStatus = "Finished anyway: \(values)"
            isUncooperativeRunning = false
        }
    }

    func cancelUncooperative() {
        uncooperativeStatus = "Cancel requested, but the loop can't see it…"
        uncooperativeTask?.cancel()
    }

    func startCooperative() {
        isCooperativeRunning = true
        cooperativeStatus = "Running…"
        cooperativeTask = Task {
            do {
                let values = try await dataProvider.countCheckingCancellation()
                cooperativeStatus = "Finished: \(values)"
            } catch {
                cooperativeStatus = "Cancelled early"
            }
            isCooperativeRunning = false
        }
    }

    func cancelCooperative() {
        cooperativeTask?.cancel()
    }

    func startDownload() {
        isDownloading = true
        downloadStatus = "Downloading…"
        downloadedImage = nil
        downloadTask = Task {
            do {
                let data = try await dataProvider.downloadCancellably(from: "https://picsum.photos/2000")
                downloadedImage = UIImage(data: data)
                downloadStatus = "Downloaded \(data.count) bytes"
            } catch {
                downloadStatus = "Download cancelled"
            }
            isDownloading = false
        }
    }

    func cancelDownload() {
        downloadTask?.cancel()
    }
}

struct TaskCancellationExample: View {
    @StateObject private var viewModel = TaskCancellationExampleViewModel()

    var body: some View {
        Form {
            Section("Ignores cancellation") {
                Text(viewModel.uncooperativeStatus)
                HStack {
                    Button("Start") { viewModel.startUncooperative() }
                        .buttonStyle(.bordered)
                        .disabled(viewModel.isUncooperativeRunning)
                    Button("Cancel") { viewModel.cancelUncooperative() }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isUncooperativeRunning)
                }
            }

            Section("Checks Task.checkCancellation()") {
                Text(viewModel.cooperativeStatus)
                HStack {
                    Button("Start") { viewModel.startCooperative() }
                        .buttonStyle(.bordered)
                        .disabled(viewModel.isCooperativeRunning)
                    Button("Cancel") { viewModel.cancelCooperative() }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isCooperativeRunning)
                }
            }

            Section("Cancels underlying URLSessionTask") {
                Text(viewModel.downloadStatus)
                if let image = viewModel.downloadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                HStack {
                    Button("Start") { viewModel.startDownload() }
                        .buttonStyle(.bordered)
                        .disabled(viewModel.isDownloading)
                    Button("Cancel") { viewModel.cancelDownload() }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isDownloading)
                }
            }
        }
        .navigationTitle("Task Cancellation")
    }
}

#Preview {
    TaskCancellationExample()
}
