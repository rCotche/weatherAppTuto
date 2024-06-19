import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String hour;
  final IconData icon;
  final String temperature;
  const HourlyForecastItem({
    super.key,
    required this.hour,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        //Pour s'assurer que le widget prends la place nécessaire
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              hour,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              //maxLines pour retrict le nombre de ligne que le txt peut prendre
              maxLines: 1,
              //Pour avoir des points de suspensions lorsque le texte est coupé
              //TextOverflow.fade pour un effet dégradé lorsque le texte est coupé
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
