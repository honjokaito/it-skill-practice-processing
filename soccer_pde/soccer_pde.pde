ArrayList<Bullet> bullets;  
Goalkeeper keeper;           
boolean scored = false;      
boolean blocked = false;     

int messageTimer = 0;   // ← 表示タイマー（フレーム単位）

void setup(){
  size(800,500);
  bullets = new ArrayList<Bullet>();
  keeper = new Goalkeeper();  
}

void draw(){
  background(#11F51A);
  drawField();

  keeper.update();
  keeper.display();

  // マウスボール
  float mainR = 30;
  float fixedX = width/2;
  float py = constrain(mouseY, 100, height-100);
  fill(255,200,0);
  ellipse(fixedX, py, mainR*2, mainR*2);

  // くっついてる弾
  float bulletR = 15;
  float attachDist = mainR + bulletR;
  float bx = fixedX;
  float by = py - attachDist;
  fill(255,100,100);
  ellipse(bx, by, bulletR*2, bulletR*2);

  // 発射された弾の処理
  for (int i = bullets.size()-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    // ゴール判定
    if (b.checkGoal()) {
      scored = true;
      blocked = false;
      messageTimer = frameCount;   // ← メッセージ開始時刻
      bullets.remove(i);
      continue;
    }

    // キーパー判定
    if (keeper.blocks(b)) {
      blocked = true;
      scored = false;
      messageTimer = frameCount;   // ← メッセージ開始時刻
      bullets.remove(i);
      continue;
    }

    if (b.isOutOfBounds()) bullets.remove(i);
  }

  // 結果表示（1秒=約60フレーム）
  if (frameCount - messageTimer < 60) {
    textAlign(CENTER, CENTER);
    textSize(50);
    if (scored) {
      fill(255,255,0);
      text("GOAL!!!", width/2, height/2);
    } else if (blocked) {
      fill(255,0,0);
      text("NO GOAL!", width/2, height/2);
    }
  }
}

// --- フィールド描画 ---
void drawField(){
  stroke(#ffffff);
  strokeWeight(7);
  line(0,50,800,50);
  strokeWeight(5);
  line(100,50,100,350);
  line(700,50,700,350);
  line(100,350,700,350);
  line(200,50,200,180);
  line(600,50,600,180);
  line(200,180,600,180);
  noFill();
  arc(400,350,200,100,0,PI);
  ellipse(400,265,10,10);

  // ゴール枠とネット
  stroke(255);
  strokeWeight(4);
  noFill();
  rect(250,-100,300,150);
  stroke(200);
  strokeWeight(1);
  for (int x = 250; x <= 550; x += 20) line(x,-100,x,50);
  for (int y = -100; y <= 50; y += 20) line(250,y,550,y);
}

// --- シュート ---
void mousePressed(){
  if (mouseButton == LEFT){
    float mainR = 30;
    float bulletR = 15;
    float attachDist = mainR + bulletR;

    float fixedX = width/2;
    float py = constrain(mouseY, 100, height-100);

    float bx = fixedX;
    float by = py - attachDist;

    float goalX = width/2;
    float goalY = 50;

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

// --- Bullet ---
class Bullet {
  float x, y, vx, vy, r;
  Bullet(float x, float y, float vx, float vy, float r){
    this.x=x; this.y=y; this.vx=vx; this.vy=vy; this.r=r;
  }
  void update(){ x+=vx; y+=vy; }
  void display(){ fill(255,100,100); ellipse(x,y,r*2,r*2); }
  boolean isOutOfBounds(){ return (x<-r || x>width+r || y<-r || y>height+r); }
  boolean checkGoal(){ return (x>200 && x<600 && y>-100 && y<50); }
}

// --- Goalkeeper ---
class Goalkeeper {
  float x, y, w, h;
  float vx = 3;

  Goalkeeper() {
    x = width/2;
    y = 100;   // ← ゴールラインより前（フィールド内）
    w = 80;
    h = 20;
  }

  void update() {
    x += vx;
    if (x < 250 + w/2 || x > 550 - w/2) vx *= -1;
  }

  void display() {
    fill(0,100,255);
    rectMode(CENTER);
    rect(x, y, w, h, 10);
  }

  boolean blocks(Bullet b){
    return (b.x > x - w/2 && b.x < x + w/2 &&
            b.y > y - h/2 && b.y < y + h/2);
  }
}
