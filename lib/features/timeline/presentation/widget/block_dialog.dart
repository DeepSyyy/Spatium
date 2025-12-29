import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/timeline/presentation/providers/moderation_provider.dart';

/// Block User Dialog Widget
/// Shows a confirmation dialog for blocking a user
class BlockUserDialog extends ConsumerStatefulWidget {
  final String userId;
  final String? userAlias;

  const BlockUserDialog({
    super.key,
    required this.userId,
    this.userAlias,
  });

  /// Show the block confirmation dialog
  static Future<bool?> show(
    BuildContext context, {
    required String userId,
    String? userAlias,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => BlockUserDialog(
        userId: userId,
        userAlias: userAlias,
      ),
    );
  }

  @override
  ConsumerState<BlockUserDialog> createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends ConsumerState<BlockUserDialog> {
  bool _isBlocking = false;

  Future<void> _blockUser() async {
    setState(() => _isBlocking = true);

    final success = await ref.read(blockedUsersProvider.notifier).blockUser(
      widget.userId,
    );

    if (mounted) {
      setState(() => _isBlocking = false);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.userAlias ?? 'Pengguna'} telah diblokir'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(blockedUsersProvider).error ?? 'Gagal memblokir pengguna'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = widget.userAlias ?? 'pengguna ini';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.block, color: Colors.red[400]),
          const SizedBox(width: 12),
          const Text('Blokir Pengguna'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah Anda yakin ingin memblokir $userName?',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Apa yang terjadi jika memblokir:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[900],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoItem('Postingan mereka tidak akan muncul di timeline Anda'),
                _buildInfoItem('Komentar mereka tidak akan terlihat oleh Anda'),
                _buildInfoItem('Mereka tidak akan bisa melihat postingan Anda'),
                _buildInfoItem('Anda bisa membuka blokir kapan saja'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isBlocking ? null : _blockUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
          ),
          child: _isBlocking
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Blokir'),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.amber[700])),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Blocked Users Page
/// Shows the list of blocked users and allows unblocking
class BlockedUsersPage extends ConsumerStatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  ConsumerState<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends ConsumerState<BlockedUsersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(blockedUsersProvider.notifier).loadBlockedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(blockedUsersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengguna Diblokir'),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.blockedUsers.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.blockedUsers.length,
                  itemBuilder: (context, index) {
                    final user = state.blockedUsers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            user.alias.isNotEmpty ? user.alias[0].toUpperCase() : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(user.alias),
                        subtitle: Text(
                          'Diblokir pada ${_formatDate(user.blockedAt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () => _unblockUser(user.publicId, user.alias),
                          child: const Text('Buka Blokir'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pengguna yang diblokir',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pengguna yang Anda blokir akan muncul di sini',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _unblockUser(String userId, String alias) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buka Blokir'),
        content: Text('Apakah Anda yakin ingin membuka blokir $alias?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Buka Blokir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(blockedUsersProvider.notifier).unblockUser(userId);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$alias telah dibuka blokirnya'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
