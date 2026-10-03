local MailAllianceCommon = BaseClass("MailAllianceCommon", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local title_path = "UIMailItemTitle/txtMainTitle"
local subTitle_path = "UIMailItemTitle/txtSubTitle"
local time_path = "UIMailItemTitle/txtTime"
local mailMsg_path = "txtContext"

local function OnCreate(self)
  base.OnCreate(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.timeN = self:AddComponent(UIText, time_path)
  self.mailMsgN = self:AddComponent(UITextMeshProUGUIEx, mailMsg_path)
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
end

MailAllianceCommon.OnCreate = OnCreate
MailAllianceCommon.OnDestroy = OnDestroy
MailAllianceCommon.setData = setData
MailAllianceCommon.ParseContent = ParseContent
MailAllianceCommon.RefreshUI = RefreshUI
return MailAllianceCommon
