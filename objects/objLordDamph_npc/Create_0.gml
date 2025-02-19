init_target_statistics()

name = npc_lorddamph
tag = "Lord"

level = 32
experience = 0
money = 0

range = 120
spd = 8.3

forceFactor = 9.84
dashPower = 4.8/forceFactor
combatExperience = 80

type = type_npc
subtype = stype_npc

attackSpeed = 1.6
event_inherited()
physicalPower = 527
weapon = sprSw_004S

mode = md_waiting

maxHp = 5500
hp = maxHp

armor = 60
resistance = 60

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

image_xscale = 0.95
image_yscale = image_xscale

shoulders.sprite_index = sprClothes6_npc
leftArm[0].sprite_index = sprClothesArmFull
rightArm[0].sprite_index = sprClothesArmFull
leftArm[1].sprite_index = sprClothesFrontArmFull
rightArm[1].sprite_index = sprClothesFrontArmFull
hair = sprHair5

#region FIXED
qKey = 0

quests = false

targetAngle = image_angle
#endregion

#region FIXED (FOR QUEST)
quests = ds_list_create()
availableQuests = ds_list_create()
availableQuests_desc = ds_list_create()
finishedQuests = ds_list_create()
event_perform(ev_other, ev_user1)
#endregion

grouping_initiate()
fury_initiate()
strike_initiate(dashPower*5, 1)
turtle_initiate()

event_user(3)