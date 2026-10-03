local AlDuelLotteryGetInfoMessage = BaseClass("AlDuelLotteryGetInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AlDuelLotteryGetInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function AlDuelLotteryGetInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllyDuelScoreGachaManager:OnGachaInfoMessageCallback(t)
  end
end

return AlDuelLotteryGetInfoMessage
