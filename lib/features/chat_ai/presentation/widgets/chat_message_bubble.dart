import 'package:flutter/material.dart';
import 'package:spatium/features/chat_ai/data/models/chat_message_model.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColor.chatRobotPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                color: AppColor.white,
                size: 18,
              ),
            ),
            const SizedBox(width: AppConstants.spacingS),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingL,
                vertical: AppConstants.spacingM,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColor.black : AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 20 : 5),
                  topRight: Radius.circular(isUser ? 5 : 20),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: isUser
                    ? SpatiumTypography.chatSmall.copyWith(color: AppColor.white)
                    : SpatiumTypography.chatSmall,
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppConstants.spacingS),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.gradientPurple, AppColor.gradientPink],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: AppColor.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
