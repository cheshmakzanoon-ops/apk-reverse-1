local ClaimBattleCardStageRewardMessage = BaseClass("ClaimBattleCardStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, index, cardType, cfgId)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
  self.sfsObj:PutInt("cardType", cardType)
  self.sfsObj:PutInt("cfgId", cfgId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    return
  end
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.TacticalCardDataManager:UpdateCardCollections({
    message.collectObj
  })
end

ClaimBattleCardStageRewardMessage.OnCreate = OnCreate
ClaimBattleCardStageRewardMessage.HandleMessage = HandleMessage
return ClaimBattleCardStageRewardMessage
