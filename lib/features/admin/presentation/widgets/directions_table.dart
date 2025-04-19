import 'package:flutter/material.dart';
import 'package:variant_master/core/theme/app_colors.dart';
import 'package:variant_master/features/admin/domain/entities/direction.dart';

class DirectionsTable extends StatelessWidget {
  final List<Direction> directions;
  final Function(Direction) onEdit;
  final Function(Direction) onDelete;

  const DirectionsTable({
    Key? key,
    required this.directions,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(13),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withAlpha(25)),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '#',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Yo\'nalish nomi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Yo\'nalish kodi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Fanlar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Amallar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Table content
        Expanded(
          child: directions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: directions.length,
                  itemBuilder: (context, index) {
                    final direction = directions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              direction.name,
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              direction.code,
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  direction.subjects.isEmpty
                                      ? 'Fan qo\'shilmagan'
                                      : '${direction.subjectsCount} ta fan',
                                  style: const TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                if (direction.subjects.isNotEmpty)
                                  Text(
                                    direction.subjects.join(', '),
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => onEdit(direction),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  tooltip: 'Tahrirlash',
                                ),
                                IconButton(
                                  onPressed: () => onDelete(direction),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  tooltip: 'O\'chirish',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Yo\'nalishlar topilmadi',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Yangi yo\'nalish qo\'shish uchun + tugmasini bosing',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
