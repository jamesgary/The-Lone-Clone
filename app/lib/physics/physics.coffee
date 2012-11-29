# Wrap around your external dependencies!
define ['box2d'], (Box2D) ->
  debugDrawing = true
  b2Vec2         = Box2D.Common.Math.b2Vec2
  b2BodyDef      = Box2D.Dynamics.b2BodyDef
  b2Body         = Box2D.Dynamics.b2Body
  b2FixtureDef   = Box2D.Dynamics.b2FixtureDef
  b2Fixture      = Box2D.Dynamics.b2Fixture
  b2World        = Box2D.Dynamics.b2World
  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
  b2EdgeShape    = Box2D.Collision.Shapes.b2EdgeShape
  b2CircleShape  = Box2D.Collision.Shapes.b2CircleShape
  b2DebugDraw    = Box2D.Dynamics.b2DebugDraw
  {
    createWorld: ->
      gravity = new b2Vec2(0, 10)
      @world = new b2World(gravity, true) #allow sleep
      @setupDebugDraw(document.getElementById('canvas')) if debugDrawing
      @fixDef = new b2FixtureDef
      @fixDef.density = 1.0
      @fixDef.friction = 0.5
      @fixDef.restitution = 0.2
      @bodyDef = new b2BodyDef

    addStaticPolygon: (vertices) ->
      @bodyDef.type = b2Body.b2_staticBody
      @fixDef.shape = new b2PolygonShape
      vecs = for vertice in vertices
        vec = new b2Vec2
        vec.Set(vertice.x, vertice.y)
        vec
      @fixDef.shape.SetAsArray(vecs, vecs.length)
      @bodyDef.position.x = 0
      @bodyDef.position.y = 0
      b = @world.CreateBody(@bodyDef)
      b.CreateFixture(@fixDef)
      b

    addCircle: (circle) ->
      @createCircle(circle, b2Body.b2_dynamicBody)

    addStaticCircle: (circle) ->
      @createCircle(circle, b2Body.b2_staticBody)

    addStaticCircle: (circle) ->
      @createCircle(circle, b2Body.b2_staticBody)

    setListeners: (preCollision, postCollision) ->
      listener = new Box2D.Dynamics.b2ContactListener
      listener.PreSolve = (contact) ->
        a = contact.GetFixtureA().GetBody().userdata
        b = contact.GetFixtureB().GetBody().userdata
        unless preCollision(a, b)
          contact.SetEnabled(false)
      listener.PostSolve = (contact) ->
        a = contact.GetFixtureA().GetBody().userdata
        b = contact.GetFixtureB().GetBody().userdata
        postCollision(a, b)
      @world.SetContactListener(listener)

    freeze: (body) ->
      body.SetType(b2Body.b2_staticBody)

    update: ->
      @world.Step(
        1 / 60 # framerate
        10 # velocity iterations
        10 # position iterations
      )
      @world.DrawDebugData() if debugDrawing
      @world.ClearForces()

    ###########
    # private #
    ###########

    createCircle: (circle, bodyDefType) ->
      @bodyDef.type = bodyDefType
      @fixDef.shape = new b2CircleShape(circle.r)
      @bodyDef.position.x = circle.x
      @bodyDef.position.y = circle.y
      body = @world.CreateBody(@bodyDef)
      body.CreateFixture(@fixDef)
      body

    setupDebugDraw: (canvas) ->
      if canvas
        debugDraw = new b2DebugDraw()
        debugDraw.SetSprite(canvas.getContext("2d"))
        debugDraw.SetDrawScale 30.0
        debugDraw.SetFillAlpha 0.3
        debugDraw.SetLineThickness 1.0
        debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit)
        @world.SetDebugDraw debugDraw
    # for some crazy reason, Contact is made when two boxes collide (not just the polygon edges)
    #addStaticLine: (vertices) ->
    #  # b2EdgeShape isn't supported in Box2d: https://code.google.com/p/box2dweb/issues/detail?id=31
    #  # So fudge it with a third point to make a flat triangle
    #  @bodyDef.type = b2Body.b2_staticBody
    #  @fixDef.shape = new b2PolygonShape
    #  vecs = for vertice in vertices
    #    vec = new b2Vec2
    #    vec.Set(vertice.x, vertice.y)
    #    vec
    #  fudge = -1.01
    #  fudgedVec = new b2Vec2
    #  fudgedVec.Set(
    #    vecs[1].x + fudge
    #    vecs[1].y + fudge
    #  )
    #  vecs.push(fudgedVec)
    #  @fixDef.shape.SetAsArray(vecs, vecs.length)
    #  @bodyDef.position.x = 0
    #  @bodyDef.position.y = 0
    #  b = @world.CreateBody(@bodyDef)
    #  b.CreateFixture(@fixDef)
    #  b
  }
