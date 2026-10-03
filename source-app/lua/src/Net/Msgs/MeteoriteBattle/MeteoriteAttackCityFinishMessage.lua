local MeteoriteAttackCityFinishMessage = BaseClass("MeteoriteAttackCityFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MeteoriteAttackCityFinishMessage:OnCreate(id)
  base.OnCreate(self)
end

function MeteoriteAttackCityFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActMeteoriteBattleManager:OnHandleAttackCityFinish(t)
end

return MeteoriteAttackCityFinishMessage
