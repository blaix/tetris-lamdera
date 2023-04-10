module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Events as Events
import Browser.Navigation as Nav
import Element as E
import Element.Background as Bg
import Element.Border as Border
import Lamdera
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init _ key =
    ( { key = key
      , playArea = { width = 800, height = 1004 } -- height is multiple of block height + borders
      , block = { width = 150, height = 20, x = 200, y = 0 }
      , frameDelta = 0
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged _ ->
            ( model, Cmd.none )

        Tick delta ->
            let
                frameDelta =
                    model.frameDelta + delta

                -- Lower block every 1/2 second
                ( newFrameDelta, newBlock ) =
                    if frameDelta > 500.0 then
                        ( 0, lowerBlock model )

                    else
                        ( frameDelta, model.block )
            in
            ( { model | frameDelta = newFrameDelta, block = newBlock }
            , Cmd.none
            )


lowerBlock : Model -> Block
lowerBlock model =
    let
        block =
            model.block

        lowerY =
            block.y + block.height

        newY =
            if lowerY < model.playArea.height - (borderWidth * 2) then
                lowerY

            else
                block.y
    in
    { block | y = newY }


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


subscriptions : Model -> Sub FrontendMsg
subscriptions _ =
    Events.onAnimationFrameDelta Tick


view : Model -> Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ E.layout [ E.padding 20, E.width E.fill, E.height E.fill ] <|
            E.column [ E.width E.fill, E.height E.fill ]
                [ viewPlayArea model ]
        ]
    }


viewPlayArea : Model -> E.Element FrontendMsg
viewPlayArea model =
    E.el
        [ E.width (E.px model.playArea.width)
        , E.height (E.px model.playArea.height)
        , E.centerX
        , E.centerY
        , Bg.color gray
        , Border.color black
        , Border.width borderWidth
        ]
        (viewBlock model)


viewBlock : Model -> E.Element FrontendMsg
viewBlock model =
    let
        block =
            model.block
    in
    E.el
        [ E.width (E.px block.width)
        , E.height (E.px block.height)
        , Bg.color purple
        , E.moveRight (toFloat block.x)
        , E.moveDown (toFloat block.y)
        ]
        (E.text " ")


borderWidth : Int
borderWidth =
    2


gray : E.Color
gray =
    E.rgb255 200 200 200


black : E.Color
black =
    E.rgb255 0 0 0


purple : E.Color
purple =
    E.rgb255 128 0 128
