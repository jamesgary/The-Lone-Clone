# Wrap around your external dependencies!
define ['vendor/Box2dWeb-2.1.a.3', 'lib/gameLoop'], (Box2D, gameLoop) ->
  b2Vec2         = Box2D.Common.Math.b2Vec2
  b2BodyDef      = Box2D.Dynamics.b2BodyDef
  b2Body         = Box2D.Dynamics.b2Body
  b2FixtureDef   = Box2D.Dynamics.b2FixtureDef
  b2Fixture      = Box2D.Dynamics.b2Fixture
  b2World        = Box2D.Dynamics.b2World
  b2MassData     = Box2D.Collision.Shapes.b2MassData
  b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
  b2CircleShape  = Box2D.Collision.Shapes.b2CircleShape
  b2DebugDraw    = Box2D.Dynamics.b2DebugDraw
  {
    setupCanvas: (canvas) ->
      @world = new b2World(new b2Vec2(0, 10), true) #allow sleep
      @setupDebugDraw(canvas)
    createGround: ->
      @fixDef = new b2FixtureDef
      @fixDef.density = 1.0
      @fixDef.friction = 0.5
      @fixDef.restitution = 0.2
      @bodyDef = new b2BodyDef

      #create ground
      @bodyDef.type = b2Body.b2_staticBody
      @bodyDef.position.x = 10
      @bodyDef.position.y = 13
      @fixDef.shape = new b2PolygonShape
      @fixDef.shape.SetAsBox 8, 0.5
      @world.CreateBody(@bodyDef).CreateFixture @fixDef

    generateObjects: ->
      @bodyDef.type = b2Body.b2_dynamicBody
      objectCount = 50
      while objectCount--
        @fixDef.shape = new b2CircleShape((Math.random() * .5) + .5) #radius
        @bodyDef.position.x = Math.random() * 20
        @bodyDef.position.y = Math.random() * 10
        @world.CreateBody(@bodyDef).CreateFixture @fixDef
    createPlayer: ->
      @bodyDef.type = b2Body.b2_dynamicBody

      @fixDef.shape = new b2CircleShape((Math.random() * .5) + .5) #radius
      @bodyDef.position.x = 5 + Math.random() * 10
      @bodyDef.position.y = Math.random() * 10
      @player = @world.CreateBody(@bodyDef)
      @player.CreateFixture @fixDef
      @player
    go: ->
      gameLoop.loopThis(this, 'update')
    cloneRight: ->
      @bodyDef.type = b2Body.b2_dynamicBody
      @fixDef.shape = new b2CircleShape((Math.random() * .5) + .5) #radius
      window.p = @player
      @bodyDef.position.x = @player.GetPosition().x - .10
      @bodyDef.position.y = @player.GetPosition().y
      clone = @world.CreateBody(@bodyDef)
      clone.CreateFixture @fixDef

    ###########
    # private #
    ###########

    update: ->
      @world.Step(1 / 60, 10, 10)
      @world.DrawDebugData()
      @world.ClearForces()
      #if Math.random() > .95
      #  @fixDef.shape = new b2CircleShape((Math.random() * .5) + .2) #radius
      #  @bodyDef.position.x = 10
      #  @bodyDef.position.y = 0
      #  @world.CreateBody(@bodyDef).CreateFixture @fixDef
    setupDebugDraw: (canvas) ->
      debugDraw = new b2DebugDraw()
      debugDraw.SetSprite(canvas.getContext("2d"))
      debugDraw.SetDrawScale 30.0
      debugDraw.SetFillAlpha 0.3
      debugDraw.SetLineThickness 1.0
      debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit)
      @world.SetDebugDraw debugDraw
  }
