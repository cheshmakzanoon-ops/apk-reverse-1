local PlayerCareerSelectMessage = BaseClass("PlayerCareerSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, careerType)
  base.OnCreate(self)
  self.sfsObj:PutInt("careerType", careerType)
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
  if t.careerFreeChangeEndTime then
    DataCenter.PlayerCareerManager:UpdateCareerFreeChangeEndTime(t.careerFreeChangeEndTime)
  end
  EventManager:GetInstance():Broadcast(EventId.PlayerCareerSelect)
end

PlayerCareerSelectMessage.OnCreate = OnCreate
PlayerCareerSelectMessage.HandleMessage = HandleMessage
return PlayerCareerSelectMessage
