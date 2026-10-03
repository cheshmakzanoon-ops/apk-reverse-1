local LimitGiftOpMessage = BaseClass("LimitGiftOpMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
end

LimitGiftOpMessage.OnCreate = OnCreate
LimitGiftOpMessage.HandleMessage = HandleMessage
return LimitGiftOpMessage
