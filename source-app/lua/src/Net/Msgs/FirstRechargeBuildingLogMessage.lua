local FirstRechargeBuildingLogMessage = BaseClass("FirstRechargeBuildingLogMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FirstRechargeBuildingLogMessage:OnCreate(param)
  base.OnCreate(self)
end

function FirstRechargeBuildingLogMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.dataArr then
    EventManager:GetInstance():Broadcast(EventId.FirstRechargeBuildingLogData, t.dataArr)
  end
end

return FirstRechargeBuildingLogMessage
