local UILastStandWinView = BaseClass("UILastStandWinView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LayoutLayer = "Layout/"

function UILastStandWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILastStandWinView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILastStandWinView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, "Layout/BtnGroup/BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.victoryText:SetText(Localization:GetString("311105"))
  self.backBtnText = self:AddComponent(UIText, "Layout/BtnGroup/BackBtn/BackBtnText")
  self.backBtnText:SetText(Localization:GetString(800306))
end

function UILastStandWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UILastStandWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UILastStandWinView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UILastStandWinView:ComponentDestroy()
  self.backBtn = nil
  self.victoryText = nil
  self.backBtnText = nil
end

function UILastStandWinView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "win")
end

return UILastStandWinView
