﻿local T, C, L = unpack(select(2, ...))

----------------------------------------------------------------------------------------
--	Accept invites from guild memers or friend list(by ALZA)
----------------------------------------------------------------------------------------
if C.misc.auto_accept_invite == true then
	local IsFriend = function(name)
		for i = 1, GetNumFriends() do
			if GetFriendInfo(i) == name then
				return true
			end
		end
		for i = 1, select(2, BNGetNumFriends()) do
			local _, _, _, toonName, _, client = BNGetFriendInfo(i)
			if client == "WoW" and toonName == name then
				return true
			end
		end
		if IsInGuild() then
			for i = 1, GetNumGuildMembers() do
				if GetGuildRosterInfo(i) == name then
					return true
				end
			end
		end
	end

	local ai = CreateFrame("Frame")
	ai:RegisterEvent("PARTY_INVITE_REQUEST")
	ai:SetScript("OnEvent", function(frame, event, name)
		if MiniMapLFGFrame:IsShown() then return end
		if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then return end
		if IsFriend(name) then
			T.InfoTextShow(L_INFO_INVITE..name)
			print(format("|cffffff00"..L_INFO_INVITE..name.."."))
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which == "PARTY_INVITE" then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				end
			end
		else
			SendWho(name)
		end
	end)
end

----------------------------------------------------------------------------------------
--	Auto invite by whisper(by Tukz)
----------------------------------------------------------------------------------------
local ainvenabled = false
local ainvkeyword = C.misc.invite_keyword

local autoinvite = CreateFrame("Frame")
autoinvite:RegisterEvent("CHAT_MSG_WHISPER")
autoinvite:SetScript("OnEvent", function(self, event, arg1, arg2)
	if ((not UnitExists("party1") or IsPartyLeader("player") or IsRaidOfficer("player") or IsRaidLeader("player")) and arg1:lower():match(ainvkeyword)) and ainvenabled == true then
		InviteUnit(arg2)
	end
end)

SlashCmdList.AUTOINVITE = function(msg, editbox)
	if msg == "off" then
		ainvenabled = false
		print("|cffffff00"..L_INVITE_DISABLE..".")
	elseif msg == "" then
		ainvenabled = true
		print("|cffffff00"..L_INVITE_ENABLE..ainvkeyword..".")
		ainvkeyword = C.misc.invite_keyword
	else
		ainvenabled = true
		print("|cffffff00"..L_INVITE_ENABLE..msg..".")
		ainvkeyword = msg
	end
end
SLASH_AUTOINVITE1 = "/ainv"
SLASH_AUTOINVITE2 = "/фштм"