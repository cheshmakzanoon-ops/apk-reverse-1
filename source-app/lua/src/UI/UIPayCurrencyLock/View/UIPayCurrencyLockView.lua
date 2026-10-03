local UIPayCurrencyLockView = BaseClass("UIPayCurrencyLockView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIPayCurrencyLockView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIPayCurrencyLockView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPayCurrencyLockView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnRight = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.btnLeft = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.textRightBtnName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textLeftBtnName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDesName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
end

function UIPayCurrencyLockView:ComponentDestroy()
  self.viewSkin = nil
  self.btnRight = nil
  self.btnLeft = nil
  self.textRightBtnName = nil
  self.textLeftBtnName = nil
  self.textDesName = nil
  self.textTitleTxt = nil
  self.btnClose = nil
  self.btnPanel = nil
end

function UIPayCurrencyLockView:DataDefine()
end

function UIPayCurrencyLockView:DataDestroy()
end

function UIPayCurrencyLockView:OnAddListener()
  base.OnAddListener(self)
end

function UIPayCurrencyLockView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPayCurrencyLockView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIPayCurrencyLockView:OnBtnRightClick()
  CS.AIHelp.AIHelpProxy.Show("E024", Localization:GetString("2700006"))
end

function UIPayCurrencyLockView:OnBtnLeftClick()
end

function UIPayCurrencyLockView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIPayCurrencyLockView:InitView()
  self.textTitleTxt:SetLocalText("currency_suspended_title")
  self.textDesName:SetLocalText("currency_suspended_desc")
  self.textRightBtnName:SetLocalText("kid_limit_btn02")
  self.btnLeft:SetActive(false)
  self.btnRight:SetActive(true)
end

return UIPayCurrencyLockView
