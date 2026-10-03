local GetCityAttachmentRewardByIconMessage = BaseClass("GetCityAttachmentRewardByIconMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityAttachmentRewardByIconMessage:OnCreate(cityId, slotIndex)
  base.OnCreate(self)
  self.sfsObj:PutInt("cityId", cityId)
  self.sfsObj:PutInt("slotIndex", slotIndex)
end

function GetCityAttachmentRewardByIconMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  local allianceBuildInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo
  if allianceBuildInfo and allianceBuildInfo.rewardList then
    for _, v in ipairs(allianceBuildInfo.rewardList) do
      if v.cityId == t.cityId and v.slot == t.slotIndex then
        v.leftNum = 0
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CityAttachmentOneRewardFinish, t)
end

return GetCityAttachmentRewardByIconMessage
