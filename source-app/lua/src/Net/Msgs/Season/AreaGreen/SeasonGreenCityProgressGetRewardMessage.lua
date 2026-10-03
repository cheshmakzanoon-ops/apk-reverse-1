local SeasonGreenCityProgressGetRewardMessage = BaseClass("SeasonGreenCityProgressGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.reward or t.resource then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.SeasonGreenManager:SeasonGreenCityProgressGetReward(t.index)
end

local function GetTestData(self)
  local t = {}
  return t
end

SeasonGreenCityProgressGetRewardMessage.GetTestData = GetTestData
SeasonGreenCityProgressGetRewardMessage.OnCreate = OnCreate
SeasonGreenCityProgressGetRewardMessage.HandleMessage = HandleMessage
return SeasonGreenCityProgressGetRewardMessage
