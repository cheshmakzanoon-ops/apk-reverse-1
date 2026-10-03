local LWSeasonActivitySynthesisMessage = BaseClass("LWSeasonActivitySynthesisMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.ActivityListDataManager:UpdateExtraData(SEASON_ACTIVITY_SYNTHESIS, t.info)
    EventManager:GetInstance():Broadcast(EventId.SeasonActivitySynthesisUpdate, t)
  end
end

LWSeasonActivitySynthesisMessage.OnCreate = OnCreate
LWSeasonActivitySynthesisMessage.HandleMessage = HandleMessage
return LWSeasonActivitySynthesisMessage
