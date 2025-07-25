/obj/item/circuitboard/computer/cargo/express/interdyne
	name = "Interdyne Express Supply Console"
	build_path = /obj/machinery/computer/cargo/express/interdyne
	contraband = TRUE

/obj/machinery/computer/cargo/express/interdyne
	name = "\improper Interdyne express supply console"
	desc = "A standard NT express console, hacked by Gorlex Industries to use \
	their own experimental \"1100mm Rail Cannon\", made to be extra robust to prevent \
	being emagged by the Syndicate cadets of the SSV Dauntless."
	circuit = /obj/item/circuitboard/computer/cargo/express/interdyne
	req_access = list(ACCESS_SYNDICATE)
	cargo_account = ACCOUNT_INT
	contraband = TRUE

	var/static/list/allowed_categories = list(
		NAKAMURA_ENGINEERING_MODSUITS_NAME,
		BLACKSTEEL_FOUNDATION_NAME,
		NRI_SURPLUS_COMPANY_NAME,
		DEFOREST_MEDICAL_NAME,
		DONK_CO_NAME,
		KAHRAMAN_INDUSTRIES_NAME,
		FRONTIER_EQUIPMENT_NAME,
		SOL_DEFENSE_DEFENSE_NAME,
		MICROSTAR_ENERGY_NAME,
		VITEZSTVI_AMMO_NAME,
	)

	pod_type = /obj/structure/closet/supplypod/bluespacepod

/obj/machinery/computer/cargo/express/interdyne/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user)
		to_chat(user, span_notice("You try to change the routing protocols, but the machine displays a runtime error and reboots!"))
	return FALSE //never let this console be emagged

/obj/machinery/computer/cargo/express/interdyne/packin_up(forced = FALSE) //we're the dauntless, add the company imports stuff to our express console
	. = ..()

	if(meme_pack_data["Company Imports"])
		return

	meme_pack_data["Company Imports"] = list(
		"name" = "Company Imports",
		"packs" = list()
	)

	for(var/armament_category as anything in SSarmaments.entries)//babe! it's 4pm, time for the company importing logic
		for(var/subcategory as anything in SSarmaments.entries[armament_category][CATEGORY_ENTRY])
			if(armament_category in allowed_categories)
				for(var/datum/armament_entry/armament_entry as anything in SSarmaments.entries[armament_category][CATEGORY_ENTRY][subcategory])
					meme_pack_data["Company Imports"]["packs"] += list(list(
						"name" = "[armament_category]: [armament_entry.name]",
						"first_item_icon" = armament_entry?.item_type.icon,
						"first_item_icon_state" = armament_entry?.item_type.icon_state,
						"cost" = armament_entry.cost,
						"id" = REF(armament_entry),
						"description" = armament_entry.description,
						"desc" = armament_entry.description,
					))

/obj/machinery/computer/cargo/express/interdyne/ui_act(action, params, datum/tgui/ui)
	if(action == "add") // if we're generating a supply order
		if (!beacon || !using_beacon ) // checks if using a beacon or not.
			say("Error! Destination is not whitelisted, aborting.")
			return
		var/id = params["id"]
		id = text2path(id) || id
		var/datum/supply_pack/is_supply_pack = SSshuttle.supply_packs[id]
		if(!is_supply_pack || !istype(is_supply_pack)) //if we're ordering a company import pack, add a temp pack to the global supply packs list, and remove it
			var/datum/armament_entry/armament_order = locate(id)
			params["id"] = length(SSshuttle.supply_packs) + 1
			var/datum/supply_pack/armament/temp_pack = new
			temp_pack.name = initial(armament_order.item_type.name)
			temp_pack.cost = armament_order.cost
			temp_pack.contains = list(armament_order.item_type)
			SSshuttle.supply_packs += temp_pack
			. = ..()
			SSshuttle.supply_packs -= temp_pack
			return
	return ..()

//Deep Space 2's console
/obj/item/circuitboard/computer/cargo/express/interdyne/syndicate
	name = "Syndicate Express Supply Console"
	build_path = /obj/machinery/computer/cargo/express/interdyne/syndicate
	contraband = TRUE

/obj/machinery/computer/cargo/express/interdyne/syndicate
	name = "\improper Syndicate express supply console"
	desc = "A standard Syndicate console."
	circuit = /obj/item/circuitboard/computer/cargo/express/interdyne/syndicate
	req_access = list(ACCESS_SYNDICATE)
	cargo_account = ACCOUNT_DS2

// Tarkon Industries console
/obj/item/circuitboard/computer/cargo/express/interdyne/tarkon
	name = "Tarkon Express Supply Console"
	build_path = /obj/machinery/computer/cargo/express/interdyne/tarkon
	contraband = TRUE

/obj/machinery/computer/cargo/express/interdyne/tarkon
	name = "\improper Tarkon express supply console"
	desc = "A standard Tarkon console."
	circuit = /obj/item/circuitboard/computer/cargo/express/interdyne/tarkon
	req_access = list(ACCESS_TARKON)
	cargo_account = ACCOUNT_TI
