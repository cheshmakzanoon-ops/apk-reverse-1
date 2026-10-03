local DarkKnightAllianceInfoMessage = BaseClass("DarkKnightAllianceInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DarkKnightAllianceInfoMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
end

function DarkKnightAllianceInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.CounterAttackDataManager:RecMsgActivityInfo(message)
end

return DarkKnightAllianceInfoMessage
