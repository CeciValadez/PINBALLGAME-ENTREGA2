class Bumper extends Drawable
{
  // Box2D body
  Body pBody; 
  PShape pShape;
  color resetColor;
  boolean inThread;

  Bumper(Vec2 position, float radius)
  {
    // Create shape
    PolygonShape shape = new PolygonShape();

    Vec2[] vertices = new Vec2[8];
    float angleStep = PI/4;
    for (int i = 0; i < 8; i++)
    {
      vertices[i] = new Vec2(radius * cos(angleStep*i), radius * sin(angleStep*i));
    }

    // Create an array to temporarily store the box2D vertex coordinates
    Vec2[] box2DVertices = new Vec2[vertices.length];

    // Create a new PShape
    pShape = createShape();
    pShape.beginShape();

    // Iterate through every vertex
    for (int i = 0; i < vertices.length; i++)
    {
      float x = vertices[i].x;
      float y = vertices[i].y;

      // Add the vertex to the shape
      pShape.vertex(x, y);

      // Add the vertex (converted to box2D coords)
      box2DVertices[i] = new Vec2(box2d.scalarPixelsToWorld(x), -box2d.scalarPixelsToWorld(y));
    }

    // End the PShape
    pShape.endShape(CLOSE);

    // Set the box2D vertices 
    shape.set(box2DVertices, box2DVertices.length);

    // Define physics body
    BodyDef bodyDef = new BodyDef();
    bodyDef.type = BodyType.STATIC;
    bodyDef.position.set(box2d.coordPixelsToWorld(position));

    // Add body to world
    this.pBody = box2d.createBody(bodyDef);
    this.pBody.createFixture(shape, 1);

    // set the callback data to this instance
    this.pBody.setUserData(this);
  }

  void render()
  {
    // Since we're using a PShape we can't just call fill and stroke
    pShape.setFill(fillColor);
    pShape.setStroke(strokeColor);

    Vec2 ballPos = box2d.getBodyPixelCoord(this.pBody);

    float angle = this.pBody.getAngle();

    pushMatrix();
    translate(ballPos.x, ballPos.y);
    rotate(-angle);
    shape(pShape);
    popMatrix();
  }
  void collide(Ball ball, color ballColor, Vec2 normal)
  {
    // Physically bump the ball away
    ball.bumpAway(100, normal); 


    // Create a new thread
    Thread resetBumper = new Thread()
    {
      @Override
        public void run()
      {
        // Wait one second and change
        // The color back to it's original color
        delay(250);
        fillColor = resetColor;
        inThread = false;
      }
    };

    if (!inThread)
    {
      inThread = true;

      // Store the current color
      this.resetColor = fillColor;

      // Change the current color
      this.fillColor = ballColor;

      //// Set volume to max
      //gainValue.setValue(1.0f);

      //// Reset the scrubber on the sound to start position
      //dingSound.setToLoopStart();

      //// Play the ding sound!
      //dingSound.start();

      // Run the new thread
      resetBumper.start();
    }

    // Add to Player Score
    playerScore += 10;
  }
}
