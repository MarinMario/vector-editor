module Functions.CustomEvents exposing (..)
 
import Html.Events as He

import Json.Decode as Decode

onRightClick msg =
    He.preventDefaultOn "contextmenu" (Decode.succeed msg)