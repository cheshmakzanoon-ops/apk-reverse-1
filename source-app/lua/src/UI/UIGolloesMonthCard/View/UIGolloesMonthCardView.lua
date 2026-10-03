local UIGolloesMonthCard = BaseClass("UIGolloesMonthCard", UIBaseView)
local base = UIBaseView
local UIGolloesMonthCardContent = require("UI.UIGolloesMonthCard.Component.UIGolloesMonthCardContent")
local close_path = "Close"
local content_path = "UIGolloesMonthCardContent"
local back_path = "Back"

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
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.back_btn = self:AddComponent(UIButton, back_path)
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.content = self:AddComponent(UIGolloesMonthCardContent, content_path)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.content = nil
  self.back_btn = nil
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

local function ReInit(self)
  local param = {
    monthCardInfo = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  }
  self.content:ReInit(param, self)
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
