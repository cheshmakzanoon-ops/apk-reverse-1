local UISeasonOfficialMailView = BaseClass("UISeasonOfficialMailView", UIBaseView)
local base = UIBaseView
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
local EMAIL_AUTO_SAVE_KEY = "MAIL_AUTO_SAVE_KEY"

function UISeasonOfficialMailView:OnCreate()
  base.OnCreate(self)
  self.serverId, self.buildingId = self:GetUserData()
  self:ComponentDefine()
end

function UISeasonOfficialMailView:OnDestroy()
  self:AutoSavUISeasonOfficialMail()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialMailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
end

function UISeasonOfficialMailView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function UISeasonOfficialMailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.dialog_title_text:SetLocalText("supreme_president_ui_7")
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
  self.title_text:SetLocalText("455140")
  self.text:SetLocalText("455141")
  self.send_btn_txt:SetLocalText("457041")
  self.tips:SetLocalText("supreme_president_ui_24")
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
  local mailCost = DataCenter.BuildingOfficialManager:GetEightMailCost()
  self.diamond_num_txt:SetText(tostring(mailCost))
  self:InitMailByDraft()
end

function UISeasonOfficialMailView:ComponentDestroy()
  self.btn_back = nil
end

function UISeasonOfficialMailView:TitleValueChange(value)
  self.mailTitle = value
end

function UISeasonOfficialMailView:TextValueChange(value)
  self.mailContent = value
end

function UISeasonOfficialMailView:OnSubmitClick()
  if not LuaEntry.Player:IsSurfaceLeader(self.serverId, self.buildingId) then
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
  SFSNetwork.SendMessage(MsgDefines.KingdomBuildingGroupMailSend, self.mailTitle, self.mailContent)
  self:SavUISeasonOfficialMailDraft()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialMail)
  UIUtil.ShowTipsId(390497)
end

function UISeasonOfficialMailView:UpdateData()
end

function UISeasonOfficialMailView:InitMailByDraft()
  self.autoSave = true
  local data = self:GetMailDraft()
  self:SetTitleAndContent(data.title, data.content)
end

function UISeasonOfficialMailView:SetTitleAndContent(title, content)
  self.input_field_text:SetText(content)
  self.mailContent = content
  self.input_field_title:SetText(title)
  self.mailTitle = title
end

function UISeasonOfficialMailView:GetTitleAndContent()
  return self.input_field_title:GetText(), self.input_field_text:GetText()
end

function UISeasonOfficialMailView:AutoSavUISeasonOfficialMail()
  if self.autoSave then
    self:SavUISeasonOfficialMailDraft(self:GetTitleAndContent())
  end
end

function UISeasonOfficialMailView:OnCloseBtnClick()
  local title, content = self:GetTitleAndContent()
  if not string.IsNullOrEmpty(title) or not string.IsNullOrEmpty(content) then
    UIUtil.ShowMessage(Localization:GetString("announcement_draft_tips"), 2, "btn_save", "announcement_draft_btn", function()
      self:SavUISeasonOfficialMailDraft(title, content)
      self.ctrl:CloseSelf()
    end, function()
      self:SavUISeasonOfficialMailDraft()
      self.ctrl:CloseSelf()
    end)
  else
    self:SavUISeasonOfficialMailDraft()
    self.ctrl:CloseSelf()
  end
end

function UISeasonOfficialMailView:SavUISeasonOfficialMailDraft(title, content)
  self.autoSave = false
  CommonUtil.PlayerPrefsSetTable(EMAIL_AUTO_SAVE_KEY, {
    title = title or "",
    content = content or ""
  })
end

function UISeasonOfficialMailView:GetMailDraft()
  local data = CommonUtil.PlayerPrefsGetTable(EMAIL_AUTO_SAVE_KEY, {title = "", content = ""})
  return data
end

return UISeasonOfficialMailView
