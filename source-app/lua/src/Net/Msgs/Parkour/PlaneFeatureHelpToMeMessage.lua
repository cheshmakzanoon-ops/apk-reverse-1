local PlaneFeatureHelpToMeMessage = BaseClass("PlaneFeatureHelpToMeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureHelpToMeMessage:OnCreate()
  base.OnCreate(self)
end

function PlaneFeatureHelpToMeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureGetHelpToMe, t)
  end
end

return PlaneFeatureHelpToMeMessage
