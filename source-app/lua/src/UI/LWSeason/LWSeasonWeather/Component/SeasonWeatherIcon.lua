local base = UIBaseContainer
local SeasonWeatherIcon = BaseClass("SeasonWeatherIcon", base)
local icon0_path = "yun"
local icon1_path = "wu"
local icon2_path = "yu"
local icon3_path = "suanyu"
local icon4_path = "caihong"
local icon5_path = "qing"
local icon6_path = "feng"
local icon100_path = "wenhao"

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
  self.icon0 = self:AddComponent(UIBaseContainer, icon0_path)
  self.icon1 = self:AddComponent(UIBaseContainer, icon1_path)
  self.icon2 = self:AddComponent(UIBaseContainer, icon2_path)
  self.icon3 = self:AddComponent(UIBaseContainer, icon3_path)
  self.icon4 = self:AddComponent(UIBaseContainer, icon4_path)
  self.icon5 = self:AddComponent(UIBaseContainer, icon5_path)
  self.icon6 = self:AddComponent(UIBaseContainer, icon6_path)
  self.icon100 = self:AddComponent(UIBaseContainer, icon100_path)
end

local function ComponentDestroy(self)
  self.icon0 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.icon4 = nil
  self.icon5 = nil
  self.icon6 = nil
  self.icon100 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonWeatherIcon:ReInit(weatherType)
  if not weatherType or weatherType < 0 then
    weatherType = 100
  end
  local list = DataCenter.SeasonWeatherManager:GetWeatherTypeList()
  for i, v in ipairs(list) do
    local fx = self["icon" .. v.type]
    if fx then
      fx:SetActive(v.type == weatherType)
    end
  end
end

SeasonWeatherIcon.OnCreate = OnCreate
SeasonWeatherIcon.OnDestroy = OnDestroy
SeasonWeatherIcon.OnEnable = OnEnable
SeasonWeatherIcon.OnDisable = OnDisable
SeasonWeatherIcon.ComponentDefine = ComponentDefine
SeasonWeatherIcon.ComponentDestroy = ComponentDestroy
SeasonWeatherIcon.DataDefine = DataDefine
SeasonWeatherIcon.DataDestroy = DataDestroy
return SeasonWeatherIcon
