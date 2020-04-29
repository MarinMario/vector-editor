module CustomTypes exposing (..)

import File exposing (File)
type alias Model =
    { mousePosition : (Float, Float)
    , shapes : List ShapeData
    , lastId : Int
    , selectedShape : Int
    , inputShapeData : InputShapeData
    , nextPoint : Float
    , tab : Tab
    , hoveredTab : Maybe Tab
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
    | HoverTab (Maybe Tab)
    | InputSvgData InputSvgProperty String
    | SaveModel
    | RequestFile File
    | LoadModel String
    | OpenFile

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
    | Properties
    | Save

type alias SvgProps =
    { width : Float
    , height : Float
    , color : String
    , updateSize : Bool
    }