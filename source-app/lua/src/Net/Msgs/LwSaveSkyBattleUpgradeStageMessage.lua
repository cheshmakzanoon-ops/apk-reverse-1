local LwSaveSkyBattleUpgradeStageMessage = BaseClass("LwSaveSkyBattleUpgradeStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSaveSkyBattleUpgradeStageMessage:OnCreate(id, isWin, starNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("star", starNum)
  self.sfsObj:PutBool("isWin", isWin)
end

function LwSaveSkyBattleUpgradeStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.LWSkyBattleGrowthChapterManager:CacheReward(t.id, t.reward)
      DataCenter.LWSkyBattleGrowthChapterManager:AddRewardsAndRes(t.reward)
      EventManager:GetInstance():Broadcast(EventId.SkyBattleReward, {
        reward = t.reward,
        isGrowthMode = true
      })
    end
    DataCenter.LWSkyBattleGrowthChapterManager:UpdateStageStar(t)
  end
end

return LwSaveSkyBattleUpgradeStageMessage
