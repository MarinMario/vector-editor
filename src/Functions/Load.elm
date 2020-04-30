
module Functions.Load exposing (..)

import File.Select as Select
import File.Download as Download

import Json.Encode as Enc
import Json.Decode as Dec
import Json.Decode.Extra as Jde

import CustomTypes exposing (..)
import Init exposing (initShape)

import Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

type alias EncodedModel =
    { lastId : Int
    , shapes : List EncodedShape
    , nextPoint : Float
    , svgProps : EncodedSvgProps
    }

type alias EncodedShape =
    { shapeType : String
    , positionx : Float
    , positiony : Float
    , sizex : Float
    , sizey : Float
    , fillColor : String
    , zIndex : Int
    , strokeWidth : Float
    , strokeColor : String
    , labelText : String
    , points : List PolylinePoint
    , id : Int
    }

type alias EncodedSvgProps =
    { width : Float
    , height : Float
    , name : String
    }

decodeModel : Dec.Decoder EncodedModel
decodeModel =
    Dec.succeed EncodedModel
        |> Jde.andMap (Dec.field "lastId" Dec.int)
        |> Jde.andMap (Dec.field "shapes" (Dec.list decodeShape))
        |> Jde.andMap (Dec.field "nextPoint" Dec.float)
        |> Jde.andMap (Dec.field "svgProps" decodeSvgProps)

decodeShape : Dec.Decoder EncodedShape
decodeShape =
    Dec.succeed EncodedShape
        |> Jde.andMap (Dec.field "shapeType" Dec.string)
        |> Jde.andMap (Dec.field "positionx" Dec.float)
        |> Jde.andMap (Dec.field "positiony" Dec.float)
        |> Jde.andMap (Dec.field "sizex" Dec.float)
        |> Jde.andMap (Dec.field "sizey" Dec.float)
        |> Jde.andMap (Dec.field "fillColor" Dec.string)
        |> Jde.andMap (Dec.field "zIndex" Dec.int)
        |> Jde.andMap (Dec.field "strokeWidth" Dec.float)
        |> Jde.andMap (Dec.field "strokeColor" Dec.string)
        |> Jde.andMap (Dec.field "labelText" Dec.string)
        |> Jde.andMap (Dec.field "points" (Dec.list decodePoints))
        |> Jde.andMap (Dec.field "id" Dec.int)

decodePoints =
    Dec.succeed PolylinePoint
        |> Jde.andMap (Dec.field "order" Dec.float)
        |> Jde.andMap (Dec.field "x" Dec.float)
        |> Jde.andMap (Dec.field "y" Dec.float)

decodeSvgProps =
    Dec.succeed EncodedSvgProps
        |> Jde.andMap (Dec.field "width" Dec.float)
        |> Jde.andMap (Dec.field "height" Dec.float)
        |> Jde.andMap (Dec.field "name" Dec.string)

loadModel encodedModel =
    Dec.decodeString decodeModel encodedModel

selectFile : Cmd Msg
selectFile =
    Select.file ["text/json"] RequestFile