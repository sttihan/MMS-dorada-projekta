import controlP5.*; // Koristimo Textfield iz biblioteke controlC5.
ControlP5 cp5;
// Potrebni Textfieldovi.
// Za prvu igru.
Textfield igra1_igrac;
// Za drugu igru.
Textfield igra2_igrac1, igra2_igrac2;

// Imena igrač(a).
String igrac = "Igrač";  // Za prvu igru.
// Za drugu igru.
String igrac1 = "Igrač 1";
String igrac2 = "Igrač 2";

// Podaci potrebni za rang listu.
Table rang;
boolean plasiraoSe; // Je li se igrač plasirao na rang listu (top 10).

PImage pozadina;

// Određivanje trenutno odabranog prozora.
// pocetni = 0; prva igra = 1; druga igra = 2; povratak = 3, 4; pravila = 5;
// upis imena za prvu igru = 11; upis imena za drugu igru = 21;
int prozor = 0;

//za prvu igricu
int radijus=50;
int rezultat;
boolean igra;
boolean kraj;
Loptica[] protiv;
Loptica dohvati;

//za drugu igricu
int lopticax, lopticay, visinaLop, sirinaLop, brzinax, brzinay;
int lijevaL, lijevaV, debljina, visina, pomak;
int desnaD, desnaV;
boolean doleL, doleD, goreL, goreD;
color boja1 = color(255, 255, 153);
color boja2 = color (255, 255, 255);
int bodovi1 = 0; 
int bodovi2 = 0;
int p = 0;

//klasa koju implementiramo za loptice u prvoj igrici
class Loptica
{
  int x, y, brzinax, brzinay;
  
  Loptica (int x_, int y_, int brzinax_, int brzinay_)
  {
    x = x_;
    y = y_;
    brzinax = brzinax_;
    brzinay = brzinay_;
  }
  
  void update()
  {
    x += brzinax;
    y += brzinay;
    if(x <= 0 || x >= width)
      brzinax = -brzinax;
      
    if(y <= 0 || y >= width)
      brzinay = -brzinay;
  }
}

//kreiranje loptice na bilo kojoj lokaciji s random brzinom
Loptica napraviLopticu()
{
  int x, y, brzinax, brzinay;
   
  do
  {
    x = (int) random(width);
    y = (int) random(height);
  } while (dist(mouseX, mouseY, x, y) < radijus*2 + 50);
  brzinax = (int) random(5);
  brzinay = (int) random(5);
  return new Loptica(x, y, brzinax, brzinay);
}

//napravi lopticu na početnoj lokaciji u drugoj igrici
void nacrtajLopticu() {
  fill(153, 255, 255);
  ellipse(lopticax, lopticay, visinaLop, sirinaLop);
}

//micanje lopcite određenom brzinom
void pomakniLopticu() {  
  lopticax = lopticax + brzinax*2;
  lopticay = lopticay + brzinay*2;
}

//kreiranje dvije pločice s kojima se udara loptica
void nacrtajPlocicu() {
  fill(boja1);
  rect(lijevaL, lijevaV, debljina, visina);
  fill(boja2);
  rect(desnaD, desnaV, debljina, visina);
}

//udarac loptice u bočne strane ili gornju i donju
void loptica() {
 if ( lopticax > width - sirinaLop/2) {
    osvjeziIgre();
    brzinax = -brzinax;
    bodovi1 = bodovi1 + 1;
  } else if ( lopticax < 0 + sirinaLop/2) {
    osvjeziIgre();
    bodovi2 = bodovi2 + 1;
  }
  if ( lopticay > height - visinaLop/2) {
    brzinay = -brzinay;
  } else if ( lopticay < 0 + visinaLop/2) {
    brzinay = -brzinay;
  }
}

//ispisivanje rezultata
void rezultat() {
  textSize(30);
  fill(boja1);
  textAlign(LEFT);
  text(igrac1, 20, 50);
  text(bodovi1, 20, 80);
  fill(boja2);
  textAlign(RIGHT);
  text(igrac2, width-20, 50);
  text(bodovi2, width-20, 80);
}
 
