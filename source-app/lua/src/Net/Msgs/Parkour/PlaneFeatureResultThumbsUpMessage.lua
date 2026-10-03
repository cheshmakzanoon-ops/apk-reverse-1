local PlaneFeatureResultThumbsUpMessage = BaseClass("PlaneFeatureResultThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureResultThumbsUpMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function PlaneFeatureResultThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    UIUtil.ShowTipsId("alliance_train_vip033")
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureThumbsSuccess, t.uuid)
  end
end

return PlaneFeatureResultThumbsUpMessage
