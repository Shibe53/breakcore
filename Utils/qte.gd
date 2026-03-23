extends Node
class_name QTE
#USAGE: SET THE RECIPIE THROUGH THE EXPORTED VARIABLE. KEY_ESCAPE WILL BE RANODMIZED ON THE CORRESPONDING PLAYER'S 

@export var recipie: Array[Key]
@export var player_num: int
var active = false
var current_index = 0

signal success(qte: QTE)
signal successful_key(qte: QTE, key: Key)
signal failed(qte: QTE)

# I would have preferred to have a 3x5 square of keys for each player
# but for p2 this would have meant having special characters and those
# are not be the same on each keyboard.
const P1_KEYS = [
	KEY_Q, KEY_W, KEY_E, KEY_R, KEY_T,
		   KEY_S, KEY_D, KEY_F, KEY_G,
						 KEY_V, KEY_B
]
const P2_KEYS = [ 
	KEY_Y, KEY_U, KEY_I, KEY_O, KEY_P,
	KEY_H, KEY_J, KEY_K, KEY_L,
	KEY_N, KEY_M,
]

func _ready() -> void:
	on_activate()

func randomise_keys():
	for i in range(recipie.size()):
		if recipie[i] != KEY_ESCAPE: continue
		if player_num == 1:
			recipie[i] = P1_KEYS.pick_random()
		else:
			recipie[i] = P2_KEYS.pick_random()

func _input(event: InputEvent) -> void:
	#if not active: return
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == recipie[current_index]:
			successful_key.emit(self, recipie[current_index])
			current_index += 1
			if current_index >= recipie.size():
				active = false
				success.emit(self)
	
func on_activate():
	active = true
	randomise_keys()
	
