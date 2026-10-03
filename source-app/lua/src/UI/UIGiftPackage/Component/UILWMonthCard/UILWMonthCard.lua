local UILWMonthCard = BaseClass("UILWMonthCard", UIBaseView)
local base = UIBaseView
local UILWMonthCardContent = require("UI.UIGiftPackage.Component.UILWMonthCard.UILWMonthCardContent")
local content_path = "UILWMonthCardContent"

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
  self.content = self:AddComponent(UILWMonthCardContent, content_path)
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
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.MoonCardUI, false)
  self.content:ReInit(param, view)
end

UILWMonthCard.OnCreate = OnCreate
UILWMonthCard.OnDestroy = OnDestroy
UILWMonthCard.OnEnable = OnEnable
UILWMonthCard.OnDisable = OnDisable
UILWMonthCard.ComponentDefine = ComponentDefine
UILWMonthCard.ComponentDestroy = ComponentDestroy
UILWMonthCard.DataDefine = DataDefine
UILWMonthCard.DataDestroy = DataDestroy
UILWMonthCard.OnAddListener = OnAddListener
UILWMonthCard.OnRemoveListener = OnRemoveListener
UILWMonthCard.ReInit = ReInit
return UILWMonthCard
