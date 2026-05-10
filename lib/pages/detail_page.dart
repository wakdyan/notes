import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_sizes.dart';
import '../core/validators/note_validator.dart';
import '../models/note.dart';
import '../providers/detail_provider.dart';
import '../states/request_state.dart';
import '../widgets/loading_view.dart';

part '../widgets/detail_view.dart';

class DetailPage extends StatelessWidget {
  final Note note;

  const DetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailProvider>(
      builder: (_, provider, _) {
        return Stack(
          children: [
            _DetailView(note: note, callback: _saveNote),
            if (provider.state == RequestState.loading) ...[
              ModalBarrier(dismissible: false, color: Colors.black26),
              LoadingView(),
            ],
          ],
        );
      },
    );
  }

  Future<void> _saveNote(BuildContext context, Note note) async {
    final provider = context.read<DetailProvider>();

    await provider.saveNote(note);

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
