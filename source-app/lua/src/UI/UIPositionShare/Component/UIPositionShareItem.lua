local UIPositionShareItem = BaseClass("UIPositionShareItem", UIBaseContainer)
local base = UIBaseContainer
local btn_path = "ImgBg"
local flag_path = "ImgBg/Flag"
local channel_name_path = "ImgBg/ChannelName"
local userHeadContent = "ImgBg/UIPlayerHead"
local userHead = "ImgBg/UIPlayerHead/HeadIcon"
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
  self.channel_name_txt = self:AddComponent(UIText, channel_name_path)
  self.groupHead = self:AddComponent(GroupHead, "ImgBg/groupHeadCom")
  self.data = nil
  self.senderUid = nil
end

local function OnDestroy(self)
  base.OnDestroy(self)
  self.data = nil
  self.senderUid = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
end

local function OnRefreshUserInfo(self, uid)
  if self.data == nil or self.senderUid == nil then
    return
  end
  if self.senderUid == uid then
    local userInfo = ChatInterface.getUserData(self.senderUid)
    if self.userHead and userInfo then
      self.userHead:SetData(userInfo.uid, userInfo.headPic, userInfo.headPicVer)
      self.channel_name_txt:SetText(self.data:getRoomName(true))
    end
  end
end

local function SetItemShow(self, data)
  self.data = data
  if data.group == ChatGroupType.GROUP_CUSTOM_GROUP then
    self.userHeadArea:SetActive(false)
    self.groupHead:SetActive(true)
    self.groupHead:UpdateGroupHeadList(data.memberList)
    self.channel_name_txt:SetText(self.data:getRoomName(true))
    return
  else
    self.groupHead:SetActive(false)
    self.userHeadArea:SetActive(true)
  end
  local roomImg = self.data:getRoomImg()
  if string.IsNullOrEmpty(roomImg) then
    self.flag:SetActive(false)
    self.userHead:SetActive(true)
    self.userHeadArea:SetActive(true)
    self.senderUid = ""
    local memberList = self.data.memberList or {}
    for _, memUid in pairs(memberList) do
      if memUid ~= LuaEntry.Player.uid then
        self.senderUid = memUid
        break
      end
    end
    if string.IsNullOrEmpty(self.senderUid) then
      return
    end
    local userInfo = ChatInterface.getUserData(self.senderUid)
    if self.userHead ~= nil and userInfo then
      self.userHead:SetData(userInfo.uid, userInfo.headPic, userInfo.headPicVer)
    end
  else
    self.flag:SetActive(true)
    self.userHead:SetActive(false)
    self.userHeadArea:SetActive(false)
    local path = self.data:getRoomImg()
    if not string.IsNullOrEmpty(path) then
      self.flag:LoadSprite(self.data:getRoomImg())
    end
  end
  self.flag:SetSizeDeltaXY(86, 88)
  self.channel_name_txt:SetText(self.data:getRoomName(true))
end

local function SetItemSimple(self, param)
  self.data = param
  self.senderUid = nil
  self.flag:SetActive(true)
  self.userHead:SetActive(false)
  self.groupHead:SetActive(false)
  self.userHeadArea:SetActive(false)
  self.flag:LoadSprite(param.icon)
  self.channel_name_txt:SetText(param.name)
  self.flag:SetNativeSize()
end

local function OnItemClick(self)
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  if self.data.callback then
    self.data.callback()
    self.view.ctrl:CloseSelf()
    return
  end
  self.view:OnItemClick(self.data)
end

UIPositionShareItem.OnCreate = OnCreate
UIPositionShareItem.OnDestroy = OnDestroy
UIPositionShareItem.OnAddListener = OnAddListener
UIPositionShareItem.OnRemoveListener = OnRemoveListener
UIPositionShareItem.SetItemShow = SetItemShow
UIPositionShareItem.SetItemSimple = SetItemSimple
UIPositionShareItem.OnItemClick = OnItemClick
UIPositionShareItem.OnRefreshUserInfo = OnRefreshUserInfo
return UIPositionShareItem
