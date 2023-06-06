class Presentation {
  final String title;
  final String filePath;

  Presentation({required this.title, required this.filePath});

  /*-NXFX-ofC_k9BK4Mg73C
      file_path: "https://firebasestorage.googleapis.com/v0/b/zoom-lite-8c2e5.appspot.com/o/presentations%2FTest?alt=media&token=b96bf119-3428-49cb-a8b4-ad2326165160"
      title: "Test"
  */
  factory Presentation.fromRTDB(Map<String, dynamic> data) {
    return Presentation(
      title: data['title'],
      filePath: data['file_path'],
    );
  }
}