local GetAdsRewardMessage = BaseClass("GetAdsRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetAdsRewardMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", param.id)
  self.sfsObj:PutBool("all", param.isAll)
end

function GetAdsRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.MaxAdManager:ClearWatchInfo()
    DataCenter.MaxAdManager:OnReceiveAdsInfo(t)
    DataCenter.RewardManager:AddRewards(t.rewards or {})
    DataCenter.MaxAdManager:ShowReward(t)
  end
end

return GetAdsRewardMessage
