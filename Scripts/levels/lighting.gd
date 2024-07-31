#---------------------------------------------------------------------------------------------
# lighting.gd
# author: Corbin McKay
# script to control transparent textures visibility to emulate night getting darker
# there are 8 full night hours in the run, and four different images of increasing/decreasing
# opacity is used
#---------------------------------------------------------------------------------------------
extends Node2D

func _on_clock_light_1():
	# make 10pm/5am lighting visible
	$lighting_10pm.visible = true
	# make potential prior lighting invisible
	if $lighting_11pm.visible:
		$lighting_11pm.visible = false

func _on_clock_light_2():
	# make 11pm/4am lighing visible
	$lighting_11pm.visible = true
	# make 10pm/5am or 12am/3am lighing invisible
	if $lighting_10pm.visible:
		$lighting_10pm.visible = false
	if $lighting_12am.visible:
		$lighting_12am.visible = false
	


func _on_clock_light_3():
	# make 12am/3am lighting visible
	$lighting_12am.visible = true
	
	# make 11pm/4am or 1am-2am lighting invisible
	if $lighting_11pm.visible:
		$lighting_11pm.visible = false
	if $lighting_1am.visible:
		$lighting_1am.visible = false
	


func _on_clock_light_4():
	# make 1am-2am lighting visible
	$lighting_1am.visible = true
	# make 12am/3am lighting invisible
	if $lighting_12am.visible:
		$lighting_12am.visible = false
