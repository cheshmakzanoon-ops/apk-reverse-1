local PushDesertCollectTimeUpdateMessage = BaseClass("PushDesertCollectTimeUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.time ~= nil then
    DataCenter.DesertDataManager:SetLastCollectTime(t.time)
    EventManager:GetInstance():Broadcast(EventId.GatherSeasonResTimeChange)
  end
end

PushDesertCollectTimeUpdateMessage.OnCreate = OnCreate
PushDesertCollectTimeUpdateMessage.HandleMessage = HandleMessage
return PushDesertCollectTimeUpdateMessage
