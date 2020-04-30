module Functions.Drag exposing (..)

import CustomTypes exposing (Model, ShapeData, ShapeType(..), SvgProps)

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
            tff = toFloat << floor
            newSize =
                if newSizeX > 10 && newSizeY > 10 then
                    ( tff newSizeX, tff newSizeY)
                else if newSizeX > 10 && newSizeY < 10 then
                    ( tff newSizeX, 10)
                else if newSizeX < 10 && newSizeY > 10 then
                    (10, tff newSizeY)
                else (10, 10)

            newPosition =
                case shape.shapeType of
                    Rect ->
                        ( tff <| mousex - shapew / 2
                        , tff <| mousey - shapeh / 2
                        )
                    Label ->
                        ( tff <| mousex + 10
                        , tff <| mousey + 10
                        )
                    _ -> (tff mousex, tff mousey)

            updatedPoints =
                case shape.updatePoint of
                    Just one ->
                        List.map (\point ->
                            if point.order == one then
                                { point | x = tff mousex, y = tff mousey }
                            else point
                        ) shape.points
                    Nothing -> shape.points
        in
        { shape
        | position =
            if shape.followMouse then newPosition 
            else shape.position
        , size = 
            ( if Tuple.first shape.updateSize then Tuple.first newSize else Tuple.first shape.size
            , if Tuple.second shape.updateSize then Tuple.second newSize else Tuple.second shape.size
            )
        , points = updatedPoints
        }) model.shapes

dragSvgSize : Model -> SvgProps
dragSvgSize model =
    let sp = model.svgProps

        updatedWidth = Tuple.first model.mousePosition + 5
        updatedHeight = Tuple.second model.mousePosition + 5
    in
    { sp
    | width = if sp.updateSize then updatedWidth else model.svgProps.width
    , height = if sp.updateSize then updatedHeight else model.svgProps.height
    }
    