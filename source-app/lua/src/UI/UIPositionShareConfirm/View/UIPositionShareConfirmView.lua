local UIPositionShareConfirmView = BaseClass("UIPositionShareConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local channel_path = "ImgBg/Channel"
local channel_flag_path = "ImgBg/Channel/Flag"
local channel_name_path = "ImgBg/Channel/NameText"
local preview_text_path = "ImgBg/PreviewText"
local monster_text_path = "ImgBg/monsterText"
local btn_yes_path = "ImgBg/BtnYes"
local btn_yes_text_path = "ImgBg/BtnYes/BtnYesText"
local btnYesCost_path = "ImgBg/BtnYes/costObj"
local btnYesTxtWithCost_path = "ImgBg/BtnYes/costObj/useText"
local btnYesCostTxt_path = "ImgBg/BtnYes/costObj/itemCount"
local btn_no_path = "ImgBg/BtnNo"
local btn_no_text_path = "ImgBg/BtnNo/BtnNoText"
local userhead = "ImgBg/Channel/UIPlayerHead"
local title_path = "UICommonMiniPopUpTitle/titleText"
local nameMaxWidth = 465
local UnityLayoutElement = typeof(CS.UnityEngine.UI.LayoutElement)

local function OnCreate(self)
  base.OnCreate(self)
  local chat_channel, chat_param = self:GetUserData()
  self.chat_channel = chat_channel
  local chat_data = {}
  chat_data.roomId = chat_channel:getRoomId()
  if chat_param.postType ~= nil then
    chat_data.post = chat_param.postType
  else
    chat_data.post = PostType.Text_PointShare
  end
  chat_data.param = chat_param
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
  self.preview_text = self:AddComponent(UIText, preview_text_path)
  self.monster_text = self:AddComponent(UIText, monster_text_path)
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
  self.groupHead = self:AddComponent(GroupHead, "ImgBg/Channel/groupHeadCom")
  self.unity_LayoutElement = self.channel_name.gameObject:GetComponent(UnityLayoutElement)
  self.btn_no = self:AddComponent(UIButton, btn_no_path)
  self.btn_no:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_no_text = self:AddComponent(UIText, btn_no_text_path)
  self.btn_no_text:SetLocalText(GameDialogDefine.CANCEL)
  self.title = self:AddComponent(UIText, title_path)
  self.title:SetLocalText(393087)
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

function UIPositionShareConfirmView:UpdateNameMaxWidth()
  local preferredValues = self.channel_name.unity_tmpro:GetPreferredValues(nameMaxWidth, 0)
  self.unity_LayoutElement.preferredWidth = math.min(preferredValues.x, nameMaxWidth)
end

local function InitState(self)
  if self.chat_channel.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self.groupHead:SetActive(true)
    self.groupHead:UpdateGroupHeadList(self.chat_channel.memberList)
    self.channel_flag:SetActive(false)
    self.userhead:SetActive(false)
    self.channel_name:SetText(self.chat_channel:getRoomName())
    self:UpdateNameMaxWidth()
    self.preview_text:SetText(self.ctrl:getPreviewText(self.chat_data))
    self.channel_group.transform:Set_localPosition(0, 86.8, 0)
    self.preview_text.transform:Set_localPosition(0, -10.3, 0)
    return
  end
  self.groupHead:SetActive(false)
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
  self.preview_text:SetText(self.ctrl:getPreviewText(self.chat_data))
  if (self.chat_data.post == PostType.Text_ScoutReport or self.chat_data.post == PostType.Text_Formation_Fight_Share) and self.chat_channel.group == ChatGroupType.GROUP_COUNTRY then
    local diamondCost = LuaEntry.DataConfig:TryGetNum("share_report", "k1")
    if 0 < diamondCost then
      self.btn_yes_text:SetActive(false)
      self.btnYesCost:SetActive(true)
      self.btnYesCostTxt:SetText(diamondCost)
    else
      self.btn_yes_text:SetActive(true)
      self.btnYesCost:SetActive(false)
    end
  else
    self.btn_yes_text:SetActive(true)
    self.btnYesCost:SetActive(false)
  end
  self.monster_text:SetActive(false)
  if self.chat_data.post == PostType.MONSTER_INVASION_BOSS_SELF_PROTECTED then
    if self.chat_channel and self.chat_channel.group ~= ChatGroupType.GROUP_ALLIANCE and self.chat_channel.group ~= ChatGroupType.GROUP_ALLIANCE_MANAGER and self.chat_channel.group ~= ChatGroupType.GROUP_CUSTOM then
      self.channel_group.transform:Set_localPosition(0, 118, 0)
      self.monster_text.transform:Set_localPosition(5, -22.772, 0)
      self.preview_text.transform:Set_localPosition(0, 42, 0)
      self.monster_text:SetActive(true)
      self.monster_text:SetLocalText("monster_invasion_05")
    elseif self.chat_channel and self.chat_channel.group == ChatGroupType.GROUP_CUSTOM then
      local find = false
      local all = DataCenter.AllianceMemberDataManager:GetAllMember()
      for key, value in pairs(self.chat_channel.memberList) do
        if all[value] == nil then
          find = true
        end
      end
      if find then
        self.channel_group.transform:Set_localPosition(0, 118, 0)
        self.monster_text.transform:Set_localPosition(5, -22.772, 0)
        self.preview_text.transform:Set_localPosition(0, 42, 0)
        self.monster_text:SetActive(true)
        self.monster_text:SetLocalText("monster_invasion_05")
      else
        self.channel_group.transform:Set_localPosition(0, 86.8, 0)
        self.preview_text.transform:Set_localPosition(0, -10.3, 0)
      end
    else
      self.channel_group.transform:Set_localPosition(0, 86.8, 0)
      self.preview_text.transform:Set_localPosition(0, -10.3, 0)
    end
  else
    self.channel_group.transform:Set_localPosition(0, 86.8, 0)
    self.preview_text.transform:Set_localPosition(0, -10.3, 0)
  end
  self:UpdateNameMaxWidth()
end

local function OnClickConfirmBtn(self)
  if self.chat_data.post == PostType.Text_ScoutReport or self.chat_data.post == PostType.Text_Formation_Fight_Share then
    if self.chat_channel.group == ChatGroupType.GROUP_COUNTRY then
      local diamondCost = LuaEntry.DataConfig:TryGetNum("share_report", "k1")
      if diamondCost > LuaEntry.Player.gold then
        GoToUtil.GotoPayTips(diamondCost)
      else
        DataCenter.MailDataManager:TryShareMail(self.chat_data)
      end
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionShare)
      self.ctrl:CloseSelf()
    else
      self.ctrl:Confirm(self.chat_data, self.chat_channel)
    end
  else
    self.ctrl:Confirm(self.chat_data, self.chat_channel)
  end
end

UIPositionShareConfirmView.OnCreate = OnCreate
UIPositionShareConfirmView.OnDestroy = OnDestroy
UIPositionShareConfirmView.OnEnable = OnEnable
UIPositionShareConfirmView.InitState = InitState
UIPositionShareConfirmView.OnDisable = OnDisable
UIPositionShareConfirmView.OnClickConfirmBtn = OnClickConfirmBtn
return UIPositionShareConfirmView
