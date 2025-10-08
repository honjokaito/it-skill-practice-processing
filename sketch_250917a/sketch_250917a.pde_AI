// Comical Processing Game: "Sir Splat's Pie Panic"
// Save as Comical_Processing_Game.pde and run in Processing (Java mode).
// Controls: LEFT/RIGHT or A/D to move, SPACE to throw pies, M to toggle auto-mode, R to restart.
// Goal: Hit the grumpy vegetables and collect bonus bananas. Stay alive, rack up 'LOL' points.

int W = 900;
int H = 640;
Player player;
ArrayList<Pie> pies;
ArrayList<Enemy> enemies;
ArrayList<Banana> bananas;
ParticleSystem ps;
int spawnTimer = 0;
int score = 0;
int lives = 3;
int level = 1;
boolean gameOver = false;
PFont uiFont;
boolean autoMode = false;

void setup() {
  size(900, 640);
  uiFont = createFont("Arial", 16);
  resetGame();
  frameRate(60);
}

void resetGame() {
  player = new Player(W/2, H - 90);
  pies = new ArrayList<Pie>();
  enemies = new ArrayList<Enemy>();
  bananas = new ArrayList<Banana>();
  ps = new ParticleSystem();
  spawnTimer = 0;
  score = 0;
  lives = 3;
  level = 1;
  gameOver = false;
  // seed some enemies
  for (int i = 0; i < 4; i++) enemies.add(new Enemy(random(60, W-60), random(60, 220), level));
}

void draw() {
  background(30, 200, 250);
  drawClouds();
  drawGround();

  if (!gameOver) {
    handleInput();
    player.update();
    player.display();

    if (autoMode && frameCount % 12 == 0) pies.add(player.shoot());

    for (int i = pies.size()-1; i >= 0; i--) {
      Pie p = pies.get(i);
      p.update();
      p.display();
      if (p.offscreen()) pies.remove(i);
    }

    for (int i = enemies.size()-1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();
      e.display();
      // collision with pies
      for (int j = pies.size()-1; j >= 0; j--) {
        Pie p = pies.get(j);
        if (e.hitBy(p)) {
          score += e.hitReward();
          ps.spray(p.x, p.y, 18, color(255, 220, 180)); // pie crumble
          pies.remove(j);
          e.hit();
          break;
        }
      }
      // collision with player
      if (e.hitsPlayer(player)) {
        ps.spray(player.x, player.y, 30, color(255, 0, 0));
        lives -= 1;
        e.explode();
        if (lives <= 0) gameOver = true;
      }
      if (e.dead) enemies.remove(i);
    }

    for (int i = bananas.size()-1; i >= 0; i--) {
      Banana b = bananas.get(i);
      b.update();
      b.display();
      if (b.collectedBy(player)) {
        score += 50;
        ps.spray(b.x, b.y, 20, color(255, 255, 0));
        bananas.remove(i);
      } else if (b.offscreen()) bananas.remove(i);
    }

    // spawn logic
    spawnTimer++;
    if (spawnTimer > max(40, 120 - level*8)) {
      spawnTimer = 0;
      if (random(1) < 0.12 + level*0.02) enemies.add(new Enemy(random(50, W-50), -40, level));
      if (random(1) < 0.08) bananas.add(new Banana(random(60, W-60), -20));
    }

    // level up occasionally
    if (score > level * 500) {
      level++;
      // small celebratory sprinkle
      ps.spray(W/2, H/2 - 40, 80, color(255, 200, 0));
    }

    ps.update();
    ps.display();

    drawUI();

  } else {
    drawGameOver();
  }
}

