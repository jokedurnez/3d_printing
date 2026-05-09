# 3D Printing

Parametric 3D models for everyday life, designed in OpenSCAD and printed on an Ender 3 S1.

## Projects

### car/trash_can — Car Trash Bag Hanger

A four-part assembly that mounts a small trash bag from the headrest post.

**Parts:**
- **Base + hook** — mounting column with two bracket hooks that clip over the headrest post; includes hinge ears for the lid
- **Insert** — snap-in tray that grips the bag opening inside the base frame
- **Lid** — hinged cap that closes over the frame when not in use

**Key parameters** (top of `car_trash_bag_hanger.scad`):
| Variable | Default | Description |
|---|---|---|
| `$w` / `$l` | 200 / 230 mm | Frame width and length |
| `$space_between_hooks` | 145 mm | Distance between the two hooks — adjust for your headrest post |
| `$hook_d` | 25 mm | Hook inner diameter |
| `$lid_depth` | 30 mm | Depth of the lid cap |

**STL files:**
- `car_trash_bag_hanger.stl` — full assembly preview
- `car_trash_bag_hanger_test2.stl` / `car_trash_bag_hanger_test_hanger.stl` — fit-test prints

## Tools

- **CAD:** [OpenSCAD](https://openscad.org/)
- **Printer:** Creality Ender 3 S1
- **Material:** PLA, 200–210 °C, 0.1–0.28 mm layer height
