local ThanksgivingReceiveBaseRewardMessage = BaseClass("ThanksgivingReceiveBaseRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, otherUid, statusId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("otherUid", otherUid)
  self.sfsObj:PutInt("statusId", statusId)
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
  DataCenter.ActGiftGivingDataManager:SetRewardBubbleGetNumData(t)
  EventManager:GetInstance():Broadcast(EventId.WorldRewardBubbleGetMsg)
end

ThanksgivingReceiveBaseRewardMessage.OnCreate = OnCreate
ThanksgivingReceiveBaseRewardMessage.HandleMessage = HandleMessage
return ThanksgivingReceiveBaseRewardMessage
