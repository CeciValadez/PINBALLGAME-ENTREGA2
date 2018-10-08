class Ball extends Drawable
{
  // Box2D body
  Body pBody; 

  float diameter;

  Vec2 startPos;

  Ball(float diameter, Vec2 position)
  {
    --ballCount;
    this.startPos = position;
    this.diameter = diameter;

    // Create circle shape
    CircleShape shape = new CircleShape();
    shape.m_radius = box2d.scalarPixelsToWorld(diameter/2);

    // Create circle fixture
    FixtureDef fixture = new FixtureDef();
    fixture.shape = shape;
    fixture.density = 1.0f;
    fixture.restitution = 0.5f;

    // Define physics body
    BodyDef bodyDef = new BodyDef();
    bodyDef.type = BodyType.DYNAMIC;
    bodyDef.position.set(box2d.coordPixelsToWorld(position));

    // Add body to world
    this.pBody = box2d.createBody(bodyDef);
    this.pBody.createFixture(fixture);
    this.pBody.isBullet();

    // set the callback data to this instance
    this.pBody.setUserData(this);
  }

  void render()
  {
    super.render();

    Vec2 ballPos = box2d.getBodyPixelCoord(this.pBody);

    float angle = this.pBody.getAngle();

    pushMatrix();
    translate(ballPos.x, ballPos.y);
    rotate(-angle);
    ellipse(0, 0, diameter, diameter);
    line(0, 0, 0, diameter/2);
    popMatrix();
  }
  void bumpAway(float amount, Vec2 normal)
  {
    normal.normalize();
    Vec2 pushForce = normal.mul(-amount);
    this.pBody.applyLinearImpulse(pushForce, this.pBody.getPosition(), true);
  }
  boolean offScreen()
  {
    Vec2 ballPos = box2d.getBodyPixelCoord(this.pBody);

    return ballPos.y > height;
  }
}
