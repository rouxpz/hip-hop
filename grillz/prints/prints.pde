import processing.pdf.*;
import java.util.Collections;

int horiz = 10;
int vert = 15;
int makeBigger = 40;

float max;

int bgColor = 0;
String filename;
float ts;
float spacing;

PFont font;

ArrayList<Data> words = new ArrayList<Data>();
ArrayList<Float> scores = new ArrayList<Float>();

void setup() {

  size(horiz*makeBigger, vert*makeBigger);
  font = createFont("Gotham", 40);
  textFont(font);

  beginRecord(PDF, "" + bgColor + ".pdf");
  selectSong();
  addData(filename);
  drawText();
  endRecord();
}

void draw() {
  
}

void addData(String filename) {

  String[] keys = loadStrings(filename);

  for (int i = 10; i < keys.length-10; i++) {
    // println(lyrics[i]);
    String[] split = keys[i].split(",");
    Data data = new Data();

    data.word = split[0];
    data.score = float(split[1]); 
    words.add(data);
    scores.add(data.score);

    println(data.word);
  }

  max = Collections.max(scores);
}

void selectSong() { 

  if (bgColor == 0) {
    background(242, 223, 154);
    filename = "the notorious big-juicy-full.txt";
    ts = 13.7;
    spacing = 13.3;
  } else if (bgColor == 1) {
    background(185, 227, 234);
    filename = "diddy-been around the world-full.txt";
    ts = 13.7;
    spacing = 13.3;
  } else if (bgColor == 2) {
    background(247, 202, 202);
    filename = "rick ross-hustlin-full.txt";
    ts = 13.7;
    spacing = 13.3;
  } else if (bgColor == 3) {
    background(200);
    filename = "jay z-hard knock life ghetto anthem-full.txt";
    ts = 15.7;
    spacing = 15.9;
  } else {
    background(185, 234, 217);
    filename = "fat joe-make it rain-full.txt"; 
    ts = 13.7;
    spacing = 13.3;
  }
}

void drawText() {

  float y = 10;
  float x = -5;

  for (Data d : words) {
    d.a = round(map(d.score, -1, max, 75, 200));    
    fill(255, d.a);
    textSize(ts);
    text(d.word, x, y);

    x += textWidth(d.word) + 2;

    if (x >= (horiz*makeBigger)) {
      x = -5;
      y += spacing;
    }
  }
}

void keyPressed() {
  if (key == 's') {
    drawText();
    endRecord();
    println("saved");
    
  } else {
    words.clear();
    if (bgColor >= 4) {
      bgColor = 0;
    } else {
      bgColor++;
    }
  }

  beginRecord(PDF, "" + bgColor + ".pdf");
  font = createFont("Gotham", 40);
  textFont(font);
  selectSong();
  addData(filename);
  drawText();
  endRecord();
}
