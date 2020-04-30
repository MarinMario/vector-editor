module Functions.ConvertShapeDataToString exposing (convertShapeDataToString)

import CustomTypes exposing (Model, ShapeType(..))

import Functions.BasicsShape exposing (shapeProps, orderShapes)

import Functions.BasicsPoints exposing (convertPointsToString)

convertShapeDataToString : Model -> String
convertShapeDataToString model =
    let inQuotes val = "'" ++ val ++ "'"
        shapeStringList =
            List.map (\shapeData ->
                let p = shapeProps shapeData
                    x = inQuotes <| String.fromFloat p.xPos
                    y = inQuotes <| String.fromFloat p.yPos
                    w = inQuotes <| String.fromFloat p.width
                    h = inQuotes <| String.fromFloat p.height
                    c = inQuotes <| p.fillColor
                    sw = inQuotes <| String.fromFloat p.strokeWidth
                    sc = inQuotes <| p.strokeColor
                    points = inQuotes <| convertPointsToString shapeData
                    labelText = shapeData.labelText
                    fontSize = inQuotes <| String.fromFloat p.width ++ "px"

                in
                case shapeData.shapeType of
                    Rect ->
                        "<rect" ++
                            " x=" ++ x ++
                            " y=" ++ y ++
                            " width=" ++ w ++
                            " height=" ++ h ++
                            " fill=" ++ c ++
                            " stroke=" ++ sc ++
                            " stroke-width=" ++ sw ++ 
                        " />"
                    Ellipse -> 
                        "<ellipse" ++
                            " cx=" ++ x ++
                            " cy=" ++ y ++
                            " rx=" ++ w ++
                            " ry=" ++ h ++
                            " fill=" ++ c ++
                            " stroke=" ++ sc ++
                            " stroke-width=" ++ sw ++
                        " />"
                    Polyline ->
                        "<polyline" ++
                            " points=" ++ points ++
                            " stroke=" ++ sc ++
                            " fill=" ++ c ++
                            " stroke-width=" ++ sw ++
                        " />"
                    Polygon ->
                        "<polygon" ++
                            " points=" ++ points ++
                            " stroke=" ++ sc ++
                            " fill=" ++ c ++
                            " stroke-width=" ++ sw ++
                        " />"
                    Label ->
                        "<text" ++
                            " x=" ++ x ++
                            " y=" ++ y ++
                            " stroke=" ++ sc ++
                            " fill=" ++ c ++
                            " stroke-width=" ++ sw ++
                            " font-size=" ++ fontSize ++
                        " >" ++ "\n" ++
                            labelText ++ "\n" ++
                        "</text>"
                    NoShape -> ""
            
            ) <| orderShapes model.shapes
    
        svgWidth =
            model.svgProps.width
                |> String.fromFloat
                |> inQuotes
            
        svgHeight =
            model.svgProps.height
                |> String.fromFloat
                |> inQuotes
    in
    "<svg width=" ++ svgWidth ++ 
        " height=" ++ svgHeight ++ 
        " xmlns='http://www.w3.org/2000/svg'>" ++ "\n" ++
        String.join "\n" shapeStringList ++ "\n" ++
    "</svg>"

