/mob/living/carbon/human
	maxHealth = HUMAN_MAXHEALTH
	health = HUMAN_MAXHEALTH
	/// Color of the undershirt
	var/undershirt_color = "#FFFFFF"
	/// Color of the socks
	var/socks_color = "#FFFFFF"
	/// Flags for showing/hiding underwear, toggleabley by a verb
	var/underwear_visibility = NONE
	/// Render key for mutant bodyparts, utilized to reduce the amount of re-rendering
	var/mutant_renderkey = ""
	/// A list of mutant parts the human is trying to hide, read from `mutant_renderkey`
	var/list/try_hide_mutant_parts
	/// The Examine Panel datum for the mob.
	var/datum/examine_panel/mob_examine_panel
	// Whether or not the human has emissive eyes
	var/emissive_eyes
	/// Chance for oversized to wound someone smaller, if they try to piggyback ride them.
	var/oversized_piggywound_chance = 50
	/// Base damage for oversized piggyback riding.
	var/oversized_piggydam = 25
	/// Paralyze time for oversized piggyback riding in deciseconds. (10 deciseconds = 1 second)
	var/oversized_piggyknock = 3 SECONDS
	/// Alpha of the hair. Takes precedent over species hair_alpha if non-null.
	var/hair_alpha
	/// The selected bra.
	var/bra = "Nude"
	/// Color of the bra.
	var/bra_color = "#FFFFFF"
	/// Chronological age.
	var/chrono_age = 30
	///This are the TK effect object for the left hand for psionic holding.
	var/obj/effect/abstract/held_tk_effect/left/held_left
	///This are the TK effect object for the right hand for psionic holding.
	var/obj/effect/abstract/held_tk_effect/right/held_right
	/// This is the color of the TK effect for the hands when psionic holding is active.
	var/held_hover_color
