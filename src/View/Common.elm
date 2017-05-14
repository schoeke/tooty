module View.Common
    exposing
        ( accountAvatar
        , accountAvatarLink
        , accountLink
        , closeablePanelheading
        , icon
        , justifiedButtonGroup
        , loadMoreBtn
        , confirmView
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Mastodon.Http exposing (Links)
import Mastodon.Model exposing (..)
import Types exposing (..)
import View.Events exposing (..)


accountAvatar : String -> Account -> Html Msg
accountAvatar avatarClass account =
    img [ class avatarClass, src account.avatar ] []


accountLink : Bool -> Account -> Html Msg
accountLink external account =
    let
        accountHref =
            if external then
                target "_blank"
            else
                onClickWithPreventAndStop (LoadAccount account.id)
    in
        a
            [ href account.url
            , accountHref
            ]
            [ text <| "@" ++ account.username ]


accountAvatarLink : Bool -> Account -> Html Msg
accountAvatarLink external account =
    let
        accountHref =
            if external then
                target "_blank"
            else
                onClickWithPreventAndStop (LoadAccount account.id)

        avatarClass =
            if external then
                ""
            else
                "avatar"
    in
        a
            [ href account.url
            , accountHref
            , title <| "@" ++ account.username
            ]
            [ accountAvatar avatarClass account ]


closeablePanelheading : String -> String -> String -> Msg -> Html Msg
closeablePanelheading context iconName label onClose =
    div [ class "panel-heading" ]
        [ div [ class "row" ]
            [ a
                [ href "", onClickWithPreventAndStop <| ScrollColumn ScrollTop context ]
                [ div [ class "col-xs-9 heading" ] [ icon iconName, text label ] ]
            , div [ class "col-xs-3 text-right" ]
                [ a
                    [ href "", onClickWithPreventAndStop onClose ]
                    [ icon "remove" ]
                ]
            ]
        ]


icon : String -> Html Msg
icon name =
    i [ class <| "glyphicon glyphicon-" ++ name ] []


justifiedButtonGroup : String -> List (Html Msg) -> Html Msg
justifiedButtonGroup cls buttons =
    div [ class <| "btn-group btn-group-justified " ++ cls ] <|
        List.map (\b -> div [ class "btn-group" ] [ b ]) buttons


loadMoreBtn : { timeline | id : String, links : Links, loading : Bool } -> Html Msg
loadMoreBtn { id, links, loading } =
    if loading then
        li [ class "list-group-item load-more text-center" ]
            [ text "Loading..." ]
    else
        case links.next of
            Just next ->
                a
                    [ class "list-group-item load-more text-center"
                    , href next
                    , onClickWithPreventAndStop <| TimelineLoadNext id next
                    ]
                    [ text "Load more" ]

            Nothing ->
                text ""


confirmView : Confirm -> Html Msg
confirmView { message, onConfirm, onCancel } =
    div []
        [ div [ class "modal-backdrop" ] []
        , div
            [ class "modal fade in", style [ ( "display", "block" ) ], tabindex -1 ]
            [ div
                [ class "modal-dialog" ]
                [ div
                    [ class "modal-content" ]
                    [ div [ class "modal-header" ] [ h4 [] [ text "Confirmation required" ] ]
                    , div [ class "modal-body" ] [ p [] [ text message ] ]
                    , div
                        [ class "modal-footer" ]
                        [ button
                            [ type_ "button", class "btn btn-default", onClick (ConfirmCancelled onCancel) ]
                            [ text "Cancel" ]
                        , button
                            [ type_ "button", class "btn btn-primary", onClick (Confirmed onConfirm) ]
                            [ text "OK" ]
                        ]
                    ]
                ]
            ]
        ]