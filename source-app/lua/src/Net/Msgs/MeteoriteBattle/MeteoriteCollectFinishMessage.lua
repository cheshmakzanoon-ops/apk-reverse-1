local MeteoriteCollectFinishMessage = BaseClass("MeteoriteCollectFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteCollectFinishMessage:OnCreate(id)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
end

function MeteoriteCollectFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleCollectFinish(t)
end

return MeteoriteCollectFinishMessage
