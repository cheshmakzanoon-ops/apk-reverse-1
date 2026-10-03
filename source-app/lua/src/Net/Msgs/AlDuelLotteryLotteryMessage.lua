local AlDuelLotteryLotteryMessage = BaseClass("AlDuelLotteryLotteryMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AlDuelLotteryLotteryMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", param.configId)
  self.sfsObj:PutInt("num", param.num)
end

function AlDuelLotteryLotteryMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.AllyDuelScoreGachaEndGacha)
  else
    DataCenter.AllyDuelScoreGachaManager:OnGachaMessageCallback(t)
  end
end

return AlDuelLotteryLotteryMessage
