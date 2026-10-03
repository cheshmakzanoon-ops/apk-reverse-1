local EmailView = BaseClass("EmailView", UIBaseView)
local base = UIBaseView
local EmailItem = require("UI.UIGovernment.Email.Component.EmailItem")
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "Content/TitleText"
local input_field_title_path = "Content/InputFieldTitle"
local text_path = "Content/Text"
local input_field_text_path = "Content/InputFieldText"
local tips_path = "Content/tips"
local send_btn_path = "Content/SendBtn"
local send_btn_txt_path = "Content/SendBtn/SendBtnTxt"
local diamond_num_txt_path = "Content/SendBtn/DiamondNumTxt"
local EMAIL_AUTO_SAVE_KEY = "EMAIL_AUTO_SAVE_KEY"

function EmailView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
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
end

function EmailView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function EmailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.dialog_title_text:SetLocalText("457055")
  self.close_btn:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(function()
    self:OnCloseBtnClick()
  end)
  self.input_field_title = self:AddComponent(UIInput, input_field_title_path)
  self.text = self:AddComponent(UIText, text_path)
  self.input_field_text = self:AddComponent(UIInput, input_field_text_path)
  self.tips = self:AddComponent(UIText, tips_path)
  self.send_btn = self:AddComponent(UIButton, send_btn_path)
  self.send_btn_txt = self:AddComponent(UIText, send_btn_txt_path)
  self.diamond_num_txt = self:AddComponent(UIText, diamond_num_txt_path)
  self.title_text:SetLocalText("457036")
  self.text:SetLocalText("457038")
  self.send_btn_txt:SetLocalText("457041")
  self.tips:SetLocalText("457040")
  self.input_field_title:SetLocalText("457037")
  self.input_field_text:SetLocalText("457039")
  self.input_field_title:SetOnValueChange(function(value)
    self:TitleValueChange(value)
  end)
  self.input_field_text:SetOnValueChange(function(value)
    self:TextValueChange(value)
  end)
  self.send_btn:SetOnClick(function()
    self:OnSubmitClick()
  end)
  local curPresident = DataCenter.GovernmentManager:GetCurPresident()
  if curPresident ~= nil then
    local mailCost = curPresident.mailCost or 200
    self.diamond_num_txt:SetText(tostring(mailCost))
  else
    self.diamond_num_txt:SetText("200")
  end
  self:InitMailByDraft()
end

function EmailView:ComponentDestroy()
  self.btn_back = nil
end

function EmailView:TitleValueChange(value)
  self.mailTitle = value
end

function EmailView:TextValueChange(value)
  self.mailContent = value
end

function EmailView:OnSubmitClick()
  if not LuaEntry.Player:IsPresident() then
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
  SFSNetwork.SendMessage(MsgDefines.MailSend, "", self.mailTitle, self.mailContent, "", "", curTime, MailType.MAIL_PRESIDENT_SEND)
  self:SaveMailDraft()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEmail)
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
  self.mailContent = content
  self.input_field_title:SetText(title)
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

return EmailView
