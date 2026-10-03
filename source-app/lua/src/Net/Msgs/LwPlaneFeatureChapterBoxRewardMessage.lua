local LwPlaneFeatureChapterBoxRewardMessage = BaseClass("LwPlaneFeatureChapterBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwPlaneFeatureChapterBoxRewardMessage:OnCreate(chapter)
  base.OnCreate(self)
  self.sfsObj:PutInt("chapter", chapter)
end

function LwPlaneFeatureChapterBoxRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.LWEasyStageFeatureChapterManager:UpdateBoxRewardData(t)
  end
end

return LwPlaneFeatureChapterBoxRewardMessage
