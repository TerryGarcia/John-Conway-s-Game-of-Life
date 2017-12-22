// Settings
byte choice = 3; // 1 for Exploder, 2 for Ten cell row, 3 for a random grid
int cellSize = 2;
color aliveColor = color(255, 255, 255); // Fill color of alive cells
color deadColor = color(0, 0, 0); // Fill color of dead cells
int windowWidth = 600;
int windowHeight = 600;
boolean waitForKeypress = false;
int fps = -1; // -1 for unlimited frames per second

// Proceed with caution
boolean[][] gridPop;
int gridPopWidth;
int gridPopHeight;

void settings()
{
  size(windowWidth, windowHeight);
}

void setup() 
{
  gridPopWidth = ceil(width / cellSize);
  gridPopHeight = ceil(height / cellSize);
  gridPop = new boolean[gridPopWidth][gridPopHeight];

  // These if statements are to choose how to set up the grid.
  if (choice == 1)
  {
    int xStart = int(gridPopWidth / 2) - 2;
    int yStart = int(gridPopHeight / 2) - 2;
    for (int x = 0; x < gridPopWidth; x++) {
      for (int y = 0; y < gridPopHeight; y++) gridPop[x][y] = false;
    }
    for (int i = 0; i < 5; i++) {
      gridPop[xStart][i + yStart] = true;
      gridPop[xStart + 4][i + yStart] = true;
    }
    gridPop[xStart + 2][yStart] = true;
    gridPop[xStart + 2][yStart + 4] = true;
  } else
  {
    if (choice == 2)
    {
      for (int x = 0; x < gridPopWidth; x++) {
        for (int y = 0; y < gridPopHeight; y++) gridPop[x][y] = false;
      }
      for (int x = 10; x < 20; x++)
      {
        gridPop[x][10] = true;
      }
    } else
    {
      for (int x = 0; x < gridPopWidth; x++) {
        for (int y = 0; y < gridPopHeight; y++)
        {
          gridPop[x][y] = ((int)random(0, 50) > 3) ? false : true;
        }
      }
    }
  }
  frameRate(fps);
}

void draw()
{
  if (!waitForKeypress)
    keyPressed();
}

void checkSquares()
{
  boolean[][] gridPopTemp = new boolean[gridPopWidth][gridPopHeight];
  for (int x = 0; x < gridPopWidth; x++)
  {
    for (int y = 0; y < gridPopHeight; y++)
    {
      gridPopTemp[x][y] = gridPop[x][y];
    }
  }

  for (int y = 0; y < gridPopHeight; y++) 
  {
    for (int x = 0; x < gridPopWidth; x++)
    {
      if (gridPop[x][y]) fill(aliveColor);
      else fill(deadColor);
      rect(x * cellSize, y * cellSize, cellSize, cellSize);
      int numberOfNeighbors = 0;
      for (int xx = x - 1; xx <= x + 1; xx++)
      {
        for (int yy = y - 1; yy <= y + 1; yy++)
        {
          int tempXX = wrapAround(xx, 0, gridPopWidth);
          int tempYY = wrapAround(yy, 0, gridPopHeight);
          if (!(xx == x && yy == y) && 
            gridPop[tempXX][tempYY]) numberOfNeighbors++;
        }
      }
      if (gridPop[x][y])
      {
        if (numberOfNeighbors < 2 || numberOfNeighbors > 3) 
          gridPopTemp[x][y] = false;
      } else if (numberOfNeighbors == 3) gridPopTemp[x][y] = true;
    }
  }

  for (int x = 0; x < gridPopWidth; x++)
  {
    for (int y = 0; y < gridPopHeight; y++)
    {
      gridPop[x][y] = gridPopTemp[x][y];
    }
  }
}

void keyPressed()
{
  background(0);
  checkSquares();
}

int wrapAround(int x, int start, int stop)
{
  if (x < start) return stop - abs(x);
  if (x >= stop) return x - stop;
  return x;
}