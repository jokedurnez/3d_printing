// to create the image:
// 1. open the original image in inkscape
// 2. path -> trace to bitmap
// 3. apply
// 4. move the traced image to the side and delete the original
// 5. save as svg

linear_extrude(10) scale(0.26)

    minkowski()
{
	circle(10);
	import("cat_path.svg");
}
