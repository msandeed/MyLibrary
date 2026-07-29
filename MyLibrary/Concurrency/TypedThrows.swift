//
//  TypedThrowsExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 30/07/2026.
//

import SwiftUI

enum ImageDownloadError: Error {
    case invalidURL
    case transportFailure(URLError)
    case invalidImageData
}

struct TypedThrowsExampleDataProvider {
    // Untyped throws: the signature only promises "something Error-conforming might be thrown".
    // Callers can't tell from the type alone that ImageDownloadError is the only thing that
    // ever comes out of here — that fact lives in a comment, not in the compiler's ledger.
    //
    // This version has a realistic bug: it forgets to catch and re-wrap URLSession's URLError
    // into ImageDownloadError. Untyped `throws` doesn't care — a raw URLError satisfies `throws`
    // just as well as ImageDownloadError does, so this compiles without complaint. Compare to
    // downloadImageTyped below, where the same omission is a compile error, not a latent bug.
    func downloadImageUntyped(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageDownloadError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageDownloadError.invalidImageData
        }
        return image
    }

    // Typed throws: `throws(ImageDownloadError)` makes the closed set part of the function's
    // type. Every throw site must produce an ImageDownloadError, so URLSession's untyped
    // `throws` has to be caught and re-boxed here — the compiler won't let a stray Error escape.
    func downloadImageTyped(from urlString: String) async throws(ImageDownloadError) -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageDownloadError.invalidURL
        }
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: url)
        } catch let urlError as URLError {
            throw ImageDownloadError.transportFailure(urlError)
        } catch {
            // URLSession.data(from:) only ever throws URLError in practice, but its own
            // signature is untyped `throws` and can't express that. Typed throws forces this
            // catch-all to exist so no unnormalized error can leave the function.
            throw ImageDownloadError.transportFailure(URLError(.unknown))
        }
        guard let image = UIImage(data: data) else {
            throw ImageDownloadError.invalidImageData
        }
        return image
    }
}

enum DownloadScenario: String, CaseIterable, Identifiable {
    case valid = "Valid URL"
    case malformed = "Malformed URL"
    case unreachable = "Unreachable host"

    var id: String { rawValue }

    var urlString: String {
        switch self {
        case .valid: "https://picsum.photos/300"
        case .malformed: "not a url"
        case .unreachable: "https://this-host-does-not-exist.invalid"
        }
    }
}

@MainActor
class TypedThrowsExampleViewModel: ObservableObject {
    @Published var scenario: DownloadScenario = .valid
    @Published private(set) var untypedStatus = "Not started"
    @Published private(set) var typedStatus = "Not started"
    @Published private(set) var image: UIImage?

    private let dataProvider = TypedThrowsExampleDataProvider()

    func runUntyped() async {
        untypedStatus = "Downloading…"
        do {
            image = try await dataProvider.downloadImageUntyped(from: scenario.urlString)
            untypedStatus = "Success"
        } catch let error as ImageDownloadError {
            // The `as?`-style cast is needed here only because we, the caller, happen to know
            // ImageDownloadError is the sole thing thrown — the untyped signature doesn't say so.
            untypedStatus = describe(error)
        } catch {
            // This is where the untyped provider's bug surfaces: a raw URLError (from the
            // missing catch-and-rewrap above) lands here instead of in the ImageDownloadError
            // case above, producing a rawer, less friendly message than the typed side gives
            // for the exact same failure.
            untypedStatus = "Unknown error: \(error)"
        }
    }

    func runTyped() async {
        typedStatus = "Downloading…"
        do {
            image = try await dataProvider.downloadImageTyped(from: scenario.urlString)
            typedStatus = "Success"
        } catch {
            // `error` is statically ImageDownloadError here — no cast, and describe(_:)'s switch
            // below is exhaustive with no `default:` needed.
            typedStatus = describe(error)
        }
    }

    private func describe(_ error: ImageDownloadError) -> String {
        switch error {
        case .invalidURL:
            "Invalid URL"
        case .transportFailure(let urlError):
            "Transport failure: \(urlError.localizedDescription)"
        case .invalidImageData:
            "Server responded but data wasn't a valid image"
        }
    }
}

struct TypedThrowsExample: View {
    @StateObject private var viewModel = TypedThrowsExampleViewModel()

    var body: some View {
        Form {
            Section("Scenario") {
                Picker("URL", selection: $viewModel.scenario) {
                    ForEach(DownloadScenario.allCases) { scenario in
                        Text(scenario.rawValue).tag(scenario)
                    }
                }
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
            }

            Section("Untyped throws") {
                Text(viewModel.untypedStatus)
                Button("Run") { Task { await viewModel.runUntyped() } }
                    .buttonStyle(.bordered)
            }

            Section("Typed throws(ImageDownloadError)") {
                Text(viewModel.typedStatus)
                Button("Run") { Task { await viewModel.runTyped() } }
                    .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Typed Throws")
    }
}

#Preview {
    TypedThrowsExample()
}