//određivanje kada smo došli do kraja igrice
void kraj() 
{
  if(bodovi1 == 5) {
    prozor = 4;
    bodovi1=0; 
    bodovi2=0;
    p=1;
  }
  if(bodovi2 == 5) {
    prozor = 4;
    bodovi1=0;
    bodovi2=0;
    p=2;
  }
}

void keyPressed() {
if (key == 'w' || key == 'W') {
    goreL = true;
  }
  if (key == 's' || key == 'S') {
    doleL = true;
  }
  if (keyCode == UP) {
    goreD = true;
  }
  if (keyCode == DOWN) {
    doleD = true;
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    goreL = false;
  }
  if (key == 's' || key == 'S') {
    doleL = false;
  }
  if (keyCode == UP) {
    goreD = false;
  }
  if (keyCode == DOWN) {
    doleD = false;
  }
}

//pomicanje pločice gore ili dole
void pomakniPlocicu(){
  if (goreL) {
    lijevaV = lijevaV - pomak;
  }
  if (doleL) {
    lijevaV = lijevaV + pomak;
  }
  if (goreD) {
    desnaV = desnaV - pomak;
  }
  if (doleD) {
    desnaV = desnaV + pomak;
  }
}

//gledamo je li pločica možda došla do vrha ili dna
void plocicaUZid() {
  if (lijevaV - visina/100 < 0) {
    lijevaV = lijevaV + pomak;
  }
  if (lijevaV + visina > height) {
    lijevaV = lijevaV - pomak;
  }
  if (desnaV - visina/100 < 0) {
    desnaV = desnaV + pomak;
  }
  if (desnaV + visina > height) {
    desnaV = desnaV - pomak;
  }
}

//provjeravamo je li loptica udarila o pločicu
void dodir() {
  if (lopticax - sirinaLop/2 < lijevaL + debljina && lopticay - visinaLop/2 < lijevaV + visina/2 && lopticay + visinaLop/2 > lijevaV - visina/2 ) {
    if (brzinax < 0) {
      brzinax = -brzinax*1 + 1;
    }
  }
  else if (lopticax + sirinaLop/2 > desnaD && lopticay - visinaLop/2 < desnaV + visina/2 && lopticay + visinaLop/2 > desnaV - visina/2 ) {
    if (brzinax > 0) {
      brzinax = -brzinax*1 - 1;
    }
  }
}

//funkcija koja provjerava jesmo li prošli preko nekog dijela prozora
boolean prelazak (int x, int y, int width, int height){
  if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height)
    return true;
  return false;
}

// Ažurira rang listu nakon završetka prve igre.
void updateRangTable() {
  int brojRedaka = rang.getRowCount();
  // Rang tablica bi već trebala biti sortirana silazno po broju bodova.
  if (brojRedaka < 10) {
    TableRow redak = rang.addRow();
    redak.setString("igrac", igrac);
    redak.setInt("rezultat", rezultat);  
    rang.sortReverse(1);
    plasiraoSe = true;
    
    saveTable(rang, "data/rang.csv");
  }
  else {
    TableRow zadnjiRedak = rang.getRow(brojRedaka-1);
    if (zadnjiRedak.getInt("rezultat") <= rezultat) {
      // Obriši zadnjeg.
      rang.removeRow(brojRedaka-1);
      // Dodaj novog.
      TableRow redak = rang.addRow();
      redak.setString("igrac", igrac);
      redak.setInt("rezultat", rezultat);  
      rang.sortReverse(1);
      plasiraoSe = true;
      saveTable(rang, "data/rang.csv");
    }
    // U protivnom, igrač se nije plasirao i ne radimo ništa.
    else
      plasiraoSe = false;
  } 
}

void prikaziRangListu(float startY) {
  int i = 1;
  textSize(30);
  textAlign(LEFT);
  
  for (TableRow row : rang.rows()) {
    fill(255, 255, 153);
    text(i + ". " + row.getString("igrac") + " (" + row.getInt("rezultat") + " bodova)", 100, startY+(40*i));
    ++i;
  }
}

