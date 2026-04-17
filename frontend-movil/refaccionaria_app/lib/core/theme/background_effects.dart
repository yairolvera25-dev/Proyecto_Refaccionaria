import 'package:flutter/material.dart';
import 'dart:math';

// --- CLASES DE DATOS ---
class MouseParticle {
  double x, y;
  double opacity = 1.0;
  Color color;
  MouseParticle(this.x, this.y, this.color);
  void update() { opacity -= 0.04; }
}

class Meteor {
  double x = Random().nextDouble() * 800;
  double y = Random().nextDouble() * -800;
  double speed = Random().nextDouble() * 5 + 4;
  Color color = Random().nextBool() ? Colors.redAccent : Colors.blueAccent;
  void update(Size size) {
    y += speed; x -= speed * 0.4;
    if (y > size.height) { y = -100; x = Random().nextDouble() * (size.width + 200); }
  }
}

class Particle {
  double x = Random().nextDouble() * 600;
  double y = Random().nextDouble() * 1000;
  double vx = (Random().nextDouble() - 0.5) * 2;
  double vy = (Random().nextDouble() - 0.5) * 2;
  Color color;
  Particle(this.color);
  void update(Size s) {
    x += vx; y += vy;
    if (x < 0 || x > s.width) vx *= -1;
    if (y < 0 || y > s.height) vy *= -1;
  }
}

// --- PAINTERS ---
class MouseTrailPainter extends CustomPainter {
  final List<MouseParticle> trail;
  MouseTrailPainter(this.trail);
  @override
  void paint(Canvas canvas, Size size) {
    for (var p in trail) {
      p.update();
      if (p.opacity > 0) {
        canvas.drawCircle(Offset(p.x, p.y), 3, Paint()..color = p.color.withOpacity(p.opacity.clamp(0.0, 1.0)));
      }
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MeteorPainter extends CustomPainter {
  final List<Meteor> meteors; final bool fading;
  MeteorPainter(this.meteors, this.fading);
  @override void paint(Canvas canvas, Size size) {
    for (var m in meteors) {
      m.update(size);
      final paint = Paint()..shader = LinearGradient(
        begin: Alignment.topRight, 
        end: Alignment.bottomLeft, 
        colors: [m.color.withOpacity(fading ? 0 : 0.5), Colors.transparent]
      ).createShader(Rect.fromLTWH(m.x, m.y, 20, 120));
      canvas.drawLine(Offset(m.x, m.y), Offset(m.x - 25, m.y + 120), paint..strokeWidth = 2);
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);
  @override void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      p.update(size);
      canvas.drawCircle(Offset(p.x, p.y), 2, Paint()..color = p.color.withOpacity(0.2));
    }
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => true;
}