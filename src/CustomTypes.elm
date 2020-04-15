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
    , zIndex : String
    , strokeWidth : String
    , strokeColor : String
    }

type Msg
    = MoveMouse (Float, Float)
    | EditShape ShapeData
    | NewShape ShapeType
    | InputSelectedShape Int
    | InputData String String
    | StopDrag
    | AddNewPoint
    | DeleteSelectedShapes
    | DuplicateSelectedShapes


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
    , zIndex : Int
    , strokeWidth : Float
    , strokeColor : String
    }

type ShapeType
    = Rect
    | Ellipse
    | Polyline