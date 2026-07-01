//
//  ContentView.swift
//  DrawingApp
//
//  Created by Reginald Grant on 6/30/26.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var canvasView = PKCanvasView() // blank space to draw and save data
    @State private var toolPicker = PKToolPicker() // tool picker to select the tool to draw with

    var body: some View {
        NavigationView {
            VStack {
                CanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
                    .navigationTitle("Drawing App")
                    .navigationBarItems(
                        leading: HStack {
                            Button(action: clearCanvas) {
                                Label("Clear", systemImage: "trash")
                            }
                            .keyboardShortcut("K", modifiers: .command)
                        }, trailing: HStack {
                            Button(action: undo) {
                                Label("Undo", systemImage: "arrow.uturn.forward")
                            }
                            .keyboardShortcut("z", modifiers: .command)

                            Button(action: redo) {
                                Label("Redo", systemImage: "arrow.uturn.forward")
                            }
                            .keyboardShortcut("r", modifiers: .command)
                        }

                    )
                    .onAppear(perform: setuptoolPicker)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationViewStyle(StackNavigationViewStyle())

            }
        }
    }

    func setuptoolPicker(){
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
    func clearCanvas() {
        canvasView.drawing = PKDrawing()
    }
    func undo() {
        canvasView.undoManager?.undo()
    }
    func redo() {
        canvasView.undoManager?.redo()
    }
}

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker

    func makeUIView(context: Context) -> PKCanvasView {
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            canvasView.allowsFingerDrawing = true
            return canvasView
        }
        canvasView.delegate = context.coordinator
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView

        init(_ parent: CanvasView) {
            self.parent = parent
        }
    }
}
