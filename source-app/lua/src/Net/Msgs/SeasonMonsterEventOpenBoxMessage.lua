local SeasonMonsterEventOpenBoxMessage = BaseClass("SeasonMonsterEventOpenBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMonsterEventOpenBoxMessage:OnCreate(actId)
  base.OnCreate(self)
  self.sfsObj:PutInt("actId", actId)
end

function SeasonMonsterEventOpenBoxMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.JungleTrialDataManager:HandleOpenBox(t.userSeasonMonsterEventActInfo)
  end
end

return SeasonMonsterEventOpenBoxMessage
