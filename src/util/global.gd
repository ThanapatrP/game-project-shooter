extends Node


# UI stuff
var camera : Camera2D = null
var cursor = null
var hurt_overlay = null
var score_label = null

# Save stuff
var curr_score = 0
var highscore = 0


func add_score(amt):
    if amt < 0:
        return
    
    curr_score += amt
    if score_label: score_label.trigger_impulse_color()


# save load stuff
func load_data():
    pass

