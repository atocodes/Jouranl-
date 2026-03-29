import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/data/models/journal_entry.dart';
import 'package:journal/features/journal/bloc/journal_bloc.dart';
import 'package:journal/features/journal/bloc/journal_event.dart';
import 'package:journal/features/journal/bloc/journal_state.dart';
import 'package:journal/features/journal/widgets/journal_form.dart';
import 'package:journal/features/journal/widgets/journal_metas.dart';

class MinimalJournalEditorPage extends StatefulWidget {
  final JournalEntity? journal;

  const MinimalJournalEditorPage({this.journal, super.key});

  @override
  State<MinimalJournalEditorPage> createState() =>
      _MinimalJournalEditorPageState();
}

class _MinimalJournalEditorPageState extends State<MinimalJournalEditorPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  String? _selectedMood;

  final List<String> moods = ['Happy', 'Sad', 'Neutral', 'Angry'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal?.title ?? '');
    _contentController = TextEditingController(
      text: widget.journal?.content ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.journal?.tags?.join(', ') ?? '',
    );
    _selectedMood = widget.journal?.mood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveJournal() {
    if (!_formKey.currentState!.validate()) return;

    context.read<JournalBloc>().add(
      widget.journal != null
          ? UpdateJournal(
              JournalEntity(
                id: widget.journal?.id ?? 0,
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
                tags: _tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                mood: _selectedMood,
                isPosted: widget.journal?.isPosted ?? false,
                createdAt: widget.journal?.createdAt ?? DateTime.now(),
              ),
            )
          : CreateJournal(
              _titleController.text.trim(),
              _contentController.text.trim(),
            ),
    );
  }

  void _summrizeAndPost() {
    if (widget.journal != null) {
      context.read<JournalBloc>().add(SummarizeAndPost(widget.journal!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<JournalBloc, JournalState>(
      listener: (context, state) {
        if (state is JournalCreated ||
            state is JournalUpdated ||
            state is SummarizedJournalPosted) {
          Navigator.pop(context);
          context.read<JournalBloc>().add(GetJournals());
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Journal Created")));
        }
        if (state is JournalError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Something Wrong")));
        }
        if (state is SummarizingJournal) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Summarizing Journal")));
        }
        if (state is PostingSummarizedJournal) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Posting Summarized Journal")));
        }
        if (state is SummarizedJournalPosted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Summarized Journal Posted")));
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.journal == null ? 'New Journal' : 'Edit Journal'),
          actions: [
            if (widget.journal != null)
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _summrizeAndPost,
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: JournalFormSection(
                    titleController: _titleController,
                    contentController: _contentController,
                  ),
                ),

                /// 🔹 META (only for edit)
                if (widget.journal != null) ...[
                  const SizedBox(height: 16),
                  JournalMetaSection(
                    journal: widget.journal!,
                    tagsController: _tagsController,
                    // selectedMood: _selectedMood,
                    // moods: moods,
                    onMoodChanged: (mood) {
                      setState(() => _selectedMood = mood);
                    },
                  ),
                ],

                const SizedBox(height: 24),

                /// 🔹 SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveJournal,
                    child: const Text("Save"),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
