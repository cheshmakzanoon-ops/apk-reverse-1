local SeasonWeatherData = BaseClass("SeasonWeatherData")
local Localization = CS.GameEntry.Localization

function SeasonWeatherData:__init(t)
  self:UpdateData(t)
end

function SeasonWeatherData:__delete()
end

function SeasonWeatherData:UpdateData(netData)
  self.uuid = netData.uuid
  self.configId = netData.configId
  self.weatherId = netData.weatherId
  self.startTime = netData.startTime
  self.endTime = netData.endTime
  self.state = netData.state
  self.lastWeatherId = netData.lastWeatherId
  self.summonUserInfo = netData.summonUserInfo
end

function SeasonWeatherData:GetLastDefaultData()
  local netData = {}
  netData.uuid = -1
  netData.configId = math.max(self.configId - 1, 0)
  local config = DataCenter.SeasonWeatherManager:GetConfigData(netData.configId)
  netData.weatherId = config and config:GetWeatherType() or 0
  netData.startTime = self.startTime - 1000
  netData.endTime = self.startTime - 1
  netData.state = 2
  return netData
end

function SeasonWeatherData:GetLeftTimeStr()
  local leftTime = self.endTime - UITimeManager:GetInstance():GetServerTime()
  if leftTime <= 0 then
    return Localization:GetString("s1_weather_ui01")
  end
  local str
  leftTime = leftTime / 1000
  if 3600 <= leftTime then
    local hours = math.ceil(leftTime / 3600)
    return Localization:GetString("s1_weather_ui010", hours)
  end
  if 1800 <= leftTime then
    str = Localization:GetString("s1_weather_ui08", 1)
  else
    str = Localization:GetString("s1_weather_ui09", 30)
  end
  return string.format("%s%s", Localization:GetString("s1_weather_ui02"), str)
end

function SeasonWeatherData:GetAMBSoundId()
  local conf = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(self.weatherId)
  return conf and conf.bgm
end

function SeasonWeatherData:UpdateAMBSound()
  local ambSerial, ambId
  local curScene = CS.SceneManager.CurrSceneID
  if curScene == SceneManagerSceneID.World then
    ambSerial, ambId = SceneUtils.PlayWorldAMBSound()
    if not ambSerial or ambSerial <= 0 then
      DataCenter.LWSoundManager:StopAMBSound()
    end
  elseif curScene == SceneManagerSceneID.City then
    ambSerial, ambId = SceneUtils.PlayCityAMBSound()
    if not ambSerial or ambSerial <= 0 then
      DataCenter.LWSoundManager:StopAMBSound()
    end
  end
end

function SeasonWeatherData:PlaySound()
  local curScene = CS.SceneManager.CurrSceneID
  if curScene ~= SceneManagerSceneID.World and curScene ~= SceneManagerSceneID.City then
    return
  end
  local config = self.weatherId and DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(self.weatherId)
  if not (config and config.sound) or config.sound <= 0 then
    return
  end
  if 0 < UIUtil.GetMonthActiveCount("ScreenWeather" .. self.uuid) then
    return
  end
  return DataCenter.LWSoundManager:PlaySound(config.sound, false)
end

return SeasonWeatherData
