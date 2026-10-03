local AlDuelLotteryGetProtectRewardMessage = BaseClass("AlDuelLotteryGetProtectRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AlDuelLotteryGetProtectRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", param.configId)
end

function AlDuelLotteryGetProtectRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.AllyDuelScoreGachaManager:SetWaitingClaimMsgFlag(false)
  else
    DataCenter.AllyDuelScoreGachaManager:OnClaimWishMessageCallback(t)
  end
end

return AlDuelLotteryGetProtectRewardMessage
