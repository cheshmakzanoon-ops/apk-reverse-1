local MailAllianceInvite = BaseClass("MailAllianceInvite", UIBaseContainer)
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local UIGray = CS.UIGray
local title_path = "UIMailItemTitle/txtMainTitle"
local subTitle_path = "UIMailItemTitle/txtSubTitle"
local time_path = "UIMailItemTitle/txtTime"
local mailMsg_path = "txtDesc"
local infoBtn_path = "allianceIcon/infoBtn"
local btnsContainer_path = "status/btns"
local statusTxt_path = "status/statusTxt"
local acceptBtn_path = "status/btns/btnAccept"
local acceptTxt_path = "status/btns/btnAccept/txtAccept"
local refuseBtn_path = "status/btns/btnRefuse"
local refuseTxt_path = "status/btns/btnRefuse/txtRefuse"
local allianceFlag_path = "allianceIcon/AllianceFlag"

local function OnCreate(self)
  base.OnCreate(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.timeN = self:AddComponent(UIText, time_path)
  self.mailMsgN = self:AddComponent(UITextMeshProUGUIEx, mailMsg_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
  self.btnsContainerN = self:AddComponent(UIBaseContainer, btnsContainer_path)
  self.statusTxtN = self:AddComponent(UIText, statusTxt_path)
  self.acceptBtnN = self:AddComponent(UIButton, acceptBtn_path)
  self.acceptBtnN:SetOnClick(function()
    self:OnClickAcceptBtn()
  end)
  self.acceptTxtN = self:AddComponent(UIText, acceptTxt_path)
  self.acceptTxtN:SetLocalText(110037)
  self.refuseBtnN = self:AddComponent(UIButton, refuseBtn_path)
  self.refuseBtnN:SetOnClick(function()
    self:OnClickRefuseBtn()
  end)
  self.refuseTxtN = self:AddComponent(UIText, refuseTxt_path)
  self.refuseTxtN:SetLocalText(390005)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceInviteStatusChange, self.RefreshUI)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceInviteStatusChange, self.RefreshUI)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function setData(self, mailInfo)
  self.mailInfo = mailInfo
  self:RefreshUI()
end

local function RefreshUI(self)
  local mailContent = self.mailInfo:GetMailBody()
  local mailCustom = self.mailInfo:GetMailCustom()
  local strMainTitle = MailShowHelper.GetMainTitle(self.mailInfo)
  self.titleN:SetText(strMainTitle)
  local inviter = mailContent.b.userInfo.name
  local alAbbr = mailContent.b.allianceInfo.abbr or ""
  local alName = mailContent.b.allianceInfo.name or ""
  local subTitle = Localization:GetString("311027", inviter, alAbbr, alName)
  self.subTitleN:SetText(subTitle)
  self.allianceFlagN:SetData(mailContent.b.allianceInfo.icon)
  local strTime = MailShowHelper.GetAbstractCreateTime(self.mailInfo)
  self.timeN:SetText(strTime)
  local mailMsg = Localization:GetString("391044", inviter, alName)
  self.mailMsgN:SetText(mailMsg)
  local dealStatus = mailCustom and mailCustom.c and mailCustom.c.deal and mailCustom.c.deal or 1
  if dealStatus == 1 then
    local strKey = "MailInviteDeal_" .. self.mailInfo.uid
    dealStatus = CS.GameEntry.Setting:GetInt(strKey, 1)
  end
  if dealStatus == 1 then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    if serverTime > self.mailInfo.expireTime then
      self.btnsContainerN:SetActive(false)
      self.statusTxtN:SetActive(true)
      self.statusTxtN:SetLocalText(391049)
    else
      self.btnsContainerN:SetActive(true)
      self.statusTxtN:SetActive(false)
    end
  else
    self.btnsContainerN:SetActive(false)
    self.statusTxtN:SetActive(true)
    if dealStatus == 2 then
      self.statusTxtN:SetLocalText(391045)
    else
      self.statusTxtN:SetLocalText(391046)
    end
  end
end

local function OnClickAcceptBtn(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceInviteAccept, self.mailInfo.uid)
end

local function OnClickRefuseBtn(self)
  SFSNetwork.SendMessage(MsgDefines.AllianceInviteRefuse, self.mailInfo.uid)
end

local function OnClickInfoBtn(self)
  local mailContent = self.mailInfo:GetMailBody()
  local alName = mailContent.b.allianceInfo.name
  local alId = mailContent.b.allianceInfo.uid
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, alName, alId)
end

MailAllianceInvite.OnCreate = OnCreate
MailAllianceInvite.OnDestroy = OnDestroy
MailAllianceInvite.setData = setData
MailAllianceInvite.ParseContent = ParseContent
MailAllianceInvite.RefreshUI = RefreshUI
MailAllianceInvite.OnClickAcceptBtn = OnClickAcceptBtn
MailAllianceInvite.OnClickRefuseBtn = OnClickRefuseBtn
MailAllianceInvite.OnAddListener = OnAddListener
MailAllianceInvite.OnRemoveListener = OnRemoveListener
MailAllianceInvite.OnClickInfoBtn = OnClickInfoBtn
return MailAllianceInvite
