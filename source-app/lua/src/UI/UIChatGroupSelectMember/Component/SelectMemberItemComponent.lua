local base = UIBaseContainer
local SelectMemberItemComponent = BaseClass("SelectMemberItemComponent", UIBaseContainer)
local UIChatHead = require("UI.UIChatNew.Component.ChatHead")
local Localization = CS.GameEntry.Localization

function SelectMemberItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SelectMemberItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SelectMemberItemComponent:ComponentDefine()
  self.imgNotClickMask = self:AddComponent(UIImage, "board/notClickMask")
  self.boardBtn = self:AddComponent(UIButton, "board")
  self.textTxtName = self:AddComponent(UITextMeshProUGUIEx, "board/txtName")
  self.compChatHead = self:AddComponent(UIChatHead, "board/ChatHead")
  self.imgNotClick = self:AddComponent(UIImage, "btnBatchSelect/notClick")
  self.imgBtnBatchSelect = self:AddComponent(UIImage, "btnBatchSelect/btnBatchSelectImg")
  self.btnBatchSelect = self:AddComponent(UIButton, "btnBatchSelect")
  self.btnBatchSelect:SetOnClick(function()
    self:OnBoardBtnClick()
  end)
  self.boardBtn:SetOnClick(function()
    self:OnBoardBtnClick()
  end)
  self.maskBtn = self:AddComponent(UIButton, "board/notClickMask")
  self.maskBtn:SetOnClick(function()
    self:OnMaskBtnClick()
  end)
end

function SelectMemberItemComponent:ComponentDestroy()
  self.imgNotClickMask = nil
  self.textTxtName = nil
  self.compChatHead = nil
  self.imgNotClick = nil
  self.imgBtnBatchSelect = nil
  self.btnBatchSelect = nil
  self.isOn = nil
end

function SelectMemberItemComponent:DataDefine()
end

function SelectMemberItemComponent:OnMaskBtnClick()
  if self.view and self.view.OnTipBtnClick then
    self.view:OnTipBtnClick()
  end
end

function SelectMemberItemComponent:DataDestroy()
end

function SelectMemberItemComponent:OnBoardBtnClick()
  if self.data.notClick then
    return
  end
  self.isOn = not self.isOn
  self.data.isOn = self.isOn
  self.imgBtnBatchSelect:SetActive(self.isOn)
  self.contentView:UpdatePlayer(self.userInfo.uid, self.isOn)
end

function SelectMemberItemComponent:SetContentViewScript(contentView)
  self.contentView = contentView
end

function SelectMemberItemComponent:InitItem()
  self.imgNotClickMask:SetActive(self.data.notClick)
  self.imgNotClick:SetActive(self.data.notClick)
  self.imgBtnBatchSelect:SetActive(self.data.isOn)
end

function SelectMemberItemComponent:UpdateItem(data)
  if not data or not data.uid then
    return
  end
  self.data = data
  self:OnUpdateUser(self.data.uid)
end

function SelectMemberItemComponent:OnUpdateUser(uid)
  if self.data and self.data.uid == uid then
    local room
    if self.view.openType == GroupMemberOpenType.CreateRooom or self.view.openType == GroupMemberOpenType.InviteNewMember then
      if self.view and self.view.roomId then
        room = ChatInterface.getRoomData(self.view.roomId)
      end
      self.data.notClick = ChatInterface.getGroupChatMgr():IsInviteBlocked(room, uid)
    end
    self:UpdateUserInfo(self.data.uid)
  end
end

function SelectMemberItemComponent:UpdateUserInfo(uid)
  if self.data and self.data.uid == uid then
    self.textTxtName:SetText(ChatInterface.GetShowRoomUserName(uid))
    self.userInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
    self.compChatHead:UpdateHead(self.userInfo, {})
    self:InitItem()
  end
end

function SelectMemberItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnUpdateUser)
end

function SelectMemberItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnUpdateUser)
  base.OnRemoveListener(self)
end

function SelectMemberItemComponent:OnBtnBatchSelectClick()
end

return SelectMemberItemComponent
