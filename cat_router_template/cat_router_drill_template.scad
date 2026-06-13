// to create the image:
// 1. open the original image in inkscape
// 2. path -> trace to bitmap
// 3. apply
// 4. move the traced image to the side and delete the original
// 5. save as svg

$fn = 100;

$guide_l = 0;
$thickness = 5;
$pattern_inset = 1;

module cat()
{
	scale(0.26)
	{
		minkowski()
		{
			circle(10);
			import("cat_path.svg");
		}
	}
}

module filler()
{
	polygon([
		[ 10, 10 ], [ 3, 30 ], [ 8, 70 ], [ 15, 70 ], [ 25, 60 ], [ 38, 65 ], [ 60, 60 ], [ 70, 70 ], [ 75, 70 ],
		[ 80, 30 ], [ 75, 10 ], [ 50, 3 ], [ 20, 3 ]

	]);
}

module filled_cat(extrude_height)
{
	linear_extrude(extrude_height)
	{
		cat();
		filler();
	}
}

module base_jig()
{
	difference()
	{
		cube([ 95, 85, $thickness ]);
		translate([ 5, 5, $thickness - $pattern_inset ])
		filled_cat(10);
	}
}

module with_magnet_guide()
{
	difference()
	{
		base_jig();
		for (i = [ 19.25, 74.25 ])
		{
			translate([ i, 68.5, -2 ])
			cylinder(h = 40, r = 5);
		}
	}
}

with_magnet_guide();
