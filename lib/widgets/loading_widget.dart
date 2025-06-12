import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.yellow,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LoadingListWidget extends StatelessWidget {
  final int itemCount;
  final bool showSeparator;

  const LoadingListWidget({
    super.key,
    this.itemCount = 5,
    this.showSeparator = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: itemCount,
      separatorBuilder: (context, index) => showSeparator
          ? const Divider(height: 24, color: AppColors.lightGrey)
          : const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return _buildLoadingItem();
      },
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  margin: const EdgeInsets.only(right: 48),
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 120,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 12,
                  width: 180,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