void handleInput() {
  if (keyPressed) {
    if (key == 'a' || key == 'A' || keyCode == LEFT) player.move(-1);
    if (key == 'd' || key == 'D' || keyCode == RIGHT) player.move(1);
    if (key == ' ') {
      if (frameCount % 8 == 0) pies.add(player.shoot());
    }
  } else {
    player.stop();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') resetGame();
  if (key == 'm' || key == 'M') autoMode = !autoMode;
}

void drawUI() {
  fill(0, 150);
  noStroke();
  rect(10, 10, 260, 80, 8);
  textFont(uiFont);
  fill(255);
  textSize(16);
  text("Sir Splat's Pie Panic", 20, 32);
  textSize(14);
  text("Score: " + score, 20, 52);
  text("Lives: " + lives, 20, 70);
  text("Level: " + level, 140, 52);
  text("Auto: " + (autoMode?"ON":"OFF") + "  (M)", 140, 70);

  // silly message
  fill(0);
  textSize(12);
  text(getSillyMessage(), W - 280, 28);
}

String getSillyMessage() {
  if (frameCount % 240 < 60) return "Warning: Pie-napping in progress";
  if (frameCount % 240 < 120) return "Collect bananas for extra giggles";
  if (frameCount % 240 < 180) return "Tip: Pies > Tomatoes (usually)";
  return "Press R to reset if you slip on jelly";
}

void drawClouds() {
  noStroke();
  for (int i = 0; i < 6; i++) {
    float x = (frameCount*0.3f + i*200) % (W+200) - 100;
    float y = 60 + sin((frameCount*0.02f + i)*0.8f) * 8;
    fill(255, 240);
    ellipse(x, y, 140, 70);
    ellipse(x+30, y+10, 110, 55);
    ellipse(x-40, y+12, 90, 40);
  }
}

void drawGround() {
  noStroke();
  fill(38, 180, 75);
  rect(0, H-80, W, 80);
  // cheeky fences
  for (int i = 0; i < W; i+=40) {
    fill(200, 120, 80);
    rect(i+6, H-80, 12, 40, 4);
  }
}

void drawGameOver() {
  fill(0, 180);
  rect(0, 0, W, H);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(46);
  text("GAME OVER", W/2, H/2 - 60);
  textSize(20);
  text("You got laughed at " + score + " times. Press R to retry.", W/2, H/2);
  textSize(14);
  text("Tip: try auto-mode or throw pies faster!", W/2, H/2 + 40);
}

// --------- Player ---------
class Player {
  float x, y;
  float vx = 0;
  float targetV = 0;
  float speed = 6;
  float w = 78;
  float h = 72;
  int faceTimer = 0;

  Player(float x_, float y_) {
    x = x_;
    y = y_;
  }

  void update() {
    vx = lerp(vx, targetV, 0.2);
    x += vx;
    x = constrain(x, 40, W-40);
    faceTimer = (faceTimer+1) % 120;
  }

  void move(int dir) {
    targetV = dir * speed;
  }
  void stop() { targetV = 0; }

  void display() {
    pushMatrix();
    translate(x, y);
    // legs
    fill(40);
    rect(-18, 26, 14, 24, 5);
    rect(4, 26, 14, 24, 5);
    // body (gigantic rubber chicken torso)
    noStroke();
    fill(255, 220, 100);
    ellipse(0, 0, w, h);
    // beak
    fill(255, 120, 20);
    triangle(30, -6, 58, -6, 30, 8);
    // eyes
    fill(255);
    ellipse(-12, -8, 18, 18);
    ellipse(6, -10, 14, 14);
    fill(0);
    float pupilBounce = sin(frameCount*0.2 + x*0.02) * 2;
    ellipse(-12 + pupilBounce, -6, 6, 6);
    ellipse(6 + pupilBounce*0.7, -9, 5, 5);

    // silly hat
    fill(200, 20, 120);
    arc(-6, -36, 44, 28, PI, TWO_PI);
    fill(255, 240, 100);
    textAlign(CENTER);
    textSize(12);
    fill(20);
    text("Sir Splat", 0, -40);

    popMatrix();
  }

  Pie shoot() {
    return new Pie(x + 40, y - 8, -8 - random(0, 3));
  }
}

// --------- Pie (projectile) ---------
class Pie {
  float x, y;
  float vy;
  float rot = 0;
  color c;
  boolean crumb = false;
  Pie(float x_, float y_, float vy_) {
    x = x_; y = y_; vy = vy_;
    c = color(255, 230, 200);
  }
  void update() {
    y += vy;
    vy += 0.22; // gravity
    rot += 0.12;
    if (y > H - 90) {
      // splat on ground
      crumb = true;
      vy *= -0.3;
      y = H - 90;
    }
  }
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(rot);
    fill(c);
    ellipse(0, 0, 36, 22);
    // cream
    fill(255);
    ellipse(-6, -6, 18, 10);
    popMatrix();
    if (crumb) {
      noStroke();
    }
  }
  boolean offscreen() {
    return x < -60 || x > W+60 || y > H + 120;
  }
}

// --------- Enemy (grumpy veg/fruits) ---------
class Enemy {
  float x, y;
  float vx;
  float vy;
  int hp;
  boolean dead = false;
  float wobble;
  int kind; // 0 tomato, 1 broccoli, 2 angry donut
  float rot = 0;

  Enemy(float x_, float y_, int lvl) {
    x = x_; y = y_;
    vx = random(-1.6, 1.6) * (1 + lvl*0.06);
    vy = random(0.6, 1.2) + lvl*0.02;
    hp = 1 + lvl/3;
    wobble = random(100);
    kind = int(random(3));
  }

