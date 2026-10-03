local PlaneFeatureHelpFromMeMessage = BaseClass("PlaneFeatureHelpFromMeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureHelpFromMeMessage:OnCreate(param)
  base.OnCreate(self)
end

function PlaneFeatureHelpFromMeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureGetHelpFromMe, t)
  end
end

return PlaneFeatureHelpFromMeMessage
