let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.14-20240213/packages.dhall
        sha256:c7196e3a5895098b1bf108c8210429b658d2baaa6c188879d75effc293ffe45f

let overrides = {=}

let additions = 
  {
    react-map-gl =
    { dependencies = [ "prelude", "react", "web-mercator", "simple-json" ]
    , repo = "https://github.com/f-o-a-m/purescript-react-map-gl.git"
    , version = "purs-0.15"
    }
  , map-gl =
    { dependencies =
      [ "aff", "aff-bus", "effect", "prelude", "react-dom", "web-mercator" ]
    , repo = "https://github.com/f-o-a-m/purescript-react-map-gl.git"
    , version = "purs-0.15"
    }
  , deck-gl =
    { dependencies =
      [ "effect"
      , "foreign"
      , "foreign-object"
      , "prelude"
      , "psci-support"
      , "web-mercator"
      , "react-dom"
      ]
    , repo = "https://github.com/f-o-a-m/purescript-deck-gl.git"
    , version = "purs-0.15"
    }
  , web-mercator =
    { dependencies = [ "partial", "prelude", "functions" ]
    , repo = "https://github.com/f-o-a-m/purescript-web-mercator.git"
    , version = "purs-0.15"
    }
  }

in  upstream // overrides // additions
