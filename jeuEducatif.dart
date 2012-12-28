library jeu_educatif;

import 'dart:html';
import 'dart:math';
import 'dart:isolate';

part 'outils/animaux.dart';
part 'outils/random.dart';
part 'outils/lettres.dart';
part 'rules.dart';

CssStyleSheet styleSheet;
String animalATrouver;

//niveau 1
const int nbImagesAnimauxAffichees = 6;
var animauxAffiches = new List();

//niveau 2
const int nbLettresParColonne = 3;
const int interval = 50;
const int increment = 10;
int espaceEntreDeuxColonnesDeLettres = 0;
int espaceEntreDeuxLignesDeLettres = 0;
var bonnesLettresTrouvees = new List();
var mauvaisesLettresChoisiesMap = new Map<String, String>();

var espace = {
  'vaisseau': {
    'speed': 1,
    'x'    : 0,
    'y'    : 100,
    'dx'   : 1,
    'dy'   : 1,
    'width': 60,
    'height': 60
  },
  'key': {
    'left'  : 37,
    'up'    : 38,
    'right' : 39,
    'down'  : 40
  },
  'zone' : {
    'width'      : 1200,
    'height'     : 550
  }
};

void main() {
  styleSheet = document.styleSheets[0];
  lancerNiveau1();
}

// NIVEAU 1
void lancerNiveau1(){
  afficherImages();
  animalATrouver = randomListElement(animauxAffiches);
  
  query("#question").innerHtml = "Cherche un animal : ";
  query("#en_gros").innerHtml = "${animalATrouver}".toUpperCase();
  
  for(String animal in animauxAffiches){
    query("#${animal}").on.click.add(onMouseDown);
  }
}

void afficherImages(){
  String animal = '';
  Element section = document.query('#zone');
  
  for(int i=0; i<nbImagesAnimauxAffichees; i++){
    DivElement animalDiv = new Element.tag('div');
    do {
      animal = randomAnimal();
    } while (animauxAffiches.contains(animal));
    animalDiv.id = '${animal}';
    section.children.add(animalDiv);
    styleSheet.insertRule(animalRule(animal, i), i+4);
    animauxAffiches.add(animal);
  }
}

void onMouseDown(MouseEvent e){
  String animal = '${e.target.id}';
  int i = 0;
  for(int k=0; k<nbImagesAnimauxAffichees; k++){
    if (animauxAffiches[k] == animal){
      i = k;
    }
  }
  if (animal == animalATrouver){
    styleSheet.removeRule(i+4);
    styleSheet.insertRule(bonAnimalRule(animal, i), i+4);
    for (int k=0; k<nbImagesAnimauxAffichees; k++){
      if(k!=i){
        styleSheet.removeRule(k+4);
        styleSheet.insertRule(mauvaisAnimalRule(animauxAffiches[k], k), k+4);
      }
    }
    new Timer(1500, (t) => lancerNiveau2());
  }
  else {
    styleSheet.removeRule(i+4);
    styleSheet.insertRule(mauvaisAnimalRule(animal, i), i+4);
  }
}

// NIVEAU 2
void lancerNiveau2(){
  quitterNiveau1();
  
  query("#question").innerHtml = "Comment ça s'écrit ? (utilise les flèches du clavier... attention, une seule bonne réponse par colonne)";
  query("#en_gros").innerHtml = "&nbsp;";
  styleSheet.insertRule(montrerAnimalNiveau2Rule(animalATrouver), 4);
  
  afficherColonnesDeLettres();
  
  Element section = document.query('#zone');
  DivElement vaisseauDiv = new Element.tag('div');
  vaisseauDiv.id = 'vaisseau';
  section.children.add(vaisseauDiv);
  
  document.on.keyDown.add(onKeyDown);
  new Timer.repeating(interval, (t) => deplacerVaisseau());
  new Timer.repeating(interval, (t) => verifierLettreTouchee());
}

void quitterNiveau1(){
  for(int k=nbImagesAnimauxAffichees-1; k>=0; k--){
    styleSheet.removeRule(k+4);
  }
  Element section = document.query('#zone');
  for(int i=nbImagesAnimauxAffichees-1; i>=0; i--){
    if(animauxAffiches[i] != animalATrouver){
      section.children.removeAt(i);
    }
  }
  animauxAffiches.clear();
}

