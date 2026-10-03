local LottoReceiveBigRewardMessage = BaseClass("LottoReceiveBigRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, day)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("day", day)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ActLotteryDataManager:GetReceiveBigRewardMsg(t)
  DataCenter.ActLotteryDataManager:GetOpenBigRewardViewClose()
  EventManager:GetInstance():Broadcast(EventId.ActLotteryOpenViewClose)
  EventManager:GetInstance():Broadcast(EventId.ActLotteryReceiveBigRewardMsg, t)
end

LottoReceiveBigRewardMessage.OnCreate = OnCreate
LottoReceiveBigRewardMessage.HandleMessage = HandleMessage
return LottoReceiveBigRewardMessage
