///|
pub(all) enum Shape {
  Circle(Vec2, Double)
  Polygon(FixedArray[Vec2])
}

///|
fn far(self : Shape, dir : Vec2) -> Vec2 {
  match self {
    Circle(c, r) => c + dir.normal_then_mul(r)
    Polygon(ps) => ps.max_by(dir.dot(_))
  }
}

///|
fn add(self : Shape, v : Vec2) -> Shape {
  match self {
    Circle(c, r) => Circle(c + v, r)
    Polygon(ps) => Polygon(ps.map(_.add(v)))
  }
}

///|
fn[A, B : Compare] FixedArray::max_by(self : FixedArray[A], f : (A) -> B) -> A {
  guard self.length() > 0
  let a0 = self.unsafe_get(0)
  loop (a0, f(a0), self.length() - 1) {
    (am, _, 0) => am
    (am, bm, i) => {
      let ai = self.unsafe_get(i)
      let bi = f(ai)
      continue if bi > bm { (ai, bi, i - 1) } else { (am, bm, i - 1) }
    }
  }
}

///|
test "circle far" {
  let s1 = Circle(Vec2(0, 0), 5)
  let s2 = s1.add(Vec2(-1, -1))
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
  let s3 = s1.add(Vec2(1, 1))
  let d1 = Vec2(5, -1)
  let d2 = Vec2(1, 5)
  inspect(s1.far(d1), content="(1, 0)")
  inspect(s1.far(d2), content="(1, 1)")
  inspect(s2.far(d1), content="(1, 0)")
  inspect(s2.far(d2), content="(0, 1)")
  inspect(s3.far(d1), content="(2, 1)")
  inspect(s3.far(d2), content="(2, 2)")
}
