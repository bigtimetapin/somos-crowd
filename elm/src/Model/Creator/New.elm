module Model.Creator.New exposing (New(..))


type New
    = Top
    | TypingHandle String
    | WaitingForHandleConfirmation
    | HandleInvalid String
    | HandleAlreadyExists String
