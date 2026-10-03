local UIActEasterEggRulesGamePlayView = BaseClass("UIActEasterEggRulesGamePlayView", UIBaseView)
local base = UIBaseView
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
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

local function ComponentDestroy(self)
  self.btnPanel = nil
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

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

UIActEasterEggRulesGamePlayView.OnCreate = OnCreate
UIActEasterEggRulesGamePlayView.OnDestroy = OnDestroy
UIActEasterEggRulesGamePlayView.OnEnable = OnEnable
UIActEasterEggRulesGamePlayView.OnDisable = OnDisable
UIActEasterEggRulesGamePlayView.ComponentDefine = ComponentDefine
UIActEasterEggRulesGamePlayView.ComponentDestroy = ComponentDestroy
UIActEasterEggRulesGamePlayView.DataDefine = DataDefine
UIActEasterEggRulesGamePlayView.DataDestroy = DataDestroy
UIActEasterEggRulesGamePlayView.OnAddListener = OnAddListener
UIActEasterEggRulesGamePlayView.OnRemoveListener = OnRemoveListener
UIActEasterEggRulesGamePlayView.OnBtnPanelClick = OnBtnPanelClick
return UIActEasterEggRulesGamePlayView
