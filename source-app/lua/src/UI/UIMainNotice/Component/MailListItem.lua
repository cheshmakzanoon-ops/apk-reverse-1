local MailListItem = BaseClass("MailListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local name_path = "txtTitle"
local des_txt_path = "txtSubTitle"
local time_path = "txtTime"
local red_point_path = "RedPoint"
local select_img_path = "item_select"
local item_bg_path = "item_bg"
local btn_path = ""
local img_gift_icon = "img_gift_icon"
local _cp_mailIcon = "mailIcon"
local _cp_txtTitleFight = "txtTitleFight"

local function OnCreate(self)
  base.OnCreate(self)
  self._txtTitleFight = self:AddComponent(UIText, _cp_txtTitleFight)
  self._txtTitleFight_Outline = self:AddComponent(UIOutline, _cp_txtTitleFight)
  self._mailIcon = self:AddComponent(UIImage, _cp_mailIcon)
  self.name = self:AddComponent(UIText, name_path)
  self.des = self:AddComponent(UIText, des_txt_path)
  self.time = self:AddComponent(UIText, time_path)
  self.redPoint = self:AddComponent(UIImage, red_point_path)
  self.select = self:AddComponent(UIImage, select_img_path)
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.img_gift_icon = self:AddComponent(UIBaseContainer, img_gift_icon)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

local function SetItemShow(self, ...)
  local mailData = (...)
  self._maildata = mailData
  self.itemId = mailData.uuid
  local curUuid = self.view.maildata.uuid
  local active = curUuid and mailData.uuid == curUuid or false
  self.name:SetText(mailData.title)
  self._txtTitleFight:SetText(mailData.title)
  self.des:SetText(mailData.subTitle)
  local createTime = MailShowHelper.GetRelativeCreateTime(mailData)
  self.time:SetText(createTime)
  self.select:SetActive(active)
  self.item_bg:SetActive(not active)
  local defaultIcon = string.format(LoadPath.UIMail, "UIMail_icon_daily")
  local mailIcon = MailShowHelper.GetMailIcon(mailData)
  if string.IsNullOrEmpty(mailIcon) then
    self._mailIcon:LoadSprite(defaultIcon)
  else
    mailIcon = string.format(LoadPath.UIMail, mailIcon)
    self._mailIcon:LoadSprite(mailIcon, defaultIcon)
  end
  local reward = mailData:GetMailReward()
  if reward then
    local rewardVersion = reward.rewardVersion
    if rewardVersion then
      self.img_gift_icon:SetActive(false)
    else
      self.img_gift_icon:SetActive(mailData.rewardStatus == 0)
    end
  else
    self.img_gift_icon:SetActive(false)
  end
  self._txtTitleFight:SetActive(false)
  self.name:SetActive(true)
  if active and mailData.status == 0 then
    self.redPoint:SetActive(false)
    local curId = DataCenter.WorldNoticeManager:GetCurId()
    if curId and curId == mailData.uuid then
      return
    end
    DataCenter.WorldNoticeManager:SetCurId(mailData.uuid)
    DataCenter.WorldNoticeManager:SendReadNotice(mailData.uuid)
  else
    self.redPoint:SetActive(mailData.status ~= 1)
  end
end

local function OnClick(self)
  if self.view.maildata.uuid == self.itemId then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.NoticeItemClick, self.itemId)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NoticeItemClick, self.RefreshItemState)
  self:AddUIListener(EventId.NoticeItemReward, self.RefreshRedPoint)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.NoticeItemClick, self.RefreshItemState)
  self:RemoveUIListener(EventId.NoticeItemReward, self.RefreshRedPoint)
end

local function RefreshItemState(self, data)
  local mailData = self.view.ctrl:GetOneMailByUid(self.itemId)
  if self.itemId == data then
    self.redPoint:SetActive(false)
    self.select:SetActive(true)
    self.item_bg:SetActive(false)
    if mailData.status == 0 then
      DataCenter.WorldNoticeManager:SendReadNotice(self.itemId)
    end
  else
    if mailData then
      self.redPoint:SetActive(mailData.status ~= 1)
    end
    self.select:SetActive(false)
    self.item_bg:SetActive(true)
  end
end

local function RefreshRedPoint(self)
  local mailData = self.view.ctrl:GetOneMailByUid(self.itemId)
  if mailData then
    self.redPoint:SetActive(mailData.status ~= 1)
    self.img_gift_icon:SetActive(mailData.rewardStatus == 0)
  end
end

MailListItem.OnCreate = OnCreate
MailListItem.SetItemShow = SetItemShow
MailListItem.OnClick = OnClick
MailListItem.OnAddListener = OnAddListener
MailListItem.OnRemoveListener = OnRemoveListener
MailListItem.RefreshItemState = RefreshItemState
MailListItem.RefreshRedPoint = RefreshRedPoint
return MailListItem
