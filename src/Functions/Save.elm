module Functions.Save exposing (..)

import File.Select as Select
import File.Download as Download

import Json.Encode as Enc
import Json.Decode as Dec

import CustomTypes exposing (..)
import Init exposing (initShape)

import Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

downloadSvg : Model -> Cmd Msg
downloadSvg model =
    Download.string (model.svgProps.name ++ ".svg") "image/svg+xml" (convertShapeDataToString model)

encodeModel : Model -> Enc.Value
encodeModel model =
    Enc.object 
        [ ("lastId", Enc.int model.lastId)
        , ("nextPoint", Enc.float model.nextPoint)
        , ("svgProps", Enc.object <| encodeSvgProps model.svgProps)
        , ("shapes", encodeList encodeShape model.shapes)
        ]

encodeList encoder list =
    Enc.list Enc.object
        <| List.map (\el -> encoder el) list

convertShapeTypeToString : ShapeType -> String
convertShapeTypeToString shapeType =
    case shapeType of
        Rect -> "Rect"
        Ellipse -> "Ellipse"
        Polyline -> "Polyline"
        Polygon -> "Polygon"
        Label -> "Label"
        Selector -> "Selector"


encodeShape : ShapeData -> List (String, Enc.Value)
encodeShape shape =
    [ ("shapeType", Enc.string <| convertShapeTypeToString shape.shapeType )
    , ("positionx", Enc.float <| Tuple.first shape.position)
    , ("positiony", Enc.float <| Tuple.second shape.position)
    , ("id", Enc.int shape.id)
    , ("sizex", Enc.float <| Tuple.first shape.size)
    , ("sizey", Enc.float <| Tuple.second shape.size)
    , ("fillColor", Enc.string shape.fillColor)
    , ("zIndex", Enc.int shape.zIndex)
    , ("strokeWidth", Enc.float shape.strokeWidth)
    , ("strokeColor", Enc.string shape.strokeColor)
    , ("labelText", Enc.string shape.labelText)
    , ("points", encodeList encodePoints shape.points)
    ]

encodePoints : PolylinePoint -> List (String, Enc.Value)
encodePoints point =
    [ ("order", Enc.float point.order)
    , ("x", Enc.float point.x)
    , ("y", Enc.float point.y)
    ]

encodeSvgProps : SvgProps -> List (String, Enc.Value)
encodeSvgProps svgProps =
    [ ("width", Enc.float svgProps.width)
    , ("height", Enc.float svgProps.height)
    , ("name", Enc.string svgProps.name)
    ]

downloadModel : Model -> Cmd Msg
downloadModel model =
    Enc.encode 4 (encodeModel model)
        |> Download.string (model.svgProps.name ++ ".json") "text/json"

