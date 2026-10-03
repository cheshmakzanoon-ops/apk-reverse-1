local EmailView = BaseClass("EmailView", UIBaseView)
local base = UIBaseView
local EmailItem = require("UI.UIGovernment.Email.Component.EmailItem")
local Localization = CS.GameEntry.Localization
local close_btn_path = "Root/BottomBar/BtnBack"
local input_field_text_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Content/InputField"
local input_field_title_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Title/titleInputField"
local close_keyboard_btn_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/CloseKeyboardBtn"
local content_close_keyboard_btn_path = "Root/MiddleContentContainer/ScrollView/Viewport/Content/Content/ContentCloseKeyboardBtn"
local send_btn_path = "Root/BottomBar/SendBtn"
local send_btn_txt_path = "Root/BottomBar/SendBtn/SendBtnTxt"
local diamond_num_txt_path = "Root/BottomBar/SendBtn/DiamondNumTxt"
local EMAIL_AUTO_SAVE_KEY = "EMAIL_AUTO_SAVE_KEY"

function EmailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.serverId = LuaEntry.Player:GetSourceServerId()
  self:ComponentDefine()
end

function EmailView:OnDestroy()
  self:AutoSaveMail()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EmailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
end

function EmailView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  base.OnRemoveListener(self)
end

local function __CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  local uiFullHeight = layer.rectTransform.rect.height
  local keyboardHeight = uiFullHeight * height / Screen.height
  return keyboardHeight
end

function EmailView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.input_field_title = self:AddComponent(UIInput, input_field_title_path)
  self.input_field_text = self:AddComponent(UIInput, input_field_text_path)
  self.input_field_title_text = self:AddComponent(UITextMeshProUGUIEx, input_field_text_path .. "/Text Area/Text")
  ChatInterface.SetEmojiTextProperty(self.input_field_title_text)
  self.send_btn = self:AddComponent(UIButton, send_btn_path)
  self.send_btn_txt = self:AddComponent(UIText, send_btn_txt_path)
  self.diamond_num_txt = self:AddComponent(UIText, diamond_num_txt_path)
  self.input_field_title:SetOnValueChange(function(value)
    self:TitleValueChange(value)
  end)
  self.mobileInputField2 = self.input_field_title.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
  self.mobileInputField = self.input_field_text.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
  
  function self.OnShowKeyboard(mobilId, isShow, height)
    if isShow then
      local newHeight = __CalcKeyboardHeight(height) - 260
      self.input_field_text:SetOffsetMinXY(0, math.max(0, newHeight))
    else
      self.input_field_text:SetOffsetMinXY(0, 35)
    end
    self.contentCloseKeyboardBtn:SetActive(isShow)
  end
  
  if ChatInterface.GetMobilSupportMultiple() then
    self.mobileInputField.OnShowKeyboard = self.OnShowKeyboard
    self.mobileInputField2.OnShowKeyboard = self.OnShowKeyboard
  else
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
  end
  if CS.SDKManager.IS_UNITY_ANDROID() then
    self.mobileInputField:SetMaxLine(500)
  elseif CS.SDKManager.IS_UNITY_IOS() then
    self.mobileInputField:SetMaxLine(1)
  end
  self.input_field_text:SetOnValueChange(function(value)
    self:TextValueChange(value)
  end)
  self.send_btn:SetOnClick(function()
    self:OnSubmitClick()
  end)
  self.closeKeyboardBtn = self:AddComponent(UIButton, close_keyboard_btn_path)
  self.closeKeyboardBtn:SetOnClick(function()
    self.mobileInputField:SetFocus(false)
  end)
  self.contentCloseKeyboardBtn = self:AddComponent(UIButton, content_close_keyboard_btn_path)
  self.contentCloseKeyboardBtn:SetActive(false)
  self.contentCloseKeyboardBtn:SetOnClick(function()
    self.mobileInputField:SetFocus(false)
  end)
  self:InitView()
end

function EmailView:InitView()
  self:InitMailByDraft()
  self.mobilId2 = self.mobileInputField2:GetMobilId()
  self.mobilId = self.mobileInputField:GetMobilId()
  self.mobileInputField:SetVisible(true)
  DataCenter.CacheData:MobilTestLogInfo(self.mobilId2, self.view.__name)
  DataCenter.CacheData:MobilTestLogInfo(self.mobilId, self.view.__name)
  local curPresident = DataCenter.GovernmentManager:GetCurPresident()
  if curPresident ~= nil then
    local mailCost = curPresident.mailCost or 200
    self.diamond_num_txt:SetText(tostring(mailCost))
  else
    self.diamond_num_txt:SetText("200")
  end
