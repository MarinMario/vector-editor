module CustomTypes exposing (..)

type alias Model =
    { mousePosition : (Float, Float)
    , shapes : List ShapeData
    , lastId : Int
    , selectedShape : Int
    , inputShapeData : InputShapeData
    , nextPoint : Float
    , tab : Tab
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
    | InputData InputProperty String
    | StopDrag
    | AddNewPoint Float
    | DeleteSelectedShapes
    | DuplicateSelectedShapes
    | DeleteLinePoints Float
    | DownloadSvg
    | ChangeTab Tab

type alias ShapeData =
    { shapeType : ShapeType 
    , position : (Float, Float)
    , followMouse : Bool
    , id : Int
    , size : (Float, Float)
    , updateSize : (Bool, Bool)
    , fillColor : String
    , points : List PolylinePoint
    , updatePoint : Maybe Float
    , zIndex : Int
    , strokeWidth : Float
    , strokeColor : String
    , hovered : Bool
    }

type alias PolylinePoint =
        { order : Float
        , x : Float
        , y : Float 
        }

type ShapeType
    = Rect
    | Ellipse
    | Polyline
    | Polygon

type InputProperty 
    = Xpos
    | Ypos
    | Width
    | Height
    | FillColor
    | Zindex
    | StrokeWidth
    | StrokeColor
    | Points

type Tab
    = None
    | Properties