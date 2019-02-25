if(CLIENT) then

net.Receive( "ClientDeathNotify", function()
		
		//Colours for customizing
		local TraitorColor = Color(255,0,0)
		local InnoColor = Color(0,255,0)
		local DetectiveColor = Color(0,0,255)
			
		local NameColor = Color(142,68,173)
		local UnknownColor = Color(152,48,196)
			
		local White = Color(236,240,241)
		local Orange = Color(255, 165, 0)
			
		//Read the variables from the message
		local name = net.ReadString()
		local role =  tonumber(net.ReadString())
		local reason = net.ReadString()
			
		//Format the number role into a human readable role
		if role == ROLE_INNOCENT then
			col = InnoColor
			role = "Innocent"
		elseif role == ROLE_TRAITOR then
			col = TraitorColor
			role = "Traitor"
		elseif role == ROLE_DETECTIVE then
			col = DetectiveColor
			role = "Detective"
		else
			//He wasn't anything yet e.g pre-round
			col = InnoColor
			role = "Innocent"
		end
			
		//Format the reason for their death
		
		if name == "nil" then
		
			if reason == "suicide" then
				chat.AddText( NameColor, "You ", White, "killed ", NameColor, "Yourself!")
			
			elseif reason == "water" then
				chat.AddText( NameColor, "You ", Orange, "drowned", White, "!")
				
			elseif reason == "some" then
				chat.AddText( NameColor, "You", White," were killed by the ", Orange, "something/world!")
			
			elseif reason == "burned" then
				chat.AddText( NameColor, "You ", Orange, "burned", White, " to death!")
				
			elseif reason == "prop" then
				chat.AddText( NameColor, "You", White, " were killed by a ", Orange, "prop", White,"!")
		
			else
				chat.AddText( White, "It was ", Orange, "unknown", White, " how you were killed!")
		
			end
			
		else
			
			if reason == "ply" then
				chat.AddText( NameColor, "You", White," were killed by ", col, name, White, ", he was ", col, role.."!")
			
			elseif reason == "burned" then
				chat.AddText( col, name, Orange, " roasted ", NameColor, "you!", White, "He was ", col, role.."!")
				
			elseif reason == "prop" then
				chat.AddText( col, name, White, " killed ", NameColor, "you", White, "with a", Orange, "prop!", White, "He was ", col, role.."!")
					
			else
				chat.AddText( White, "It was ", Orange, "unknown", White, " how you were killed!")
		
			end
			
		end
		
	end)
end



if(SERVER) then
	//Precache the net message
	util.AddNetworkString( "ClientDeathNotify" )

	hook.Add("PlayerDeath", "Kill_Reveal_Notify", function( victim, entity, killer )
		
		if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
		
			local reason = 0
	
			reason = "some"
			killerz = "nil"
			role = "nil"
			ekg = true
	
			if( killer == victim ) then 
				reason = "suicide"
				killerz = "nil"
				role = "nil"
		
			elseif killer:IsPlayer() then
				reason = "ply"
				killerz = killer:Nick() 
				role = killer:GetRole()
	
			elseif victim.DiedByWater then
				reason = "water"
				killerz = "nil" 
				role = "nil"
	
			else
			
				if IsValid(entity) then
	
					if entity:GetClass() != NULL then
					
						ekg = false
	
						if entity:GetClass() == "entityflame" then
							reason = "burned"
				
						elseif victim:IsPlayer() and entity:GetClass() == 'prop_physics' or entity:GetClass() == "prop_dynamic" then
							reason = "prop"
				
						else
							reason = entity:GetClass()
							ekg = true
				
						end
			
					end
				
				end
			
				if ekg and IsValid(killer) then
	
					if killer:GetClass() != NULL then
					
						if killer:GetClass() == "entityflame" then
							reason = "burned"
							
						elseif victim:IsPlayer() and killer:GetClass() == 'prop_physics' or killer:GetClass() == "prop_dynamic" then
							reason = "prop"
			
						elseif killer:IsPlayer() then
							reason = "ply"
							killerz = killer:Nick()
							role = killer:GetRole()
				
						end
		
					end
					
				end
		
			end
	
			//Send the buffer message with the death information to the victim
			net.Start("ClientDeathNotify")
				net.WriteString(killerz)
				net.WriteString(role)
				net.WriteString(reason)
			net.Send(victim)
		
		end
		
	end)
end