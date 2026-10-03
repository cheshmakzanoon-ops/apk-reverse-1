local UIActCrazyRockRulesGamePlayView = BaseClass("UIActCrazyRockRulesGamePlayView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIActCrazyRockRulesGamePlayView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.closeCallback = self:GetUserData()
end

function UIActCrazyRockRulesGamePlayView:OnDestroy()
  if self.closeCallback then
    self.closeCallback()
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActCrazyRockRulesGamePlayView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function UIActCrazyRockRulesGamePlayView:ComponentDestroy()
  self.btnPanel = nil
end

function UIActCrazyRockRulesGamePlayView:DataDefine()
  self.closeCallback = nil
end

function UIActCrazyRockRulesGamePlayView:DataDestroy()
  self.closeCallback = nil
end

function UIActCrazyRockRulesGamePlayView:OnAddListener()
  base.OnAddListener(self)
end

function UIActCrazyRockRulesGamePlayView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActCrazyRockRulesGamePlayView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UIActCrazyRockRulesGamePlayView
