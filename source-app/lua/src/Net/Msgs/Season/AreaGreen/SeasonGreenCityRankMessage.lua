local SeasonGreenCityRankMessage = BaseClass("SeasonGreenCityRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, weekNum)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type or 1)
  self.sfsObj:PutInt("weekNum", weekNum or 1)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SeasonGreenManager:SeasonGreenCityRank(t.rankArray, t.type, t.weekNum, t.selfRank, t.selfScore)
end

local function GetTestData(self)
  local t = {}
  return t
end

SeasonGreenCityRankMessage.GetTestData = GetTestData
SeasonGreenCityRankMessage.OnCreate = OnCreate
SeasonGreenCityRankMessage.HandleMessage = HandleMessage
return SeasonGreenCityRankMessage
