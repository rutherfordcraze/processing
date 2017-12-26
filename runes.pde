import processing.pdf.*;

// Procedural grid-based writing.
// SENTENCES are made up of WORDS are made up of LETTERS
// LETTERS are 3x2(?) grids of dots, some of which are connected by lines

// Editable Variables
int sentences = 10;
int[] words = {3, 10};
int[] letters = {2, 10};
int letterSize = 3;
float variance = 1;

int background = 29;
int stroke = 220;
int strokeWeight = 1;

boolean exportMode = false;

// System Variables
boolean finished = false;
boolean finishedParagraph = false;
int m_words = 0;
int m_letters = 0;
int cursor_x = 50;
int cursor_y = 50;

void setup() {
  size(1000, 500);
  background(background);
  if(exportMode)
    beginRecord(PDF, "runes_export.pdf");
}

void draw() {
  if(!finishedParagraph) {
    AddSentence();
  } else {
    if(exportMode)
      endRecord();
  }
}

void AddSentence() {
  if(sentences <= 0) {
    finishedParagraph = true;
  }
  
  if(!finished) {
    AddWord();
  } else {
    sentences -= 1;
    finished = false;
    m_words = int(random(words[0], words[1]));
    cursor_x += 40;
    AddWord();
  }
}

void AddWord() {
  m_letters = int(random(letters[0], letters[1]));
  
  if(m_words > 0) {
    m_words --;
  } else if(m_words == 0) {
    finished = true;
  }
  
  for(int i = 0, l = m_letters; i < l; i ++) {
    
    if(cursor_x + (20 * m_letters) >= width - 50) {
      cursor_x = 50;
      cursor_y += 40; // Line feed
    }
    
    if(cursor_y <= height - 70) {
      AddLetter();
    } else {
      finishedParagraph = true;
      return;
    }
  }
  
  cursor_x += 20;
}

void AddLetter() {
  int[][] points = {{0, 0}, {10, 0}, {20, 0}, {0, 10}, {10, 10}, {20, 30}};
  
  if(random(0, 1) < 0.1) {
    points[3][0] *= 3;
  }
  
  for(int i = 0, l = int(random(2, 4)); i < l; i ++) {
    int firstPoint = int(random(0, points.length - 1));
    int secondPoint = int(random(0, points.length - 1));
    int thirdPoint = int(random(0, points.length - 1));
    
    if(firstPoint == secondPoint || secondPoint == thirdPoint) { // Reroll if duplicate
      if(secondPoint == points.length) {
        secondPoint --;
      } else {
        secondPoint ++;
      }
    }
    
    noFill();
    stroke(stroke);
    strokeWeight(strokeWeight);
    
    if(random(0, 1) < 0.3) {
      line(points[firstPoint][0] + cursor_x + random(-variance, variance), points[firstPoint][1] + cursor_y + random(-variance, variance), points[secondPoint][0] + cursor_x + random(-variance, variance), points[secondPoint][1] + cursor_y + random(-variance, variance));
    } else {
      beginShape();
      curveVertex(points[firstPoint][0] + cursor_x + random(-variance, variance), points[firstPoint][1] + cursor_y + random(-variance, variance));
      curveVertex(points[secondPoint][0] + cursor_x + random(-variance, variance), points[secondPoint][1] + cursor_y + random(-variance, variance));
      curveVertex(points[thirdPoint][0] + cursor_x + random(-variance, variance), points[thirdPoint][1] + cursor_y + random(-variance, variance));
      curveVertex(points[firstPoint][0] + cursor_x + random(-variance, variance), points[firstPoint][1] + cursor_y + random(-variance, variance));
      endShape();
    }
  }
  
  cursor_x += 20;
}
