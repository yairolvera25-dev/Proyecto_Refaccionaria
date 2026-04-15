import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  final String title;
  final String amount;
  final String percentage;
  final bool isPositive;
  final bool isSelected; // 🔥 Nuevo: Para saber si está marcada
  final VoidCallback onTap; // 🔥 Nuevo: Función de clic

  const AdminStatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.onTap,
    this.isPositive = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 175,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A2233) : const Color(0xFF161B26),
          borderRadius: BorderRadius.circular(24),
          // 🔥 Si está seleccionada, el borde brilla más
          border: Border.all(
            color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF00E5FF).withOpacity(0.1), 
            width: isSelected ? 2 : 1.5
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(amount, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    isPositive ? "+$percentage" : "-$percentage", 
                    style: TextStyle(color: isPositive ? Colors.greenAccent : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)
                  ),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text("vs mes pasado", style: TextStyle(color: Colors.white38, fontSize: 10), overflow: TextOverflow.ellipsis),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}