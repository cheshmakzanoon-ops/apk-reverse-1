local ReceiveAllianceBossS0FirstRewardMessage = BaseClass("ReceiveAllianceBossS0FirstRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ReceiveAllianceBossS0FirstRewardMessage:OnCreate(difficultyLevel)
  base.OnCreate(self)
  self.sfsObj:PutInt("difficultyLevel", difficultyLevel)
end

function ReceiveAllianceBossS0FirstRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil)
  DataCenter.S0AllianceBossDataManager:ReqActMainMessage()
end

return ReceiveAllianceBossS0FirstRewardMessage
