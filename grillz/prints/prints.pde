import processing.pdf.*;
import java.util.Collections;

int horiz = 10;
int vert = 15;
int makeBigger = 40;

float max;

ArrayList<Data> words = new ArrayList<Data>();
ArrayList<String>lyrics = new ArrayList<String>();
ArrayList<Float> scores = new ArrayList<Float>();

void setup() {

  size(horiz*makeBigger, vert*makeBigger);

  background(0, 0, 255);

  // beginRecord();
  addData("the notorious big-juicy-full.txt");
  drawText();
  // endRecord();
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

void drawText() {

  float y = 10;
  float x = 0;

  for (Data d : words) {
    d.a = round(map(d.score, 0, max, 150, 250));    
    fill(255, d.a);
    textSize(12.3);
    text(d.word, x, y);

    x += textWidth(d.word) + 2;
    
      if (x >= (horiz*makeBigger)) {
    x = 0;
    y += 15;
  }
  }

}
