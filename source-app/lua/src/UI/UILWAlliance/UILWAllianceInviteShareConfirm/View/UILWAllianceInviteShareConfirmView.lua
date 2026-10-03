local UILWAllianceInviteShareConfirmView = BaseClass("UILWAllianceInviteShareConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local channel_path = "ImgBg/Channel"
local channel_flag_path = "ImgBg/Channel/Flag"
local channel_name_path = "ImgBg/Channel/NameText"
local preview_text_path = "ImgBg/PreviewText"
local btn_yes_path = "ImgBg/BtnYes"
local btn_yes_text_path = "ImgBg/BtnYes/BtnYesText"
local btnYesCost_path = "ImgBg/BtnYes/costObj"
local btnYesTxtWithCost_path = "ImgBg/BtnYes/costObj/useText"
local btnYesCostTxt_path = "ImgBg/BtnYes/costObj/itemCount"
local btn_no_path = "ImgBg/BtnNo"
local btn_no_text_path = "ImgBg/BtnNo/BtnNoText"
local userhead = "ImgBg/Channel/UIPlayerHead"
local title_path = "UICommonMiniPopUpTitle/titleText"

local function OnCreate(self)
  base.OnCreate(self)
  local chat_channel = self:GetUserData()
  self.chat_channel = chat_channel
  local chat_data = {}
  chat_data.roomId = chat_channel:getRoomId()
  chat_data.post = PostType.Text_AllianceInvite
  chat_data.param = {}
  self.chat_data = chat_data
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.userhead = self:AddComponent(UIPlayerHead, userhead)
  self.channel_group = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, channel_path)
  self.channel_flag = self:AddComponent(UIImage, channel_flag_path)
  self.channel_name = self:AddComponent(UIText, channel_name_path)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(393087)
  self.preview_text = self:AddComponent(UIText, preview_text_path)
  self.btn_yes = self:AddComponent(UIButton, btn_yes_path)
  self.btn_yes:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickConfirmBtn()
  end)
  self.btn_yes_text = self:AddComponent(UIText, btn_yes_text_path)
  self.btn_yes_text:SetLocalText(110073)
  self.btnYesCost = self:AddComponent(UIBaseContainer, btnYesCost_path)
  self.btnYesTxtWithCost = self:AddComponent(UIText, btnYesTxtWithCost_path)
  self.btnYesTxtWithCost:SetLocalText(110073)
  self.btnYesCostTxt = self:AddComponent(UIText, btnYesCostTxt_path)
  self.btn_no = self:AddComponent(UIButton, btn_no_path)
  self.btn_no:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_no_text = self:AddComponent(UIText, btn_no_text_path)
  self.btn_no_text:SetLocalText(GameDialogDefine.CANCEL)
end

local function OnDestroy(self)
  self.chat_channel = nil
  self.chat_data = nil
  self.close_btn = nil
  self.return_btn = nil
  self.channel = nil
  self.channel_flag = nil
  self.channel_name = nil
  self.send_msg = nil
  self.btn_yes = nil
  self.btn_yes_text = nil
  self.btn_no = nil
  self.btn_no_text = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitState()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitState(self)
  local roomImg = self.chat_channel:getRoomImg()
  if not string.IsNullOrEmpty(roomImg) then
    self.channel_flag:SetActive(true)
    self.userhead:SetActive(false)
    self.channel_flag:LoadSprite(roomImg)
  else
    self.channel_flag:SetActive(false)
    self.userhead:SetActive(true)
  end
  self.channel_name:SetText(self.chat_channel:getRoomName())
  self.preview_text:SetLocalText(393088)
  local diamondCost = LuaEntry.DataConfig:TryGetNum("share_crystal", "k1", 200)
  if 0 < diamondCost then
    self.btn_yes_text:SetActive(false)
    self.btnYesCost:SetActive(true)
    self.btnYesCostTxt:SetText(diamondCost)
  else
    self.btn_yes_text:SetActive(true)
    self.btnYesCost:SetActive(false)
  end
end

local function OnClickConfirmBtn(self)
  local diamondCost = LuaEntry.DataConfig:TryGetNum("share_crystal", "k1", 200)
  if diamondCost > LuaEntry.Player.gold then
    GoToUtil.GotoPayTips(diamondCost)
  else
    self.ctrl:Confirm(self.chat_data)
  end
end

UILWAllianceInviteShareConfirmView.OnCreate = OnCreate
UILWAllianceInviteShareConfirmView.OnDestroy = OnDestroy
UILWAllianceInviteShareConfirmView.OnEnable = OnEnable
UILWAllianceInviteShareConfirmView.InitState = InitState
UILWAllianceInviteShareConfirmView.OnDisable = OnDisable
UILWAllianceInviteShareConfirmView.OnClickConfirmBtn = OnClickConfirmBtn
return UILWAllianceInviteShareConfirmView
