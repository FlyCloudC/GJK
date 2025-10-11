# FlyCloudC/GJK

This project implements the GJK (Gilbert–Johnson–Keerthi) collision detection algorithm in MoonBit, supporting intersection detection between circles and polygons, as well as any shape that implements the `ConvexShape` trait.

## Usage

```moonbit
///|
test {
  let s : Polygon = Polygon([Vec2(0, 0), Vec2(0, 2), Vec2(2, 2), Vec2(2, 0)])
  let t : Polygon = Polygon([Vec2(0, 0), Vec2(4, 0), Vec2(2, 4)])
  let c : Circle = Circle(Vec2(1, 1), 1)
  inspect(intersecting(s, c), content="true")
  inspect(intersecting(t, c), content="true")
  inspect(intersecting(s, t), content="false")
}
```
