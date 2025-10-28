///|
pub(all) struct Circle(Vec2, Double)

///|
pub impl ConvexShape for Circle with far(self, dir) {
  let Circle(c, r) = self
  c + dir.normal_then_mul(r)
}

///|
/// Note: The FixedArray must not be empty.
pub(all) struct Polygon(FixedArray[Vec2])

///|
pub impl ConvexShape for Polygon with far(self, dir) {
  self.0.unsafe_max_by(dir.dot(_))
}

///|
fn[A, B : Compare] FixedArray::unsafe_max_by(
  self : FixedArray[A],
  f : (A) -> B,
) -> A {
  guard self is [a0, .. rest]
  for am = a0, bm = f(a0), rest = rest {
    match rest {
      [] => break am
      [ai, .. rest] => {
        let bi = f(ai)
        if bi > bm {
          continue ai, bi, rest
        } else {
          continue am, bm, rest
        }
      }
    }
  }
}

///|
test "circle far" {
  let s1 = Circle(Vec2(0, 0), 5)
  let s2 = Circle(Vec2(-1, -1), 5)
  let d1 = Vec2(3, 4)
  let d2 = Vec2(1, 0)
  inspect(s1.far(d1), content="(3, 4)")
  inspect(s1.far(d2), content="(5, 0)")
  inspect(s2.far(d1), content="(2, 3)")
  inspect(s2.far(d2), content="(4, -1)")
}

///|
test "polygon far" {
  let s1 = Polygon([Vec2(0, 0), Vec2(0, 1), Vec2(1, 0), Vec2(1, 1)])
  let s2 = Polygon([Vec2(0, 0), Vec2(0, 1), Vec2(1, 0)])
  let s3 = Polygon([Vec2(1, 1), Vec2(1, 2), Vec2(2, 1), Vec2(2, 2)])
  let d1 = Vec2(5, -1)
  let d2 = Vec2(1, 5)
  inspect(s1.far(d1), content="(1, 0)")
  inspect(s1.far(d2), content="(1, 1)")
  inspect(s2.far(d1), content="(1, 0)")
  inspect(s2.far(d2), content="(0, 1)")
  inspect(s3.far(d1), content="(2, 1)")
  inspect(s3.far(d2), content="(2, 2)")
}
