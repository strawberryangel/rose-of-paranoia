#include "lib/whitelist.lsl"

	string VERSION = "3.0.0";

///////////////////////////////////////////////////////////////////////////////


float TIMER_INTERVAL = 5.0;
float BAN_DISTANCE = 28.284271247461900976033774484194; // SQRT2 * 20 to cover all of Warmth

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

		if(!is_whitelist(id))
		{
			// Get distance information
			list answer = llGetObjectDetails(id,[OBJECT_POS]);
			if (llGetListLength(answer) > 0)
			{
				vector targetPos = llList2Vector(answer,0);
				float dist = llVecDist(targetPos, current_position);

				if(dist < BAN_DISTANCE)
				{
					string name = llKey2Name(id);
					string long_name = llGetDisplayName(id);
					string composite_name = long_name + "  (" + name + ")";

					llInstantMessage(WL_Sophie, "Attempting to boot " + composite_name + " who is " + (string)dist + "m away.");
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
