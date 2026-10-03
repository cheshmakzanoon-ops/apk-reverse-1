local UIMainSeasonWeatherObj = BaseClass("UIMainSeasonWeatherObj", UIBaseContainer)
local base = UIBaseContainer
local SeasonWeatherIcon = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherIcon")
local weather_old_path = "mask_old/weather_old"
local weather_path = "mask_new/weather_new"
local name_path = "name"
local time_path = "time"
local fx_icon_path = "mask_new/fxIcon"

function UIMainSeasonWeatherObj:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainSeasonWeatherObj:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainSeasonWeatherObj:ComponentDefine()
  self.rawImageOld = self:AddComponent(UIRawImage, weather_old_path)
  self.rawImage = self:AddComponent(UIRawImage, weather_path)
  self.btn = self:AddComponent(UIButton, weather_path)
  self.btn:SetOnClick(function()
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonWeather) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonWeather, {anim = true})
    end
  end)
  self.nameTxt = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.timeTxt = self:AddComponent(UITextMeshProUGUIEx, time_path)
  local param = {
    duration = 3,
    lifeType = UIVfxLifeType.DestroyAfterOnce
  }
  self.fx = self:AddComponent(UIVfx, "fx", VfxAssets.WeatherObjChange, param)
  self.anim = self:AddComponent(UIAnimator, "")
  self.fxIcon = self:AddComponent(SeasonWeatherIcon, fx_icon_path)
  self.btn:SetInteractable(not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSeasonWeather))
end

function UIMainSeasonWeatherObj:ComponentDestroy()
end

function UIMainSeasonWeatherObj:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonWeatherInfoUpdate, self.Refresh)
end

function UIMainSeasonWeatherObj:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonWeatherInfoUpdate, self.Refresh)
  base.OnRemoveListener(self)
end

function UIMainSeasonWeatherObj:Refresh()
  if not DataCenter.SeasonWeatherManager:CanShowUI() then
    self:SetActive(false)
    return
  end
  local info = DataCenter.SeasonWeatherManager:GetWeatherInfo()
  self.info = info
  if not info or not info.endTime then
    self:SetActive(false)
    return
  end
  self.endTime = info.endTime
  if UITimeManager:GetInstance():GetServerTime() >= self.endTime then
    self:SetActive(false)
    return
  end
  local weatherType = info.weatherId or 0
  local typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  if not typeInfo then
    self:SetActive(false)
    return
  end
  self.nameTxt:SetLocalText(typeInfo.name)
  self.rawImage:LoadSpriteAuto(typeInfo.icon_bg)
  self.fxIcon:ReInit(weatherType)
  self:Update1000MS()
  self:SetActive(true)
  if self.weatherType and self.weatherType ~= weatherType then
    typeInfo = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(self.weatherType)
    if typeInfo then
      self.rawImageOld:LoadSpriteAuto(typeInfo.icon_bg)
      self.anim:Play("change")
      self.fx:Replay()
    end
  end
  self.weatherType = weatherType
end

function UIMainSeasonWeatherObj:Update1000MS()
  if self.info then
    self.timeTxt:SetText(self.info:GetLeftTimeStr())
  end
end

return UIMainSeasonWeatherObj
