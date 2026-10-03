local base = UIBaseContainer
local SeasonWeatherDetailItem = BaseClass("SeasonWeatherDetailItem", base)
local bg_path = ""
local icon_path = "icon"
local desc_path = "desc"
local name_path = "name"

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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.name = self:AddComponent(UIText, name_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.icon = nil
  self.desc = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonWeatherDetailItem:ReInit(index, weatherInfo)
  if not weatherInfo then
    return
  end
  self.icon:LoadSprite(weatherInfo.icon)
  self.desc:SetLocalText(weatherInfo.desc)
  self.name:SetLocalText(weatherInfo.name)
  self.bg:SetColor(weatherInfo.color)
end

SeasonWeatherDetailItem.OnCreate = OnCreate
SeasonWeatherDetailItem.OnDestroy = OnDestroy
SeasonWeatherDetailItem.OnEnable = OnEnable
SeasonWeatherDetailItem.OnDisable = OnDisable
SeasonWeatherDetailItem.ComponentDefine = ComponentDefine
SeasonWeatherDetailItem.ComponentDestroy = ComponentDestroy
SeasonWeatherDetailItem.DataDefine = DataDefine
SeasonWeatherDetailItem.DataDestroy = DataDestroy
return SeasonWeatherDetailItem
