local UIMainWeatherObj = BaseClass("UIMainWeatherObj", UIBaseContainer)
local base = UIBaseContainer
local weather_path = "weather"
local blizzard_path = "blizzard"
local time_path = "time"
local temperature_path = "temperature"

function UIMainWeatherObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainWeatherObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainWeatherObj:ComponentDefine()
  self.btn = self:AddComponent(UIButton, weather_path)
  self.btn:SetOnClick(function()
    self:JumpToBlizzard()
  end)
  self.blizzard = self:AddComponent(UITextMeshProUGUIEx, blizzard_path)
  self.timeTxt = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.temperature = self:AddComponent(UITextMeshProUGUIEx, temperature_path)
end

function UIMainWeatherObj:ComponentDestroy()
end

function UIMainWeatherObj:OnAddListener()
  base.OnAddListener(self)
end

function UIMainWeatherObj:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMainWeatherObj:Refresh()
  local state, ts = DataCenter.SeasonSnowStormDataManager:NeedShowBlizzardInMainUI()
  if state then
    self:SetActive(true)
    self.timestamp = ts
    self:Update1000MS()
    local cfg = DataCenter.SeasonSnowStormDataManager:GetCurBlizzardHeatSourceCfg()
    if state == ActivitySnowStormState.Warning then
      self.blizzard:SetLocalText("season_s2_storm_event_35")
    elseif state == ActivitySnowStormState.SnowStorm then
      self.blizzard:SetLocalText("season_s2_storm_event_34")
    end
    if cfg then
      self.temperature:SetLocalText("season_s2_common_temperature", cfg.default_temperature)
    else
      self.temperature:SetText("")
    end
  else
    self:SetActive(false)
  end
end

function UIMainWeatherObj:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.timestamp then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.timestamp - now)
    self.timeTxt:SetText(timeStr)
  else
    self:Refresh()
  end
end

function UIMainWeatherObj:JumpToBlizzard()
  GoToUtil.GotoSeasonSnowStormActivity()
end

return UIMainWeatherObj
