#region Click Test
if (test_upperclick_window() or test_upperclick_gui())
	exit

if (death or mode == md_attack)
	exit

if (point_distance(x, y, objPlayer.x, objPlayer.y) > NPC_CLICKDISTANCE
or collision_line(x, y, objPlayer.x, objPlayer.y, parSolid, 1, 1)) {
	instance_create_layer(x, y, "lyBelowGUI", objNPCDistanceCircle)
	show_messagebox(250, 250, eng() ? "You must be near and there\nmust be no obstacles between you." : "Yakınında olmalısın.\nAranızda engel olmamalı.", eng() ? "Not Allowed" : "İşlem Gerçekleştirilemedi", 1.5*sec)
	exit
}
#endregion

targetAngle = point_direction(x, y, objPlayer.x, objPlayer.y)

#region FIXED (FOR QUEST)
if (ds_list_size(finishedQuests) > 0) {
	// Finishes the top completed quest
	var quest = instance_create(-50, -50, ds_list_find_value(finishedQuests, 0))
	
	with (quest) {
		event_perform(ev_other, ev_user2)
		other.finishText = finishText
	}
	
	#region QUEST RETURNS
	if (quest.object_index == objQuest_blacksmith) {
		dialogue_progress_quest(objQuest_blacksmith2, 1, id)
	}
	
	if (quest.object_index == objQuest_blacksmith2) {
		dialogue_progress(1, 1, id)
	}
	
	if (quest.object_index == objQuest_firstFight) {
		dialogue_progress(3, 1, id)
	}

	if (quest.object_index == objQuest_rebelWar2) {
		dialogue_progress(4, 1, id)
	}
	#endregion
	
	instance_destroy(quest)
	
	if (finishText != "")
		show_messagebox(400, 400, finishText, name+":", sec*3)
	
	ds_list_delete(finishedQuests, 0)
	
	exit
}
#endregion
	
ask_npc(eng() ? "How can I help you?" : "Sana nasıl yardımcı olabilirim?", 1,
string_return(eng() ? "Take a quest" : "Görev al", ds_list_size(availableQuests) > 0), eng() ? ""/*"Where is the lord?"*/ : ""/*"Lord nerede?"*/, "Cancel")