import 'package:flutter/material.dart';

void showMySnackbar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
}

//Converts the database type names into nice readable strings
String convertType(String? reportType) {
  switch (reportType) {
    case "debris":
      return "Debris";

    case "vehicle_accident":
      return "Vehicle Accident";

    case "missing_signage":
      return "Missing Sign";

    case "obstructed_sign":
      return "Obstructed Sign";

    case "pothole":
      return "Pothole";

    case "flooding":
      return "Flooding";

    case "sign_blocked_foliage":
      return "Obstructed Sign - Foliage";

    case "sign_blocked_sign":
      return "Obstructed Sign - Different Sign";

    case "sign_blocked_building":
      return "Obstructed Sign - Building";

    case "sign_blocked_vehicle":
      return "Obstructed Sign - Vehicle";

    case "damaged_sign":
      return "Damaged Sign";

    case "fog":
      return "Fog";

    case "blinding_rain":
      return "Obfuscation - Rain";

    case "blinding_sun":
      return "Obfuscation - Sun";

    case "hail":
      return "Hail";

    case "ice":
      return "Ice";

    case "unplowed_road":
      return "Unplowed Road";

    case "leaves":
      return "Leaves";

    case "fallen_tree":
      return "Fallen Tree";

    case "dead_animal":
      return "Animal Carcass";

    case "spill_material":
      return "Spilled Material";

    case "blind_turn":
      return "Blind Turn";

    case "overgrowth":
      return "Overgrowth";

    case "snorlax":
      return "Snorlax in Road";

    case "animal_crossing":
      return "Animal Crossing Road";

    default:
      return "Other";
  }
}