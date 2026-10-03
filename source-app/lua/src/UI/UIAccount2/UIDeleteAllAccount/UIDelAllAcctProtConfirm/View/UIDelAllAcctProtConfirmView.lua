local UIDelAllAcctProtConfirmView = BaseClass("UIDelAllAcctProtConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local agree_tip2_path = "Root/agreeBtn/agreeTip2"

local function OnCreate(self)
  base.OnCreate(self)
  self.isAgree = false
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnClose = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonMiniPopUpTitle/titleText")
  self.des = self:AddComponent(UIText, "Root/ScrollView/Viewport/Content")
  self.textTitle:SetLocalText("delete_account_title_01")
  self.des:SetLocalText("delete_account_content_02")
  self.agree_tip2 = self:AddComponent(UITextMeshProUGUIEx, agree_tip2_path)
  self.agree_tip2:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  local agreeTxt = Localization:GetString("delete_account_contract_01")
  local agreeTxtStr = string.format("<link=https://lastwar-h5.lastwargame.com/app/delete_account_agreement.html><color=blue>%s</color></link>", agreeTxt)
  self.agree_tip2:SetText(agreeTxtStr)
  self.agreeBtn = self:AddComponent(UIButton, "Root/agreeBtn")
  self.agreeBtn:SetOnClick(BindCallback(self, self.OnAgreeBtnClick))
  self.agreeBtnBeSelect = self:AddComponent(UIBaseContainer, "Root/agreeBtn/agreeBtnBeSelect")
  self.btnOK = self:AddComponent(UIButton, "Root/BtnOk")
  self.btnOK:SetOnClick(BindCallback(self, self.OnBtnOKClick))
end

local function ComponentDestroy(self)
  self.btnClose = nil
  self.textTitle = nil
  self.btnOK = nil
end

local function RefreshView(self)
  self:RefreshBtnView()
end

local function RefreshBtnView(self)
  self.agreeBtnBeSelect:SetActive(self.isAgree)
  local isGray = self.isAgree == false
  CS.UIGray.SetGray(self.btnOK.transform, isGray, true)
end

local function OnAgreeBtnClick(self)
  if self.isAgree then
    self.isAgree = false
  else
    self.isAgree = true
  end
  self:RefreshBtnView()
end

local function OnBtnOKClick(self)
  if not self.isAgree then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDelAllAcctInfoConfirm)
  self.ctrl:CloseSelf()
end

local function OnPointerClick(self, clickPos)
  if self.agree_tip2 == nil then
    return
  end
  local linkId = self.agree_tip2:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
  end
end

UIDelAllAcctProtConfirmView.OnCreate = OnCreate
UIDelAllAcctProtConfirmView.OnDestroy = OnDestroy
UIDelAllAcctProtConfirmView.ComponentDefine = ComponentDefine
UIDelAllAcctProtConfirmView.ComponentDestroy = ComponentDestroy
UIDelAllAcctProtConfirmView.RefreshView = RefreshView
UIDelAllAcctProtConfirmView.RefreshBtnView = RefreshBtnView
UIDelAllAcctProtConfirmView.OnAgreeBtnClick = OnAgreeBtnClick
UIDelAllAcctProtConfirmView.OnBtnOKClick = OnBtnOKClick
UIDelAllAcctProtConfirmView.OnPointerClick = OnPointerClick
return UIDelAllAcctProtConfirmView
