import 'package:amazonclone/models/document_model.dart';
import 'package:amazonclone/models/error_model.dart';
import 'package:amazonclone/repository/auth_repository.dart';
import 'package:amazonclone/repository/document_repository.dart';
import 'package:amazonclone/utils/colors.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');

  final quil.QuillController _controller = quil.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref
        .read(documentRepositoryProvier)
        .getDocumentById(ref.read(userProvider)!.token, widget.id);

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvier).updateTitle(
        token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text('share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                ),
              ),
            )
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/docs-logo.png',
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: blueColor,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(),
                    ),
                    onSubmitted: (value) => updateTitle(ref, value),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: whiteColor,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: greyColor, width: 0.1),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              quil.QuillToolbar.basic(controller: _controller),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: whiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quil.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
