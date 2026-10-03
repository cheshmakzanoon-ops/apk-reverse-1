local ActivitySidposSetMessage = BaseClass("ActivitySidposSetMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ActivitySidposSetMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("pos", param.pos)
end

function ActivitySidposSetMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.SeasonSelectLocationManager:OnSetCallback(t)
  end
end

return ActivitySidposSetMessage
