import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_sizes.dart';
import '../providers/add_note_provider.dart';
import '../states/request_state.dart';
import '../widgets/loading_view.dart';

part '../widgets/add_note_view.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNoteProvider>(
      builder: (_, provider, child) {
        return Stack(
          children: [
            child!,
            if (provider.state == RequestState.loading) ...[
              ModalBarrier(dismissible: false, color: Colors.black26),
              LoadingView(),
            ],
          ],
        );
      },
      child: _AddNoteView(callback: saveNote),
    );
  }

  Future<void> saveNote(
    BuildContext context,
    String title,
    String content,
  ) async {
    final provider = context.read<AddNoteProvider>();

    await provider.saveNote(title: title, content: content);

    if (context.mounted) {
      if (provider.state == RequestState.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
      } else {
        Navigator.pop(context);
      }
    }
  }
}
