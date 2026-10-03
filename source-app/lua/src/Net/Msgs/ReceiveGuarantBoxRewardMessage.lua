local ReceiveGuarantBoxRewardMessage = BaseClass("ReceiveGuarantBoxRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, id, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", id)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshBagItems)
  end
end

ReceiveGuarantBoxRewardMessage.OnCreate = OnCreate
ReceiveGuarantBoxRewardMessage.HandleMessage = HandleMessage
return ReceiveGuarantBoxRewardMessage
