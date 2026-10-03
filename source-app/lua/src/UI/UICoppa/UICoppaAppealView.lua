local UICoppaAppealView = BaseClass("UICoppaAppealView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UICoppaAppealView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICoppaAppealView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICoppaAppealView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWClose:SetOnClick(function()
    self:OnBtnLWCloseClick()
  end)
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.titleText = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/TextTitle")
  self.titleText:SetLocalText("coppa_appeal_title")
  self.parentText = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/TextParent")
  self.parentText:SetLocalText("coppa_appeal_tips")
  CS.UIGray.SetGray(self.btnLWCommonNew.transform, false, true)
  self.textResend = UIUtil.GetComponent(self.gameObject, CS.TextMeshProUGUIEx, "Root/Parent4/GoBtn1/LW_Btn_Common_New/LW_Btn_Common_New_Base/BtnText")
  self.textResend:SetLocalText("coppa_appeal_btn")
end

function UICoppaAppealView:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWClose = nil
  self.btnLWCommonNew = nil
end

function UICoppaAppealView:DataDefine()
end

function UICoppaAppealView:DataDestroy()
end

function UICoppaAppealView:OnAddListener()
  base.OnAddListener(self)
end

function UICoppaAppealView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICoppaAppealView:OnBtnLWCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UICoppaAppealView:OnBtnLWCommonNewClick()
  if CS.PrivacyBrazil.Instance:IsBrazil() then
    DataCenter.LWCustomerServiceManager:OpenMessage("E023", "290045")
  else
    DataCenter.LWCustomerServiceManager:OpenMessage("E020", "290045")
  end
end

return UICoppaAppealView
