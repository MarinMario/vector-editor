module CustomTypes exposing (..)

type alias Model =
    { mousePosition : (Float, Float)
    , shapes : List ShapeData
    , lastId : Int
    , selectedShape : Int
    , inputShapeData : InputShapeData
    }

type alias InputShapeData =
    { xPos : String
    , yPos : String
    , width : String
    , height : String
    , fillColor : String
    , points : String
    }

type Msg
    = MoveMouse (Float, Float)
    | EditShape ShapeData
    | NewShape ShapeType
    | InputSelectedShape Int
    | InputData String String
    | StopDrag
    | AddNewPoint
    | DeleteSelectedShape


type alias ShapeData =
    { shapeType : ShapeType 
    , position : (Float, Float)
    , followMouse : Bool
    , id : Int
    , size : (Float, Float)
    , updateSize : (Bool, Bool)
    , fillColor : String
    , points : List (List Float)
    , updatePoints : Maybe Int
    }

type ShapeType
    = Rect
    | Ellipse
    | Polyline