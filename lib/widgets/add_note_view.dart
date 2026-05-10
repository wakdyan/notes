part of '../pages/add_note_page.dart';

class _AddNoteView extends StatefulWidget {
  final Function(BuildContext, String, String) callback;

  const _AddNoteView({required this.callback});

  @override
  State<_AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<_AddNoteView> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  bool get titleIsNotEmpty => titleController.text.isNotEmpty;

  bool get contentIsNoteEmpty => contentController.text.isNotEmpty;

  @override
  void initState() {
    titleController = TextEditingController();
    contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: titleIsNotEmpty && contentIsNoteEmpty
                ? onSavePressed
                : null,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p8),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              keyboardType: .text,
              onChanged: onChange,
              decoration: InputDecoration(
                label: Text('Title'),
                filled: false,
                isDense: true,
                border: OutlineInputBorder(borderSide: .new()),
              ),
            ),
            SizedBox(height: AppSizes.p24),
            TextFormField(
              controller: contentController,
              keyboardType: .text,
              maxLines: 5,
              onChanged: onChange,
              decoration: InputDecoration(
                label: Text('Content'),
                filled: false,
                isDense: true,
                border: OutlineInputBorder(borderSide: .new()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSavePressed() {
    widget.callback(
      context,
      titleController.text.trim(),
      contentController.text.trim(),
    );
  }

  void onChange(String value) => setState(() {});
}
