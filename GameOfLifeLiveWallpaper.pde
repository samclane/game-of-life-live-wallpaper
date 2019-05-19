final int CELL_SIZE = 16;
final int FADE_RATE = 36;

int sx, sy;
float density = 0.36;
int[][][] world;
int[][] alpha_map;


void setup()
{
  size(displayWidth, displayHeight, P2D);
  frameRate(30);
  sx = (int)displayWidth/CELL_SIZE;
  sy = (int)displayHeight/CELL_SIZE;
  world = new int[sx][sy][2];
  alpha_map = new color[sx][sy];

  // Set random cells to 'on'
  for (int i = 0; i < sx * sy * density; i++) {
    int x = (int)random(sx);
    int y = (int)random(sy);
    world[x][y][1] = 1;
    alpha_map[x][y] = 255;
  }
}

void draw()
{
  background(0);

  // Drawing and update cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      // if living or going to live draw square
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1))
      {
        world[x][y][0] = 1;
        alpha_map[x][y] = 255;
      }
      // if dying die
      if (world[x][y][1] == -1)
      {
        world[x][y][0] = 0;
        alpha_map[x][y] -= FADE_RATE;
      }
      world[x][y][1] = 0;
      alpha_map[x][y] -= FADE_RATE;
      
      fill(#FFFFFF, alpha_map[x][y]);
      rectMode(CORNER);
      rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }
  // Birth and death cycle
  for (int x = 0; x < sx; x=x+1) {
    for (int y = 0; y < sy; y=y+1) {
      int count = neighbors(x, y);
      if (count == 3 && world[x][y][0] == 0)
      {
        world[x][y][1] = 1;
      }
      if ((count < 2 || count > 3) && world[x][y][0] == 1)
      {
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
int neighbors(int x, int y)
{
  return world[(x + 1) % sx][y][0] + 
    world[x][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][y][0] + 
    world[x][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + 1) % sy][0] + 
    world[(x + sx - 1) % sx][(y + sy - 1) % sy][0] + 
    world[(x + 1) % sx][(y + sy - 1) % sy][0];
}
