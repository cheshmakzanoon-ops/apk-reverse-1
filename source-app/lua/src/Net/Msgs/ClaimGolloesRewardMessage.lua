local ClaimGolloesRewardMessage = BaseClass("ClaimGolloesRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, golloesParam)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", golloesParam)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.GolloesCampManager:UpdateGolloesInfo(t)
  end
end

ClaimGolloesRewardMessage.OnCreate = OnCreate
ClaimGolloesRewardMessage.HandleMessage = HandleMessage
return ClaimGolloesRewardMessage
