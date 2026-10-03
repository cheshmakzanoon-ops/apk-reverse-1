local UIMailSendView = BaseClass("UIMailSendView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "offset/common/title"
local mailTo_path = "offset/container/receiver"
local mailTitleInput_path = "offset/container/inputTitle"
local mailTitleTxt_path = "offset/container/inputTitle/titlePlaceholder"
local sendBtn_path = "offset/container/sendBtn"
local sendBtnTxt_path = "offset/container/sendBtn/sendTxt"
local closeBtn_path = "offset/common/closeBtn"
local mailContentInput_path = "offset/container/tup/inputContent"
local mailContentTxt_path = "offset/container/tup/inputContent/contentPlaceholder"
local mailContentLength_path = "offset/container/tup/contentLength"

local function OnCreate(self)
  base.OnCreate(self)
  self.maxTitleL = 50
  self.maxContentL = 2000
  self.mailTitle = ""
  self.mailContent = ""
  self.titleN = self:AddComponent(UIText, title_path)
  self.mailToN = self:AddComponent(UIText, mailTo_path)
  self.mailTitleInputN = self:AddComponent(UIInput, mailTitleInput_path)
  self.mailTitleInputN:SetOnEndEdit(function(value)
    self:OnInputMailTitle(value)
  end)
  self.mailTitleTxtN = self:AddComponent(UIText, mailTitleTxt_path)
  self.sendBtnN = self:AddComponent(UIButton, sendBtn_path)
  self.sendBtnN:SetOnClick(function()
    self:OnClickSendBtn()
  end)
  self.sendBtnTxtN = self:AddComponent(UIText, sendBtnTxt_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.mailContentInputN = self:AddComponent(UIInput, mailContentInput_path)
  self.mailContentInputN:SetOnEndEdit(function(value)
    self:OnInputMailContent(value)
  end)
  self.mailContentTxtN = self:AddComponent(UIText, mailContentTxt_path)
  self.mailContentLengthN = self:AddComponent(UIText, mailContentLength_path)
  self:InitUI()
end

local function OnDestroy(self)
  self.titleN = nil
  self.mailToN = nil
  self.mailTitleInputN = nil
  self.mailTitleTxtN = nil
  self.sendBtnN = nil
  self.closeBtnN = nil
  self.mailContentInputN = nil
  self.mailContentTxtN = nil
  self.mailContentLengthN = nil
  base.OnDestroy(self)
end

local function InitUI(self)
  self.titleN:SetLocalText(141052)
  self.mailToN:SetLocalText(141053)
  self.mailTitleTxtN:SetLocalText(141054)
  self.mailContentTxtN:SetLocalText(141055)
  self.sendBtnTxtN:SetLocalText(141056)
  self.mailContentLengthN:SetText(string.len(self.mailContent) .. "/" .. 2000)
end

local function OnInputMailTitle(self, str)
  if string.len(str) > self.maxTitleL then
    UIUtil.ShowTips(Localization:GetString("141057", Localization:GetString("141061")))
  else
    self.mailTitle = str
  end
  self.mailTitleInputN:SetText(self.mailTitle)
end

local function OnInputMailContent(self, str)
  if string.len(str) > self.maxContentL then
    UIUtil.ShowTips(Localization:GetString("141058", Localization:GetString("141062")))
  else
    self.mailContent = str
  end
  self.mailContentInputN:SetText(self.mailContent)
  self.mailContentLengthN:SetText(string.len(self.mailContent) .. "/" .. 2000)
end

local function OnClickSendBtn(self)
  if string.IsNullOrEmpty(self.mailTitle) then
    UIUtil.ShowTipsId(141059)
    return
  end
  if string.IsNullOrEmpty(self.mailContent) then
    UIUtil.ShowTipsId(141060)
    return
  end
  self.ctrl:OnSendClick(MailType.MAIL_ALLIANCE_ALL, LuaEntry.Player.uid, LuaEntry.Player.name, self.mailTitle, self.mailContent, LuaEntry.Player.allianceId)
end

UIMailSendView.OnCreate = OnCreate
UIMailSendView.OnDestroy = OnDestroy
UIMailSendView.InitUI = InitUI
UIMailSendView.OnClickSendBtn = OnClickSendBtn
UIMailSendView.OnInputMailTitle = OnInputMailTitle
UIMailSendView.OnInputMailContent = OnInputMailContent
return UIMailSendView
