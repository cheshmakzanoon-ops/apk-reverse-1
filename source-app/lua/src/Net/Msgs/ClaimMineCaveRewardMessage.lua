local ClaimMineCaveRewardMessage = BaseClass("ClaimMineCaveRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.MineCaveManager:UpdateMineCaveInfo(t)
  end
end

ClaimMineCaveRewardMessage.OnCreate = OnCreate
ClaimMineCaveRewardMessage.HandleMessage = HandleMessage
return ClaimMineCaveRewardMessage
