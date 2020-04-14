module CustomTypes exposing (..)

type alias Model =
    { mousePosition : Position
    , shapes : List ShapeData
    , lastId : Int
    , selectedShape : Int
    , inputShapeData : InputShapeData
    }
type alias Position = (Float, Float)

type alias InputShapeData =
    { xPos : String
    , yPos : String
    , width : String
    , height : String
    , fillColor : String
    }

type Msg
    = MoveMouse Position
    | EditShape ShapeData
    | NewShape ShapeType
    | InputSelectedShape Int
    | InputData String String
    | StopDrag


type alias ShapeData =
    { shapeType : ShapeType 
    , position : Position
    , followMouse : Bool
    , id : Int
    , size : (Float, Float)
    , updateSize : (Bool, Bool)
    , fillColor : String
    }

type ShapeType
    = Rect
    | Ellipse