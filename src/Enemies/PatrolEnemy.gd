tool
class_name PatrolEnemy
extends Enemy

const SNAP := Vector2(0, 20)

export var is_patrolling := true

onready var ray_cast_floor: RayCast2D = $Skin/RayCastFloor
onready var ray_cast_wall: RayCast2D = $Skin/RayCastWall
