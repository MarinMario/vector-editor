module HelperFunctions exposing (..)

import CustomTypes exposing (..)

dragShape : Model -> List ShapeData
dragShape model =
    List.map (\shape -> 
        let
            mousex = Tuple.first model.mousePosition
            mousey = Tuple.second model.mousePosition
            shapex = Tuple.first shape.position
            shapey = Tuple.second shape.position
            shapew = Tuple.first shape.size
            shapeh = Tuple.second shape.size
            newSize =
                ( mousex - shapex
                , mousey - shapey
                )
            newPosition = 
                ( mousex - shapew / 2
                , mousey - shapeh / 2
                )
        in
        { shape
        | position =
            if shape.followMouse then newPosition else shape.position
        , size =
            if shape.updateSize then newSize else shape.size
        }) model.shapes