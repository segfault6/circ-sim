package main

import "core:fmt"
import rl "vendor:raylib"
import ll "LinkedList"
import "core:mem"
import "core:math"

WINDOW_W : i32 : 1920
WINDOW_H : i32 : 1080

COMPONANT_GRAPHIC_SIZE : i32 : 100

CompoantName :: enum {
    LED,
    WIRE,
    LDR,
    BATTERY,
}

Componant :: struct {
    pos: rl.Vector2,
    name: CompoantName,
    currentFlowing: bool,
}

totalComponants : u32 = 0
componants : [dynamic]ll.List(Componant)

Componant_add :: proc(componant: Componant) {
    if totalComponants == 0 do componants = make([dynamic]ll.List(Componant))
    newComponant : ll.List(Componant)
    ll.append(&newComponant, componant)
    append(&componants, newComponant)
    totalComponants += 1
}

Componant_connect :: proc(compoant_A_index: u32, compoant_B_index: u32) {
    ll.append(&componants[compoant_A_index], componants[compoant_B_index].head.data)
}

UI_componantList :: proc() {
}

infinite_grid :: proc(camera: rl.Camera2D, spacing: i32, color: rl.Color) {
    screenSize : rl.Vector2 = {f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}
    topLeft : rl.Vector2 = rl.GetScreenToWorld2D({0.0, 0.0}, camera)
    bottomRight : rl.Vector2 = rl.GetScreenToWorld2D({screenSize.x, screenSize.y}, camera)

    startX : f32 = math.floor(topLeft.x / f32(spacing)) * f32(spacing)
    startY : f32 = math.floor(topLeft.y / f32(spacing)) * f32(spacing)

    // startX : f32 = topLeft.x
    // startY : f32 = topLeft.y

    for x: f32 = startX; x < bottomRight.x; x += f32(spacing) {
        start : rl.Vector2 = {x, topLeft.y}
        end : rl.Vector2 = {x, bottomRight.y}
        rl.DrawLineV(start, end, color)
    }

    for y: f32 = startY; y < bottomRight.y; y += f32(spacing) {
        start : rl.Vector2 = {topLeft.x, y}
        end : rl.Vector2 = {bottomRight.x, y}
        rl.DrawLineV(start, end, color)
    }
}

camera : rl.Camera2D = {
	target   = {0.0, 0.0},
	offset   = {1920.0 / 2.0, 1080.0 / 2.0},
	rotation = 0.0,
	zoom     = 1.0,
}

camera_update :: proc() {
	if rl.IsMouseButtonDown(rl.MouseButton.MIDDLE) || rl.IsKeyDown(rl.KeyboardKey.LEFT_CONTROL) {
		camera.target -= rl.GetMouseDelta()
	}

	if rl.IsKeyDown(rl.KeyboardKey.LEFT_CONTROL) {
		if rl.IsKeyPressed(rl.KeyboardKey.MINUS) {
			camera.zoom -= 0.1
		} else if rl.IsKeyPressed(rl.KeyboardKey.EQUAL) {
			camera.zoom += 0.1
		}
	}
}

draw_componant :: proc(componant : Componant, color : rl.Color) {
    rl.DrawRectangleV(componant.pos, {f32(COMPONANT_GRAPHIC_SIZE), f32(COMPONANT_GRAPHIC_SIZE)}, color)
}

main :: proc() -> () {
    for i : i32 = 0; i < 12; i += 1 {
        Componant_add({
            pos = {f32(i) * 10, 0.0},
            name = CompoantName.LED,
            currentFlowing = false,
        })
    }

    for i : i32 = 0; i < 12; i += 1 {
        fmt.println(componants[i].head.data)
    }

    Componant_connect(0, 1)

    fmt.println("------------------------------\n")
    fmt.println(componants[1].head.data)
    fmt.println(componants[0].head.next.data)

    rl.SetConfigFlags({rl.ConfigFlag.FULLSCREEN_MODE})
    rl.InitWindow(WINDOW_W, WINDOW_H, "circ6")

    for !rl.WindowShouldClose() {
        camera_update()
        rl.BeginDrawing()
            rl.ClearBackground(rl.GetColor(0x181818ff))
            rl.BeginMode2D(camera)
                infinite_grid(camera, COMPONANT_GRAPHIC_SIZE, rl.GetColor(0xc5c9c515))
                draw_componant(componants[0].head.data, rl.GetColor(0xff00ffff))
            rl.EndMode2D()
        rl.EndDrawing()
    }
    rl.CloseWindow()
}
