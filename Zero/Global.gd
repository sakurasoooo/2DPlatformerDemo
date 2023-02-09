extends Node


var coins_collected : int = 9
var playerHealth:float = 100
var stamina:float = 50;

var coin_rate:int = 1

#max
var max_playerHealth:float = 100;
var max_stamina:float = 50;

#skill
var healSkill:bool = false
var gunSkill:bool = false
var sliderSkill:bool = false
var doubleJumpSkill:bool = false
var moreCoinSkill:bool = false
var moremoreCoinSkill:bool = false
var moreStanimaSkill:bool = false
var moremoreStanimaSkill:bool = false

#signal
# warning-ignore:unused_signal
signal healSkill()
# warning-ignore:unused_signal
signal sliderSkill()
# warning-ignore:unused_signal
signal jumpSkill()
# warning-ignore:unused_signal
signal gunSkill()
# warning-ignore:unused_signal
signal doubleCoin()
# warning-ignore:unused_signal
signal trippleCoin()
# warning-ignore:unused_signal
signal moreStanima()
# warning-ignore:unused_signal
signal moremoreStanima()

var unlockLevel:int = 0;

func all_reset():
    coins_collected = 1
    playerHealth = max_playerHealth
    stamina = max_stamina;

func _ready():
    var _a = connect("moreStanima",self,"_set_more_stanima")
    _a  = connect("moremoreStanima",self,"_set_more_more_stanima")
    _a  = connect("doubleCoin",self,"_set_more_coin")
    _a  = connect("trippleCoin",self,"_set_more_more_coin")

func _set_more_stanima():
    max_stamina = 100

func _set_more_more_stanima():
    max_stamina = 200

func _set_more_coin():
    coin_rate = 2

func _set_more_more_coin():
    coin_rate = 3