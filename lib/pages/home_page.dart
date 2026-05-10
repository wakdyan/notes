import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_page.dart';
import '../core/constants/app_sizes.dart';
import '../core/extensions/context_theme.dart';
import '../models/note.dart';
import '../providers/home_provider.dart';
import '../states/request_state.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final provider = context.read<HomeProvider>();

    Future.microtask(() {
      provider.watchConnection();
      provider.watchNotes();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () => onSignOutPressed(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (_, provider, _) {
          if (!provider.hasConnection) {
            return ErrorView(message: 'No connection available');
          }

          if (provider.state == RequestState.loading) {
            return LoadingView();
          } else if (provider.state == RequestState.error) {
            return ErrorView(message: provider.errorMessage);
          } else {
            return buildLoadedView(context, provider.notes);
          }
        },
      ),
      floatingActionButton: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Visibility(
            visible: provider.notes.isNotEmpty && provider.hasConnection,
            child: FloatingActionButton.extended(
              onPressed: () => navigateToAddNotesPage(context),
              icon: const Icon(Icons.add),
              label: const Text('Add note'),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoadedView(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return buildEmptyView(context);
    } else {
      return buildListView(notes);
    }
  }

  Widget buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const Text('There is no note'),
          const Text('Please tap button below to add note'),
          SizedBox(height: AppSizes.p16),
          FilledButton(
            onPressed: () => navigateToAddNotesPage(context),
            child: const Text('Add note'),
          ),
        ],
      ),
    );
  }

  Widget buildListView(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Dismissible(
          key: Key(note.id),
          background: Container(
            color: context.colorScheme.error,
            child: Icon(Icons.delete, color: context.colorScheme.onError),
          ),
          secondaryBackground: Container(
            color: context.colorScheme.error,
            child: Icon(Icons.delete, color: context.colorScheme.onError),
          ),
          onDismissed: (_) => onNoteDeleted(context, note.id),
          child: ListTile(
            onTap: () => navigateToDetailPage(context, note),
            title: Text(note.title),
            subtitle: Text(note.content, maxLines: 1, overflow: .ellipsis),
          ),
        );
      },
    );
  }

  void navigateToDetailPage(BuildContext context, Note note) {
    Navigator.pushNamed(context, AppRoutes.detail, arguments: note);
  }

  void navigateToAddNotesPage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addNote);
  }

  void onSignOutPressed(BuildContext context) {
    final provider = context.read<HomeProvider>();

    provider.signOut();
  }

  void onNoteDeleted(BuildContext context, String id) {
    final provider = context.read<HomeProvider>();

    provider.removeNote(id);
  }
}
