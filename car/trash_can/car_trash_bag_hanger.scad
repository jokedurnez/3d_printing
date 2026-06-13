// ============================================================
// Car Trash Bag Hanger
// ============================================================
// A four-part assembly that mounts a small trash bag in the
// car.  The hook screws or clips to the headrest post; the
// base frame hangs from it; the insert snaps inside the frame
// to grip the bag; the lid caps the frame when not in use.
// Hinges on the hook column and lid allow the lid to pivot open.
//
// Parts and preview colours:
//   full_hook   — purple, z =   0
//   base        — purple, z =   0
//   hook_hinges — purple, z =   0
//   insert      — pink,   z = -10
//   lid         — grey,   z = -17
// ============================================================

// ─── Resolution ─────────────────────────────────────────────
$fn = 90;

// ─── Overall frame dimensions ───────────────────────────────
$w = 170; // frame width
$l = 230; // frame length

// ─── Base frame ─────────────────────────────────────────────
$base_thickness = 10;
$base_wall = 8;
$r_corner = 10; // outer corner radius

// ─── Hook geometry ──────────────────────────────────────────
$hook_wall = 6;
$hook_d = 28;
$hook_l = $hook_d * 2;
$hook_base_d = 20;
$space_between_hooks = 145;
$hook_base_l = $space_between_hooks + 2 * $hook_wall + $hook_d;

// ─── Shell wall thickness (shared by insert and lid) ────────
$thickness = 2;

// ─── Insert ─────────────────────────────────────────────────
$insert_margin = 2;
$insert_depth = 8;

// ─── Lid ────────────────────────────────────────────────────
$lid_margin = 8;
$lid_depth = 30;
$lid_vert_margin = 1.7; // extra clearance around hook column

// ─── Hinge ──────────────────────────────────────────────────
$hinge_base = 15;       // width between pivot points
$hinge_h = 9;           // height of the hinge ear
$hinge_bolt_d = 6.5;    // bolt hole diameter
$hinge_thickness = 8;   // extrusion depth
$hinge_nut_flat = 9.5; // nut width across flats + 0.5 mm tolerance
$hinge_nut_d = 5;       // nut pocket depth + 0.5 mm tolerance

// ─── Utility: rounded rectangle (2D) ────────────────────────
// Produces a [w × h] rectangle with corner radius r.
module rrect(w, h, r)
{
	offset(r = r) offset(delta = -r) square([ w, h ]);
}

// ─── Hinge ear (3D) ─────────────────────────────────────────
// Triangular ear extruded to $hinge_thickness with a bolt
// through-hole at the apex.  nut_side = "left" cuts a hex nut
// pocket from z = -1; "right" from z = 4; "none" skips it.
module hinge(nut_side = "none")
{
	difference()
	{
		linear_extrude($hinge_thickness) difference()
		{
			hull()
			{
				circle(1);
				translate([ $hinge_base, 0 ])
				circle(1);
				translate([ $hinge_base / 2, $hinge_h ])
				circle($hinge_h * 2 / 3);
			}
			translate([ $hinge_base / 2, $hinge_h * 2 / 3 ])
			circle($hinge_bolt_d / 2);
		}
		if (nut_side == "left")
		{
			translate([ $hinge_base / 2, $hinge_h * 2 / 3, -1.5 ])
			cylinder(h = $hinge_nut_d, r = $hinge_nut_flat / sqrt(3), $fn = 6);
		}
		else if (nut_side == "right")
		{
			translate([ $hinge_base / 2, $hinge_h * 2 / 3, 5 ])
			cylinder(h = $hinge_nut_d, r = $hinge_nut_flat / sqrt(3), $fn = 6);
		}
	}
}

// ─── Single hook profile (2D) ───────────────────────────────
// One bracket-shaped hook, opening to the left, anchored at
// the origin.  Used twice inside hook_part().
module hook()
{
	translate([ -$hook_l, 0 ])
	square([ $hook_l, $hook_wall ]);
	translate([ -$hook_l, $hook_wall ])
	square([ $hook_wall, $hook_d ]);
	translate([ -$hook_l + $hook_wall, $hook_d ])
	square([ $hook_d - $hook_wall, $hook_wall ]);
}

// ─── Two-hook column profile (2D) ───────────────────────────
// Vertical mounting column with one hook at the bottom and
// one near the top, separated by $space_between_hooks.
module hook_part()
{
	square([ $hook_base_d, $hook_base_l ]);
	hook();
	translate([ 0, $space_between_hooks + $hook_wall ])
	hook();
}

// ─── Full 3D hook assembly ───────────────────────────────────
// Extrudes hook_part() with rounded edges via a Minkowski sum
// and centres it along the frame length.
module full_hook()
{
	linear_extrude($base_thickness) translate([ -$hook_base_d, ($l - $hook_base_l) / 2 ])
	minkowski()
	{
		hook_part();
		circle(3);
	}
}

