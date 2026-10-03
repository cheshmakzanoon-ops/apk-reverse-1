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
local Color_Select_MainTitle = Color32.New(0.8156862745098039, 0.40784313725490196, 0.19607843137254902, 1)
local Color_UnSelect_MainTitle = Color32.New(0.396078431372549, 0.19607843137254902, 0.0784313725490196, 1)
local Color_Select_SubTitle = Color32.New(0.8156862745098039, 0.40784313725490196, 0.19607843137254902, 0.7)
local Color_UnSelect_SubTitle = Color32.New(0.396078431372549, 0.19607843137254902, 0.0784313725490196, 0.7)
local Color_Select_Time = Color32.New(0.8156862745098039, 0.40784313725490196, 0.19607843137254902, 0.4)
local Color_UnSelect_Time = Color32.New(0.396078431372549, 0.19607843137254902, 0.0784313725490196, 0.4)

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
  self.itemId = mailData.uid
  local currentMail = self.view.ctrl:GetCurrentMail()
  local active = currentMail and mailData.uid == currentMail.uid or false
  local mainTitle = MailShowHelper.GetMainTitle(mailData)
  self.name:SetText(mainTitle)
  self._txtTitleFight:SetText(mainTitle)
  local subTitle = MailShowHelper.GetMailSubTitle(mailData)
  self.des:SetText(subTitle)
  local createTime = MailShowHelper.GetRelativeCreateTime(mailData)
  self.time:SetText(createTime)
  self.redPoint:SetActive(mailData.status ~= 1)
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
  self.img_gift_icon:SetActive(mailData.rewardStatus == 0)
  if mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.MARCH_DESTROY_MAIL then
    self._txtTitleFight:SetActive(true)
    self.name:SetActive(false)
    local battleWin = mailData:GetMailExt():GetBattleWin()
    if battleWin then
      self._txtTitleFight:SetColor(Const_Color_Green)
      self._txtTitleFight_Outline:SetColor(Const_Green_Outline)
    else
      self._txtTitleFight:SetColor(Const_Color_Red)
      self._txtTitleFight_Outline:SetColor(Const_Red_Outline)
    end
  else
    self._txtTitleFight:SetActive(false)
    self.name:SetActive(true)
  end
end

local function OnClick(self)
  local currentMail = self.view.ctrl:GetCurrentMail()
  if currentMail and self.itemId ~= currentMail.uid then
    EventManager:GetInstance():Broadcast(EventId.CLICK_MAIL_ITEM, self.itemId)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_MAIL_ITEM, self.RefreshItemState)
  self:AddUIListener(EventId.MailPush, self.RefreshRedPoint)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CLICK_MAIL_ITEM, self.RefreshItemState)
  self:RemoveUIListener(EventId.MailPush, self.RefreshRedPoint)
end

local function RefreshItemState(self, data)
  if self.itemId == data then
    self.redPoint:SetActive(false)
    self.select:SetActive(true)
    self.item_bg:SetActive(false)
  else
    local mailData = self.view.ctrl:GetOneMailByUid(self.itemId)
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