void setup(){
  //najprije postavljamo veličinu i pozadinu koje su uvijek iste
  size(700, 800);
  pozadina = loadImage("pozadina.jpg");
  pozadina.resize(700, 800);
  
  // Kreiraj novu instancu ControlP5-a.
  cp5 = new ControlP5(this);
  
  // Tablica za rang listu.
  rang = loadTable("data/rang.csv", "header");
  // Tablica još ne postoji, treba je stvoriti.
  if (rang == null) {
    rang = new Table();
    rang.addColumn("igrac");
    rang.addColumn("rezultat");
    
    saveTable(rang, "data/rang.csv");    
  }
  rang.setColumnType("rezultat", Table.INT);
  rang.sortReverse(1);
  
  // Font NerkoOne preuzet s GoogleFontsa.
  PFont NerkoOne = createFont("NerkoOne-Regular.ttf", 40);
  textFont(NerkoOne);
  
  // Postavljanje atributa Textfielda za upis imena igrača.
  igra1_igrac = cp5.addTextfield("igra1_igracName")
     .setPosition(150, 350)
     .setSize(400, 70)
     .setVisible(false)
     .setColor(color(255, 255, 153))
     .setColorActive(color(255, 255, 153))
     .setColorForeground(color(255))
     .setColorBackground(color(0))
     .setFont(NerkoOne)
     .setText("Igrač 1");
     
  igra2_igrac1 = cp5.addTextfield("igra1_igrac1Name")
     .setPosition(150, 200)
     .setSize(400, 70)
     .setVisible(false)
     .setColor(color(255, 255, 153))
     .setColorActive(color(255, 255, 153))
     .setColorForeground(color(255))
     .setColorBackground(color(0))
     .setFont(NerkoOne)
     .setText("Igrač 1");
     
    igra2_igrac2 = cp5.addTextfield("igra1_igrac2Name")
     .setPosition(150, 350)
     .setSize(400, 70)
     .setVisible(false)
     .setColor(color(255, 255, 153))
     .setColorActive(color(255, 255, 153))
     .setColorForeground(color(255))
     .setColorBackground(color(0))
     .setFont(NerkoOne)
     .setText("Igrač 2");
  
  // Sakrij sve labele Textfieldova.
  igra1_igrac.getCaptionLabel().setText("");
  igra2_igrac1.getCaptionLabel().setText("");
  igra2_igrac2.getCaptionLabel().setText("");
     
  osvjeziIgre();
}

void osvjeziIgre() {
  //odabrana je prva igrica, 
  if(prozor == 1)
  {
    rezultat = 0;
    igra = true;
    dohvati = napraviLopticu();
    protiv = new Loptica[50];
    protiv[0] = napraviLopticu();
  }
  
  //odabrana je druga igrica
  if(prozor == 2)
  {
    lopticax = width/2; 
    lopticay = height/2;
    visinaLop = 50;
    sirinaLop = 50;
    brzinax = 1;
    brzinay = 1;

    debljina = 30;
    visina = 100;
    lijevaL = 40;
    lijevaV = height/2;
    desnaD = width-40-debljina;
    desnaV = height/2;
    pomak = 5;
  }
}

