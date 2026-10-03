local SeasonGreenCityProgressInfoMessage = BaseClass("SeasonGreenCityProgressInfoMessage", SFSBaseMessage)
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
  DataCenter.SeasonGreenManager:SeasonGreenCityProgressInfo(t)
end

local function GetTestData(self)
  local t = {}
  return t
end

SeasonGreenCityProgressInfoMessage.GetTestData = GetTestData
SeasonGreenCityProgressInfoMessage.OnCreate = OnCreate
SeasonGreenCityProgressInfoMessage.HandleMessage = HandleMessage
return SeasonGreenCityProgressInfoMessage
