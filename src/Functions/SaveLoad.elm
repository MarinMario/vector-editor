module Functions.SaveLoad exposing (..)

import File.Select as Select
import File.Download as Download

import Json.Encode as Enc
import Json.Decode as Dec
import Json.Decode.Pipeline as Jdp

import CustomTypes exposing (Model, Msg(..), EncodedModel)

import Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

downloadSvg : Model -> Cmd Msg
downloadSvg model =
    Download.string "svgeditor.svg" "image/svg+xml" (convertShapeDataToString model)

encodeModel : Model -> Enc.Value
encodeModel model =
    Enc.object 
        [ ("lastId", Enc.int model.lastId)
        , ("selectedShape", Enc.int model.selectedShape)
        ]

downloadModel : Model -> Cmd Msg
downloadModel model =
    Enc.encode 4 (encodeModel model)
        |> Download.string "svgeditor.json" "text/json"

decoderModel : Dec.Decoder EncodedModel
decoderModel =
    Dec.succeed EncodedModel
        |> Jdp.required "lastId" Dec.int
        |> Jdp.required "selectedShape" Dec.int

loadModel encodedModel =
    Dec.decodeString decoderModel encodedModel

selectFile : Cmd Msg
selectFile =
    Select.file ["text/json"] RequestFile