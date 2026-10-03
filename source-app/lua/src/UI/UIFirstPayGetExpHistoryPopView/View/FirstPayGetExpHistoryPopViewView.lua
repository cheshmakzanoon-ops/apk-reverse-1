local FirstPayGetExpHistoryPopViewView = BaseClass("FirstPayGetExpHistoryPopViewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local FirstPayGetExpHistoryInfoCptComponent = require("UI.UIFirstPay.Component.FirstPayGetExpHistoryInfoCptComponent")

function FirstPayGetExpHistoryPopViewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function FirstPayGetExpHistoryPopViewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FirstPayGetExpHistoryPopViewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compFirstPayGetExpHistoryInfoCpt = self.viewSkin:AddComponent(self, FirstPayGetExpHistoryInfoCptComponent, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
end

function FirstPayGetExpHistoryPopViewView:ComponentDestroy()
  self.viewSkin = nil
  self.compFirstPayGetExpHistoryInfoCpt = nil
  self.textTitle = nil
  self.btnClose = nil
  self.btnMask = nil
end

function FirstPayGetExpHistoryPopViewView:DataDefine()
end

function FirstPayGetExpHistoryPopViewView:DataDestroy()
end

function FirstPayGetExpHistoryPopViewView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FirstPayStatusChange, self.OnFirstPayStatusChange)
end

function FirstPayGetExpHistoryPopViewView:OnRemoveListener()
  self:RemoveUIListener(EventId.FirstPayStatusChange, self.OnFirstPayStatusChange)
  base.OnRemoveListener(self)
end

function FirstPayGetExpHistoryPopViewView:RefreshView()
  self.compFirstPayGetExpHistoryInfoCpt:RefreshView()
end

function FirstPayGetExpHistoryPopViewView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function FirstPayGetExpHistoryPopViewView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function FirstPayGetExpHistoryPopViewView:OnFirstPayStatusChange()
  self.ctrl:CloseSelf()
end

return FirstPayGetExpHistoryPopViewView