  void update() {
    x += vx;
    y += vy;
    // bounce off walls
    if (x < 50 || x > W-50) vx *= -1;
    // float around
    rot = sin((frameCount*0.04f) + wobble) * 0.25;
    // slight homing to player
    vx += (player.x - x) * 0.0006 * (1 + level*0.05);
    // ground collision
    if (y > H - 120) {
      vy *= -0.6;
      y = H - 120;
      vy += 0.5;
    }
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(rot);
    noStroke();
    if (kind == 0) drawTomato();
    if (kind == 1) drawBroccoli();
    if (kind == 2) drawDonut();
    popMatrix();
  }

  void drawTomato() {
    fill(220, 40, 40);
    ellipse(0, 0, 64 + hp*6, 56 + hp*6);
    fill(50, 200, 50);
    rect(-12, -40, 24, 10, 6);
    // angry eyes
    fill(255);
    ellipse(-14, -4, 12, 12);
    ellipse(8, -6, 10, 10);
    fill(0);
    ellipse(-14, -3, 5, 5);
    ellipse(8, -6, 4, 4);
  }

  void drawBroccoli() {
    fill(40, 160, 40);
    ellipse(0, -8, 72 + hp*6, 56 + hp*5);
    fill(140, 90, 40);
    rect(-14, 8, 28, 46, 6);
    fill(255);
    textSize(10);
    textAlign(CENTER);
    fill(0);
    text("GRR", 0, -6);
  }

  void drawDonut() {
    fill(200, 120, 60);
    ellipse(0, 0, 70 + hp*5, 70 + hp*5);
    fill(255, 100, 200);
    ellipse(0, 0, 36, 36);
    fill(0);
    textSize(12);
    textAlign(CENTER);
    text("UGH", 0, 6);
  }

  boolean hitBy(Pie p) {
    float d = dist(x, y, p.x, p.y);
    if (d < 36 + hp*3) return true;
    return false;
  }

  void hit() {
    hp -= 1;
    ps.spray(x, y, 10, color(255, 180, 180));
    if (hp <= 0) {
      explode();
    }
  }

  int hitReward() {
    return 100 + int(random(0, level*20));
  }

  boolean hitsPlayer(Player pl) {
    float d = dist(x, y, pl.x, pl.y);
    return d < 56;
  }

  void explode() {
    dead = true;
    // spawn bits and maybe a banana
    ps.spray(x, y, 40, color(200, 80, 100));
    if (random(1) < 0.35) bananas.add(new Banana(x, y));
  }
}

// --------- Banana (bonus) ---------
class Banana {
  float x, y;
  float vy = 1.8;
  float vx = 0;
  Banana(float x_, float y_) {
    x = x_; y = y_;
    vx = random(-1.2, 1.2);
  }
  void update() {
    x += vx;
    y += vy;
    vy += 0.08;
  }
  void display() {
    pushMatrix();
    translate(x, y);
    fill(255, 230, 30);
    arc(0, 0, 28, 40, PI/6, PI - PI/6);
    fill(120);
    ellipse(6, -10, 6, 6);
    popMatrix();
  }
  boolean collectedBy(Player p) {
    return dist(x,y,p.x,p.y) < 44;
  }
  boolean offscreen() {
    return y > H + 120;
  }
}

// --------- Particle System ---------
class Particle {
  float x, y;
  float vx, vy;
  float life;
  color c;
  Particle(float x_, float y_, float vx_, float vy_, float life_, color c_) {
    x = x_; y = y_; vx = vx_; vy = vy_; life = life_; c = c_;
  }
  void update() {
    x += vx;
    y += vy;
    vy += 0.12;
    life -= 1.6;
  }
  void display() {
    noStroke();
    float alpha = map(life, 0, 80, 0, 255);
    fill(red(c), green(c), blue(c), alpha);
    ellipse(x, y, 6, 6);
  }
}

class ParticleSystem {
  ArrayList<Particle> parts;
  ParticleSystem() { parts = new ArrayList<Particle>(); }
  void spray(float x, float y, int n, color c) {
    for (int i = 0; i < n; i++) {
      float ang = random(TWO_PI);
      float spd = random(0.8, 6);
      parts.add(new Particle(x + random(-8,8), y + random(-8,8), cos(ang)*spd, sin(ang)*spd - random(0,2), random(40,90), c));
    }
  }
  void update() {
    for (int i = parts.size()-1; i >= 0; i--) {
      Particle p = parts.get(i);
      p.update();
      if (p.life <= 0) parts.remove(i);
    }
  }
  void display() {
    for (Particle p : parts) p.display();
  }
}

// end of sketch
