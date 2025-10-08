// スロットゲーム (Processing)
// setup() に size() を移動済みバージョン

import java.util.Collections;
import java.util.Arrays;

String[] reelSymbols = {"7", "BAR", "CHERRY", "BELL", "GRAPE"};
String[][] reels = new String[3][3];
boolean spinning = false;
boolean bonusActive = false;
int credits = 100;
int bet = 1;
int frameCounter = 0;
color bonusColor;

void setup() {
  size(800, 600);  // ← setup に移動
  frameRate(60);
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  background(0);

  // リール描画
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      fill(255);
      rect(200 + i * 120, 150 + j * 100, 100, 80);
      fill(0);
      text(reels[i][j] == null ? "" : reels[i][j], 250 + i * 120, 190 + j * 100);
    }
  }

  // UI 表示
  fill(255);
  text("Credits: " + credits, width/2, 50);
  text("Bet: " + bet, width/2, 100);
  text("Press SPACE to SPIN", width/2, height - 100);

  // ボーナス演出
  if (bonusActive) {
    if (frameCounter % 20 < 10) {
      bonusColor = color(255, 0, 0);
    } else {
      bonusColor = color(255, 255, 0);
    }
    fill(bonusColor);
    textSize(64);
    text("BONUS!!", width/2, height/2);
    textSize(32);

    frameCounter++;
    if (frameCounter > 120) { // 2秒ほど演出
      bonusActive = false;
      frameCounter = 0;
    }
  }
}

void keyPressed() {
  if (key == ' ' && !spinning) {
    spinReels();
  } else if (key == '+') {
    bet++;
  } else if (key == '-' && bet > 1) {
    bet--;
  }
}

void spinReels() {
  if (credits < bet) return;
  credits -= bet;
  spinning = true;

  for (int i = 0; i < 3; i++) {
    shuffleArray(reelSymbols);
    for (int j = 0; j < 3; j++) {
      reels[i][j] = reelSymbols[(int)random(reelSymbols.length)];
    }
  }

  checkWin();
  spinning = false;
}

void checkWin() {
  if (reels[0][1].equals(reels[1][1]) && reels[1][1].equals(reels[2][1])) {
    int win = bet * 10;
    credits += win;
    bonusActive = true;
    frameCounter = 0;
  }
}

// 自作シャッフル関数
void shuffleArray(String[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = int(random(i + 1));
    String temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}

