import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.Manifold;
import org.jbox2d.common.*;
import org.jbox2d.callbacks.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.contacts.*;
import beads.*;

import org.gamecontrolplus.gui.*;
import org.gamecontrolplus.*;
import net.java.games.input.*;

boolean USE_GAMEPAD = true;
PFont pin;



// Gamepad controls
ControlIO control;
Configuration config;
ControlDevice gpad;

Box2DProcessing box2d;

Ball ball;

ArrayList<Wall> wallList;

Plunger plunger;

ArrayList<Flipper> flipperList;

ArrayList<Bumper> bumperList;

int playerScore;

int ballCount = 5;

boolean lostGame;

void setup()
{
  // Create the window
  size(600, 700);
  smooth();
  pin = loadFont("Broadway-15.vlw");
  

  if (USE_GAMEPAD)

  
  // Init box2d world
  box2d = new Box2DProcessing (this);
  box2d.createWorld();

  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  ball = new Ball(15.0f, new Vec2(550, 100));
  ball.fillColor = color(255, 0, 0);

  wallList = new ArrayList<Wall>();  

  plunger = new Plunger(new Vec2( 550, 650));

  flipperList = new ArrayList<Flipper>();
  bumperList = new ArrayList<Bumper>();

  addWalls();
  addBumpers();
  addFlippers();
}

