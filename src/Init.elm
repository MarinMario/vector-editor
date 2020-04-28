module Init exposing (..)

import CustomTypes exposing (..)

init : flags -> (Model, Cmd Msg)
init _ =
    ( Model (1, 1) 
        [initShape] 1 1
        (InputShapeData "0" "0" "50" "50" "blue" "0 0" "1" "5" "black" "This is a label" "800" "600")
        1.5 None Nothing (800, 600)
    , Cmd.none
    )

initPoints = [PolylinePoint 1 20 20, PolylinePoint 2 100 100]

initShape : ShapeData
initShape = 
    { shapeType = Rect
    , position = (50, 50)
    , followMouse = False
    , id = 1
    , size = (50, 50)
    , updateSize = (False, False)
    , fillColor = "grey"
    , points = initPoints
    , updatePoint = Nothing
    , zIndex = 1
    , strokeWidth = 5
    , strokeColor = "black"
    , hovered = False
    , labelText = "This is a label"
    }