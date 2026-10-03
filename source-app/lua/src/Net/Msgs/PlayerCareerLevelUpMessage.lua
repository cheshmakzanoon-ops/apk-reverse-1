local PlayerCareerLevelUpMessage = BaseClass("PlayerCareerLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, careerLv)
  base.OnCreate(self)
  self.sfsObj:PutInt("careerLv", careerLv)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    return
  end
  if t.careerType then
    LuaEntry.Player.careerType = t.careerType
  end
  if t.careerLv then
    LuaEntry.Player.careerLv = t.careerLv
  end
  if t.lastUpdateTime then
    LuaEntry.Player:SetLastUpdateTime(t.lastUpdateTime)
  end
  EventManager:GetInstance():Broadcast(EventId.PlayerCareerLevelUp, t.careerLv)
end

PlayerCareerLevelUpMessage.OnCreate = OnCreate
PlayerCareerLevelUpMessage.HandleMessage = HandleMessage
return PlayerCareerLevelUpMessage
