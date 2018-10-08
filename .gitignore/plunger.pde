class Plunger extends Drawable
{
  Body baseBody;
  Body headBody;

  float width, height;

  Plunger(Vec2 position)
  {
    this.width = 45;
    this.height = 10;

    // Create shape
    PolygonShape shape = new PolygonShape();
    float b2Width = box2d.scalarPixelsToWorld(width/2);
    float b2Height = box2d.scalarPixelsToWorld(height/2);
    shape.setAsBox(b2Width, b2Height);

    // Create circle fixture
    FixtureDef headFixture = new FixtureDef();
    headFixture.shape = shape;
    headFixture.density = 1.0f;

    // Define physics body
    BodyDef headBodyDef = new BodyDef();
    headBodyDef.type = BodyType.DYNAMIC;
    headBodyDef.position.set(box2d.coordPixelsToWorld(position));
    headBodyDef.setFixedRotation(true);

    // Add body to world
    this.headBody = box2d.createBody(headBodyDef);
    this.headBody.createFixture(headFixture);

    // Create circle fixture
    PolygonShape baseShape = new PolygonShape();
    baseShape.setAsBox(b2Width, b2Height);

    // Define physics body
    BodyDef baseBodyDef = new BodyDef();
    baseBodyDef.type = BodyType.STATIC;
    baseBodyDef.position.set(box2d.coordPixelsToWorld(new Vec2(position.x, position.y + 60)));
    baseBodyDef.setFixedRotation(true);

    // Add body to world
    this.baseBody = box2d.createBody(baseBodyDef);
    this.baseBody.createFixture(baseShape, 1);

    // Create spring joint
    DistanceJointDef springJoint = new DistanceJointDef();
    springJoint.frequencyHz = 4;
    springJoint.dampingRatio = 0.1;
    springJoint.collideConnected = true;

    // add spring joint to world
    springJoint.initialize(headBody, baseBody, headBody.getPosition(), baseBody.getPosition());
    box2d.createJoint(springJoint);


    // set the callback data to this instance
    this.headBody.setUserData(this);
    this.baseBody.setUserData(this);
  }
  void render()
  {
    super.render();

    Vec2 headPos = box2d.getBodyPixelCoord(this.headBody);

    float angle = this.headBody.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(headPos.x, headPos.y);
    rotate(-angle);
    rect(0, 0, width, height);
    popMatrix();
  }
  void pullPlunger()
  {
    headBody.applyForce(new Vec2(0, -10000), headBody.getPosition());
  }
}
