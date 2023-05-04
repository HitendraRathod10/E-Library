import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//ignore: must_be_immutable
class ReadPdfScreen extends StatefulWidget {

  String url;

  ReadPdfScreen({Key? key,required this.url}) : super(key: key);

  @override
  State<ReadPdfScreen> createState() => _ReadPdfScreenState();
}

class _ReadPdfScreenState extends State<ReadPdfScreen> {

  void showErrorDialog(BuildContext context, String error, String description) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(error),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    PdfViewerController pdfViewerController = PdfViewerController();
    debugPrint(widget.url);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.black38,
            ),
            onPressed: () {
              pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black38,
            ),
            onPressed: () {
              pdfViewerController.nextPage();
            },
          ),
        ],
      ),
      
      body: widget.url == '' ? const Center(child: CircularProgressIndicator(strokeWidth: 4,color: Colors.indigo)) :
      SfPdfViewer.network(
          scrollDirection : PdfScrollDirection.vertical,
          //pageLayoutMode : PdfPageLayoutMode.single,
          widget.url.toString(),
          //canShowPaginationDialog: false,
          controller: pdfViewerController,
          enableHyperlinkNavigation: true,
          canShowHyperlinkDialog: true,
          interactionMode: PdfInteractionMode.selection,
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            showErrorDialog(context, details.error, details.description);
          },
      ),
    );
  }
}
