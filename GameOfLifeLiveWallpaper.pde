final int CELL_SIZE = 4;
final int FADE_RATE = 36;
final float DENSITY = 0.36;

int sx, sy;
int[][][] world;
int[][] alpha_map;
color[][] color_map;

void setup() {
  // Display
  size(displayWidth, displayHeight, P2D);
  frameRate(30);

  // Grid
  sx = (int)displayWidth/CELL_SIZE;
  sy = (int)displayHeight/CELL_SIZE;

  // Grid backend
  world = new int[sx][sy][2];
  alpha_map = new int[sx][sy];
  color_map = new color[sx][sy];

  // Set random cells to 'on'
  for (int i = 0; i < sx * sy * DENSITY; i++) {
    int x = (int)random(sx);
    int y = (int)random(sy);
    world[x][y][1] = 1;
    alpha_map[x][y] = 255;
  }

  for (int i = 0; i < sx; i++) {
    for (int j = 0; j < sy; j++) {
      color_map[i][j] = color(255*((float)i/sx), 255*((float)j/sy), 255*((float)(i+j)/sqrt(sx^2 +sy^2)));
    }
  }
}

void draw() {
  background(0);

  // Drawing and update cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      //color_map[x][y] = color((((float)x/sx)) * 255, ((float)y/sy) * 255, ((float)sqrt(x^2+y^2)/sqrt(sx^2 +sy^2)) * 255) + color(sin(frameCount)*255); 

      // if living or going to live draw square
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) {
        world[x][y][0] = 1;
        alpha_map[x][y] = 255;
      }
      // if dying fade-out
      if (world[x][y][1] == -1) {
        world[x][y][0] = 0;
        alpha_map[x][y] -= FADE_RATE;
      }
      world[x][y][1] = 0;
      alpha_map[x][y] -= FADE_RATE;

      if (alpha_map[x][y] > 0) {
        fill(color_map[x][y], alpha_map[x][y]);
        rectMode(CORNER);
        rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
      }
    }
  }
  // Birth and death cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      int count = neighbors(x, y);
      if (count == 3 && world[x][y][0] == 0) {
        world[x][y][1] = 1;
      }
      if ((count < 2 || count > 3) && world[x][y][0] == 1) {
        world[x][y][1] = -1;
      }
    }
  }
}

// Bring the current cell to life
void touchMoved() {
  world[min(sx-1, max(mouseX/CELL_SIZE, 0))][min(sy-1, max(mouseY/CELL_SIZE, 0))][1] = 1;
}

void mouseDragged() {
  world[min(sx-1, max(mouseX/CELL_SIZE, 0))][min(sy-1, max(mouseY/CELL_SIZE, 0))][1] = 1;
}

// Count the number of adjacent cells 'on'
int neighbors(int x, int y) {
  return world[(x + 1) % sx][y][0] + 
    world[x][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][y][0] + 
    world[x][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + sy - 1) % sy][0];
}
