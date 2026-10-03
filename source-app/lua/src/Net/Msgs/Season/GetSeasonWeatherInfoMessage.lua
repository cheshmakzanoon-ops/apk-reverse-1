local GetSeasonWeatherInfoMessage = BaseClass("GetSeasonWeatherInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonWeatherInfoMessage:OnCreate()
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", LuaEntry.Player:GetCurServerId())
end

function GetSeasonWeatherInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.SeasonWeatherManager:InitData()
    return
  end
  if not (t and t.curWeather) or t.curWeather.endTime < UITimeManager:GetInstance():GetServerTime() then
    DataCenter.SeasonWeatherManager:InitData()
    return
  end
  DataCenter.SeasonWeatherManager:InitData(t)
end

function GetSeasonWeatherInfoMessage:GetTestData(weatherId)
  local t = {}
  local curServerConfig = SeasonUtil.GetCurServerConfig()
  local seasonType = curServerConfig and curServerConfig.seasonType or 0
  local weatherIdRandom = seasonType == SeasonMapType.CityStronghold and math.random(0, 6) or math.random(10, 16)
  t.serverId = LuaEntry.Player:GetCurServerId()
  t.curWeather = {
    uuid = -math.random(0, 1000000000),
    configId = math.random(100, 199),
    weatherId = weatherId or weatherIdRandom,
    startTime = UITimeManager:GetInstance():GetServerTime() - 100000,
    endTime = UITimeManager:GetInstance():GetServerTime() + math.random(100, 100000000),
    state = 1
  }
  t.lastWeather = {
    uuid = -math.random(0, 1000000000),
    configId = t.curWeather.configId - 1,
    weatherId = math.random(0, 6),
    startTime = UITimeManager:GetInstance():GetServerTime() - 200000,
    endTime = UITimeManager:GetInstance():GetServerTime() - 100000,
    state = 2
  }
  return t
end

return GetSeasonWeatherInfoMessage
