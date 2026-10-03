local LwSkyBattleChapterBoxRewardMessage = BaseClass("LwSkyBattleChapterBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSkyBattleChapterBoxRewardMessage:OnCreate(chapter, stageType)
  base.OnCreate(self)
  self.sfsObj:PutInt("chapter", chapter)
  self.sfsObj:PutInt("stageType", stageType)
end

function LwSkyBattleChapterBoxRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    if t.stageType and t.stageType == 1 then
      DataCenter.LWSkyBattleGrowthChapterManager:UpdateBoxRewardData(t)
    else
      DataCenter.LWSkyBattleChapterManager:UpdateBoxRewardData(t)
    end
  end
end

return LwSkyBattleChapterBoxRewardMessage
