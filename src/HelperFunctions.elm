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

            newSizeX = mousex - shapex
            newSizeY = mousey - shapey
            newSize =
                if newSizeX > 10 && newSizeY > 10 then
                    (newSizeX, newSizeY)
                else if newSizeX > 10 && newSizeY < 10 then
                    (newSizeX, 10)
                else if newSizeX < 10 && newSizeY > 10 then
                    (10, newSizeY)
                else (10, 10)

            newPosition =
                case shape.shapeType of
                    Rect -> 
                        ( mousex - shapew / 2
                        , mousey - shapeh / 2
                        )
                    Ellipse -> 
                        ( mousex, mousey )
        in
        { shape
        | position =
            if shape.followMouse then newPosition else shape.position
        , size = 
            ( if Tuple.first shape.updateSize then Tuple.first newSize else Tuple.first shape.size
            , if Tuple.second shape.updateSize then Tuple.second newSize else Tuple.second shape.size
            )
        }) model.shapes