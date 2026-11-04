extends Node
class_name ShootingComponent

signal shot_fired
signal shot_failed
signal ammo_changed(cur_ammo_on_mag, cur_ammo)

@export var fire_rate: float = 0.15
@export var spread_angle: float = 3.0
@export var bullet_speed: float = 2500
@export var bullet_scene: PackedScene
@export var muzzle : Marker2D
@export_category("Ammo Settings")
@export var max_ammo: int = 150
@export var max_bullets_on_mag: int = 30
@onready var fire_timer: Timer = $FireTimer
@onready var current_ammo_on_mag: int = max_bullets_on_mag
@onready var current_ammo: int = max_ammo

func _ready() -> void:
	fire_timer.wait_time = fire_rate
	fire_timer.one_shot = true

func try_shoot() -> void:
	if !fire_timer.is_stopped():
		return
	if current_ammo_on_mag <= 0:
		fire_timer.start()
		shot_failed.emit()
		return
	shoot()

func shoot() -> void:
	if !bullet_scene:
		return
	fire_timer.start()
	var bullet_inst = bullet_scene.instantiate()
	bullet_inst.global_position = muzzle.global_position
	bullet_inst.global_rotation = muzzle.global_rotation
	bullet_inst.setup_bullet(muzzle.global_rotation, bullet_speed, spread_angle)
	get_tree().current_scene.add_child(bullet_inst)
	current_ammo_on_mag = clamp(current_ammo_on_mag - 1, 0, max_bullets_on_mag)
	shot_fired.emit()
	ammo_changed.emit(current_ammo_on_mag, current_ammo)

func reload() -> void:
	var ammo_needed = max_bullets_on_mag - current_ammo_on_mag
	var ammo_to_take = min(ammo_needed, current_ammo)
	current_ammo_on_mag += ammo_to_take
	current_ammo -= ammo_to_take
	ammo_changed.emit(current_ammo_on_mag, current_ammo)


func _on_shot_fired() -> void:
	pass # Replace with function body.


func _on_shot_failed() -> void:
	pass # Replace with function body.
