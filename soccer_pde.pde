ArrayList<Bullet> bullets;  // 発射されたボールたち
boolean scored = false;     // ゴールしたかどうかのフラグ

void setup(){
  size(800,500);
  bullets = new ArrayList<Bullet>();
}

void draw(){
  // --- フィールド描画 ---
  background(#11F51A);

  // ペナルティエリア
  stroke(#ffffff);
  strokeWeight(7);
  line(0,50,800,50);     // ゴールライン

  strokeWeight(5);
  line(100,50,100,350);  // 左エリアライン
  line(700,50,700,350);  // 右エリアライン
  line(100,350,700,350); // ペナルティエリア下端

  // ゴールエリア
  line(200,50,200,180);
  line(600,50,600,180);
  line(200,180,600,180);

  // ペナルティアーク
  noFill();
  arc(400,350,200,100,0,PI);

  // ペナルティマーク
  ellipse(400,265,10,10);

  // --- ゴール---
  stroke(255);
  strokeWeight(4);
  noFill();
  rect(250, -100, 300, 150);   // ゴール枠

  // --- マウスに追従するボール（上下のみ動く） ---
  float mainR = 30;
  float fixedX = width/2;        // 中央固定
  float py = constrain(mouseY, 100, height-100);  // 上下の範囲を制限
  fill(255, 200, 0);  // 黄色いボール
  noStroke();
  ellipse(fixedX, py, mainR*2, mainR*2);

  // --- くっついている弾（常に前に表示＝上方向） ---
  float bulletR = 15;
  float attachDist = mainR + bulletR;
  float bx = fixedX;
  float by = py - attachDist;
  fill(255, 100, 100);
  ellipse(bx, by, bulletR*2, bulletR*2);

  // --- 発射されたボールを描画 ---
  for (int i = bullets.size()-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    // ゴール判定
    if (b.checkGoal()) {
      scored = true;
      bullets.remove(i);
      continue;
    }

    if (b.isOutOfBounds()) {
      bullets.remove(i);
    }
  }

  // --- ゴールしたら表示 ---
  if (scored) {
    fill(255, 255, 0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("GOAL!!!", width/2, height/2);
  }
}

// マウス左クリックでシュート（ゴール方向へ）
void mousePressed() {
  if (mouseButton == LEFT) {
    float mainR = 30;
    float bulletR = 15;
    float attachDist = mainR + bulletR;

    float fixedX = width/2;
    float py = constrain(mouseY, 100, height-100);

    float bx = fixedX;
    float by = py - attachDist;

    // --- ゴールの座標（ゴール中央） ---
    float goalX = width/2;
    float goalY = 50;

    // 方向ベクトルを計算
    float dx = goalX - bx;
    float dy = goalY - by;
    float len = sqrt(dx*dx + dy*dy);
    dx /= len;
    dy /= len;

    float speed = 10;
    float vx = dx * speed;
    float vy = dy * speed;

    bullets.add(new Bullet(bx, by, vx, vy, bulletR));
  }
}

// --- ボールクラス ---
class Bullet {
  float x, y;
  float vx, vy;
  float r;

  Bullet(float x, float y, float vx, float vy, float r) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.r = r;
  }

  void update() {
    x += vx;
    y += vy;
  }

  void display() {
    fill(255, 100, 100);
    noStroke();
    ellipse(x, y, r*2, r*2);
  }

  boolean isOutOfBounds() {
    return (x < -r || x > width+r || y < -r || y > height+r);
  }

  // --- ゴール判定 ---
  boolean checkGoal() {
  // ゴール枠の範囲 (x:200〜600, y:-100〜50)
  if (x > 200 && x < 600 && y > -100 && y < 50) {
    return true;
  }
  return false;
  }
}
