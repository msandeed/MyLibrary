//
//  MusicQueueView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

/// The "Up Next" queue, presented as a sheet. Reorder by dragging, swipe to remove.
@available(iOS 27, *)
struct MusicQueueView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    @ObservedObject var viewModel: MusicLibraryViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.output.queue.isEmpty {
                    ContentUnavailableView("Nothing Up Next",
                                           systemImage: "music.note.list",
                                           description: Text("Swipe right on a song in any playlist to add it here."))
                } else {
                    queue
                }
            }
            .navigationTitle("Up Next")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        coordinator.dismissSheet()
                    }
                }
            }
        }
    }
    
    private var queue: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.output.queue) { track in
                    MusicTrackRow(track: track)
                        .clipShape(.rect(cornerRadius: 14))
                        // Keep the rounded card shape while the row is lifted for reordering.
                        .contentShape(.dragPreview, .rect(cornerRadius: 14))
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.input.removeFromQueue.send(track.id)
                            } label: {
                                Label("Remove", systemImage: "minus.circle")
                            }
                        }
                }
                .reorderable()
            }
            .reorderContainer(for: MusicLibrary.TrackViewModel.self) { difference in
                viewModel.input.moveQueue.send(difference)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        // Grouped background so the white rows read as separate cards.
        .background(Color(.systemGroupedBackground))
        .swipeActionsContainer()
    }
}
