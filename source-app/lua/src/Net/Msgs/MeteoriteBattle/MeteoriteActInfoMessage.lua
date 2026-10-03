local MeteoriteActInfoMessage = BaseClass("MeteoriteActInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteActInfoMessage:OnCreate()
  base.OnCreate(self)
end

function MeteoriteActInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleActInfo(t)
end

return MeteoriteActInfoMessage
