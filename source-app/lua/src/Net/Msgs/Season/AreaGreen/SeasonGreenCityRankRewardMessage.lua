local SeasonGreenCityRankRewardMessage = BaseClass("SeasonGreenCityRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonRewardDataManager:SeasonGreenCityRankRewardInfo(t.rankReward)
end

local function GetTestData(self)
  local t = {}
  return t
end

SeasonGreenCityRankRewardMessage.GetTestData = GetTestData
SeasonGreenCityRankRewardMessage.OnCreate = OnCreate
SeasonGreenCityRankRewardMessage.HandleMessage = HandleMessage
return SeasonGreenCityRankRewardMessage
