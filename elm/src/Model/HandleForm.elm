module Model.HandleForm exposing (StringForm(..))


type StringForm
    = Start
    | Typing String
    | Confirm Confirmed


type alias Confirmed =
    String
