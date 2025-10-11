# FlyCloudC/GJK

This project implements the GJK (Gilbert–Johnson–Keerthi) collision detection algorithm in MoonBit, supporting intersection detection between circles and polygons.

## Usage

```moonbit
///|
test {
  let s : Shape = Polygon([Vec2(0, 0), Vec2(0, 2), Vec2(2, 2), Vec2(2, 0)])
  let t : Shape = Polygon([Vec2(0, 0), Vec2(4, 0), Vec2(2, 4)])
  let c : Shape = Circle(Vec2(1, 1), 1)
  inspect(s.intersecting(c), content="true")
  inspect(t.intersecting(c), content="true")
  inspect(s.intersecting(t), content="false")
}
```
