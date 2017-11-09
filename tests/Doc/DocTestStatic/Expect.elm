module Doc.DocTestStatic.Expect exposing (equal)

import Expect exposing (Expectation)
import OpenSolid.Scalar as Scalar
import Regex exposing (HowMany(All), regex)
import Result
import String


--import List


{-| This is a very hacky function to compare arbitrary types and the numbers in them with a certain precision.
In order to achieve this all numbers in the string representation of the two objects are truncated and then the
resulting strings are compared.

    It should never be used.

-}
equal : a -> a -> Expectation
equal a b =
    let
        --truncateToFourDigits number =
        --    let
        --        scale =
        --            10000.0
        --    in
        --    toFloat (truncate (scale * number)) / scale
        --truncateStrNumber str =
        --    String.toFloat str
        --        |> Result.map truncateToFourDigits
        --        |> Result.map toString
        --        |> Result.withDefault ("ERROR: This should never happen (" ++ str ++ ")")
        --truncateNumsInStr str =
        --    let
        --    in
        --    Regex.replace All anyNumber (.match >> truncateStrNumber) str
        strA =
            toString a

        strB =
            toString b

        anyNumberRegExpr =
            regex "(-?[0-9]+(?:\\.[0-9]+)?)"

        removeAllNumbers str =
            Regex.replace All anyNumberRegExpr (always "") str

        extractAllNumbers str =
            Regex.find All anyNumberRegExpr str
                |> List.map .match

        sameNumber a b =
            let
                numA =
                    String.toFloat a

                numB =
                    String.toFloat b
            in
            Result.map2 (Scalar.equalWithin 1.0e-4) numA numB
                |> Result.withDefault False

        sameNumbers =
            let
                numbersA =
                    extractAllNumbers strA

                numbersB =
                    extractAllNumbers strB

                sameLength =
                    List.length numbersA == List.length numbersB
            in
            sameLength
                && (List.map2 sameNumber numbersA numbersB
                        |> List.all identity
                   )
    in
    if removeAllNumbers strA == removeAllNumbers strB && sameNumbers then
        Expect.pass
    else
        -- this custom test fails, assume that a and b are really different (even by this test's rules)
        -- use Expect.equal to get a nicely formatted output
        Expect.equal a b
