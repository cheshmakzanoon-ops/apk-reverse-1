local MeteoriteEnterWorldMessage = BaseClass("MeteoriteEnterWorldMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteEnterWorldMessage:OnCreate(targetServerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetServerId", targetServerId)
end

function MeteoriteEnterWorldMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleEnterWorldMessage(t)
end

return MeteoriteEnterWorldMessage
