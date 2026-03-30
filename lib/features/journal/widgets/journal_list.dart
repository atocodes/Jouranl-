import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal/features/journal/bloc/journal_bloc.dart';
import 'package:journal/features/journal/bloc/journal_event.dart';
import 'package:journal/features/journal/bloc/journal_state.dart';
import 'package:journal/features/journal/widgets/journal_card.dart';

class JournalListSection extends StatelessWidget {
  final bool? isAutoPost;
  const JournalListSection( {super.key,this.isAutoPost});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Your Journals", style: theme.textTheme.titleMedium),
          ),

          const SizedBox(height: 8),

          /// 🔹 LIST
          Expanded(
            child: BlocConsumer<JournalBloc, JournalState>(
              listener: (context, state) {
                if (state is JournalUpdated ||
                    state is JournalRemoved ||
                    state is JournalCreated ||
                    state is SummarizingJournal ||
                    state is SummarizingError ||
                    state is SummarizedJournalPosted) {
                  context.read<JournalBloc>().add(GetJournals());
                }
                if (state is SummarizingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message ?? "Unknown Error Summarizing Journal",
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is JournalLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is JournalsLoaded) {
                  final journals = state.journals;

                  if (journals.isEmpty) {
                    return Center(
                      child: Text(
                        "No journals yet ✍️",
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: journals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final journal = journals[index];
                      return JournalCard(journal: journal);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
