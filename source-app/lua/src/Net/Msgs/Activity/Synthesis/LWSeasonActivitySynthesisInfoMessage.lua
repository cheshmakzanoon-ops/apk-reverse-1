local LWSeasonActivitySynthesisInfoMessage = BaseClass("LWSeasonActivitySynthesisInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.ActivityListDataManager:UpdateExtraData(SEASON_ACTIVITY_SYNTHESIS, t)
  end
end

LWSeasonActivitySynthesisInfoMessage.OnCreate = OnCreate
LWSeasonActivitySynthesisInfoMessage.HandleMessage = HandleMessage
return LWSeasonActivitySynthesisInfoMessage
