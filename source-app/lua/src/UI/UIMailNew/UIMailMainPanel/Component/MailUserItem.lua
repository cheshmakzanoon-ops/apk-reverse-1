local MailUserItem = BaseClass("MailUserItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local headIconPath = "head/UIPlayerHead/HeadIcon"
local nameTextPath = "nameText"
local jumpBtnPath = "jumpBtnObj"
local jumpBtnTextPath = "jumpBtnObj/jumpText"

local function OnCreate(self)
  base.OnCreate(self)
  self.headIcon = self:AddComponent(UIPlayerHead, headIconPath)
  self.nameText = self:AddComponent(UIText, nameTextPath)
  self.jumpBtn = self:AddComponent(UIButton, jumpBtnPath)
  self.jumpBtnText = self:AddComponent(UIText, jumpBtnTextPath)
  self.jumpBtnText:SetLocalText(GameDialogDefine.MAIl_PLAYER_INFO_CLICK)
  self.jumpBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function OnDestroy(self)
  self.headIcon = nil
  self.nameText = nil
  self.jumpBtn = nil
  self.jumpBtnText = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnBtnClick(self)
  local userData = {}
  userData.uid = self.userInfo.uid
  userData.headPic = self.userInfo.pic
  userData.headPicVer = self.userInfo.picVer
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, userData)
end

local function RefreshData(self, userInfo)
  self.userInfo = userInfo
  local uname
  if string.IsNullOrEmpty(userInfo.abbr) then
    uname = userInfo.name
  else
    uname = "[" .. userInfo.abbr .. "]" .. userInfo.name
  end
  self.nameText:SetText(uname)
  local pic = userInfo.pic or ""
  local picVer = userInfo.picVer or 0
  self.headIcon:SetData(userInfo.uid, pic, picVer)
end

MailUserItem.OnCreate = OnCreate
MailUserItem.OnDestroy = OnDestroy
MailUserItem.OnBtnClick = OnBtnClick
MailUserItem.OnEnable = OnEnable
MailUserItem.OnDisable = OnDisable
MailUserItem.RefreshData = RefreshData
return MailUserItem
