local PushGoldTreePowerFinishMessage = BaseClass("PushGoldTreePowerFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGoldTreePowerFinishMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushGoldTreePowerFinishMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonGoldTreeManager:PushGoldTreePowerFinishMessage(t)
end

return PushGoldTreePowerFinishMessage
