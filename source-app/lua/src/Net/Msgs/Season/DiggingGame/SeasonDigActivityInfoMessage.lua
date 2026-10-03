local SeasonDigActivityInfoMessage = BaseClass("SeasonDigActivityInfoMessage", SFSBaseMessage)
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
  DataCenter.DiggingDataManager:OnMapListUpdate(t)
end

local function GetTestData(self)
  local t = {}
  local now = UITimeManager:GetInstance():GetServerTime()
  local mapList = {}
  for id = 10001, 10020 do
    local v = {
      uuid = id,
      mapConfigId = id,
      startTime = now + math.random(-30000, 30000),
      endTime = now + math.random(-50000, 10000000),
      redNum = 0
    }
    table.insert(mapList, v)
  end
  t.mapList = mapList
  t.shardTime = now
  t.helpNum = math.random(0, 10)
  return t
end

SeasonDigActivityInfoMessage.GetTestData = GetTestData
SeasonDigActivityInfoMessage.OnCreate = OnCreate
SeasonDigActivityInfoMessage.HandleMessage = HandleMessage
return SeasonDigActivityInfoMessage
