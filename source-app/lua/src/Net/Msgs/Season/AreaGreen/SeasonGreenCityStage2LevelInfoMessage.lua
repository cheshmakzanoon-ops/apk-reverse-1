local SeasonGreenCityStage2LevelInfoMessage = BaseClass("SeasonGreenCityStage2LevelInfoMessage", SFSBaseMessage)
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
  if not t.areaLevelInfo then
    return
  end
  local count, curOpenLevel = 0, 0
  for i, v in ipairs(t.areaLevelInfo) do
    if v.open and v.open == 1 then
      curOpenLevel = v.level
    end
    count = count + 1
  end
  DataCenter.SeasonGreenManager:SeasonGreenCityStage2LevelInfo(t.areaLevelInfo, curOpenLevel, t.totalGreenRate or 0)
end

local function GetTestData(self)
  local t = {}
  return t
end

SeasonGreenCityStage2LevelInfoMessage.GetTestData = GetTestData
SeasonGreenCityStage2LevelInfoMessage.OnCreate = OnCreate
SeasonGreenCityStage2LevelInfoMessage.HandleMessage = HandleMessage
return SeasonGreenCityStage2LevelInfoMessage
