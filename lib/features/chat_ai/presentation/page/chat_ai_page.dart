import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatium/features/auth/presentation/providers/auth_providers.dart';
import 'package:spatium/features/chat_ai/presentation/providers/chat_providers.dart';
import 'package:spatium/features/chat_ai/presentation/widgets/chat_message_bubble.dart';
import 'package:spatium/features/chat_ai/presentation/widgets/new_session_dialog.dart';
import 'package:spatium/features/chat_ai/presentation/widgets/session_drawer.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class ChatAIPage extends ConsumerStatefulWidget {
  const ChatAIPage({super.key});

  @override
  ConsumerState<ChatAIPage> createState() => _ChatAIPageState();
}

class _ChatAIPageState extends ConsumerState<ChatAIPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Reset chat state first to clear any leftover data from previous sessions
      ref.read(chatNotifierProvider.notifier).resetState();
      
      // Check if user is logged in
      final isLoggedInAsync = ref.read(isLoggedInProvider);
      final isLoggedIn = await isLoggedInAsync.whenOrNull(
        data: (value) => value,
      ) ?? false;
      
      if (!isLoggedIn && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus login terlebih dahulu untuk menggunakan Chat AI'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
        // Don't pop - just show message, user is already in MainNavigationPage
        return;
      }
      
      // Load sessions if logged in
      ref.read(chatNotifierProvider.notifier).loadSessions();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();
    
    final success = await ref.read(chatNotifierProvider.notifier).sendMessage(content);
    if (success) {
      _scrollToBottom();
    }
  }

  Future<void> _showNewSessionDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const NewSessionDialog(),
    );

    if (result != null && result.isNotEmpty && mounted) {
      // Show loading
      if (!mounted) return;
      
      final success = await ref.read(chatNotifierProvider.notifier).createSession(result);
      
      if (!mounted) return;
      
      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Percakapan "$result" berhasil dibuat!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        _scrollToBottom();
      } else {
        // Show error message
        final error = ref.read(chatNotifierProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Gagal membuat percakapan'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.backgroundLight,
      drawer: SessionDrawer(onNewSession: _showNewSessionDialog),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColor.black),
          onPressed: _openDrawer,
          tooltip: 'Riwayat Chat',
        ),
        title: Text(
          chatState.currentSession?.title ?? 'Chat AI',
          style: SpatiumTypography.appBarTitle,
        ),
        backgroundColor: AppColor.white,
        elevation: AppConstants.elevationNone,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColor.black),
            onPressed: chatState.isLoading ? null : _showNewSessionDialog,
            tooltip: 'Buat Percakapan Baru',
          ),
        ],
      ),
      body: chatState.isLoading && chatState.messages.isEmpty && !chatState.hasActiveSession
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat...'),
                ],
              ),
            )
          : !chatState.hasActiveSession
              ? _buildEmptyState()
              : Column(
                  children: [
                    Expanded(
                      child: chatState.messages.isEmpty
                          ? _buildEmptyChat()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(AppConstants.spacingL),
                              itemCount: chatState.messages.length,
                              itemBuilder: (context, index) {
                                return ChatMessageBubble(
                                  message: chatState.messages[index],
                                );
                              },
                            ),
                    ),
                    if (chatState.isSendingMessage)
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingS),
                        child: Row(
                          children: [
                            const SizedBox(width: AppConstants.spacingL),
                            const CircularProgressIndicator(),
                            const SizedBox(width: AppConstants.spacingM),
                            Text(
                              'AI sedang mengetik...',
                              style: SpatiumTypography.hint,
                            ),
                          ],
                        ),
                      ),
                    _buildMessageInput(chatState.isSendingMessage),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Robot image from assets
                SvgPicture.asset(
                  'assets/svg/robot.svg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: AppConstants.radiusXl + 10),
                Text(
                  'Mulai percakapan baru',
                  style: SpatiumTypography.pageTitle,
                ),
                const SizedBox(height: AppConstants.spacingM),
                Text(
                  'Tekan tombol + untuk memulai',
                  style: SpatiumTypography.hint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Robot image from assets
          Image.asset(
            'assets/images/robot.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: AppConstants.radiusXl + 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacing40),
            padding: const EdgeInsets.all(AppConstants.spacingL),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sparkles SVG icon
                SvgPicture.asset(
                  'assets/svg/sparkles-sharp.svg',
                  width: AppConstants.spacingXl,
                  height: AppConstants.spacingXl,
                  colorFilter: ColorFilter.mode(
                    AppColor.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Flexible(
                  child: Text(
                    'Halo, apa yang ingin kamu ceritakan hari ini?',
                    style: SpatiumTypography.chatSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isSendingMessage) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppConstants.opacityLow),
            blurRadius: AppConstants.blurRadiusM,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
              decoration: BoxDecoration(
                color: AppColor.backgroundLight,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Tulis pesanmu ...',
                  hintStyle: SpatiumTypography.hint,
                  border: InputBorder.none,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                enabled: !isSendingMessage,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          GestureDetector(
            onTap: isSendingMessage ? null : _sendMessage,
            child: Container(
              width: AppConstants.buttonHeightS,
              height: AppConstants.buttonHeightS,
              decoration: BoxDecoration(
                color: isSendingMessage 
                    ? AppColor.primary.withOpacity(0.5)
                    : AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/sent.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    AppColor.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
