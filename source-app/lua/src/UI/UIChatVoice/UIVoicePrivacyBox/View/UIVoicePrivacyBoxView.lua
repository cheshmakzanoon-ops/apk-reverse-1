local UIVoicePrivacyBoxView = BaseClass("UIVoicePrivacyBoxView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local SDKManager = CS.SDKManager
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "Root/ScrollView/Viewport/Content",
    name = "content",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/agreeBtn",
    name = "agree_btn",
    type = UIButton
  },
  {
    path = "Root/agreeBtn/agreeBtn3BeSelect",
    name = "agree_btn_be_select",
    type = UIImage
  },
  {
    path = "Root/agreeBtn/tipContent/agreeTip3",
    name = "agree_tip",
    type = UITextMeshProUGUIEx
  },
  {
    path = "Root/BtnAgreeAll",
    name = "btn_agree_all",
    type = UIButton
  },
  {
    path = "UICommonMiniPopUpTitle/CloseBtn",
    name = "btn_close",
    type = UIButton
  },
  {
    path = "UICommonMiniPopUpTitle/titleText",
    name = "title_text",
    type = UITextMeshProUGUIEx
  },
  {
    path = "UICommonMiniPopUpTitle/panel",
    name = "btn_panel",
    type = UIButton
  }
}

function UIVoicePrivacyBoxView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  self:RefreshView()
end

function UIVoicePrivacyBoxView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIVoicePrivacyBoxView:OnAddListener()
  base.OnAddListener(self)
end

function UIVoicePrivacyBoxView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIVoicePrivacyBoxView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.agree_btn:SetOnClick(function()
    self:OnAgreeClick()
  end)
  self.btn_agree_all:SetOnClick(function()
    self:OnConfirmClick()
  end)
  self.btn_close:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.btn_panel:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.agree_tip:OnPointerClick(function(eventData)
    self:OnAgreeTipPointerClick(eventData.position)
  end)
  self.content:OnPointerClick(function(eventData)
    self:OnContentPointerClick(eventData.position)
  end)
end

function UIVoicePrivacyBoxView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIVoicePrivacyBoxView:DataDefine()
  self.isAgree = false
end

function UIVoicePrivacyBoxView:DataDestroy()
  self.isAgree = nil
end

function UIVoicePrivacyBoxView:ReInit()
  self.title_text:SetLocalText("notice_title")
  local str1 = Localization:GetString("voice_room_protocol_des1")
  local str2 = Localization:GetString("voice_room_protocol_des2")
  self.content:SetText(string.format([[
%s
%s]], str1, str2))
  self.agree_tip:SetLocalText("btn_confirm")
  self.btn_agree_all.gameObject:SetActive(true)
end

function UIVoicePrivacyBoxView:RefreshView()
  self.agree_btn_be_select:SetActive(self.isAgree)
  UIGray.SetGray(self.btn_agree_all.transform, not self.isAgree, true)
end

function UIVoicePrivacyBoxView:OnAgreeTipPointerClick(clickPos)
  local linkId = self.agree_tip:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  SDKManager.OpenURL(linkId)
end

function UIVoicePrivacyBoxView:OnContentPointerClick(clickPos)
  local linkId = self.content:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  SDKManager.OpenURL(linkId)
end

function UIVoicePrivacyBoxView:OnAgreeClick()
  self.isAgree = not self.isAgree
  self:RefreshView()
end

function UIVoicePrivacyBoxView:OnConfirmClick()
  if not self.isAgree then
    return
  end
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if voiceRoomMgr then
    voiceRoomMgr:AcceptPrivacyPolicyEnterVoiceRoom()
  end
  self.ctrl:CloseSelf()
end

function UIVoicePrivacyBoxView:OnCloseClick()
  local voiceRoomMgr = ChatManager2 and ChatManager2:GetInstance() and ChatManager2:GetInstance().Voice or nil
  if voiceRoomMgr then
    voiceRoomMgr:ClearEnterVoiceRoomPending()
  end
  self.ctrl:CloseSelf()
end

return UIVoicePrivacyBoxView
