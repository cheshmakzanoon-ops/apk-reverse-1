local CrossGetAlliancePointMessage = BaseClass("CrossGetAlliancePointMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.server ~= nil and t.pointId ~= nil then
    DataCenter.AllianceCompeteDataManager:HandleRecommendAttackPointMessage(t.server, t.pointId)
  end
end

CrossGetAlliancePointMessage.OnCreate = OnCreate
CrossGetAlliancePointMessage.HandleMessage = HandleMessage
return CrossGetAlliancePointMessage
