local base = UIBaseContainer
local GroupMemberItem = BaseClass("GroupMemberItem", UIBaseContainer)
local addSpritePath = "GroupChat/zyf_liaotian_zengjiachengyuan.png"
local outSpritePath = "GroupChat/zyf_liaotian_jianshaochengyuan.png"
local Localization = CS.GameEntry.Localization

function GroupMemberItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GroupMemberItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GroupMemberItem:ComponentDefine()
  self.head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.goBtn = self:AddComponent(UIButton, "Btn")
  self.goBtnImg = self:AddComponent(UIImage, "Btn")
  self.nameTxt = self:AddComponent(UITextMeshProUGUIEx, "txtName")
  self.ownerIcon = self:AddComponent(UIImage, "ownerIcon")
  self.goBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function GroupMemberItem:ComponentDestroy()
  self.head = nil
  self.btnImg = nil
end

function GroupMemberItem:DataDefine()
  self.data = nil
end

function GroupMemberItem:DataDestroy()
  self.data = nil
end

function GroupMemberItem:UpdateItem(data)
  self.data = data
  self.ownerIcon:SetActive(false)
  if data.uid then
    local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(data.uid)
    self.head:SetHeadAndFrame(chatUserInfo.uid, chatUserInfo.headPic, chatUserInfo.headPicVer, false, chatUserInfo.headSkinId, chatUserInfo.headSkinET)
    self.head:SetActive(true)
    self.nameTxt:SetActive(true)
    self.ownerIcon:SetActive(data.isOwner)
    self.nameTxt:SetText(chatUserInfo.userName)
    self.goBtn:SetActive(false)
    self.head:SetEnableClickShowInfo(true, true)
  elseif data.openType == GroupMemberOpenType.InviteNewMember then
    self.head:SetActive(false)
    self.goBtn:SetActive(true)
    self.goBtnImg:LoadSprite(ChatInterface.GetChatUIPath(addSpritePath))
    self.nameTxt:SetActive(false)
  elseif data.openType == GroupMemberOpenType.GroupMembersOut then
    self.head:SetActive(false)
    self.goBtn:SetActive(true)
    self.goBtnImg:LoadSprite(ChatInterface.GetChatUIPath(outSpritePath))
    self.nameTxt:SetActive(false)
  end
end

function GroupMemberItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
end

function GroupMemberItem:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnRefreshUserInfo)
  base.OnRemoveListener(self)
end

function GroupMemberItem:OnRefreshUserInfo(playerUid)
  if self.data and self.data.uid and playerUid == self.data.uid then
    self:UpdateItem(self.data)
  end
end

function GroupMemberItem:OnBtnClick()
  local param = {
    openType = self.data.openType,
    roomId = self.data.roomId
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatGroupSelectMember, {anim = true}, param)
end

return GroupMemberItem
