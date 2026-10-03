local base = UIBaseContainer
local SeasonWeatherNextItem = BaseClass("SeasonWeatherNextItem", base)
local SeasonWeatherIcon = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherIcon")
local title_path = "title"
local desc1_path = "weather1/desc1"
local icon1_path = "weather1/icon1"
local btn1_path = "weather1/btn1"
local desc2_path = "weather2/desc2"
local icon2_path = "weather2/icon2"
local btn2_path = "weather2/btn2"
local desc3_path = "weather3/desc3"
local icon3_path = "weather3/icon3"
local btn3_path = "weather3/btn3"
local fxIcon1_path = "weather1/fxIcon1"
local fxIcon2_path = "weather2/fxIcon2"
local fxIcon3_path = "weather3/fxIcon3"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.desc1 = self:AddComponent(UIText, desc1_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.btn1 = self:AddComponent(UIButton, btn1_path)
  self.desc2 = self:AddComponent(UIText, desc2_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.btn2 = self:AddComponent(UIButton, btn2_path)
  self.desc3 = self:AddComponent(UIText, desc3_path)
  self.icon3 = self:AddComponent(UIImage, icon3_path)
  self.btn3 = self:AddComponent(UIButton, btn3_path)
  self.fxIcon1 = self:AddComponent(UIBaseContainer, fxIcon1_path)
  self.fxIcon2 = self:AddComponent(UIBaseContainer, fxIcon2_path)
  self.fxIcon3 = self:AddComponent(UIBaseContainer, fxIcon3_path)
  self.btn1:SetOnClick(function()
    local weatherId = self.nextWeather and self.nextWeather.weatherList and self.nextWeather.weatherList[1] and self.nextWeather.weatherList[1].weatherId
    local info = weatherId and DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherId)
    if info then
      info:ShowBuffTips(self.btn1.transform)
    end
  end)
  self.btn2:SetOnClick(function()
    local weatherId = self.nextWeather and self.nextWeather.weatherList and self.nextWeather.weatherList[2] and self.nextWeather.weatherList[2].weatherId
    local info = weatherId and DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherId)
    if info then
      info:ShowBuffTips(self.btn2.transform)
    end
  end)
  self.btn3:SetOnClick(function()
    local weatherId = self.nextWeather and self.nextWeather.weatherList and self.nextWeather.weatherList[3] and self.nextWeather.weatherList[3].weatherId
    local info = weatherId and DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherId)
    if info then
      info:ShowBuffTips(self.btn3.transform)
    end
  end)
  self.fxIcon1 = self:AddComponent(SeasonWeatherIcon, fxIcon1_path)
  self.fxIcon2 = self:AddComponent(SeasonWeatherIcon, fxIcon2_path)
  self.fxIcon3 = self:AddComponent(SeasonWeatherIcon, fxIcon3_path)
end

local function ComponentDestroy(self)
  self.title = nil
  self.desc1 = nil
  self.icon1 = nil
  self.btn1 = nil
  self.desc2 = nil
  self.icon2 = nil
  self.btn2 = nil
  self.desc3 = nil
  self.icon3 = nil
  self.btn3 = nil
  self.fxIcon1 = nil
  self.fxIcon2 = nil
  self.fxIcon3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonWeatherNextItem:ReInit(nextWeather, showEffect)
  self.nextWeather = nextWeather
  if nextWeather.weatherList then
    for i = 1, 3 do
      local v = nextWeather.weatherList[i]
      local iconFxComp = self["fxIcon" .. i]
      local iconComp = self["icon" .. i]
      local descComp = self["desc" .. i]
      if v then
        if showEffect then
          iconFxComp:ReInit(v.weatherId)
          iconFxComp:SetActive(true)
          iconComp:SetActive(false)
        else
          iconFxComp:SetActive(false)
          local info = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(v.weatherId)
          iconComp:LoadSpriteAuto(info.icon)
          iconComp:SetActive(true)
        end
        descComp:SetLocalText("s1_weather_ui10", v.weightRate)
      else
        iconFxComp:SetActive(false)
        iconComp:SetActive(false)
        descComp:SetLocalText("")
      end
    end
  end
end

SeasonWeatherNextItem.OnCreate = OnCreate
SeasonWeatherNextItem.OnDestroy = OnDestroy
SeasonWeatherNextItem.OnEnable = OnEnable
SeasonWeatherNextItem.OnDisable = OnDisable
SeasonWeatherNextItem.ComponentDefine = ComponentDefine
SeasonWeatherNextItem.ComponentDestroy = ComponentDestroy
SeasonWeatherNextItem.DataDefine = DataDefine
SeasonWeatherNextItem.DataDestroy = DataDestroy
return SeasonWeatherNextItem
