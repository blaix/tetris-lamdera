module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , playArea : PlayArea
    , block : Block
    , frameDelta : Float
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | Tick Float


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend


type alias PlayArea =
    { width : Int
    , height : Int
    }


type alias Block =
    { width : Int
    , height : Int
    , x : Int
    , y : Int
    }
