local CrossThroneGetStrategicAreaOverviewMessage = BaseClass("CrossThroneGetStrategicAreaOverviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossThroneGetStrategicAreaOverviewMessage:OnCreate(param)
  base.OnCreate(self)
end

function CrossThroneGetStrategicAreaOverviewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and t.ls then
    DataCenter.CampWarManager:CrossThroneGetStrategicAreaOverview(t.ls)
  end
end

return CrossThroneGetStrategicAreaOverviewMessage
