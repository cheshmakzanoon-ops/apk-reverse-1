local Localization = CS.GameEntry.Localization
local BerserkBossRankPraiseMessage = BaseClass("BerserkBossRankPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BerserkBossRankPraiseMessage:OnCreate(uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
end

function BerserkBossRankPraiseMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = message.reward
    if reward ~= nil then
      DataCenter.RewardManager:AddRewardsAndRes(message)
    end
    if message.changeGold and message.changeGold > 0 then
      local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.Gold)
      local num = message.changeGold
      UIUtil.ShowTips(Localization:GetString("500216", name, num))
    end
  end
  DataCenter.LWBerserkBossManager:HandleBerserkBossRankPraiseData(message)
end

return BerserkBossRankPraiseMessage
