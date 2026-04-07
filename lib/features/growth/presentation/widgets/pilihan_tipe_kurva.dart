import 'package:flutter/material.dart';

class PilihanTipeKurva extends StatelessWidget {
  final bool isBeratBadan;
  final Function(bool) onChanged;

  const PilihanTipeKurva({
    super.key,
    required this.isBeratBadan,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isBeratBadan ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isBeratBadan
                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monitor_weight_outlined, 
                         color: isBeratBadan ? const Color(0xFFF43F5E) : Colors.grey.shade500, size: 20),
                    const SizedBox(width: 8),
                    Text('Berat Badan',
                        style: TextStyle(
                            color: isBeratBadan ? const Color(0xFFF43F5E) : Colors.grey.shade500,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isBeratBadan ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: !isBeratBadan
                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.height, 
                         color: !isBeratBadan ? const Color(0xFFF43F5E) : Colors.grey.shade500, size: 20),
                    const SizedBox(width: 8),
                    Text('Tinggi Badan',
                        style: TextStyle(
                            color: !isBeratBadan ? const Color(0xFFF43F5E) : Colors.grey.shade500,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}