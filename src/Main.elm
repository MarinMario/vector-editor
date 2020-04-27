module Main exposing (main)

import Browser

import CustomTypes exposing (..)
import HelperFunctions exposing (..)

import View exposing (view)
import Update exposing (update)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

init : flags -> (Model, Cmd Msg)
init _ =
    ( Model (1, 1) 
        [initShape] 1 1
        (InputShapeData "0" "0" "50" "50" "blue" "0 0" "1" "5" "black")
        1.5 None
    , Cmd.none 
    )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none