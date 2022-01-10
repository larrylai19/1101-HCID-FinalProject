//
//  ImagePicker.swift
//  HelloImagePicker
//
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?
    @Binding var isSourceTypeAlbum: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if !isSourceTypeAlbum{
            picker.sourceType = .camera
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @Binding var presentationMode: PresentationMode
    @Binding var image: Image?

    init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
        _presentationMode = presentationMode
        _image = image
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        presentationMode.dismiss()

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentationMode.dismiss()
    }

}
