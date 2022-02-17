PImage barcode;     //unterprogrammübergreifende Variablen werden definiert.
int[] decodiert;
int[] zahlen = new int[13];
int ende = 0;
int stelle1 = 0;
int stelle2;
int stelle3 = 0;
int stelle4;
int help = 0;
int stop = 0;

void setup(){  //Setup mit Import des Barcodes und Ausführung der Unterprogramme.
  size(900,400);
  println("Taste r für Reset");
  println("Taste i für Interrupt");
  println("Taste s für Start");
  barcode = loadImage("barcode.png"); 
}

void draw(){
  if(keyPressed){
    if(key == 'r'){
      setup();
      delay(2000);
    }
    if(key == 'i'){
      stop++;
    }
    if(key == 's'){
      einrichten();
    }
  }
}

void fehler(){
  fehler();
  if(stop == 0){
    setup();
  }
}

void einrichten(){ //<>//
  barcodeAnzeigen();
  auslese();
  ordnung();
  orientieren();
  umrechnen();
  pruefziffer();
}

void barcodeAnzeigen() {  //zeichnet den Barcode auf den Bildschirm.
  image(barcode,0,0,900,400); 
  int s = second();
  int m = minute();
  int h = hour();
  int d = day();
  int mo = month();
  int y = year();
  save(d+"."+mo+"."+y+"  "+h+"."+m+"."+s+".png");
}
void auslese() {  //prüft die Länge des Barcodes.
println("Auslese gestartet!");
  int counter = 0;
  int counter2 = 0;
   for(int i = 0; (i <= 1000) && (ende == 0); i++){
    if(get(i,40) < -10000000){
      counter = 1;
    }else{
      if(counter == 1){
        counter2++;
        counter = 0;
      }
    }
    if(counter2 == 30){
      ende = i+10;
    }
  }
  
  for(int i = 0; i <= ende; i++){
    if(get(i,40) != get(i,80)){
      fehler();
    }
  }
  
  int achtung = 0;
  for(int i = 0;achtung == 0;i++) {  //einstellen des Programms auf im Barcode vorgegeben Balkengröße 1 (mit c1).
    if(get(i,40)<-8000000) {
      help++;
    }else{
      if(help!=0){
        achtung++;
      }
    }
  }
  if(ende==0){   //Bermerkbarmachen eines Prüffehlers.
    fehler();
  }
  decodiert = new int[ende/help];   //Auslese der Farben um die Striche zu Erkennen.
  for(int i = 0; i < ende/help; i++){
    println(get(i*help,40));
    decodiert[i] = get(i*help,40);
  }  
}
void ordnung(){  //ordnen der Farbcodes zu 0en und 1en.
println("Ordnung gestartet!");
  for(int i = 0; i < ende/help; i++) {
    if(decodiert[i] <= -8388608) {
      decodiert[i] = 1;
    }else{
      decodiert[i] = 0;
    }
  }
  //println(decodiert);
}

