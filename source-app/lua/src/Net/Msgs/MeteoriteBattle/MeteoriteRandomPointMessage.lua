local MeteoriteRandomPointMessage = BaseClass("MeteoriteRandomPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteRandomPointMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function MeteoriteRandomPointMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleRandomPoint(t)
end

return MeteoriteRandomPointMessage
