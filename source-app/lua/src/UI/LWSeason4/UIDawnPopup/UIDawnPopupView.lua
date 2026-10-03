local UIDawnPopupView = BaseClass("UIDawnPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIDawnPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDawnPopupView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDawnPopupView:ComponentDefine()
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "bg/desc")
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "bg/BtnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnGo = self:AddComponent(UIButton, "bg/BtnGo")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textDesc:SetLocalText("season_s4_activity_1200009_desc55")
end

function UIDawnPopupView:ComponentDestroy()
  self.textDesc = nil
  self.btnClose = nil
  self.btnGo = nil
end

function UIDawnPopupView:DataDefine()
  Setting:SetPrivateBool("NightOverDawnStartPopup", false)
end

function UIDawnPopupView:DataDestroy()
end

function UIDawnPopupView:OnAddListener()
  base.OnAddListener(self)
end

function UIDawnPopupView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDawnPopupView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIDawnPopupView:OnBtnGoClick()
  self.ctrl:CloseSelf()
end

function UIDawnPopupView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return UIDawnPopupView
