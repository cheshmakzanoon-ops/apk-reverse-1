local ActivitySidposInfoMessage = BaseClass("ActivitySidposInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivitySidposInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function ActivitySidposInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonSelectLocationManager:OnGetInfoCallback(t)
  end
end

return ActivitySidposInfoMessage
