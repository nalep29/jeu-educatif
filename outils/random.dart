part of jeu_educatif;

int randomInt(int max) => new Random().nextInt(max);

randomListElement(List list) => list[randomInt(list.length)];

String randomAnimal() => randomListElement(animauxList);

String randomLettre() => randomListElement(alphabet);

String randomLettreSimilaire(String lettre) {
  String lettreARetourner;
  if(lettresSimilairesMap.containsKey(lettre.toUpperCase())){
    var listeLettresSimilaires = lettresSimilairesMap[lettre.toUpperCase()];
    lettreARetourner = randomListElement(listeLettresSimilaires);
  }
  else {
    lettreARetourner = randomLettre();
  }
  return lettreARetourner;
}
