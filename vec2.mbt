///|
pub(all) struct Vec2(Double, Double)

///|
impl Show for Vec2 with output(self, logger) {
  (self.0, self.1).output(logger)
}

///|
impl Add for Vec2 with add(a, b) {
  Vec2(a.0 + b.0, a.1 + b.1)
}

///|
impl Sub for Vec2 with sub(a, b) {
  Vec2(a.0 - b.0, a.1 - b.1)
}

///|
impl Neg for Vec2 with neg(a) {
  Vec2(-a.0, -a.1)
}

///|
fn Vec2::dot(self : Vec2, other : Vec2) -> Double {
  self.0 * other.0 + self.1 * other.1
}

///|
fn Vec2::length2(self : Vec2) -> Double {
  self.0 * self.0 + self.1 * self.1
}

///|
fn Vec2::normal_then_mul(self : Vec2, new_len : Double) -> Vec2 {
  let len2 = self.length2()
  if len2 == 0.0 {
    Vec2(new_len, 0)
  } else {
    let len = len2.sqrt()
    let c = new_len / len
    Vec2(self.0 * c, self.1 * c)
  }
}

///|
test "normal_then_mul" {
  inspect(Vec2(3, 4).normal_then_mul(10), content="(6, 8)")
  inspect(Vec2(0, 0).normal_then_mul(10), content="(10, 0)")
}

///|
/// (a x b) x c
fn Vec2::triple_prod(a : Vec2, b : Vec2, c : Vec2) -> Vec2 {
  Vec2(
    b.0 * (a.0 * c.0 + a.1 * c.1) - a.0 * (b.0 * c.0 + b.1 * c.1),
    b.1 * (a.0 * c.0 + a.1 * c.1) - a.1 * (b.0 * c.0 + b.1 * c.1),
  )
}

///|
test "triple_prod" {
  let (p10, p11) = (Vec2(1, 0), Vec2(1, 1))
  inspect(Vec2::triple_prod(p10, p11, p11), content="(-1, 1)")
}
