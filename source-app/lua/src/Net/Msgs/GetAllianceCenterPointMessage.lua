local GetAllianceCenterPointMessage = BaseClass("GetAllianceCenterPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceCompeteDataManager:HandleRecommendBackPointMessage(t.pointId)
  end
end

GetAllianceCenterPointMessage.OnCreate = OnCreate
GetAllianceCenterPointMessage.HandleMessage = HandleMessage
return GetAllianceCenterPointMessage
