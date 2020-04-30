module CustomTypes exposing (..)

import File exposing (File)
type alias Model =
    { mousePosition : (Float, Float)
    , shapes : List ShapeData
    , lastId : Int
    , selectedShape : Int
    , inputShapeData : InputShapeData
    , nextPoint : Float
    , selectHover : SelectHover
    , svgProps : SvgProps
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
    , labelText : String
    }

type Msg
    = MoveMouse (Float, Float)
    | EditShape ShapeData
    | NewShape (Maybe ShapeType)
    | InputSelectedShape Int
    | InputData InputProperty String
    | StopDrag
    | AddNewPoint Float
    | DeleteSelectedShapes
    | DuplicateSelectedShapes
    | DeleteLinePoints Float
    | DownloadSvg
    | InputSvgData InputSvgProperty String
    | SaveModel
    | RequestFile File
    | LoadModel String
    | OpenFile
    | EditModel Model

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
    , labelText : String
    , rotation : Float
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
    | Label
    | NoShape

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
    | LabelText

type InputSvgProperty
    = SvgWidth
    | SvgHeight
    | SvgColor
    | UpdateSize

type Tab
    = None
    | Canvas
    | Tools
    | Properties
    | Save

type alias SvgProps =
    { width : Float
    , height : Float
    , color : String
    , updateSize : Bool
    }

type alias SelectHover =
    { tab : Tab
    , hoveredTab : Maybe Tab
    , shape : ShapeType
    , hoveredShape : Maybe ShapeType
    }