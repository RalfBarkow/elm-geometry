module OpenSolid.Plane3d
    exposing
        ( xy
        , xz
        , yx
        , yz
        , zx
        , zy
        , fromPointAndNormal
        , point
        , vector
        , offsetBy
        , flip
        , normalAxis
        , scaleAbout
        , rotateAbout
        , translateBy
        , mirrorAbout
        , relativeTo
        , placeIn
        )

import OpenSolid.Core.Types exposing (..)
import OpenSolid.Point3d as Point3d
import OpenSolid.Vector3d as Vector3d
import OpenSolid.Direction3d as Direction3d


xy : Plane3d
xy =
    Plane3d Point3d.origin
        Direction3d.x
        Direction3d.y
        Direction3d.z


xz : Plane3d
xz =
    Plane3d Point3d.origin
        Direction3d.x
        Direction3d.z
        (Direction3d.negate Direction3d.y)


yx : Plane3d
yx =
    Plane3d Point3d.origin
        Direction3d.y
        Direction3d.x
        (Direction3d.negate Direction3d.z)


yz : Plane3d
yz =
    Plane3d Point3d.origin
        Direction3d.y
        Direction3d.z
        Direction3d.x


zx : Plane3d
zx =
    Plane3d Point3d.origin
        Direction3d.z
        Direction3d.x
        Direction3d.y


zy : Plane3d
zy =
    Plane3d Point3d.origin
        Direction3d.z
        Direction3d.y
        (Direction3d.negate Direction3d.x)


fromPointAndNormal : Point3d -> Direction3d -> Plane3d
fromPointAndNormal originPoint normalDirection =
    let
        ( xDirection, yDirection ) =
            Direction3d.normalBasis normalDirection
    in
        Plane3d originPoint xDirection yDirection normalDirection


point : Float -> Float -> Plane3d -> Point3d
point x y plane =
    Point3d.plus (vector x y plane) plane.originPoint


vector : Float -> Float -> Plane3d -> Vector3d
vector x y plane =
    let
        xVector =
            Direction3d.times x plane.xDirection

        yVector =
            Direction3d.times y plane.yDirection
    in
        Vector3d.plus yVector xVector


offsetBy : Float -> Plane3d -> Plane3d
offsetBy distance plane =
    translateBy (Direction3d.times distance plane.normalDirection) plane


flip : Plane3d -> Plane3d
flip plane =
    { plane | normalDirection = Direction3d.negate plane.normalDirection }


normalAxis : Plane3d -> Axis3d
normalAxis plane =
    Axis3d plane.originPoint plane.normalDirection


scaleAbout : Point3d -> Float -> Plane3d -> Plane3d
scaleAbout centerPoint scale plane =
    let
        scaledOriginPoint =
            Point3d.scaleAbout centerPoint scale plane.originPoint
    in
        { plane | originPoint = scaledOriginPoint }


rotateAbout : Axis3d -> Float -> Plane3d -> Plane3d
rotateAbout axis angle =
    let
        rotatePoint =
            Point3d.rotateAbout axis angle

        rotateDirection =
            Direction3d.rotateAbout axis.direction angle
    in
        \plane ->
            Plane3d (rotatePoint plane.originPoint)
                (rotateDirection plane.xDirection)
                (rotateDirection plane.yDirection)
                (rotateDirection plane.normalDirection)


translateBy : Vector3d -> Plane3d -> Plane3d
translateBy vector plane =
    { plane | originPoint = Point3d.plus vector plane.originPoint }


mirrorAbout : Plane3d -> Plane3d -> Plane3d
mirrorAbout otherPlane =
    let
        mirrorPoint =
            Point3d.mirrorAbout otherPlane

        mirrorDirection =
            Direction3d.mirrorAlong otherPlane.normalDirection
    in
        \plane ->
            Plane3d (mirrorPoint plane.originPoint)
                (mirrorDirection plane.xDirection)
                (mirrorDirection plane.yDirection)
                (mirrorDirection plane.normalDirection)


relativeTo : Frame3d -> Plane3d -> Plane3d
relativeTo frame =
    let
        localizePoint =
            Point3d.relativeTo frame

        localizeDirection =
            Direction3d.relativeTo frame
    in
        \plane ->
            Plane3d (localizePoint plane.originPoint)
                (localizeDirection plane.xDirection)
                (localizeDirection plane.yDirection)
                (localizeDirection plane.normalDirection)


placeIn : Frame3d -> Plane3d -> Plane3d
placeIn frame =
    let
        globalizePoint =
            Point3d.placeIn frame

        globalizeDirection =
            Direction3d.placeIn frame
    in
        \plane ->
            Plane3d (globalizePoint plane.originPoint)
                (globalizeDirection plane.xDirection)
                (globalizeDirection plane.yDirection)
                (globalizeDirection plane.normalDirection)
