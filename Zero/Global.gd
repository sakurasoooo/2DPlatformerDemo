extends Node


var coins_collected : int = 1
var playerHealth:float = 100
var stamina:float = 100;

#max
var max_playerHealth:float = 100;
var max_stamina:float = 100;

#skill
var healSkill:bool = false
var gunSkill:bool = false
var sliderSkill:bool = false
var doubleJumpSkill:bool = false
var moreCoinSkill:bool = false
var moremoreCoinSkill:bool = false
var moreStanimaSkill:bool = false
var moremoreStanimaSkill:bool = false

var unlockLevel = 0;

func all_reset():
    coins_collected = 1
    playerHealth = max_playerHealth
    stamina = max_stamina;