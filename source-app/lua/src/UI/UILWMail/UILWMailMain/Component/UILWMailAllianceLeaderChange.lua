local UILWMailAllianceLeaderChange = BaseClass("UILWMailAllianceLeaderChange", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local title_path = "System/Content/Layout/ChatAllianceRankChange/title"
local left_name_path = "System/Content/Layout/ChatAllianceRankChange/Left/LeftName"
local left_head_path = "System/Content/Layout/ChatAllianceRankChange/Left/LeftHeadNew"
local right_name_path = "System/Content/Layout/ChatAllianceRankChange/Right/RightName"
local right_head_path = "System/Content/Layout/ChatAllianceRankChange/Right/RightHeadNew"
local left_empty_path = "System/Content/Layout/ChatAllianceRankChange/LeftEmpty"
local right_empty_path = "System/Content/Layout/ChatAllianceRankChange/RightEmpty"
local left_path = "System/Content/Layout/ChatAllianceRankChange/Left"
local right_path = "System/Content/Layout/ChatAllianceRankChange/Right"

function UILWMailAllianceLeaderChange:OnCreate()
  base.OnCreate(self)
  self.detail_title = self:AddComponent(UIText, "System/DetailTitle")
  self.detail_time = self:AddComponent(UIText, "System/DetailTimeBg/DetailTime")
  self.icon = self:AddComponent(UIImage, "System/Content/IconBg/Icon")
  self.tip1Text = self:AddComponent(UIText, "System/Content/Tip1Text")
  self.goBtn = self:AddComponent(UIButton, "System/Content/GoBtn")
  self.goBtnText = self:AddComponent(UIText, "System/Content/GoBtn/BtnText")
  self.goBtnText:SetLocalText("450004")
  self.goBtn:SetOnClick(function()
    if self.jumpLink then
      GoToUtil.TryJumpToWorld(self.jumpLink)
    end
  end)
  self.descText = self:AddComponent(UIText, "System/Content/Layout/Desc")
  self.tipText = self:AddComponent(UIText, "System/Content/Layout/Tips")
  self.rankChange = self:AddComponent(UIBaseContainer, "System/Content/Layout/ChatAllianceRankChange")
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.left_name = self:AddComponent(UITextMeshProUGUIEx, left_name_path)
  self.left_head = self:AddComponent(UICommonHead, left_head_path)
  self.right_name = self:AddComponent(UITextMeshProUGUIEx, right_name_path)
  self.right_head = self:AddComponent(UICommonHead, right_head_path)
  self.left_empty = self:AddComponent(UIBaseContainer, left_empty_path)
  self.right_empty = self:AddComponent(UIBaseContainer, right_empty_path)
  self.left = self:AddComponent(UIBaseContainer, left_path)
  self.right = self:AddComponent(UIBaseContainer, right_path)
end

function UILWMailAllianceLeaderChange:OnDestroy()
  self.detail_title = nil
  self.detail_time = nil
  self.icon = nil
  self.tip1Text = nil
  self.goBtn = nil
  self.goBtnText = nil
  self.descText = nil
  self.tipText = nil
  self.title = nil
  self.left_name = nil
  self.left_head = nil
  self.right_name = nil
  self.right_head = nil
  self.left_empty = nil
  self.right_empty = nil
  self.left = nil
  self.right = nil
  base.OnDestroy(self)
end

function UILWMailAllianceLeaderChange:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnGetUserInfoSuccess)
end

function UILWMailAllianceLeaderChange:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnGetUserInfoSuccess)
  base.OnRemoveListener(self)
end

function UILWMailAllianceLeaderChange:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  self.detail_title:SetText(MailShowHelper.GetMainTitle(self.mailData))
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detail_time:SetText(_strTime)
  if not string.IsNullOrEmpty(MailShowHelper.GetMailSubTitle(self.mailData)) then
    self.descText:SetActive(true)
    self.descText:SetText(MailShowHelper.GetMailSubTitle(self.mailData))
  elseif self.mailData:GetMailId() == MailIdMap.Alliance_R5_Change_Force then
    self.descText:SetText(Localization:GetString("311020", tostring(self.mailData:GetMailParam(2))))
  else
    self.descText:SetActive(false)
  end
  local _strContents = self.mailData:GetMailMessage()
  self.tipText:SetText(_strContents)
  local titleInfo = self.mailData:GetMailParamTable(3)
  if titleInfo and titleInfo.dialog then
    self.title:SetLocalText(393095, Localization:GetString(titleInfo.dialog.id))
  elseif self.mailData:GetMailId() == MailIdMap.Alliance_R5_Change or self.mailData:GetMailId() == MailIdMap.Alliance_R5_Change_Force then
    self.title:SetLocalText(393095, Localization:GetString("302336"))
  end
  local last = self.mailData:GetMailParamTable(4)
  if last and last.user then
    local lastPlayerInfo
    self.lastUid = last.user.uid
    if self.lastUid then
      lastPlayerInfo = UIUtil.GetPlayerInfoShowByUid(self.lastUid)
    end
    self:RefreshLastPlayer(lastPlayerInfo)
  end
  local now = self.mailData:GetMailParamTable(5)
  if now and now.user then
    local nowPlayerInfo
    self.nowUid = now.user.uid
    if self.nowUid then
      nowPlayerInfo = UIUtil.GetPlayerInfoShowByUid(self.nowUid)
    end
    self:RefreshNowPlayer(nowPlayerInfo)
  end
  local isShowNewUI = last and last.user and now and now.user
  self.rankChange:SetActive(isShowNewUI)
end

function UILWMailAllianceLeaderChange:OnGetUserInfoSuccess(uid)
  local info = UIUtil.GetPlayerInfoShowByUid(uid)
  if uid == self.lastUid then
    self:RefreshLastPlayer(info)
  elseif uid == self.nowUid then
    self:RefreshNowPlayer(info)
  end
end

function UILWMailAllianceLeaderChange:RefreshLastPlayer(info)
  self.left_empty:SetActive(info == nil)
  self.left:SetActive(info ~= nil)
  if info then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(info.uid, info.name)
    self.left_name:SetText(showName)
    self.left_head:SetEnableClickShowInfo(true)
    self.left_head:ParseHeadInfo(info)
  end
end

function UILWMailAllianceLeaderChange:RefreshNowPlayer(info)
  self.right_empty:SetActive(info == nil)
  self.right:SetActive(info ~= nil)
  if info then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(info.uid, info.name)
    self.right_name:SetText(showName)
    self.right_head:SetEnableClickShowInfo(true)
    self.right_head:ParseHeadInfo(info)
  end
end

return UILWMailAllianceLeaderChange
