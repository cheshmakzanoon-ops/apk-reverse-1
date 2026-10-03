local PushDragonBattleBehaviorNotifyMessage = BaseClass("PushDragonBattleBehaviorNotifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonBattleBehaviorNotifyMessage:OnCreate()
  base.OnCreate(self)
end

function PushDragonBattleBehaviorNotifyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActDragonManager:HandleBattleBehaviorData(t)
end

return PushDragonBattleBehaviorNotifyMessage
