part of '../pages/detail_page.dart';

class _DetailView extends StatefulWidget {
  final Note note;
  final Function(BuildContext context, Note note) callback;

  const _DetailView({required this.note, required this.callback});

  @override
  State<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;
  late final TextEditingController contentController;

  bool get titleHasChange => widget.note.title != titleController.text;

  bool get contentHasChange => widget.note.content != contentController.text;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
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
            onPressed: titleHasChange || contentHasChange ? saveNote : null,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p8),
        child: Form(
          key: formKey,
          onChanged: () => setState(() {}),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              TextFormField(
                enabled: false,
                initialValue: widget.note.id,
                decoration: InputDecoration(
                  label: Text('ID'),
                  filled: false,
                  isDense: true,
                  border: OutlineInputBorder(borderSide: .new()),
                ),
              ),
              SizedBox(height: AppSizes.p24),
              TextFormField(
                controller: titleController,
                keyboardType: .text,
                validator: NoteValidator.textValidator,
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
                validator: NoteValidator.textValidator,
                decoration: InputDecoration(
                  label: Text('Content'),
                  filled: false,
                  isDense: true,
                  border: OutlineInputBorder(borderSide: .new()),
                ),
              ),
              SizedBox(height: AppSizes.p24),
              TextFormField(
                enabled: false,
                initialValue: widget.note.createdAt.toString(),
                decoration: InputDecoration(
                  label: Text('Created At'),
                  filled: false,
                  isDense: true,
                  border: OutlineInputBorder(borderSide: .new()),
                ),
              ),
              SizedBox(height: AppSizes.p24),
              TextFormField(
                readOnly: true,
                enabled: false,
                initialValue: widget.note.updatedAt.toString(),
                decoration: InputDecoration(
                  label: Text('Updated At'),
                  filled: false,
                  isDense: true,
                  border: OutlineInputBorder(borderSide: .new()),
                ),
              ),
              SizedBox(height: AppSizes.p24),
              TextFormField(
                enabled: false,
                initialValue: widget.note.userID,
                decoration: InputDecoration(
                  label: Text('User ID'),
                  filled: false,
                  isDense: true,
                  border: OutlineInputBorder(borderSide: .new()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveNote() {
    if (formKey.currentState!.validate()) {
      final updatedNote = widget.note.copyWith(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        updatedAt: DateTime.now(),
      );
      widget.callback(context, updatedNote);
    }
  }
}
