float TIMER_INTERVAL = 5.0;
float BAN_DISTANCE = 140.0;
key me     = "xxxxxxxx-xxxx-4697-a945-0b71c53e4771";
key person1  = "xxxxxxxx-xxxx-44ec-9e0e-be2a09dee8cd";
key person2  = "xxxxxxxx-xxxx-416f-a2d7-fce0ae13dad6";

region_scan()
{
	list avatarsInRegion = llGetAgentList(AGENT_LIST_PARCEL, []);
	integer numOfAvatars = llGetListLength(avatarsInRegion);

	if (!numOfAvatars) return;

	integer index;
	vector current_position = llGetPos();

	while (index < numOfAvatars)
	{
		key id = llList2Key(avatarsInRegion, index);
		++index;

		if(id != me && id != person1 && id != person2)
		{
			string name = llKey2Name(id);
			string long_name = llGetDisplayName(id);
			string composite_name = long_name + "  (" + name + ")";

			// Get distance information
			list answer = llGetObjectDetails(id,[OBJECT_POS]);
			if (llGetListLength(answer) > 0)
			{
				vector targetPos = llList2Vector(answer,0);
				float dist = llVecDist(targetPos, current_position);

				if(dist < BAN_DISTANCE)
				{
					// llSay(PUBLIC_CHANNEL, "Attempting to boot " + composite_name + " who is " + (string)dist + "m away.");
					llTeleportAgentHome(id);
				}
			}
		}
	}
}

default
{
	state_entry()
	{
		llSetTimerEvent(TIMER_INTERVAL);
	}
	timer()
	{
		region_scan();
	}
}
