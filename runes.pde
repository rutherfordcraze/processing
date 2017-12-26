import processing.pdf.*;

// Procedural grid-based writing.
// SENTENCES are made up of WORDS are made up of LETTERS
// LETTERS are grids of dots, which are connected to each other by random lines

// Editable Variables
int sentences = 6; // Number of sentences to write (only affects up until the end of the canvas; vertical overflow is cut off)
int[] words = {3, 10}; // {min, max} no. of words per line
int[] letters = {2, 10}; // {min, max} no. of letters per word

int background = 29; // RGB value of the background
int stroke = 220; // RGB value of the writing
int strokeWeight = 1; // Weight (in pixels) of the writing

int[][] points = {{0, 0}, {10, 0}, {20, 0}, {0, 10}, {10, 10}, {20, 30}}; // This defines the 'grid' for each letter, where {0, 0} is the top left corner
float variance = 1; // How far line start/end points should deviate from the grid

int letterWidth = 20; // Left of one letter → left of the next
int letterHeight = 20; // Affects last line overflow; if unclear just set it to the highest y-value in points[][];
int wordSpacing = 40; // Space to insert between words
int lineFeed = 50; // Bottom of one line to bottom of the next. Adobe apps call this 'leading' but they shouldn't.

int padding = 100; // Page margins

boolean exportMode = false; // Set to true to enable PDF exporting of the document; change the filename in setup()

// System Variables
boolean finished = false;
boolean finishedParagraph = false;
int m_words = 0;
int m_letters = 0;
int cursor_x = padding;
int cursor_y = padding;

void setup() {
  if(exportMode)
    beginRecord(PDF, "runes_export.pdf");
    
  size(1000, 500);
  background(background);
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
    cursor_x += wordSpacing;
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
    
    if(cursor_x + (letterWidth * m_letters) >= width - padding) {
      cursor_x = padding;
      cursor_y += lineFeed; // Line feed
    }
    
    if(cursor_y <= height - padding - letterHeight) {
      AddLetter();
    } else {
      finishedParagraph = true;
      return;
    }
  }
  
  cursor_x += letterWidth;
}

void AddLetter() {
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
    
    if(random(0, 1) < 0.4) { // Draw a linear connection 40% of the time 
      line(points[firstPoint][0] + cursor_x + random(-variance, variance), points[firstPoint][1] + cursor_y + random(-variance, variance), points[secondPoint][0] + cursor_x + random(-variance, variance), points[secondPoint][1] + cursor_y + random(-variance, variance));
    } else { // Draw a curved connection 60% of the time
      beginShape();
      curveVertex(points[firstPoint][0] + cursor_x + random(-variance, variance), points[firstPoint][1] + cursor_y + random(-variance, variance));
      curveVertex(points[secondPoint][0] + cursor_x + random(-variance, variance), points[secondPoint][1] + cursor_y + random(-variance, variance));
      curveVertex(points[thirdPoint][0] + cursor_x + random(-variance, variance), points[thirdPoint][1] + cursor_y + random(-variance, variance));
      curveVertex(points[firstPoint][0] + cursor_x + random(-variance, variance), points[firstPoint][1] + cursor_y + random(-variance, variance));
      endShape();
    }
  }
  
  cursor_x += letterWidth;
}
