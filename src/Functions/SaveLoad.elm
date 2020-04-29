module Functions.SaveLoad exposing (..)

import File.Select as Select
import File.Download as Download

import Json.Encode as Enc
import Json.Decode as Dec
import Json.Decode.Pipeline as Jdp

import CustomTypes exposing (..)
import Init exposing (initShape)

import Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

type alias EncodedModel =
    { lastId : Int
    , shapes : List EncodedShape
    , nextPoint : Float
    }

type alias EncodedShape =
    { shapeType : String
    , positionx : Float
    , positiony : Float
    , sizex : Float
    , sizey : String
    , fillColor : String
    , zIndex : Int
    , strokeWidth : Float
    , strokeColor : String
    , labelText : String
    }

downloadSvg : Model -> Cmd Msg
downloadSvg model =
    Download.string "svgeditor.svg" "image/svg+xml" (convertShapeDataToString model)

encodeModel : Model -> Enc.Value
encodeModel model =
    Enc.object 
        [ ("lastId", Enc.int model.lastId)
        , ("nextPoint", Enc.float model.nextPoint)
        , ("svgProps", encodeSvgProps model.svgProps)
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

encodePoints point =
    [ ("order", Enc.float point.order)
    , ("x", Enc.float point.x)
    , ("y", Enc.float point.y)
    ]

encodeSvgProps : SvgProps -> Enc.Value
encodeSvgProps svgProps =
    Enc.object
        [ ("width", Enc.float svgProps.width)
        , ("height", Enc.float svgProps.height)
        ]

downloadModel : Model -> Cmd Msg
downloadModel model =
    Enc.encode 4 (encodeModel model)
        |> Download.string "svgeditor.json" "text/json"

-- decoderModel : Dec.Decoder EncodedModel
-- decoderModel =
--     Dec.succeed EncodedModel
--         |> Jdp.required "lastId" Dec.int
--         |> 

-- decoderShape : Dec.Decoder EncodedShape
-- decoderShape =
--     Dec.succeed EncodedShape
--         |> Jdp.required "shapeType" Dec.string
--         |> Jdp.required "positionx" Dec.float
--         |> Jdp.required "positiony" Dec.float
--         |> Jdp.required "id" Dec.int
--         |> Jdp.required "sizex" Dec.float
--         |> Jdp.required "sizey" Dec.float
--         |> Jdp.required "fillColor" Dec.string

-- loadModel encodedModel =
--     Dec.decodeString decoderModel encodedModel

-- selectFile : Cmd Msg
-- selectFile =
--     Select.file ["text/json"] RequestFile