void orientieren() {
  println("Orientierung gestartet!");
  int hilfe;
  int counter = 0;
  for (int i=0; i<decodiert.length && counter<3;i++) {  //auszählen der ersten drei Balken(c1) und Speichen des Anfangs vom ersten Zahlenteils in Stelle1.
    hilfe = decodiert[i];  
    if (counter == 1) {
      if(hilfe == 0) {
        counter++;
      }else{
        fehler();
      }
    }
    if (hilfe == 1) {
      counter++;  
    }
    stelle1 = i+1;  
  }
  if(stelle1==0){
    fehler();
  }
  stelle2 = stelle1+41; //Speichern des Endes des ersten Zahlenteils.
  //println(stelle1);
  //println(stelle2);
  
  counter = 0;
  for (int i=stelle2+1; i<decodiert.length && counter<5;i++) {  //auszählen der fünf Balken(c2) und Speichen des Anfangs vom zweiten Zahlenteils in Stelle3.
    hilfe = decodiert[i];  
    if (hilfe == 0) {
      if(counter % 2 == 0){
        counter++; 
      }else{
        fehler();
      }
    }
    if (hilfe == 1) {
      if(counter % 2 == 1){
        counter++;
      }else{
        fehler();
      }
    }
    stelle3 = i+1;
  }
  if(stelle3==0){
    fehler();
  }
  stelle4 = stelle3+41;
  //println(stelle3);
  //println(stelle4);
  
  for (int i=stelle4+1; i<decodiert.length && counter<3;i++) {  //auszählen der letzten drei Balken(c3) zum überprüfen von Stelle4.
    hilfe = decodiert[i];  
    if (hilfe == 1) {
      counter++;  
    }
    if (hilfe == 0) {
      if(counter == 1) {
      counter++;
      }else{
        fehler();
      }
    }
  }
}
void umrechnen(){    //Umrechen von Siebenerblöcken in Zahlen (speichern in String "Zahlen").
  println("Umrechnung gestartet!");  //Erster Teil
  int z1;
  int z2;
  int z3;
  int z4;
  int z5;
  int z6;
  int z7;
  int counter;
  int mitzaehlen = 1;
  boolean keinFehler = false;
  int hilfe;
  for(int i = stelle1;i<stelle2;i=i+7){
    hilfe = 2;
    counter = 0;
    for(int i2 = 0;i2<7;i2++){
      if(decodiert[i+i2] != hilfe){
        hilfe = decodiert[i+i2];
        counter++;
      }
    }
    if(counter != 4){
      fehler();
    }
  }
  for(int i = stelle3;i<stelle4;i=i+7){
    hilfe = 2;
    counter = 0;
    for(int i2 = 0;i2<7;i2++){
      if(decodiert[i+i2] != hilfe){
        hilfe = decodiert[i+i2];
        counter++;
      }
    }
    if(counter != 4){
      fehler();
    }
  }
  for(int i = stelle1;i<stelle2;i=i+7){
    z1 = decodiert[i];
    z2 = decodiert[i+1];
    z3 = decodiert[i+2];
    z4 = decodiert[i+3];
    z5 = decodiert[i+4];
    z6 = decodiert[i+5];
    z7 = decodiert[i+6];
    counter = 0;
    keinFehler = false;
    //println(i);
    //println("mitzählen:"+mitzählen);
    for(int i2 = 0;i2<7;i2++){
      if(decodiert[i+i2] == 1) {
        counter++;
      }
    }
    //println(counter);
    if(counter%2==0) {  //Gerade oder Umgerade Anzahl Einsen?
      if(z1==0&&z2==1&&z3==0&&z4==0&&z5==1&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 0;
         keinFehler = true;
      }
      if(z1==0&&z2==1&&z3==1&&z4==0&&z5==0&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 1;
      }
      if(z1==0&&z2==0&&z3==1&&z4==1&&z5==0&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 2;
      }
      if(z1==0&&z2==1&&z3==0&&z4==0&&z5==0&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 3;
      }
      if(z1==0&&z2==0&&z3==1&&z4==1&&z5==1&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 4;
      }
      if(z1==0&&z2==1&&z3==1&&z4==1&&z5==0&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 5;
      }
      if(z1==0&&z2==0&&z3==0&&z4==0&&z5==1&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 6;
      }
      if(z1==0&&z2==0&&z3==1&&z4==0&&z5==0&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 7;
      }
      if(z1==0&&z2==0&&z3==0&&z4==1&&z5==0&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 8;
      }
      if(z1==0&&z2==0&&z3==1&&z4==0&&z5==1&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 9;
      }
    }else{ 
      if(z1==0&&z2==0&&z3==0&&z4==1&&z5==1&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 0;
         keinFehler = true;
      }
      if(z1==0&&z2==0&&z3==1&&z4==1&&z5==0&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 1;
      }
      if(z1==0&&z2==0&&z3==1&&z4==0&&z5==0&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 2;
      }
      if(z1==0&&z2==1&&z3==1&&z4==1&&z5==1&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 3;
      }
      if(z1==0&&z2==1&&z3==0&&z4==0&&z5==0&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 4;
      }
      if(z1==0&&z2==1&&z3==1&&z4==0&&z5==0&&z6==0&&z7==1){
        zahlen[mitzaehlen] = 5;
      }
      if(z1==0&&z2==1&&z3==0&&z4==1&&z5==1&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 6;
      }
      if(z1==0&&z2==1&&z3==1&&z4==1&&z5==0&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 7;
      }
      if(z1==0&&z2==1&&z3==1&&z4==0&&z5==1&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 8;
      }
      if(z1==0&&z2==0&&z3==0&&z4==1&&z5==0&&z6==1&&z7==1){
        zahlen[mitzaehlen] = 9;
      }
    }
    if(zahlen[mitzaehlen] == 0 && keinFehler == false){
      fehler();
    }
    mitzaehlen++;
  }
  for(int i = stelle3;i<stelle4;i=i+7){ // zweiter Teil
    z1 = decodiert[i];
    z2 = decodiert[i+1];
    z3 = decodiert[i+2];
    z4 = decodiert[i+3];
    z5 = decodiert[i+4];
    z6 = decodiert[i+5];
    z7 = decodiert[i+6];
    keinFehler = false;
    //println(i);
    //println("mitzählen:"+mitzählen);
    if(z1==1&&z2==1&&z3==1&&z4==0&&z5==0&&z6==1&&z7==0){
      zahlen[mitzaehlen] = 0;
      keinFehler = true;
    }
    if(z1==1&&z2==1&&z3==0&&z4==0&&z5==1&&z6==1&&z7==0){
      zahlen[mitzaehlen] = 1;
    }
    if(z1==1&&z2==1&&z3==0&&z4==1&&z5==1&&z6==0&&z7==0){
      zahlen[mitzaehlen] = 2;
    }
    if(z1==1&&z2==0&&z3==0&&z4==0&&z5==0&&z6==1&&z7==0){
      zahlen[mitzaehlen] = 3;
    }
    if(z1==1&&z2==0&&z3==1&&z4==1&&z5==1&&z6==0&&z7==0){
      zahlen[mitzaehlen] = 4;
    }
    if(z1==1&&z2==0&&z3==0&&z4==1&&z5==1&&z6==1&&z7==0){
      zahlen[mitzaehlen] = 5;
    }
    if(z1==1&&z2==0&&z3==1&&z4==0&&z5==0&&z6==0&&z7==0){
      zahlen[mitzaehlen] = 6;
    }
    if(z1==1&&z2==0&&z3==0&&z4==0&&z5==1&&z6==0&&z7==0){
      zahlen[mitzaehlen] = 7;
    }
    if(z1==1&&z2==0&&z3==0&&z4==1&&z5==0&&z6==0&&z7==0){
      zahlen[mitzaehlen] = 8;
    }
    if(z1==1&&z2==1&&z3==1&&z4==0&&z5==1&&z6==0&&z7==0){
      zahlen[mitzaehlen] = 9;
    }
    if(zahlen[mitzaehlen] == 0 && keinFehler == false){
      fehler();
    }
    mitzaehlen++;
  }
  //println(zahlen);
  //println("Stelle zwölf noch nicht berechnet");
}
void pruefziffer() {   //Errechnen und Prüfen der Prüfziffer
  println("Prüfzifferarbeit gestartet!");
  int counter;
  int[] pruefziffer = new int[12];
  int mitzaehlen = 0;
  for(int i = stelle1;i<stelle2;i=i+7) {
    counter = 0;
    for(int i2 = 0;i2 < 7;i2++) {
      if(decodiert[i+i2] == 1) {
        counter++;
      }
    }
    pruefziffer[mitzaehlen] = counter%2;
    mitzaehlen++;
  }
  //println(pruefziffer);
  //println("nur linke Seite");
  
  int z1 = pruefziffer[0];
  int z2 = pruefziffer[1];
  int z3 = pruefziffer[2];
  int z4 = pruefziffer[3];
  int z5 = pruefziffer[4];
  int z6 = pruefziffer[5];
  boolean keinFehler = false;
  if(z1==1&&z2==1&&z3==1&&z4==1&&z5==1&&z6==1){
    zahlen[0]=0;
    keinFehler = true;
  }
  if(z1==1&&z2==1&&z3==0&&z4==1&&z5==0&&z6==0){
    zahlen[0]=1;
  }
  if(z1==1&&z2==1&&z3==0&&z4==0&&z5==1&&z6==0){
    zahlen[0]=2;
  }
  if(z1==1&&z2==1&&z3==0&&z4==0&&z5==0&&z6==1){
    zahlen[0]=3;
  }
  if(z1==1&&z2==0&&z3==1&&z4==1&&z5==0&&z6==0){
    zahlen[0]=4;
  }
  if(z1==1&&z2==0&&z3==0&&z4==1&&z5==1&&z6==0){
    zahlen[0]=5;
  }
  if(z1==1&&z2==0&&z3==0&&z4==0&&z5==1&&z6==1){
    zahlen[0]=6;
  }
  if(z1==1&&z2==0&&z3==1&&z4==0&&z5==1&&z6==0){
    zahlen[0]=7;
  }
  if(z1==1&&z2==0&&z3==1&&z4==0&&z5==0&&z6==1){
    zahlen[0]=8;
  }
  if(z1==1&&z2==0&&z3==0&&z4==1&&z5==0&&z6==1){
    zahlen[0]=9;
  }
  if(zahlen[0] == 0 && keinFehler == false){
    fehler();
  }
  for(int i = 0;i<13;i++) {
    print(zahlen[i]);
    if(i==0 || i==6){
      print(" ");
    }
  }
  println();
  println("Alle Zahlen mit Prüfziffer");
  
  for(int i = 0; i < 12; i++){
    if(i%2 == 0){
      pruefziffer[i] = zahlen[i];
    }else{
      pruefziffer[i] = zahlen[i] * 3;
    }
  }
  //println(pruefziffer);
  double gesamt = 0;
  for(int i = 0; i < 12; i++){
    gesamt = gesamt + pruefziffer[i];
  }
  //println(gesamt);
  double hilfe = gesamt;
  gesamt = Math.ceil(gesamt / 10) * 10;
  //println(gesamt);
  gesamt = gesamt - hilfe;
  println(gesamt);
  if(gesamt == zahlen[12]){
    println("Prüfziffer stimmt.");
  }else{
    println("Prüfziffer falsch.");
  }
}
