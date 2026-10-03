local base = UIBaseContainer
local SeasonWeatherItem = BaseClass("SeasonWeatherItem", base)
local SeasonWeatherIcon = require("UI.LWSeason.LWSeasonWeather.Component.SeasonWeatherIcon")
local title_path = "title"
local desc_path = "desc"
local icon_path = "icon"
local btnIcon_path = "btn"
local fx_path = "fx"
local fxIcon_path = "fxIcon"
local bg_path = ""

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
  self.desc = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btnIcon = self:AddComponent(UIButton, btnIcon_path)
  self.fx = self:AddComponent(UIBaseContainer, fx_path)
  self.fxIcon = self:AddComponent(UIBaseContainer, fxIcon_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btnIcon:SetOnClick(function()
    local info = self.weatherType and DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(self.weatherType)
    if info then
      info:ShowBuffTips(self.btnIcon.transform)
    end
  end)
  local param = {
    duration = 3,
    lifeType = UIVfxLifeType.DestroyAfterOnce
  }
  self.fx = self:AddComponent(UIVfx, fx_path, VfxAssets.WeatherChange, param)
  self.anim = self:AddComponent(UISimpleAnimation, "")
  self.weatherIcon = self:AddComponent(SeasonWeatherIcon, fxIcon_path)
end

local function ComponentDestroy(self)
  self.title = nil
  self.desc = nil
  self.icon = nil
  self.btnIcon = nil
  self.fx = nil
  self.fxIcon = nil
  self.bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonWeatherItem:ReInit(data, showEffect)
  local weatherType = data and data.weatherId
  self.anim:SampleAnimationAtTime("Default", 0)
  if self.weatherType and weatherType ~= self.weatherType then
    self.anim:Play("Default")
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.fx then
        self.fx:Replay()
      end
    end, 0.1)
  end
  self.weatherType = weatherType or 0
  local info = DataCenter.SeasonWeatherManager:GetWeatherTypeInfo(weatherType)
  if showEffect then
    self.weatherIcon:ReInit(weatherType)
    self.weatherIcon:SetActive(true)
    self.icon:SetActive(false)
  else
    self.weatherIcon:SetActive(false)
    self.icon:LoadSpriteAuto(info.icon)
    self.icon:SetActive(true)
  end
  self.desc:SetLocalText(info.name)
  if 0 < data.endTime - UITimeManager:GetInstance():GetServerTime() then
    self.data = data
    self:Update1000MS()
  else
    self.data = nil
    self.title:SetText(data:GetLeftTimeStr())
  end
  if showEffect then
    self.bg:LoadSpriteAsync(info:GetBgPath())
  end
end

function SeasonWeatherItem:Update1000MS()
  if self.data then
    self.title:SetText(self.data:GetLeftTimeStr())
  end
end

SeasonWeatherItem.OnCreate = OnCreate
SeasonWeatherItem.OnDestroy = OnDestroy
SeasonWeatherItem.OnEnable = OnEnable
SeasonWeatherItem.OnDisable = OnDisable
SeasonWeatherItem.ComponentDefine = ComponentDefine
SeasonWeatherItem.ComponentDestroy = ComponentDestroy
SeasonWeatherItem.DataDefine = DataDefine
SeasonWeatherItem.DataDestroy = DataDestroy
return SeasonWeatherItem
