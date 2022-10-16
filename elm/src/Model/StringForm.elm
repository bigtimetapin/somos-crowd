module Model.StringForm exposing (StringForm(..))


type StringForm
    = Typing String
    | Confirm Confirmed


type alias Confirmed =
    String
