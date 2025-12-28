import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/chat_ai/data/models/chat_session_model.dart';
import 'package:spatium/features/chat_ai/presentation/providers/chat_providers.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';
import 'package:intl/intl.dart';

/// Session Drawer Widget
/// Displays list of chat sessions for user to select
class SessionDrawer extends ConsumerWidget {
  final VoidCallback onNewSession;

  const SessionDrawer({
    super.key,
    required this.onNewSession,
  });

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return 'Hari ini';
      } else if (diff.inDays == 1) {
        return 'Kemarin';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} hari lalu';
      } else {
        return DateFormat('dd MMM yyyy', 'id').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _confirmDeleteSession(
    BuildContext context,
    WidgetRef ref,
    ChatSessionModel session,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: Text(
          'Hapus Percakapan',
          style: SpatiumTypography.pageTitle,
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${session.title}"?',
          style: SpatiumTypography.chatSmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Batal',
              style: SpatiumTypography.button.copyWith(
                color: AppColor.secondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
            ),
            child: Text(
              'Hapus',
              style: SpatiumTypography.button.copyWith(
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await ref
          .read(chatNotifierProvider.notifier)
          .deleteSession(session.publicId);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Percakapan "${session.title}" berhasil dihapus'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);
    final sessions = chatState.sessions;

    return Drawer(
      backgroundColor: AppColor.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: AppColor.primary,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: AppColor.white,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Riwayat Chat',
                          style: SpatiumTypography.pageTitle.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                        Text(
                          '${sessions.length} percakapan',
                          style: SpatiumTypography.small.copyWith(
                            color: AppColor.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // New Session Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close drawer
                    onNewSession();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Percakapan Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingM,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Sessions List
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: AppColor.secondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: AppConstants.spacingM),
                          Text(
                            'Belum ada percakapan',
                            style: SpatiumTypography.hint,
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          Text(
                            'Mulai percakapan baru dengan AI',
                            style: SpatiumTypography.small.copyWith(
                              color: AppColor.secondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingS,
                      ),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final isSelected =
                            chatState.currentSession?.publicId ==
                                session.publicId;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingS,
                            vertical: AppConstants.spacingXs,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusM,
                            ),
                            border: isSelected
                                ? Border.all(
                                    color: AppColor.primary.withOpacity(0.3),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).pop(); // Close drawer
                              ref
                                  .read(chatNotifierProvider.notifier)
                                  .selectSession(session.publicId);
                            },
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.primary
                                    : AppColor.hintBackground,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusS,
                                ),
                              ),
                              child: Icon(
                                Icons.chat_bubble,
                                color: isSelected
                                    ? AppColor.white
                                    : AppColor.secondary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              session.title,
                              style: SpatiumTypography.labelSemiBold.copyWith(
                                color: isSelected
                                    ? AppColor.primary
                                    : AppColor.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              _formatDate(session.updatedAt),
                              style: SpatiumTypography.small.copyWith(
                                color: AppColor.secondary,
                              ),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: AppColor.secondary,
                              ),
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _confirmDeleteSession(context, ref, session);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: AppColor.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppConstants.spacingS),
                                      Text(
                                        'Hapus',
                                        style: SpatiumTypography.chatSmall.copyWith(
                                          color: AppColor.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
