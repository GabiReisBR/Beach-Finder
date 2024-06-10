import 'package:flutter/material.dart';
import '../models/beach.dart';
import '../pages/beach_detail_page.dart';

class BeachCard extends StatelessWidget {
  final Beach beach;

  BeachCard({required this.beach});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BeachDetailPage(beach: beach)),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beach.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(beach.location),
              SizedBox(height: 8),
              Text(
                'Avaliação: ${beach.rating}',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
