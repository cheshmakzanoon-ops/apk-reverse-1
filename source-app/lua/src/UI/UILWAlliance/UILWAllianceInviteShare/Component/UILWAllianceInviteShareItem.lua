local UILWAllianceInviteShareItem = BaseClass("UILWAllianceInviteShareItem", UIBaseContainer)
local base = UIBaseContainer
local btn_path = "ImgBg"
local flag_path = "ImgBg/Flag"
local channel_name_path = "ImgBg/ChannelName"
local userHeadContent = "ImgBg/UIPlayerHead"
local userHead = "ImgBg/UIPlayerHead"
local GroupHead = require("UI/UIChatNewV2/Component/GroupHead")

local function OnCreate(self)
  base.OnCreate(self)
  self.userHead = self:AddComponent(UIPlayerHead, userHead)
  self.userHeadArea = self:AddComponent(UIBaseContainer, userHeadContent)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnItemClick()
  end)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.groupHead = self:AddComponent(GroupHead, "ImgBg/groupHeadCom")
  self.channel_name_txt = self:AddComponent(UIText, channel_name_path)
end

local function SetItemShow(self, data)
  if data.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self.userHeadArea:SetActive(false)
    self.groupHead:SetActive(true)
    self.groupHead:UpdateGroupHeadList(data.memberList)
    self.channel_name_txt:SetText(data:getRoomName(true))
    return
  else
    self.groupHead:SetActive(false)
    self.userHeadArea:SetActive(true)
  end
  self.data = data
  local roomImg = self.data:getRoomImg()
  if string.IsNullOrEmpty(roomImg) then
    self.flag:SetActive(false)
    self.userHead:SetActive(true)
    self.userHeadArea:SetActive(true)
  else
    self.flag:SetActive(true)
    self.userHead:SetActive(false)
    self.userHeadArea:SetActive(false)
    self.flag:LoadSprite(self.data:getRoomImg())
  end
  self.channel_name_txt:SetText(self.data:getRoomName())
end

local function OnItemClick(self)
  self.view:OnItemClick(self.data)
end

UILWAllianceInviteShareItem.OnCreate = OnCreate
UILWAllianceInviteShareItem.SetItemShow = SetItemShow
UILWAllianceInviteShareItem.OnItemClick = OnItemClick
return UILWAllianceInviteShareItem
