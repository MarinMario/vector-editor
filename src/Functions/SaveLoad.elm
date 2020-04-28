module Functions.SaveLoad exposing (..)

import File.Download as Download

import CustomTypes exposing (Model, Msg(..))

import Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

downloadSvg : Model -> Cmd Msg
downloadSvg model =
    Download.string "svgeditor.svg" "image/svg+xml" (convertShapeDataToString model)