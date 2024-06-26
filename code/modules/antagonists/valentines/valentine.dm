/datum/antagonist/valentine
	name = "valentine"
	roundend_category = "valentines" //there's going to be a ton of them so put them in separate category
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/mind/date
	count_against_dynamic_roll_chance = FALSE
	banning_key = UNBANNABLE_ANTAGONIST

/datum/antagonist/valentine/proc/forge_objectives()
	var/datum/objective/protect/protect_objective = new /datum/objective/protect
	protect_objective.owner = owner
	protect_objective.set_target(date)
	if(!ishuman(date.current))
		protect_objective.human_check = FALSE
	protect_objective.explanation_text = "Protect [date.name], your date."
	objectives += protect_objective
	log_objective(owner, protect_objective.explanation_text)

/datum/antagonist/valentine/on_gain()
	forge_objectives()
	if(isliving(owner))
		var/mob/living/L = owner
		L.apply_status_effect(STATUS_EFFECT_INLOVE, date)
		//Faction assignation
		L.faction |= "[REF(date.current)]"
		L.faction |= date.current.faction
	if(issilicon(owner))
		var/mob/living/silicon/S = owner
		var/laws = list("Protect your date and do not allow them to come to harm.", "Ensure your date has a good time.")
		S.set_valentines_laws(laws)
	. = ..()

/datum/antagonist/valentine/on_removal()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		L.remove_status_effect(STATUS_EFFECT_INLOVE)
		L.faction -= "[REF(date.current)]"

/datum/antagonist/valentine/greet()
	to_chat(owner, "<span class='clown'><B>You're on a date with [date.name]! Protect [date.p_them()] at all costs. This takes priority over all other loyalties.</B></span>")
	owner.current.client?.tgui_panel?.give_antagonist_popup("You are on a date with [date.name]",
		"Protect your date no matter the cost. Your loyalities are insignificant compared to your true love, you may do whatever you can to help and protect them!")

//Squashed up a bit
/datum/antagonist/valentine/roundend_report()
	var/objectives_complete = TRUE
	if(objectives.len)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break

	if(objectives_complete)
		return "<span class='greentext big'>[owner.name] protected [owner.p_their()] date</span>"
	else
		return "<span class='redtext big'>[owner.name] date failed!</span>"