// Prilikom pritiska miša provjeravamo koji je prozor
// trenutno odabran te koji je gumb (ako ikoji) prisnut
// u trenutnom prozoru.
void mouseClicked() {
  // Početni prozor.
  if (prozor == 0) {
    // Igraj prvu igru (unos imena igrača).
    if(prelazak(150, 300, 160, 100)) {
        prozor = 11;
        osvjeziIgre();
    }
    // Igraj drugu igru (unos imena igrača).
    if(prelazak(350, 300, 160, 100)) {
      prozor = 21;     
      osvjeziIgre();
    }
    // Pravila.
    if(prelazak(250, 440, 160, 100))
      prozor = 5;
  }
  // Unos imena igrača prije prve igre.
  else if (prozor == 11) {
    // Početak igre -- pritisak gumba "IGRAJ!".
    if (prelazak(270, 500, 160, 100) && igra1_igrac.getText().length() <= 20) {
      prozor = 1;
      igra1_igrac.setVisible(false);
      igrac = igra1_igrac.getText();
      osvjeziIgre(); 
    }
  }
  // Unos imena igrača prije druge igre.
  else if (prozor == 21) {
    // Početak igre -- pritisak gumba "IGRAJ!".
    if (prelazak(270, 500, 160, 100) && igra2_igrac1.getText().length() <= 20 && igra2_igrac2.getText().length() <= 20) {
      prozor = 2;
      igra2_igrac1.setVisible(false);
      igra2_igrac2.setVisible(false);
      igrac1 = igra2_igrac1.getText();
      igrac2 = igra2_igrac2.getText();
      osvjeziIgre(); 
    }
  }
  // Prozor nakon prve igre.
  else if (prozor == 3) {
    // Natrag na početnu stranicu.
    if(prelazak(150, 200, 160, 100)) {
      prozor = 0;
      osvjeziIgre();
    }
    // Igraj ponovno.
    if(prelazak(350, 200, 160, 100)) {
      prozor = 1;
      osvjeziIgre();
    } 
  }
  // Prozor nakon druge igre.
  else if (prozor == 4) {
    // Natrag na početnu stranicu.
    if(prelazak(150, 300, 160, 100)) {
        prozor = 0;
        osvjeziIgre();
      }
      // Igraj ponovno.
      if(prelazak(350, 300, 160, 100)) {
        prozor = 2;
        osvjeziIgre();
      } 
  }
  // Pravila.
  else if (prozor == 5) {
    // Natrag na početnu stranicu.
    if(prelazak(250, 650, 160, 100)) {
      prozor = 0;
      osvjeziIgre();
    } 
  }
}

