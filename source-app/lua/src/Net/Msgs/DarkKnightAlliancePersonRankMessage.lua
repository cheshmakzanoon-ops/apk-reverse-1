local DarkKnightAlliancePersonRankMessage = BaseClass("DarkKnightAlliancePersonRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DarkKnightAlliancePersonRankMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
end

function DarkKnightAlliancePersonRankMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTipsId(message.errorCode)
    return
  end
  DataCenter.CounterAttackDataManager:RecMsgPersonRank(message)
end

return DarkKnightAlliancePersonRankMessage
