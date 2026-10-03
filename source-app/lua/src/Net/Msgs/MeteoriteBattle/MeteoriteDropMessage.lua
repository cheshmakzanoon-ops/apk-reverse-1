local MeteoriteDropMessage = BaseClass("MeteoriteDropMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteDropMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function MeteoriteDropMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnDropMeteorite(t)
end

return MeteoriteDropMessage
