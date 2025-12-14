///|
/// A trait for convex geometric shapes that can compute their support point in
/// a given direction.
///
/// The support point is the point on the shape that is furthest in the
/// specified direction. This is a fundamental operation used in collision
/// detection algorithms like GJK (Gilbert-Johnson-Keerthi) and EPA (Expanding
/// Polytope Algorithm).
///
/// Methods:
///
/// * `far(Self, Vec2) -> Vec2`: Returns the support point of the shape in the
///   given direction.
///
pub(open) trait ConvexShape {
  far(Self, Vec2) -> Vec2
}

///|
const EPS : Double = 1.0e-10

///|
/// Determines whether two shapes are intersecting using the
/// Gilbert-Johnson-Keerthi (GJK) collision detection algorithm.
///
/// Parameters:
///
/// * `s1` : The first shape to test for intersection.
/// * `s2` : The second shape to test for intersection.
/// * `iter_step` : The maximum number of iterations to perform (default: 100).
///   Higher values provide more accuracy but may impact performance.
///
/// Returns `true` if the shapes are intersecting, `false` otherwise.
pub fn[A : ConvexShape, B : ConvexShape] intersecting(
  s1 : A,
  s2 : B,
  iter_step? : Int = 100,
) -> Bool {
  let a = s1.far(Vec2(1, 0)) - s2.far(Vec2(-1, 0))
  let b = s1.far(-a) - s2.far(a)
  if b.dot(a) > 0 {
    return false
  }
  let ba_perp = {
    let (ba, bo) = (a - b, -b)
    Vec2::triple_prod(ba, bo, ba)
  }
  for i = iter_step, l = a, r = b, dt = ba_perp; i > 0; {
    let t = s1.far(dt) - s2.far(-dt)
    let (tr, tl) = (r - t, l - t)
    let tr_perp = Vec2::triple_prod(tl, tr, tr)
    if tr_perp.dot(t) < EPS {
      continue i - 1, t, r, tr_perp
    }
    let tl_perp = Vec2::triple_prod(tr, tl, tl)
    if tl_perp.dot(t) < EPS {
      continue i - 1, l, t, tl_perp
    }
    break true
  } else {
    false
  }
}

///|
test "polygon polygon" {
  let sq1 = Polygon([Vec2(0, 0), Vec2(0, 1), Vec2(1, 1), Vec2(1, 0)])
  let s12 = Polygon([Vec2(1, 1), Vec2(1, 2), Vec2(2, 2), Vec2(2, 1)])
  let t1 = Polygon([Vec2(0, 0), Vec2(2, 0), Vec2(1, 2)])
  let t2 = Polygon([Vec2(1, 1), Vec2(3, 1), Vec2(2, 3)])
  //
  assert_true(intersecting(t1, s12))
  assert_true(intersecting(s12, t1))
  assert_true(intersecting(t1, t2))
  assert_true(intersecting(t2, t1))
  assert_true(intersecting(sq1, t1))
  assert_true(intersecting(t1, sq1))
  //
  assert_false(intersecting(sq1, s12))
  assert_false(intersecting(s12, sq1))
  assert_false(intersecting(sq1, t2))
  assert_false(intersecting(t2, sq1))
}

///|
test "circle circle" {
  inspect(EPS, content="1e-10")
  let coll_1 = r => intersecting(Circle(Vec2(4, 3), 1), Circle(Vec2(0, 0), r))
  let coll_2 = r => intersecting(Circle(Vec2(0, 0), 1), Circle(Vec2(4, 3), r))
  let range = 3.9.until(4.1, step=0.01)
  let range_rest : (Double) -> _ = _.until(4.5, step=1 / 32)
  //
  let r1 = range.find_first(coll_1).unwrap()
  assert_true(r1.is_close(4, relative_tolerance=0.005))
  assert_true(range_rest(r1).all(coll_1))
  //
  let r2 = range.find_first(coll_2).unwrap()
  assert_true(r2.is_close(4, relative_tolerance=0.005))
  assert_true(range_rest(r2).all(coll_2))
}

///|
test "polygon circle" {
  let s = Polygon([Vec2(0, 0), Vec2(0, 2), Vec2(2, 2), Vec2(2, 0)])
  let t = Polygon([Vec2(0, 0), Vec2(4, 0), Vec2(2, 4)])
  let c1 = Circle(Vec2(1, 1), 1)
  let c2 = Circle(Vec2(3, 3), 1)
  let c3 = Circle(Vec2(5, 5), 1)

  //
  assert_true(intersecting(s, c1))
  assert_true(intersecting(c1, s))
  assert_true(intersecting(t, c2))
  assert_true(intersecting(c2, t))

  //
  assert_false(intersecting(s, c3))
  assert_false(intersecting(c3, s))
  assert_false(intersecting(t, c3))
  assert_false(intersecting(c3, t))
}
