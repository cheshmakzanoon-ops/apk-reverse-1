local UIExpiredMonthlyCardTipsView = BaseClass("UIExpiredMonthlyCardTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIExpiredMonthlyCardTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIExpiredMonthlyCardTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIExpiredMonthlyCardTipsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textAutoSizeDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose2 = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose2:SetOnClick(function()
    self:OnBtnCloseClick2()
  end)
  self.textCloseName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function UIExpiredMonthlyCardTipsView:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.textAutoSizeDesc = nil
  self.textCloseName = nil
end

function UIExpiredMonthlyCardTipsView:DataDefine()
  local showTipsCountdown = self:GetUserData()
  self.textTitle:SetLocalText("weekcard_expire_remind_title")
  self.textCloseName:SetLocalText("weekcard_expire_remind_button")
  self.textAutoSizeDesc:SetText(Localization:GetString("weekcard_expire_remind_desc_1", showTipsCountdown))
end

function UIExpiredMonthlyCardTipsView:DataDestroy()
end

function UIExpiredMonthlyCardTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UIExpiredMonthlyCardTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIExpiredMonthlyCardTipsView:OnBtnCloseClick()
  self.ctrl.CloseSelf()
end

function UIExpiredMonthlyCardTipsView:OnBtnCloseClick2()
  self.ctrl.CloseSelf()
end

return UIExpiredMonthlyCardTipsView
