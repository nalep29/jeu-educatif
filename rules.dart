part of jeu_educatif;

updateVaisseauRule(int left, int top) {
  int numeroRule = 4 + nbLettresParColonne * animalATrouver.length + 1;
  styleSheet.removeRule(numeroRule);
  styleSheet.insertRule(vaisseauRule(left, top), numeroRule);
}

updateBonneLettreRule(int pos, int k) {
  int numeroRule = 5 + pos * nbLettresParColonne + k;
  styleSheet.removeRule(numeroRule);
  styleSheet.insertRule(bonneLettreRule(pos, k), numeroRule);
}

updateMauvaiseLettreRule(int pos, int k) {
  int numeroRule = 5 + pos * nbLettresParColonne + k;
  styleSheet.removeRule(numeroRule);
  styleSheet.insertRule(mauvaiseLettreRule(pos, k), numeroRule);
}

String animalRule(String animal, int i) {
  String fichier = animauxFichiersImagesMap[animal];
  String rule = '''
    #${animal} {
  background-image: url("images/animaux/${fichier}");
  position: absolute;
  width: 200px;
  height: 200px;
  left: ${i<2?150:(i<4?500:850)}px;
  top: ${i.isOdd?50:300}px;
    }
  ''';
  return rule;
}

String bonAnimalRule(String animal, int i) {
  String fichier = animauxFichiersImagesMap[animal];
  String rule = '''
    #${animal} {
  background-image: url("images/animaux/${fichier}");
  position: absolute;
  width: 200px;
  height: 200px;
  left: ${i<2?150:(i<4?500:850)}px;
  top: ${i.isOdd?50:300}px;
  border : 6px solid orange;
    }
  ''';
  return rule;
}

String mauvaisAnimalRule(String animal, int i) {
  String fichier = animauxMauvaisesReponsesMap[animal];
  String rule = '''
    #${animal} {
  background-image: url("images/animaux/${fichier}");
  position: absolute;
  width: 200px;
  height: 200px;
  left: ${i<2?150:(i<4?500:850)}px;
  top: ${i.isOdd?50:300}px;
    }
  ''';
  return rule;
}

String montrerAnimalNiveau2Rule(String animal) {
  String fichier = animauxFichiersImagesMap[animal];
  String rule = '''
    #${animal} {
  background-image: url("images/animaux/${fichier}");
  position: absolute;
  width: 200px;
  height: 200px;
  left: 10px;
  top: 340px;
    }
  ''';
  return rule;
}

String lettreRule(int i, int k, bool bonneLettre) {
  int x = 200 + i*espaceEntreDeuxColonnesDeLettres;
  int y = 50 + k*espaceEntreDeuxLignesDeLettres;
  int width = 80;
  int height = 80;
  String id = bonneLettre?'bonneLettre_${i}_${k}':'mauvaiseLettre_${i}_${k}';
  String rule = '''
    #$id {
  background: wheat;
  position: absolute;
  width: ${width}px;
  height: ${height}px;
  left: ${x}px;
  top: ${y}px;
  font: normal normal normal 500% arial, verdana, sans-serif;
  text-align: center;
    }
  ''';
  espace['${id}'] = {'width': width,'height': height,'left': x,'top': y};
  return rule;
}

String mauvaiseLettreRule(int i, int k) {
  int x = 200 + i*espaceEntreDeuxColonnesDeLettres;
  int y = 50 + k*espaceEntreDeuxLignesDeLettres;
  int width = 80;
  int height = 80;
  String id = 'mauvaiseLettre_${i}_${k}';
  String rule = '''
    #$id {
  background-image: url("images/mauvaise_lettre.png");
  position: absolute;
  width: ${width}px;
  height: ${height}px;
  left: ${x}px;
  top: ${y}px;
  font: normal normal normal 500% arial, verdana, sans-serif;
  text-align: center;
    }
  ''';
  return rule;
}

String bonneLettreRule(int i, int k) {
  int x = 200 + i*espaceEntreDeuxColonnesDeLettres;
  int y = 50 + k*espaceEntreDeuxLignesDeLettres;
  int width = 80;
  int height = 80;
  String id = 'bonneLettre_${i}_${k}';
  String rule = '''
    #$id {
  background: lime;
  position: absolute;
  width: ${width}px;
  height: ${height}px;
  left: ${x}px;
  top: ${y}px;
  font: normal normal normal 500% arial, verdana, sans-serif;
  text-align: center;
    }
  ''';
  return rule;
}

String vaisseauRule(int x, int y) {
  String rule = '''
    #vaisseau {
      left: ${x.toString()}px;
      top: ${y.toString()}px;
    }
  ''';
  return rule;
}
