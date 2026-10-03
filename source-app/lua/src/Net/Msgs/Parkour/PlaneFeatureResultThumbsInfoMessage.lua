local PlaneFeatureResultThumbsInfoMessage = BaseClass("PlaneFeatureResultThumbsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureResultThumbsInfoMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function PlaneFeatureResultThumbsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local params = {}
    params.uuid = t.uuid
    params.hasThumb = t.hasThumb
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureGetResultThumbsInfo, params)
  end
end

return PlaneFeatureResultThumbsInfoMessage
