extends Resource
class_name CharacterPersonality

@export var startGaurd := 100
@export var certaintyCurve : Curve
@export var volumeCurve : Curve
@export var emotionCurve : Curve
@export var proximityCurve : Curve

func _init(p_baseGaurd := 100,p_certaintyCurve := Curve.new(), p_volumeCurve := Curve.new(), p_emotionCurve := Curve.new(), p_proximetyCurve := Curve.new()) -> void:
	startGaurd = p_baseGaurd
	certaintyCurve = p_certaintyCurve
	volumeCurve = p_volumeCurve
	emotionCurve = p_emotionCurve
	proximityCurve = p_proximetyCurve
