import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/timeline/data/models/report_model.dart';
import 'package:spatium/features/timeline/presentation/widget/report_dialog.dart';
import 'package:spatium/features/timeline/presentation/widget/block_dialog.dart';

/// Post Actions Menu
/// Shows a popup menu with report and block options for posts
class PostActionsMenu extends ConsumerWidget {
  final String postId;
  final String? postContent;
  final String? postOwnerUserId;
  final String? postOwnerAlias;
  final bool isOwner;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onReported;
  final VoidCallback? onBlocked;

  const PostActionsMenu({
    super.key,
    required this.postId,
    this.postContent,
    this.postOwnerUserId,
    this.postOwnerAlias,
    this.isOwner = false,
    this.onDelete,
    this.onEdit,
    this.onReported,
    this.onBlocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) => _handleMenuAction(context, ref, value),
      itemBuilder: (context) => [
        // Owner actions
        if (isOwner) ...[
          if (onEdit != null)
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Edit'),
                ],
              ),
            ),
          if (onDelete != null)
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outlined, size: 20, color: Colors.red[400]),
                  const SizedBox(width: 12),
                  Text('Hapus', style: TextStyle(color: Colors.red[400])),
                ],
              ),
            ),
        ],
        
        // Non-owner actions
        if (!isOwner) ...[
          const PopupMenuItem(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, size: 20, color: Colors.orange),
                SizedBox(width: 12),
                Text('Laporkan'),
              ],
            ),
          ),
          if (postOwnerUserId != null)
            PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block, size: 20, color: Colors.red[400]),
                  const SizedBox(width: 12),
                  Text('Blokir Pengguna', style: TextStyle(color: Colors.red[400])),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Future<void> _handleMenuAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'edit':
        onEdit?.call();
        break;
      case 'delete':
        final confirm = await _showDeleteConfirmation(context);
        if (confirm == true) {
          onDelete?.call();
        }
        break;
      case 'report':
        final reported = await ReportDialog.show(
          context,
          reportType: ReportType.post,
          targetId: postId,
          targetPreview: postContent,
        );
        if (reported == true) {
          onReported?.call();
        }
        break;
      case 'block':
        if (postOwnerUserId != null) {
          final blocked = await BlockUserDialog.show(
            context,
            userId: postOwnerUserId!,
            userAlias: postOwnerAlias,
          );
          if (blocked == true) {
            onBlocked?.call();
          }
        }
        break;
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Hapus Postingan'),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

/// Comment Actions Menu
/// Shows a popup menu with report and block options for comments
class CommentActionsMenu extends ConsumerWidget {
  final String commentId;
  final String? commentContent;
  final String? commentOwnerUserId;
  final String? commentOwnerAlias;
  final bool isOwner;
  final VoidCallback? onDelete;
  final VoidCallback? onReported;
  final VoidCallback? onBlocked;

  const CommentActionsMenu({
    super.key,
    required this.commentId,
    this.commentContent,
    this.commentOwnerUserId,
    this.commentOwnerAlias,
    this.isOwner = false,
    this.onDelete,
    this.onReported,
    this.onBlocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[500]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) => _handleMenuAction(context, ref, value),
      itemBuilder: (context) => [
        // Owner actions
        if (isOwner && onDelete != null)
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outlined, size: 18, color: Colors.red[400]),
                const SizedBox(width: 12),
                Text('Hapus', style: TextStyle(color: Colors.red[400])),
              ],
            ),
          ),
        
        // Non-owner actions
        if (!isOwner) ...[
          const PopupMenuItem(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag_outlined, size: 18, color: Colors.orange),
                SizedBox(width: 12),
                Text('Laporkan'),
              ],
            ),
          ),
          if (commentOwnerUserId != null)
            PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(Icons.block, size: 18, color: Colors.red[400]),
                  const SizedBox(width: 12),
                  Text('Blokir Pengguna', style: TextStyle(color: Colors.red[400])),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Future<void> _handleMenuAction(BuildContext context, WidgetRef ref, String action) async {
    switch (action) {
      case 'delete':
        final confirm = await _showDeleteConfirmation(context);
        if (confirm == true) {
          onDelete?.call();
        }
        break;
      case 'report':
        final reported = await ReportDialog.show(
          context,
          reportType: ReportType.comment,
          targetId: commentId,
          targetPreview: commentContent,
        );
        if (reported == true) {
          onReported?.call();
        }
        break;
      case 'block':
        if (commentOwnerUserId != null) {
          final blocked = await BlockUserDialog.show(
            context,
            userId: commentOwnerUserId!,
            userAlias: commentOwnerAlias,
          );
          if (blocked == true) {
            onBlocked?.call();
          }
        }
        break;
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Hapus Komentar'),
        content: const Text('Apakah Anda yakin ingin menghapus komentar ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