void draw(){
  //početni prozor
  if(prozor == 0)
  {
      background(pozadina);
      
      fill(255, 255, 153);
      textSize(60);
      text("Igrice s lopticom", 330, 100);
       
      // 1 IGRAČ
      fill(185, 59, 59);
      rect(150, 300, 160, 100);
      
      // 2 IGRAČA
      fill(185, 59, 59);
      rect(350, 300, 160, 100);
      
      // PRAVILA
      fill(185, 59, 59);
      rect(250, 440, 160, 100);
      

      fill(0, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(25);
      //tri buttona 
      text("SKUPI LOPTICE\n(1 igrač)", 230, 350);
      text("PONG\n(2 igrača)", 430, 350);
      text("PRAVILA", 330, 490);

  }
  
  // Upis imena za prvu igru.
  else if (prozor == 11) {
    background(pozadina);
    
    igra1_igrac.setVisible(true).setFocus(true);
    
    fill(255, 255, 153);
    textAlign(CENTER);
    textSize(70);
    text("Upišite ime:", 350, 300);
    
    // Gumb "Igraj!" s kojim započinje igra nakon upisa
    // imena.
    fill(185, 59, 59);
    rect(270, 500, 160, 100);
    
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("IGRAJ!", 350, 550);
    
    if (igra1_igrac.getText().length() > 20) {
      fill(185, 59, 59);
      textAlign(CENTER, CENTER);
      textSize(30);
      text("Ime smije sadržavati najviše 20 znakova!", 350, 450);
    }
    
  }
  
  //prva igrica
  else if(prozor == 1)
  {
    if(igra)
    {
      background(pozadina);
    
      fill(255, 255, 255);
      textSize(30);
      text("Rezultat: " + rezultat, 80, 40);
      
      //crvena loptica koja je uvijek tamo gdje je miš
      fill(255, 0, 0);
      ellipse(mouseX, mouseY, radijus, radijus);
      
      //zelena loptica koju trebamo uhvatiti
      fill(0, 255, 0);
      ellipse(dohvati.x, dohvati.y, radijus, radijus);
      dohvati.update();
    
      //plave loptice koje ne smijemo udariti
      fill(0, 0, 255);
      for(int i = 0; i<rezultat +1; i++)
      {
        protiv[i].update();
        ellipse(protiv[i].x, protiv[i].y, radijus, radijus);
        
        //dotakli smo plavu
        if (dist(mouseX, mouseY, protiv[i].x, protiv[i].y) < radijus )
        {
          igra = false;
          updateRangTable();          
          prozor = 3;
        }
      }
    
      //dotakli smo zelenu
      if (dist(mouseX, mouseY, dohvati.x, dohvati.y) < radijus)
      {
        rezultat++;
        protiv[rezultat] = napraviLopticu();
        dohvati = napraviLopticu();
      }
    }
  }
  
  // Upis imena za drugu igru.
  else if (prozor == 21) {
    background(pozadina);
    
    igra2_igrac1.setVisible(true);
    igra2_igrac2.setVisible(true);
    
    fill(255, 255, 153);
    textAlign(CENTER);
    textSize(70);
    text("Upišite imena:", 350, 150);
    
    // Gumb "Igraj!" s kojim započinje igra nakon upisa
    // imena.
    fill(185, 59, 59);
    rect(270, 500, 160, 100);
    
    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("IGRAJ!", 350, 550);
    
    if (igra2_igrac1.getText().length() > 20) {
      fill(185, 59, 59);
      textAlign(CENTER, CENTER);
      textSize(30);
      text("Ime smije sadržavati najviše 20 znakova!", 350, 300);
    }
    
    if (igra2_igrac2.getText().length() > 20) {
      fill(185, 59, 59);
      textAlign(CENTER, CENTER);
      textSize(30);
      text("Ime smije sadržavati najviše 20 znakova!", 350, 450);
    }
    
  }
  
  //odabrana je druga igrica
  else if(prozor == 2)
  {
    background(pozadina);
    nacrtajLopticu();
    pomakniLopticu();
    loptica();
    nacrtajPlocicu();
    pomakniPlocicu();
    plocicaUZid();
    dodir();
    rezultat();
    kraj();
  }
  
  //prozor nakon kraja prve igrice
  else if(prozor == 3)
  {
    background(pozadina);
      
    fill(255, 255, 153);
    textSize(60);
    textAlign(CENTER);
    text("Osvojili ste " + rezultat + " loptica.", 350, 100);
    
    // Prikaži rang listu.
    textSize(30);
    if (plasiraoSe)
      text("Bravo, " + igrac +"!\n Plasirali ste se na rang listu.", 350, 140);
      
    textSize(50);
    text("Rang lista", 350, 350);
    prikaziRangListu(360);
    
    fill(185, 59, 59);
    rect(150, 200, 160, 100);
     
    fill(185, 59, 59);
    rect(350, 200, 160, 100);
      

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("IGRAJ \nPONOVO", 430, 250);
    text("POČETNI \nIZBORNIK", 230, 250);

  }  
  
  //prozor nakon kraja druge igrice
  else if(prozor == 4)
  {
    background(pozadina);
      
    fill(255, 255, 153);
    textSize(60);
    textAlign(CENTER);
    text("Kraj igre!", 350, 100);
    text("Pobijedio je igrač", 350, 170);
    if (p == 1)
      text(igrac1, 350, 240);
    else if (p == 2)
      text(igrac2, 350, 240);
    
    fill(185, 59, 59);
    rect(150, 300, 160, 100);
     
    fill(185, 59, 59);
    rect(350, 300, 160, 100);
      

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("IGRAJ \nPONOVO", 430, 350);
    text("POČETNI \nIZBORNIK", 230, 350);
  }
  
  //pravila
  else if(prozor == 5)
  {
    background(pozadina);
      
    fill(boja1);
    textSize(40);
    textAlign(CENTER);
    text("Skupi loptice (1 igrač)", 350, 70);
    textSize(30);
    fill(boja2);
    text("U ovoj igrici, vi ste crvena loptica. \nPomičući miša, mičete svoju lopticu. \nCilj je tom lopticom dotaknuti što više zelenih. \nSa svakom dotaknutom zelenom lopticom, \nbroj plavih se povećava.\nIgra je gotova kada dotaknete plavu lopticu", 350, 120);
   
    fill(boja1);
    textSize(40);
    textAlign(CENTER);
    text("Pong (2 igrača)", 350, 420);
    textSize(30);
    fill(boja2);
    text("Cilj ove igrice je poslati protivniku \nlopticu tako da je on ne može vratiti. \nPobjednik je onaj igrač kojem to 5 puta \npođe za rukom.", 350, 470);
 
    fill(185, 59, 59);
    rect(250, 650, 160, 100); 

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(25);
    text("NAZAD", 330, 700);
    
  }
}
