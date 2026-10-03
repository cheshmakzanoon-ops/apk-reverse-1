local UICoppaBrazilView = BaseClass("UICoppaBrazilView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UICoppaBrazilView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICoppaBrazilView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICoppaBrazilView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  local titleText = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/TextTitle")
  titleText:SetLocalText("kid_limit_title")
  local parentText = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/TextParent")
  parentText:SetLocalText("kid_limit_desc")
  local textResend = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/GoBtn1/LW_Btn_Common_New/LW_Btn_Common_New_Base/BtnText")
  textResend:SetLocalText("kid_limit_btn02")
end

function UICoppaBrazilView:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWClose = nil
  self.btnLWCommonNew = nil
end

function UICoppaBrazilView:DataDefine()
end

function UICoppaBrazilView:DataDestroy()
end

function UICoppaBrazilView:OnAddListener()
  base.OnAddListener(self)
end

function UICoppaBrazilView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICoppaBrazilView:OnBtnLWCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UICoppaBrazilView:OnBtnLWCommonNewClick()
  DataCenter.LWCustomerServiceManager:OpenMessage("E023", "290045")
end

return UICoppaBrazilView
