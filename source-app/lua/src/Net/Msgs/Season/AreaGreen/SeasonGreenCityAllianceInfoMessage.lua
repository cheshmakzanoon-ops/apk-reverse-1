local SeasonGreenCityAllianceInfoMessage = BaseClass("SeasonGreenCityAllianceInfoMessage", SFSBaseMessage)
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
  DataCenter.SeasonGreenManager:SeasonGreenCityAllianceInfo(t.allianceCityInfo)
end

local function GetTestData(self)
  local t = {}
  t.allianceCityInfo = {
    {
      cityId = 30,
      greenRate = 0.5,
      suppliesNum = 10
    },
    {
      cityId = 31,
      greenRate = 0.6,
      suppliesNum = 20
    },
    {
      cityId = 32,
      greenRate = 0.7,
      suppliesNum = 0
    }
  }
  return t
end

SeasonGreenCityAllianceInfoMessage.GetTestData = GetTestData
SeasonGreenCityAllianceInfoMessage.OnCreate = OnCreate
SeasonGreenCityAllianceInfoMessage.HandleMessage = HandleMessage
return SeasonGreenCityAllianceInfoMessage
