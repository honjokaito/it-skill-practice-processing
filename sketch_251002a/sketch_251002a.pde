void setup() {
  size(600, 600);
  background(200, 150, 255);
}

void draw() {
  background(200, 150, 255);

  // 体
  fill(220, 200, 240);
  ellipse(width/2, height/2 + 100, 200, 250);

  // 頭
  fill(250, 230, 250);
  ellipse(width/2, height/2, 250, 250);

  // 耳
  fill(220, 200, 240);
  ellipse(width/2 - 70, height/2 - 180, 50, 120);
  ellipse(width/2 + 70, height/2 - 180, 50, 120);

  fill(255, 220, 240);
  ellipse(width/2 - 70, height/2 - 180, 30, 90);
  ellipse(width/2 + 70, height/2 - 180, 30, 90);

  // 目
  fill(255);
  ellipse(width/2 - 60, height/2 - 20, 70, 90);
  ellipse(width/2 + 60, height/2 - 20, 70, 90);

  fill(50, 0, 80);
  ellipse(width/2 - 60, height/2 - 20, 40, 60);
  ellipse(width/2 + 60, height/2 - 20, 40, 60);

  fill(255);
  ellipse(width/2 - 50, height/2 - 30, 10, 15);
  ellipse(width/2 + 50, height/2 - 30, 10, 15);

  // 口（ギザギザの歯）
  stroke(0);
  strokeWeight(3);
  noFill();
  arc(width/2, height/2 + 60, 180, 60, 0, PI);

  fill(255);
  noStroke();
  for (int i = -80; i <= 80; i += 20) {
    triangle(width/2 + i, height/2 + 60, width/2 + i + 10, height/2 + 60, width/2 + i + 5, height/2 + 80);
  }
}
