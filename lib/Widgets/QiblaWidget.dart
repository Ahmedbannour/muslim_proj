import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:muslim_proj/Constants.dart';

class QiblaWidget extends StatelessWidget {
  const QiblaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 🌍 Qibla angle fixe pour Monastir, Tunisie (≈ 116° depuis le Nord)
    const double qiblaDirection = 116.0;

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data?.heading;

        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors !"),
          );
        }

        // Rotation du cercle (boussole)
        final double rotationAngle = (direction * (math.pi / 180) * -1);

        // Calcul de la position relative de la Qibla
        final double qiblaAngle = ((qiblaDirection - direction) * (math.pi / 180));


        // --- en bas, là où tu affiches ton texte ---
        final double angleDifference = (qiblaDirection - direction).abs();

        // Si on dépasse 360° ou tombe en dessous de 0, on ajuste l’angle
        final adjustedDiff = angleDifference > 180 ? 360 - angleDifference : angleDifference;

        // Vérifie si tu es dans la bonne direction (±5°)
        bool isNearQibla = adjustedDiff <= 5;


        // Détermine le sens de rotation conseillé
        // --- Calcul de la différence signée entre direction et Qibla ---
        // Différence brute
        double diff = qiblaDirection - direction;

      // Normalisation entre -180° et +180°
        if (diff > 180) diff -= 360;
        if (diff < -180) diff += 360;

        double absDiff = diff.abs();

        // Texte dynamique d’orientation
        String guidanceText = "";

        if (isNearQibla) {
          guidanceText = "Vous êtes bien orienté vers la Qibla 🕋";
        } else {
          // Sens : si diff positif → tourner à droite, sinon à gauche
          String directionText = diff > 0 ? "à droite" : "à gauche";

          guidanceText = "Tournez ${absDiff.toStringAsFixed(0)}° $directionText pour atteindre la Qibla";
        }


        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // --- CERCLE QUI TOURNE (boussole) ---
                      Transform.rotate(
                        angle: rotationAngle,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: KBackgroundColor,
                              border: Border.all(
                                width: 6,
                                color: isNearQibla ? Colors.green.withOpacity(.4) : KPrimaryColor.withOpacity(.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: KPrimaryColor.withOpacity(.2),
                                  offset: const Offset(4.0, 4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // --- Lettres cardinales ---
                                _buildDirectionLabel("N", Alignment.topCenter),
                                _buildDirectionLabel("S", Alignment.bottomCenter),
                                _buildDirectionLabel("E", Alignment.centerRight),
                                _buildDirectionLabel("W", Alignment.centerLeft),

                                // --- Petits points décoratifs ---

                                Positioned(
                                  top: MediaQuery.of(context).size.width /16 + 8,
                                  right: MediaQuery.of(context).size.width /16 + 8,
                                  child: Container(
                                    margin: const EdgeInsets.all(24),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: KPrimaryColor,
                                    ),
                                  ),
                                ),


                                Positioned(
                                  top: MediaQuery.of(context).size.width /16 + 8,
                                  left: MediaQuery.of(context).size.width /16 + 8,
                                  child: Container(
                                    margin: const EdgeInsets.all(24),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: KPrimaryColor,
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: MediaQuery.of(context).size.width /16 + 8,
                                  left: MediaQuery.of(context).size.width /16 + 8,
                                  child: Container(
                                    margin: const EdgeInsets.all(24),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: KPrimaryColor,
                                    ),
                                  ),
                                ),

                                Positioned(
                                  bottom: MediaQuery.of(context).size.width /16 + 8,
                                  right: MediaQuery.of(context).size.width /16 + 8,
                                  child: Container(
                                    margin: const EdgeInsets.all(24),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: KPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // --- ICÔNE DE LA QIBLA (fixée sur la vraie direction) ---
                      Transform.rotate(
                        angle: qiblaAngle,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow:isNearQibla ? [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(.4),
                                    offset: const Offset(4.0, 4.0),
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0,
                                  ),
                                ] : []
                              ),
                              width: 32,
                              height: 32,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  "assets/images/kaaba.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          ),
                        ),
                      ),

                      // --- AIGUILLE CENTRALE (Nord du téléphone) ---
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.navigation_rounded,
                            color: isNearQibla ? Colors.green : Colors.deepOrange,
                            size: 24,
                          ),
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: isNearQibla ? Colors.green : Colors.deepOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Text(
              '${direction.floor()}°',  // ✅ ici le changement
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isNearQibla ? Colors.green : KTextColor,
              ),
            ),


            SizedBox(height: 8),
            Text(
              'Orientation de l’appareil vers la Qibla',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isNearQibla ? Colors.green : KTextColor,
              ),
            ),


            SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: KPrimaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(32)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  guidanceText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isNearQibla ? Colors.green : KPrimaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Fonctions utilitaires pour les labels ---
  Widget _buildDirectionLabel(String label, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }


}
