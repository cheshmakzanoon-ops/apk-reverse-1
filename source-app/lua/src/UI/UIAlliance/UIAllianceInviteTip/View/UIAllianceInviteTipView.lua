local UIAllianceInviteTipView = BaseClass("UIAllianceInviteTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonMiniPopUpTitle/titleText"
local closeBtn_path = "UICommonMiniPopUpTitle/CloseBtn"
local placeHolder_path = "ImgBg/InputField/Placeholder"
local inviteTipIpt_path = "ImgBg/InputField"
local confirmBtn_path = "ImgBg/confirmBtn"
local confirmBtnTxt_path = "ImgBg/confirmBtn/confirmTxt"
local tip_path = "ImgBg/tip"

local function OnCreate(self)
  base.OnCreate(self)
  local param = self:GetUserData()
  self.confirmCallBack = param.callback
  self.cacheTip = param.defaultTip
  self.curTip = self.cacheTip
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(110021)
  self.inviteTipIptN = self:AddComponent(UIInput, inviteTipIpt_path)
  self.inviteTipIptN:SetOnValueChange(function(value)
    self:OnInviteTipChange(value)
  end)
  self.placeHolderN = self:AddComponent(UIText, placeHolder_path)
  self.placeHolderN:SetText(self.cacheTip)
  self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
  self.confirmBtnN:SetOnClick(function()
    self:OnClickConfirmBtn()
  end)
  self.confirmBtnTxtN = self:AddComponent(UIText, confirmBtnTxt_path)
  self.confirmBtnTxtN:SetLocalText(141056)
  self.tipN = self:AddComponent(UIText, tip_path)
  self.tipN:SetLocalText(391092)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickConfirmBtn(self)
  if self.confirmCallBack then
    self.confirmCallBack(self.curTip)
  end
  self.ctrl:CloseSelf()
end

local function OnInviteTipChange(self, value)
  if string.IsNullOrEmpty(value) then
    self.curTip = self.cacheTip
  else
    self.curTip = value
  end
end

UIAllianceInviteTipView.OnCreate = OnCreate
UIAllianceInviteTipView.OnDestroy = OnDestroy
UIAllianceInviteTipView.OnClickCloseBtn = OnClickCloseBtn
UIAllianceInviteTipView.OnClickConfirmBtn = OnClickConfirmBtn
UIAllianceInviteTipView.OnInviteTipChange = OnInviteTipChange
return UIAllianceInviteTipView