end

function EmailView:ComponentDestroy()
  if ChatInterface.GetMobilSupportMultiple() then
    self.mobileInputField.OnShowKeyboard = nil
    self.mobileInputField2.OnShowKeyboard = nil
  else
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
  end
  self.OnShowKeyboard = nil
  self.btn_back = nil
end

function EmailView:TitleValueChange(value)
  self.mailTitle = value
end

function EmailView:TextValueChange(value)
  self.mailContent = value
end

function EmailView:OnSubmitClick()
  if not LuaEntry.Player:IsPresident(self.serverId) then
    UIUtil.ShowTipsId(393018)
    return
  end
  if string.IsNullOrEmpty(self.mailTitle) then
    UIUtil.ShowTipsId(141059)
    return
  end
  if string.IsNullOrEmpty(self.mailContent) then
    UIUtil.ShowTipsId(141060)
    return
  end
  local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  SFSNetwork.SendMessage(MsgDefines.MailSend, "", self.mailTitle, self.mailContent, "", "", curTime, MailType.MAIL_PRESIDENT_SEND, self.serverId)
  self:SaveMailDraft()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEmail_v2)
  UIUtil.ShowTipsId(457086)
end

function EmailView:UpdateData()
end

function EmailView:InitMailByDraft()
  self.autoSave = true
  local data = self:GetMailDraft()
  self:SetTitleAndContent(data.title, data.content)
end

function EmailView:SetTitleAndContent(title, content)
  self.input_field_text:SetText(content)
  self.mobileInputField.Text = content
  self.mailContent = content
  self.input_field_title:SetText(title)
  self.mobileInputField2.Text = title
  self.mailTitle = title
end

function EmailView:GetTitleAndContent()
  return self.input_field_title:GetText(), self.input_field_text:GetText()
end

function EmailView:AutoSaveMail()
  if self.autoSave then
    self:SaveMailDraft(self:GetTitleAndContent())
  end
end

function EmailView:OnCloseBtnClick()
  local title, content = self:GetTitleAndContent()
  if not string.IsNullOrEmpty(title) or not string.IsNullOrEmpty(content) then
    UIUtil.ShowMessage(Localization:GetString("announcement_draft_tips"), 2, "btn_save", "announcement_draft_btn", function()
      self:SaveMailDraft(title, content)
      self.ctrl:CloseSelf()
    end, function()
      self:SaveMailDraft()
      self.ctrl:CloseSelf()
    end)
  else
    self:SaveMailDraft()
    self.ctrl:CloseSelf()
  end
end

function EmailView:SaveMailDraft(title, content)
  self.autoSave = false
  CommonUtil.PlayerPrefsSetTable(EMAIL_AUTO_SAVE_KEY, {
    title = title or "",
    content = content or ""
  })
end

function EmailView:GetMailDraft()
  local data = CommonUtil.PlayerPrefsGetTable(EMAIL_AUTO_SAVE_KEY, {title = "", content = ""})
  return data
end

local IgnoreWindowNames = {
  [UIWindowNames.UINoticeTips] = true,
  [UIWindowNames.UICommonMessageSpecialBar] = true,
  [UIWindowNames.UICommonSingleMsgBar] = true,
  [UIWindowNames.UICommonMessageBar] = true,
  [UIWindowNames.UICommonMessageBarOld] = true,
  [UIWindowNames.UIBattleMessageBar] = true
}

function EmailView:OnWindowOpened(windowName)
  if IgnoreWindowNames[windowName] then
    return
  end
  local config = UIManager:GetInstance():GetWindowConfig(windowName)
  if not config then
    return
  end
  if config.Layer ~= UILayer.Dialog and config.Layer ~= UILayer.Info then
    return
  end
  self.mobileInputField:SetVisible(false)
  self.mobileInputField2:SetVisible(false)
end

function EmailView:OnWindowClosed(windowName)
  if IgnoreWindowNames[windowName] then
    return
  end
  local config = UIManager:GetInstance():GetWindowConfig(windowName)
  if not config then
    return
  end
  if config.Layer ~= UILayer.Dialog and config.Layer ~= UILayer.Info then
    return
  end
  self.mobileInputField:SetVisible(true)
  self.mobileInputField2:SetVisible(true)
end

return EmailView
