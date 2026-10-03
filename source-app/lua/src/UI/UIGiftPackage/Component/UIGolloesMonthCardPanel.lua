local UIGolloesMonthCard = BaseClass("UIGolloesMonthCard", UIBaseView)
local base = UIBaseView
local UIGolloesMonthCardContent = require("UI.UIGolloesMonthCard.Component.UIGolloesMonthCardContent")
local content_path = "UIGolloesMonthCardContent"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIGolloesMonthCardContent, content_path)
end

local function ComponentDestroy(self)
  self.content = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param, view)
  self.content:ReInit(param, view)
end

UIGolloesMonthCard.OnCreate = OnCreate
UIGolloesMonthCard.OnDestroy = OnDestroy
UIGolloesMonthCard.OnEnable = OnEnable
UIGolloesMonthCard.OnDisable = OnDisable
UIGolloesMonthCard.ComponentDefine = ComponentDefine
UIGolloesMonthCard.ComponentDestroy = ComponentDestroy
UIGolloesMonthCard.DataDefine = DataDefine
UIGolloesMonthCard.DataDestroy = DataDestroy
UIGolloesMonthCard.OnAddListener = OnAddListener
UIGolloesMonthCard.OnRemoveListener = OnRemoveListener
UIGolloesMonthCard.ReInit = ReInit
return UIGolloesMonthCard