void afficherColonnesDeLettres(){
  int nbLettres = animalATrouver.length;
  int largeurEcranDisponiblePourAfficherLettres = 800; // de 200px à 100px car la zone fait 1200px
  int hauteurEcranDisponiblePourAfficherLettres = 350; // de 50px à 400px car la zone fait 5500px
  String bonneLettre = '';
  String lettre = '';
  int positionBonneLettre;
  int positionMauvaiseLettre;
  Element section = document.query('#zone');

  espaceEntreDeuxColonnesDeLettres = largeurEcranDisponiblePourAfficherLettres ~/ (nbLettres - 1);
  espaceEntreDeuxLignesDeLettres = hauteurEcranDisponiblePourAfficherLettres ~/ (nbLettresParColonne - 1);

  for(int i=0; i<nbLettres; i++){
    positionBonneLettre = randomInt(nbLettresParColonne);
    int numeroRule = 0;
    bonneLettre = animalATrouver[i];

    for(int k=0; k<nbLettresParColonne; k++){
      DivElement lettreDiv = new Element.tag('div');
      numeroRule = (nbLettresParColonne*i) + k + 5;

      if(k == positionBonneLettre){
        lettre = bonneLettre;
        lettreDiv.id = 'bonneLettre_${i}_${k}';
        section.children.add(lettreDiv);
        styleSheet.insertRule(lettreRule(i, k, true), numeroRule);
        query("#${lettreDiv.id}").innerHtml = lettre.toUpperCase();
      }
      else {
        lettre = randomLettreSimilaire(bonneLettre);
        lettreDiv.id = 'mauvaiseLettre_${i}_${k}';
        section.children.add(lettreDiv);
        styleSheet.insertRule(lettreRule(i, k, false), numeroRule);
        query("#${lettreDiv.id}").innerHtml = lettre.toUpperCase();
      }
    }
  }
}

void onKeyDown(e) {
  var vaisseau = espace['vaisseau'];
  var key = espace['key'];
  if (e.keyCode == key['up']) {
    vaisseau['y'] = vaisseau['y'] - increment;
  } else if (e.keyCode == key['down']) {
    vaisseau['y'] = vaisseau['y'] + increment;
  }
  else if (e.keyCode == key['left']) {
    vaisseau['x'] = vaisseau['x'] - increment;
  }
  else if (e.keyCode == key['right']) {
    vaisseau['x'] = vaisseau['x'] + increment;
  }
  updateVaisseauRule(vaisseau['x'], vaisseau['y']);
}

void deplacerVaisseau() {
  var vaisseau = espace['vaisseau'];
  var zone = espace['zone'];
  
  if(vaisseau['x'] < 1150){
  vaisseau['x'] += vaisseau['speed'] * vaisseau['dx'];
  }
  else {
    vaisseau['speed'] = 0;
  }
  updateVaisseauRule(vaisseau['x'], vaisseau['y']);
}

void verifierLettreTouchee(){
  var vaisseau = espace['vaisseau'];
  var bonneLettre;
  var mauvaiseLettre;
  String key;
  
  for(int pos = 0; pos < animalATrouver.length; pos++){ // pour chaque colonne de lettres
    for(int k=0; k<nbLettresParColonne; k++){ // pour chaque lettre de la colonne

      bonneLettre = espace['bonneLettre_${pos}'];
      key = 'bonneLettre_${pos}_${k}';
      if(espace.containsKey(key)){ // si la lettre est une bonne lettre (contenue dans le mot)
        bonneLettre = espace[key];
        if (((vaisseau['x'] > bonneLettre['left'] && vaisseau['x'] < bonneLettre['left'] + bonneLettre['width'])
          || (vaisseau['x'] + vaisseau['width'] > bonneLettre['left'] && vaisseau['x'] + vaisseau['width'] < bonneLettre['left'] + bonneLettre['width']))
          && ((vaisseau['y'] > bonneLettre['top'] && vaisseau['y'] < bonneLettre['top'] + bonneLettre['height'])
          || (vaisseau['y'] + vaisseau['height'] > bonneLettre['top'] && vaisseau['y'] + vaisseau['height'] < bonneLettre['top'] + bonneLettre['height'])))
        { // si le vaisseau touche cette lettre
          if(!bonnesLettresTrouvees.contains(pos)){ // si elle n'a pas déjà été touchée avant
            bonnesLettresTrouvees.add(pos);
            updateBonneLettreRule(pos, k);
          }
        }
      }
      key = 'mauvaiseLettre_${pos}_${k}';
      if(espace.containsKey(key)){// si la lettre est une mauvaise lettre (non contenue dans le mot)
        mauvaiseLettre = espace[key];
        if (((vaisseau['x'] > mauvaiseLettre['left'] && vaisseau['x'] < mauvaiseLettre['left'] + mauvaiseLettre['width'])
          || (vaisseau['x'] + vaisseau['width'] > mauvaiseLettre['left'] && vaisseau['x'] + vaisseau['width'] < mauvaiseLettre['left'] + mauvaiseLettre['width']))
          && ((vaisseau['y'] > mauvaiseLettre['top'] && vaisseau['y'] < mauvaiseLettre['top'] + mauvaiseLettre['height'])
          || (vaisseau['y'] + vaisseau['height'] > mauvaiseLettre['top'] && vaisseau['y'] + vaisseau['height'] < mauvaiseLettre['top'] + mauvaiseLettre['height'])))
        { // si le vaisseau touche cette lettre
            updateMauvaiseLettreRule(pos, k);
        }
      }
    }
  } 
  verifierSiToutesLesBonnesLettresSontTouchees();
}

void verifierSiToutesLesBonnesLettresSontTouchees(){  
  if(bonnesLettresTrouvees.length == animalATrouver.length){
    query("#question").innerHtml = "&nbsp;";
    query("#resultat").innerHtml = "BRAVO !";
  }
}