void draw()
{
  background(14, 208, 174);
  
  userInput();

  if (!lostGame)
  {
    drawGame();

    // Set fill to black and draw score
    fill(#631192);
    textFont(pin);
    textSize(22);
    text("PINBALL GAME",4,28);
    fill(#2fb3bf);
    text("PINBALL GAME",2,26);
    fill(0);
    textSize(15);
    text("Instrucciones:",2,104);
    textSize(11);
    text("Presiona A para la palanca izquierda",71,266,136,300);
    text("Presiona L para la palanca derecha",71,299,135,300);
    text("Presiona la barra espaciadora para lanzar la pelota",51,367,87,300);
    textSize(14);
    text("Puntuacion: " + playerScore, 5, 54);
    text("Pelotas restantes: " + ballCount, 5, 71);
  } else
  {
    // Set fill to black and draw score
    fill(0);
    text("Score: " + playerScore, 5, 15);
    text("Game Over: Press Spacebar to Restart", 5, 30);
  }
}
void drawGame()
{
  // Update physics world
  box2d.step();
  ball.render();

  if (ball.offScreen())
  {
    if ( ballCount > 0)
    {
      ball = new Ball(15.0f, new Vec2(550, 100));
      ball.fillColor = color(254, 55, 102);
    } else
    {
      lostGame = true;
    }
  }

  for (Wall w : wallList)
  {
    w.render();
  }

  for (Bumper b : bumperList)
  {
    b.render();
  }

  plunger.render();

  for (Flipper f : flipperList)
  {
    f.render();
  }
}

void beginContact(Contact c)
{
  // Detect collisions for objects

  // Get the colliding fixtures
  Fixture f1 = c.getFixtureA();
  Fixture f2 = c.getFixtureB();

  // Get the bodies of each fixture
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get the objects that the bodies are from
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  // If either object is null return
  if (o1 == null || o2 == null)
  {
    return;
  }

  // Get Contact Manifold (for normal)
  Manifold m = c.getManifold();

  if (o1 instanceof Bumper && o2 instanceof Ball) 
  {
    Bumper bumper = (Bumper)o1;
    Ball ball = (Ball)o2;

    bumper.collide(ball, color(0), m.localNormal);
  } else if (o1 instanceof Ball && o2 instanceof Bumper) 
  {
    Bumper bumper = (Bumper)o2;
    Ball ball = (Ball)o1;

    bumper.collide(ball, color(0), m.localNormal);
  }
}

void endContact(Contact c)
{
  // End contact method stub
}


void userInput()
{
  // Check if plunger button on gamepad is pressed
  // or if the spacebar is pressed
  if ((keyPressed && key == ' ' ))
  {
    if (!lostGame)
    {
      // If the player is still in game pull the plunger
      plunger.pullPlunger();
    } else
    {
      // If the player has lost the game restart it
      lostGame = false;
      ballCount = 5;
    }
  }

  // If the left bumper has been pressed (or the Z key) activate the left flipper
  if ((keyPressed && (key == 'a' || key == 'A')))
  {
    for (Flipper f : flipperList)
    {
      f.flip(100000, true);
    }
  }

  // If the right bumper has been pressed (or the (/-?) key) activate the right flipper
  if ((keyPressed && (key == 'l' || key == 'L')))
  {
    for (Flipper f : flipperList)
    {
      f.flip(100000, false);
    }
  }
}

void addWalls()
{
  Vec2[] vertices = new Vec2[4];
  vertices[0] = new Vec2(10, 400);
  vertices[1] = new Vec2(10, 560);
  vertices[2] = new Vec2(115, 560);
  vertices[3] = new Vec2(110, 15);

  Wall wallToAdd = new Wall(new Vec2(410, 140), vertices);
  wallToAdd.fillColor = color(#fe3702);
  wallToAdd.strokeColor = color(0);

  wallList.add(wallToAdd);

  vertices = new Vec2[4];
  vertices[0] = new Vec2(0, 0);
  vertices[1] = new Vec2(0, 700);
  vertices[2] = new Vec2(20, 700);
  vertices[3] = new Vec2(20, 0);

  wallToAdd = new Wall(new Vec2(580, 0), vertices);
  wallToAdd.fillColor = color(#9C77CE);
  wallToAdd.strokeColor = color(0);
  wallList.add(wallToAdd);

  vertices = new Vec2[4];
  vertices[0] = new Vec2(300, 0);
  vertices[1] = new Vec2(325, 10);
  vertices[2] = new Vec2(400, 80);
  vertices[3] = new Vec2(400, 0);

  wallToAdd = new Wall(new Vec2(200, 0), vertices);
  wallToAdd.fillColor = color(#9C77CE);
  wallToAdd.strokeColor = color(0);
  wallList.add(wallToAdd);

  vertices = new Vec2[3];
  vertices[0] = new Vec2(000, 0);
  vertices[1] = new Vec2(200, 50);
  vertices[2] = new Vec2(300, 0);

  wallToAdd = new Wall(new Vec2(200, 0), vertices);
  wallToAdd.fillColor = color(#9C77CE);
  wallToAdd.strokeColor = color(0);
  wallList.add(wallToAdd);

  vertices = new Vec2[4];
  vertices[0] = new Vec2(0, 210);
  vertices[1] = new Vec2(90, 210);
  vertices[2] = new Vec2(200, 0);
  vertices[3] = new Vec2(0, 0);

  wallToAdd = new Wall(new Vec2(00, 0), vertices);
  wallToAdd.fillColor = color(#9C77CE);
  wallToAdd.strokeColor = color(0);
  wallList.add(wallToAdd);

  vertices = new Vec2[4];
  vertices[0] = new Vec2(0, 0);
  vertices[1] = new Vec2(0, 500);
  vertices[2] = new Vec2(90, 500);
  vertices[3] = new Vec2(90, 0);

  wallToAdd = new Wall(new Vec2(0, 210), vertices);
  wallToAdd.fillColor = color(#9C77CE);
  wallToAdd.strokeColor = color(0);
  wallList.add(wallToAdd);
}

void addBumpers()
{ 
  Bumper bumper = new Bumper(new Vec2( 190, 193), 50);
  bumper.fillColor = color(156, 228, 139);
  bumper.strokeColor = color(156, 228, 139);
  bumperList.add(bumper);

  bumper = new Bumper(new Vec2( 396, 311), 65);
  bumper.fillColor = color(242, 143, 84);
  bumper.strokeColor = color(242, 143, 84);
  bumperList.add(bumper);

  bumper = new Bumper(new Vec2( 142, 370), 30);
  bumper.fillColor = color(248, 85, 146);
  bumper.strokeColor = color(248, 85, 146);
  bumperList.add(bumper);

  bumper = new Bumper(new Vec2( 290, 412), 8);
  bumper.fillColor = color(244, 234, 79);
  bumper.strokeColor = color(244, 234, 79);
  bumperList.add(bumper);
  
  bumper = new Bumper(new Vec2( 365, 122), 22);
  bumper.fillColor = color(79, 244, 227);
  bumper.strokeColor = color(79, 244, 227);
  bumperList.add(bumper);
}

void addFlippers()
{
  Flipper flipper = new Flipper(new Vec2( 100, 550), true);
  flipper.fillColor = color(162, 161, 161);
  flipperList.add(flipper);

  flipper = new Flipper(new Vec2( 410, 550), false);
  flipper.fillColor = color(162, 161, 161);
  flipperList.add(flipper);
}
