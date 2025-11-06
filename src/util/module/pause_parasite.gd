class_name PauseParasite
extends Node

var host : Node = null

func _ready() -> void:
    Global.connect("pause", pause)
    Global.connect("resume", resume)


static func create(host : Node, auto_add = true):
    var new_parasite = PauseParasite.new()
    new_parasite.host = host

    if auto_add:
        host.add_child(new_parasite)
    
    return new_parasite


func pause():
    if host == null: return

    host.set_physics_process(false)
    host.set_process(false)



func resume():
    if host == null: return

    host.set_physics_process(true)
    host.set_process(true)