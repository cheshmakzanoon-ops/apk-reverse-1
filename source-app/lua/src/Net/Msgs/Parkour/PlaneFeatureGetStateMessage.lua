local PlaneFeatureGetState = BaseClass("PlaneFeatureGetState", SFSBaseMessage)
local base = SFSBaseMessage

function PlaneFeatureGetState:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function PlaneFeatureGetState:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local params = {}
    params.uuid = t.uuid
    params.state = t.state
    EventManager:GetInstance():Broadcast(EventId.PlaneFeatureGetShareStateSuccess, params)
  end
end

return PlaneFeatureGetState
