# Cat Box Router Jigs

Two jigs for routing a cat-shaped box on a router table. The cat outline is derived from an SVG traced in Inkscape.

## Parts

- **Router template** (`cat_router_template.scad`) — flat template with the cat silhouette extruded as a raised guide (10 mm tall, edges slightly rounded via Minkowski sum with a circle); run a flush-trim bit along it to cut the cat shape into wood
- **Drill template** (`cat_router_drill_template.scad`) — same cat outline inset 1 mm into a 95 × 85 × 5 mm base plate, with two countersunk holes (r = 5 mm) for magnets to hold the jig firmly in place while drilling

## SVG workflow

1. Open source image in Inkscape → Path → Trace Bitmap
2. Move traced path aside, delete original, save as SVG
3. Import `cat_path.svg` into OpenSCAD
