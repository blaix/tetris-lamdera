module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
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
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init _ key =
    ( { key = key
      , playArea = { width = 800, height = 1000 }
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

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


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
        , Border.width 2
        ]
        (E.text "play area")


gray : E.Color
gray =
    E.rgb255 200 200 200


black : E.Color
black =
    E.rgb255 0 0 0