// ─── Hook-side hinge pair ───────────────────────────────────
// Two hinge ears placed at the top and bottom of the hook
// mounting column, facing inward to mate with the lid hinges.
module hook_hinges()
{
	translate([ -6, ($l - $hook_base_l) / 2 + $hinge_thickness / 2 + 1, 0 ])
	rotate([ 90, 180, 0 ])
	hinge(nut_side = "left");

	translate([ -6, ($l - $hook_base_l) / 2 + $hook_base_l + 3, 0 ])
	rotate([ 90, 180, 0 ])
	hinge(nut_side = "right");
}

// ─── Base frame ─────────────────────────────────────────────
// Hollow rounded-rectangle frame, $base_wall thick on all sides.
module base()
{
	linear_extrude($base_thickness) difference()
	{
		rrect($w, $l, $r_corner);
		translate([ $base_wall, $base_wall ])
		rrect($w - 2 * $base_wall, $l - 2 * $base_wall, $r_corner - $base_wall / 2);
	}
}

// ─── Full base assembly ──────────────────────────────────────
// Combines the hook column, base frame, and hinge ears into
// a single printable part.
module full_base()
{
	full_hook();
	base();
	hook_hinges();
}

// ─── Snap-in insert ─────────────────────────────────────────
// Thin-walled tray that snaps inside the base frame.
// The bottom flange rests on the frame; the walls rise
// $insert_depth above it to clamp the bag opening.
module insert()
{
	// Bottom flange — sits on top of the base frame walls
	linear_extrude($thickness) difference()
	{
		rrect($w, $l, $r_corner);
		translate([ $base_wall + $insert_margin, $base_wall + $insert_margin ])
		rrect($w - 2 * $base_wall - $insert_margin * 2, $l - 2 * $base_wall - $insert_margin * 2,
		      $r_corner - $base_wall / 2);
	}

	// Upstanding walls — grip the bag
	linear_extrude($thickness + $insert_depth)
	translate([ $base_wall + $insert_margin / 2, $base_wall + $insert_margin / 2 ])
	difference()
	{
		rrect($w - 2 * $base_wall - $insert_margin, $l - 2 * $base_wall - $insert_margin, $r_corner);
		translate([ $base_wall - $insert_margin / 2, $base_wall - $insert_margin / 2 ])
		rrect($w - 4 * $base_wall, $l - 4 * $base_wall, $r_corner);
	}
}

// ─── Lid-side hinge pair ────────────────────────────────────
// Two hinge ears on the lid that align with hook_hinges(),
// positioned at 3/4 of the lid depth so the pivot is near
// the top edge.
module lid_hinge()
{
	translate([ -$lid_margin, ($l - $hook_base_l) / 2 - 2 * $lid_vert_margin - $hinge_thickness, $lid_depth * 0.6 ])
	{
		color("blue") rotate([ 270, 90, 0 ])
		hinge();

		color("blue") translate([ 0, $hook_base_l + $lid_vert_margin * 4 + $hinge_thickness, 0 ])
		rotate([ 270, 90, 0 ])
		hinge();
	}
}

// ─── Lid ────────────────────────────────────────────────────
// Cap that fits over the outside of the base frame.
// Two slots clear the hook mounting column; lid_hinge() adds
// the pivot ears on the hook side.
module lid()
{
	difference()
	{
		translate([ -$lid_margin, -$lid_margin ])
		difference()
		{
			// Outer shell
			linear_extrude($thickness + $lid_depth) rrect($w + 2 * $lid_margin, $l + 2 * $lid_margin, $r_corner);

			// Interior cavity — opens from $thickness up
			translate([ $base_wall / 2, $base_wall / 2, $thickness ])
			linear_extrude($lid_depth + 1)
			rrect($w + 2 * $lid_margin - $base_wall, $l + 2 * $lid_margin - $base_wall, $r_corner - $base_wall / 2);
		}

		// Slot to clear the hook column (main body)
		translate([ -$hook_base_d, ($l - $hook_base_l) / 2 - 2 * $lid_vert_margin, $base_wall - 5 ])
		linear_extrude(40) square([ $hook_base_d, $hook_base_l + $lid_vert_margin * 4 ]);

		// Wider slot near the top to clear the hinge ears
		translate([ -$hook_base_d, -$lid_margin, $lid_depth * 0.635 ])
		linear_extrude(20) square([ $hook_base_d, $hook_base_l * 2 + $lid_vert_margin * 2 ]);
	}

	lid_hinge();
}

// ────────────────────────────────────────────────────────────
// Preview — uncomment parts to inspect individually
// ────────────────────────────────────────────────────────────

// color("purple") full_base();

// translate([ 0, 0, -10 ])
// color("pink") insert();

// translate([ 0, 0, -17 ])
color("grey") lid();

//     difference()
// {
// lid();
// // full_base();
// // insert();


// 	translate([ 25, -80, -10 ])
// 	cube([ 200, 400, 100 ]);
// }

// hinge(nut_side="right");
