import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';

class ProjectScreenHeader extends StatelessWidget {
  final bool isGridView;
  final VoidCallback onViewToggle;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  const ProjectScreenHeader({
    super.key,
    required this.isGridView,
    required this.onViewToggle,
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
                    size: 24,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Projects',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Manage and organize your projects',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              _buildActionButton(
                context: context,
                icon: PhosphorIcons.funnelSimple(PhosphorIconsStyle.bold),
                label: 'Filter',
                onPressed: onFilter,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                context: context,
                icon: PhosphorIcons.sortAscending(PhosphorIconsStyle.bold),
                label: 'Sort',
                onPressed: onSort,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                context: context,
                icon: isGridView
                    ? PhosphorIcons.listBullets(PhosphorIconsStyle.bold)
                    : PhosphorIcons.squaresFour(PhosphorIconsStyle.bold),
                label: isGridView ? 'List view' : 'Grid view',
                onPressed: onViewToggle,
                isActive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? AppColors.accent
                    : Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? AppColors.accent
                      : Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive ? AppColors.accent : null,
                        fontWeight: isActive ? FontWeight.w600 : null,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
