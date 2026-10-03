local MailAlLeaderElect = BaseClass("MailAlLeaderElect", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local UIGray = CS.UIGray
local title_path = "UIMailItemTitle/txtMainTitle"
local subTitle_path = "UIMailItemTitle/txtSubTitle"
local time_path = "UIMailItemTitle/txtTime"
local mailMsg_path = "txtDesc"
local electBtn_path = "signup/btnSignup"
local electBtnTxt_path = "signup/btnSignup/txtSignup"

local function OnCreate(self)
  base.OnCreate(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.timeN = self:AddComponent(UIText, time_path)
  self.mailMsgN = self:AddComponent(UITextMeshProUGUIEx, mailMsg_path)
  self.electBtnN = self:AddComponent(UIButton, electBtn_path)
  self.electBtnN:SetOnClick(function()
    self:OnClickSignUpBtn()
  end)
  self.electBtnTxtN = self:AddComponent(UIText, electBtnTxt_path)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AlLeaderElectStatusChange, self.OnElectStatusChange)
  self:AddUIListener(EventId.AlSysStateChange, self.OnElectStatusChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AlLeaderElectStatusChange, self.OnElectStatusChange)
  self:RemoveUIListener(EventId.AlSysStateChange, self.OnElectStatusChange)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function setData(self, mailInfo)
  self.mailInfo = mailInfo
  self:ParseContent()
  self:RefreshUI()
end

local function ParseContent(self)
  if self.mailInfo == nil then
    return
  end
end

local function RefreshUI(self)
  local strMainTitle = MailShowHelper.GetMainTitle(self.mailInfo)
  self.titleN:SetText(strMainTitle)
  local strSubTitle = MailShowHelper.GetMailSubTitle(self.mailInfo)
  self.subTitleN:SetText(strSubTitle)
  local strTime = MailShowHelper.GetAbstractCreateTime(self.mailInfo)
  self.timeN:SetText(strTime)
  local mailMsg = self.mailInfo:GetMailMessage()
  self.mailMsgN:SetText(mailMsg)
  self:SetElectBtn()
end

local function SetElectBtn(self)
  local electStatus = DataCenter.AllianceLeaderElectManager:GetAlLeaderElectStatus()
  if electStatus == 0 then
    UIGray.SetGray(self.electBtnN.transform, false, true)
    self.electBtnTxtN:SetLocalText(390871)
  else
    UIGray.SetGray(self.electBtnN.transform, true, false)
    if electStatus == 3 then
      self.electBtnTxtN:SetLocalText(390872)
    else
      self.electBtnTxtN:SetLocalText(390874)
    end
  end
end

local function OnClickSignUpBtn(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceLeaderElect)
end

local function OnElectStatusChange(self)
  self:RefreshUI()
end

MailAlLeaderElect.OnCreate = OnCreate
MailAlLeaderElect.OnDestroy = OnDestroy
MailAlLeaderElect.setData = setData
MailAlLeaderElect.ParseContent = ParseContent
MailAlLeaderElect.RefreshUI = RefreshUI
MailAlLeaderElect.OnClickSignUpBtn = OnClickSignUpBtn
MailAlLeaderElect.OnElectStatusChange = OnElectStatusChange
MailAlLeaderElect.SetElectBtn = SetElectBtn
MailAlLeaderElect.OnAddListener = OnAddListener
MailAlLeaderElect.OnRemoveListener = OnRemoveListener
return MailAlLeaderElect
