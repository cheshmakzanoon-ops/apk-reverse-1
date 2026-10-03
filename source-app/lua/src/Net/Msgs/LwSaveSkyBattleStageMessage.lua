local LwSaveSkyBattleStageMessage = BaseClass("LwSaveSkyBattleStageMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSaveSkyBattleStageMessage:OnCreate(id, isWin, starNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("star", starNum)
  self.sfsObj:PutBool("isWin", isWin)
end

function LwSaveSkyBattleStageMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.LWSkyBattleChapterManager:CacheReward(t.id, t.reward)
      DataCenter.RewardManager:AddRewardsAndRes(t)
      EventManager:GetInstance():Broadcast(EventId.SkyBattleReward, {
        reward = t.reward,
        isGrowthMode = false
      })
    end
    DataCenter.LWSkyBattleChapterManager:UpdateStageStar(t)
  end
end

return LwSaveSkyBattleStageMessage
