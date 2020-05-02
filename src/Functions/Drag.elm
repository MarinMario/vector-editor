module Functions.Drag exposing (..)

import CustomTypes exposing (Model, ShapeData, ShapeType(..), SvgProps, PolylinePoint)

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

            init = 
                Maybe.withDefault (PolylinePoint 1 0 0) 
                    <| List.head shape.points
            newSizeX = tff <| abs <| mousex - init.x
            newSizeY = tff <| abs <| mousey - init.y
            tff = toFloat << floor
            
            posifSize =
                case shape.shapeType of
                    Rect ->
                        if init.x > mousex && init.y > mousey then
                            (tff mousex, tff mousey)
                        else if init.x < mousex && init.y > mousey then
                            (tff init.x, tff mousey)
                        else if init.x > mousex && init.y < mousey then
                            (tff mousex, tff init.y)
                        else (tff init.x, tff init.y)
                    _ -> (tff init.x, tff init.y)


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
            else if Tuple.first shape.updateSize || Tuple.second shape.updateSize
            then posifSize
            else shape.position
        , size = 
            ( if Tuple.first shape.updateSize then newSizeX else Tuple.first shape.size
            , if Tuple.second shape.updateSize then newSizeY else Tuple.second shape.size
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
    