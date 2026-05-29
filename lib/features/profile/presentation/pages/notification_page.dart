import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nalargizi/app/router/app_router.dart';
import 'package:nalargizi/features/profile/presentation/cubit/notification_cubit.dart';
import 'package:nalargizi/features/profile/presentation/cubit/notification_state.dart';
import 'package:nalargizi/features/profile/domain/entities/notification_entity.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NotificationCubit>()..loadNotifications(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  String _formatTimeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Baru saja';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} menit lalu';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} jam lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari lalu';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // slate 50
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.status == NotificationStatus.loading ||
              state.status == NotificationStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF43F5E),
              ),
            );
          }

          if (state.status == NotificationStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message.isNotEmpty
                          ? state.message
                          : 'Gagal memuat notifikasi.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<NotificationCubit>().loadNotifications(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF43F5E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              color: const Color(0xFFF43F5E),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada notifikasi.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Notifikasi penting tentang si kecil akan muncul di sini.',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationCubit>().loadNotifications(),
            color: const Color(0xFFF43F5E),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationTile(
                  notification: notification,
                  timeAgo: _formatTimeAgo(notification.createdAt),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final String timeAgo;

  const _NotificationTile({
    required this.notification,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (notification.type.toLowerCase()) {
      case 'posyandu':
        icon = Icons.calendar_month_rounded;
        iconColor = const Color(0xFF0284C7); // sky 600
        bgColor = const Color(0xFFE0F2FE); // sky 100
        break;
      case 'growth':
        icon = Icons.trending_up_rounded;
        iconColor = const Color(0xFF16A34A); // green 600
        bgColor = const Color(0xFFDCFCE7); // green 100
        break;
      default:
        icon = Icons.notifications_active_rounded;
        iconColor = const Color(0xFFF43F5E); // rose 500
        bgColor = const Color(0xFFFFF1F2); // rose 50
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: notification.isRead ? const Color(0xFFF1F5F9) : const Color(0xFFFFE4E6),
          width: notification.isRead ? 1.5 : 2.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Mark as read
          context.read<NotificationCubit>().markAsRead(notification.id);
          // Show detail modal
          _showNotificationDetailBottomSheet(context, notification, timeAgo);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: notification.isRead ? FontWeight.bold : FontWeight.w800,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE11D48), // rose 600
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: notification.isRead ? const Color(0xFF64748B) : const Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }

  void _showNotificationDetailBottomSheet(BuildContext context, NotificationEntity notification, String timeAgo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Type Badge & Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: notification.type == 'posyandu' 
                          ? const Color(0xFFE0F2FE)
                          : notification.type == 'growth'
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      notification.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: notification.type == 'posyandu' 
                            ? const Color(0xFF0284C7)
                            : notification.type == 'growth'
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFF43F5E),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                notification.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              
              // Created At / Time
              Text(
                timeAgo,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),
              
              // Message
              Text(
                notification.message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              
              // Dynamic Action Button based on Type
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext); // Close sheet
                    Navigator.pop(context); // Close notification page to return home
                    
                    if (notification.type == 'posyandu') {
                      Navigator.pushNamed(context, AppRouter.posyandu);
                    } else if (notification.type == 'growth') {
                      Navigator.pushNamed(context, AppRouter.growth);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: notification.type == 'posyandu' 
                        ? const Color(0xFF0EA5E9)
                        : notification.type == 'growth'
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFF43F5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(
                    notification.type == 'posyandu' 
                        ? Icons.calendar_month_rounded
                        : notification.type == 'growth'
                            ? Icons.trending_up_rounded
                            : Icons.notifications_active_rounded,
                    size: 18,
                  ),
                  label: Text(
                    notification.type == 'posyandu' 
                        ? 'Buka Jadwal Posyandu'
                        : notification.type == 'growth'
                            ? 'Buka Grafik Tumbuh Kembang'
                            : 'Tutup',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

