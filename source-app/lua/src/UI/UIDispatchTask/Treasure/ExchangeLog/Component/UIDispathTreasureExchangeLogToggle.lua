local UIDispathTreasureExchangeLogToggle = BaseClass("UIDispathTreasureExchangeLogToggle", UIToggle)
local base = UIToggle
local Localization = CS.GameEntry.Localization

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
  self.textTab1 = self:AddComponent(UIText, "ToggleBg/tab_text")
  self.textTab2 = self:AddComponent(UIText, "ToggleBg/Choose/tab_2_text")
  self.compChoose = self:AddComponent(UIBaseContainer, "ToggleBg/Choose")
end

local function ComponentDestroy(self)
  self.textTab1 = nil
  self.textTab2 = nil
  self.compChoose = nil
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

local function SetTitleText(self, text)
  self.textTab1:SetText(text)
  self.textTab2:SetText(text)
end

local function SetSelect(self)
  self.compChoose:SetActive(true)
end

local function SetUnSelect(self)
  self.compChoose:SetActive(false)
end

UIDispathTreasureExchangeLogToggle.OnCreate = OnCreate
UIDispathTreasureExchangeLogToggle.OnDestroy = OnDestroy
UIDispathTreasureExchangeLogToggle.OnEnable = OnEnable
UIDispathTreasureExchangeLogToggle.OnDisable = OnDisable
UIDispathTreasureExchangeLogToggle.ComponentDefine = ComponentDefine
UIDispathTreasureExchangeLogToggle.ComponentDestroy = ComponentDestroy
UIDispathTreasureExchangeLogToggle.DataDefine = DataDefine
UIDispathTreasureExchangeLogToggle.DataDestroy = DataDestroy
UIDispathTreasureExchangeLogToggle.OnAddListener = OnAddListener
UIDispathTreasureExchangeLogToggle.OnRemoveListener = OnRemoveListener
UIDispathTreasureExchangeLogToggle.SetTitleText = SetTitleText
UIDispathTreasureExchangeLogToggle.SetSelect = SetSelect
UIDispathTreasureExchangeLogToggle.SetUnSelect = SetUnSelect
return UIDispathTreasureExchangeLogToggle
