init_target_statistics()

name = "changes..."
tag = eng() ? "Banker" : "Bankacı"

level = 1
experience = 0
money = 0

range = 80
spd = 5

forceFactor = 9.84

type = type_npc
subtype = stype_npc

attackSpeed = 1
event_inherited()
physicalPower = 1

mode = md_waiting

maxHp = 100
hp = maxHp

armor = 0
resistance = 0

#region RIGIDBODY
var shoulders_obj = objShoulders_rbt1

var arm_obj = objArm_rbt1
var arm_dis = 26

var frontArm_obj = objFrontArm_rbt1
var frontArm_dis = 22

var hand_obj = objHand_rbt1
var hand_dis = 40

rigidbody_set_type1(shoulders_obj,
arm_obj, arm_dis,
frontArm_obj, frontArm_dis,
hand_obj, hand_dis)
rigidbody_set_definedstance_type1(stSerious)
#endregion

image_xscale = 0.86
image_yscale = image_xscale

shoulders.sprite_index = sprClothes_npc

#region FIXED FOR TRADE
for (var i = 0; i < global.tradeBoxCount_horizontal*global.tradeMaxPage; i++) {
    for (var j = 0; j < global.tradeBoxCount_vertical; j++) {
        item[i, j] = -1
        itemUpgrade[i, j] = -1
        itemExtension0[i, j] = -1
        itemExtension1[i, j] = -1
        itemType[i, j] = pointer_null
        itemCount[i, j] = -1
    }
}
#endregion

#region FIXED
qKey = 0

quests = false

targetAngle = image_angle
#endregion