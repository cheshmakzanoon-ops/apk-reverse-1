local UILastStandLoseView = BaseClass("UILastStandLoseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILastStandLoseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILastStandLoseView:OnDestroy()
  base.OnDestroy(self)
end

function UILastStandLoseView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, "BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.defeatText = self:AddComponent(UIText, "Root/Top/BattleDefeatPanel_ani/DefeatGo/DefeatText")
  self.defeatText:SetText(Localization:GetString("311106"))
  self.tryAgainBtn = self:AddComponent(UIButton, "Root/btnLayout/TryAgainBtn")
  self.tryAgainBtn:SetOnClick(function()
    self:OnTryAgainBtnClick()
  end)
  self.tryAgainBtnText = self:AddComponent(UIText, "Root/btnLayout/TryAgainBtn/TryAgainBtnText")
  self.tryAgainBtnText:SetText(Localization:GetString("134021"))
end

function UILastStandLoseView:ComponentDestroy()
  self.back_btn = nil
  self.defeat_text = nil
end

function UILastStandLoseView:OnBackBtnClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

function UILastStandLoseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UILastStandLoseView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UILastStandLoseView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UILastStandLoseView:OnTryAgainBtnClick()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Restart()
end

return UILastStandLoseView
