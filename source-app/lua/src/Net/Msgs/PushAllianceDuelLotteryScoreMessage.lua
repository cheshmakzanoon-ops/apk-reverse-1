local PushAllianceDuelLotteryScoreMessage = BaseClass("PushAllianceDuelLotteryScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAllianceDuelLotteryScoreMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAllianceDuelLotteryScoreMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllyDuelScoreGachaManager:OnPushScoreMessageCallback(t)
  end
end

return PushAllianceDuelLotteryScoreMessage
