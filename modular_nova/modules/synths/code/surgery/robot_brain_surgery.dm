/datum/surgery/robot_brain_surgery
	name = "Reset Logic (Brain Surgery)"
	desc = "A surgical procedure that restores the default behavior logic and personality matrix of an synthetic humanoid's neural network."
	steps = list(
		/datum/surgery_step/mechanic_open,
		/datum/surgery_step/mechanic_unwrench,
		/datum/surgery_step/pry_off_plating,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/fix_robot_brain,
		/datum/surgery_step/mechanic_close,
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST) // The brains are in the chest
	organ_to_manipulate = ORGAN_SLOT_BRAIN
	requires_bodypart_type = BODYTYPE_ROBOTIC
	requires_organ_flags = ORGAN_ROBOTIC

// Subtype for synthetic humanoids with organic bodyparts
/datum/surgery/robot_brain_surgery/hybrid
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/prepare_electronics,
		/datum/surgery_step/fix_robot_brain,
		/datum/surgery_step/close,
	)
	requires_bodypart_type = BODYTYPE_ORGANIC

/datum/surgery_step/fix_robot_brain
	name = "fix brain (multitool or hemostat)"
	implements = list(
		TOOL_MULTITOOL = 95,
		TOOL_HEMOSTAT = 35,
		/obj/item/pen = 15
	)
	repeatable = TRUE
	time = 12 SECONDS //long and complicated

/datum/surgery_step/fix_robot_brain/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/brain_type = "posibrain"
	var/obj/item/organ/brain/synth/synth_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(synth_brain)
		brain_type = synth_brain.name
	display_results(
		user,
		target,
		span_notice("You begin to clear system corruption from [target]'s [brain_type]..."),
		span_notice("[user] begins to fix [target]'s [brain_type]."),
		span_notice("[user] begins to perform surgery on [target]'s [brain_type]."),
	)

/datum/surgery_step/fix_robot_brain/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/brain_type = "posibrain"
	var/obj/item/organ/brain/synth/synth_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(synth_brain)
		brain_type = synth_brain.name
	display_results(user,
		target,
		span_notice("You succeed in clearing system corruption from [target]'s [brain_type]."),
		span_notice("[user] successfully fixes [target]'s [brain_type]!"),
		span_notice("[user] completes the surgery on [target]'s [brain_type]."),
	)

	var/datum/status_effect/neuroware/neuro_status = target.has_status_effect(/datum/status_effect/neuroware)
	if(!isnull(neuro_status))
		target.balloon_alert_to_viewers("neuroware reset")
		for(var/datum/reagent/reagent as anything in target.reagents.reagent_list)
			if(reagent.chemical_flags & REAGENT_NEUROWARE)
				target.reagents.del_reagent(reagent.type)

	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/brainwashed))
		target.mind.remove_antag_datum(/datum/antagonist/brainwashed)

	target.setOrganLoss(ORGAN_SLOT_BRAIN, target.get_organ_loss(ORGAN_SLOT_BRAIN) - 60)	//we set damage in this case in order to clear the "failing" flag
	target.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY) //Lobotomy tier fix cause you can't clone this!

	if(target.get_organ_loss(ORGAN_SLOT_BRAIN) > NONE)
		to_chat(user, "[target]'s [brain_type] still has some lasting system damage that can be cleared.")

	return ..()

/datum/surgery_step/fix_robot_brain/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/brain_type = "posibrain"
	var/obj/item/organ/brain/synth/synth_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(synth_brain)
		brain_type = synth_brain.name
		display_results(
			user,
			target,
			span_warning("You screw up, fragmenting their data!"),
			span_warning("[user] screws up, causing damage to the circuits!"),
			span_notice("[user] completes the surgery on [target]'s [brain_type]."),
		)

		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 60)
		target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	else
		user.visible_message(span_warning("[user] suddenly notices that the [brain_type] [user.p_they()] [user.p_were()] working on is not there anymore."), span_warning("You suddenly notice that the posibrain you were working on is not there anymore."))

	return FALSE
