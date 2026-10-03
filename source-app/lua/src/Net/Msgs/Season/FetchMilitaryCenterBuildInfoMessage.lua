local FetchMilitaryCenterBuildInfoMessage = BaseClass("FetchMilitaryCenterBuildInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchMilitaryCenterBuildInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchMilitaryCenterBuildInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local data = DataCenter.AllianceMineManager.militaryCenterBuildInfos or {}
  if t.info then
    data.info = t.info
  end
  if t.buildInfo then
    data.buildInfo = t.buildInfo
  end
  if t.darknessSeason then
    data.darknessSeason = t.darknessSeason
  end
  data.now = UITimeManager:GetInstance():GetServerTime()
  DataCenter.AllianceMineManager.militaryCenterBuildInfos = data
  EventManager:GetInstance():Broadcast(EventId.AllianceStoveCenterUpdate)
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

return FetchMilitaryCenterBuildInfoMessage
