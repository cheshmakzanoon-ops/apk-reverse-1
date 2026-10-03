local UserRecoverPlayerStaminaMessage = BaseClass("UserRecoverPlayerStaminaMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    LuaEntry.Player:SetStaminaData(t)
    LuaEntry.Player:SetStaminaGoldTime(t)
    EventManager:GetInstance():Broadcast(EventId.FormationStaminaUpdate)
    EventManager:GetInstance():Broadcast(EventId.UserGoldCoverStamina)
  end
end

UserRecoverPlayerStaminaMessage.OnCreate = OnCreate
UserRecoverPlayerStaminaMessage.HandleMessage = HandleMessage
return UserRecoverPlayerStaminaMessage
