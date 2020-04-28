module Main exposing (main)

import Browser

import Init exposing (init)
import View exposing (view)
import Update exposing (update)

import CustomTypes exposing (Model, Msg)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none