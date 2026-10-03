local HeroDamageItem = BaseClass("HeroDamageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local head_container_path = "Hero_Icon"
local trigger_path = ""
local slider_path = "Slider"
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function ComponentDefine(self)
  self.head_container = self:AddComponent(UIBaseContainer, head_container_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, trigger_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.event_trigger:OnPointerDown(function(eventData)
    self:OnEventTrigger(eventData)
  end)
end

local function DataDefine(self)
  self.param = {}
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.head_container = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function SetData(self, param)
  self.param = param
  self:ReInit()
end

local function ReInit(self)
  local percent = 1.0 * self.param.damage / self.param.totalDamage
  self.slider:SetValue(percent)
  self.head_container:RemoveComponents(UIHeroCell)
  self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local go_rt = go.transform
    go.gameObject:SetActive(true)
    go_rt:SetParent(self.head_container.transform)
    go_rt:Set_localScale(0.6, 0.6, 0.6)
    go_rt:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.name = self.param.heroId
    local cell = self.head_container:AddComponent(UIHeroCell, go.name)
    cell:InitWithConfigId(self.param.heroId, self.param.heroQuality, self.param.heroLevel)
    cell:SetLvTextBiggest()
  end)
end

local function OnEventTrigger(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.event_trigger.transform.position + Vector3.New(25, 10, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("140066")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 210
  param.pivot = 0.85
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

HeroDamageItem.OnCreate = OnCreate
HeroDamageItem.ComponentDefine = ComponentDefine
HeroDamageItem.DataDefine = DataDefine
HeroDamageItem.OnDestroy = OnDestroy
HeroDamageItem.ComponentDestroy = ComponentDestroy
HeroDamageItem.DataDestroy = DataDestroy
HeroDamageItem.SetData = SetData
HeroDamageItem.ReInit = ReInit
HeroDamageItem.OnEventTrigger = OnEventTrigger
return HeroDamageItem
