import 'package:flutter/material.dart';
import 'package:nalargizi/features/posyandu/domain/entities/immunization_item_entity.dart';

class ImmunizationStatusCard extends StatelessWidget {
  const ImmunizationStatusCard({
    super.key,
    required this.items,
  });

  final List<ImmunizationItemEntity> items;

  @override
  Widget build(BuildContext context) {
    final doneCount = items.where((item) => item.isDone).length;
    final totalCount = items.isEmpty ? 1 : items.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Imunisasi Dasar',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const Text(
              'Belum ada data imunisasi.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map((item) => _VaccineChip(label: item.name, done: item.isDone))
                  .toList(),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: doneCount / totalCount,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF22C55E)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$doneCount/${items.isEmpty ? 0 : items.length}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VaccineChip extends StatelessWidget {
  final String label;
  final bool done;

  const _VaccineChip({required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    final background = done ? const Color(0xFFD1FAE5) : const Color(0xFFE2E8F0);
    final textColor = done ? const Color(0xFF15803D) : const Color(0xFF94A3B8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done) ...[
            const Icon(
              Icons.check_circle_outline,
              size: 14,
              color: Color(0xFF16A34A),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
