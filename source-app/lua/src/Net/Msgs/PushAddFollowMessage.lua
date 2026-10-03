local PushAddFollowMessage = BaseClass("PushAddFollowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAddFollowMessage:OnCreate()
end

function PushAddFollowMessage:HandleMessage(t)
  if t.result.result == "success" then
    ChatInterface.getMoment():AddFollow({
      followeeId = t.result.targetUid,
      isFollow = true
    })
    UIUtil.ShowTipsId("moment_follow_tips")
    local gift = t.gift
    if gift then
      DataCenter.GiftSystemManager:HandleSendGift(gift)
      if gift.reward then
        DataCenter.RewardManager:ShowCommonReward(gift)
        DataCenter.RewardManager:AddRewardsAndRes(gift)
      end
      DataCenter.ValentineDataManager:SetActSendGiftRecordDataDirty(gift)
    end
  else
    if t.result.error then
      UIUtil.ShowTipsId(t.result.error.errorCode)
      return
    end
    UIUtil.ShowTipsId(t.result.result)
  end
end

return PushAddFollowMessage
