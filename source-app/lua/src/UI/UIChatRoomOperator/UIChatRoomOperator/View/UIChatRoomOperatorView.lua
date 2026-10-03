local UIChatRoomOperatorView = BaseClass("UIChatRoomOperatorView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local _cp_txtTitle = "ImgBg/TxtTitle"
local _cp_btnClose = "ImgBg/BtnClose"
local _cp_btn_dismiss_or_quit = "btnQuit"
local _cp_txtDismiss_or_quit = "btnQuit/txtQuit"
local _cp_txtRoomName = "ImgBg/ItemList/ScrollView/Viewport/Content/objAllUser/mainContent/txtRoomName"
local _cp_txtAddUser = "ImgBg/ItemList/ScrollView/Viewport/Content/objAdd/mainContent/txtAddUser"
local _cp_txtKickUser = "ImgBg/ItemList/ScrollView/Viewport/Content/objKick/mainContent/txtKickUser"
local _cp_btnChangeRoomName = "ImgBg/ItemList/ScrollView/Viewport/Content/objAllUser/mainContent/btnChangeName"
local _cp_btnAddUser = "ImgBg/ItemList/ScrollView/Viewport/Content/objAdd/mainContent/btnAddUser"
local _cp_btnKickUser = "ImgBg/ItemList/ScrollView/Viewport/Content/objKick/mainContent/btnKickUser"
local _cp_allUserContent = "ImgBg/ItemList/ScrollView/Viewport/Content/objAllUser/allUserContent"
local _cp_objAdd = "ImgBg/ItemList/ScrollView/Viewport/Content/objAdd"
local _cp_objKick = "ImgBg/ItemList/ScrollView/Viewport/Content/objKick"

function UIChatRoomOperatorView:ComponentDefine()
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self._txtRoomName = self:AddComponent(UIText, _cp_txtRoomName)
  self._txtAddUser = self:AddComponent(UIText, _cp_txtAddUser)
  self._txtKickUser = self:AddComponent(UIText, _cp_txtKickUser)
  self._btnChangeRoomName = self:AddComponent(UIButton, _cp_btnChangeRoomName)
  self._btnChangeRoomName:SetOnClick(BindCallback(self, self.OnClickChangeName))
  self._btnAddUser = self:AddComponent(UIButton, _cp_btnAddUser)
  self._btnAddUser:SetOnClick(BindCallback(self, self.OnClickAddUser))
  self._btnKickUser = self:AddComponent(UIButton, _cp_btnKickUser)
  self._btnKickUser:SetOnClick(BindCallback(self, self.OnClickKickUser))
  self._allUserContent = self:AddComponent(UIBaseContainer, _cp_allUserContent)
  self._btn_dismiss_or_quit = self:AddComponent(UIButton, _cp_btn_dismiss_or_quit)
  self._btn_dismiss_or_quit:SetOnClick(BindCallback(self, self.OnClickQuitOrDismiss))
  self._txtDismiss_or_quit = self:AddComponent(UIText, _cp_txtDismiss_or_quit)
  self._objAdd = self:AddComponent(UIBaseContainer, _cp_objAdd)
  self._objKick = self:AddComponent(UIBaseContainer, _cp_objKick)
end

function UIChatRoomOperatorView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.LF_Enum_UpdateRoomOperateInfo, self.ResetRoomInfo)
end

function UIChatRoomOperatorView:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.LF_Enum_UpdateRoomOperateInfo, self.ResetRoomInfo)
  base.OnRemoveListener(self)
end

function UIChatRoomOperatorView:OnClickChangeName()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatChangeRoomName, self.view.ctrl.chatRoomdId)
end

function UIChatRoomOperatorView:OnClickAddUser()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatSearchPerson, self.view.ctrl.chatRoomdId)
end

function UIChatRoomOperatorView:OnClickKickUser()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatKickUser, self.view.ctrl.chatRoomdId)
end

function UIChatRoomOperatorView:OnClickQuitOrDismiss()
  local chatRoomData = self.view.ctrl:GetChatRoomData()
  if chatRoomData == nil then
    return
  end
  if chatRoomData:isMyCreateRoom() then
    local param = {}
    param.roomId = chatRoomData.roomId
    param.uidArr = chatRoomData.memberList
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_DISMISS, chatRoomData.roomId)
  else
    UIUtil.ShowMessage(Localization:GetString("290023"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      EventManager:GetInstance():Broadcast(ChatEventEnum.QUIT_ROOM_COMMAND, chatRoomData.roomId)
    end)
  end
  self.view.ctrl:CloseSelf()
end

function UIChatRoomOperatorView:InitChatRoomPlayer()
  self._allUserContent:DestroyChildNode()
  local chatRoomData = self.view.ctrl:GetChatRoomData()
  local memeberList = chatRoomData:getMemberList()
  for k, v in pairs(memeberList) do
    self:AddUserNode(v, k)
  end
  local isMyRoom = chatRoomData:isMyCreateRoom()
  self._objAdd:SetActive(isMyRoom)
  self._objKick:SetActive(isMyRoom)
end

function UIChatRoomOperatorView:AddUserNode(userId, index)
  self:GameObjectInstantiateAsync(UIAssets.UIChatHead, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self._allUserContent.transform)
    go.transform:Set_localScale(1, 1, 1)
  end)
end

function UIChatRoomOperatorView:InitView()
  self._txtRoomName:SetLocalText(390199)
  self._txtAddUser:SetLocalText(110037)
  self._txtKickUser:SetLocalText(100190)
  self:ResetRoomInfo()
end

function UIChatRoomOperatorView:ResetRoomInfo()
  local chatRoomData = self.view.ctrl:GetChatRoomData()
  if chatRoomData == nil then
    return
  end
  self:InitChatRoomPlayer()
  self._txtTitle:SetText(chatRoomData:getRoomName())
  if chatRoomData:isMyCreateRoom() then
    self._txtDismiss_or_quit:SetLocalText(110106)
  else
    self._txtDismiss_or_quit:SetLocalText(110043)
  end
end

function UIChatRoomOperatorView:OnCreate()
  base.OnCreate(self)
  self.view.ctrl.chatRoomdId = self:GetUserData()
  self:ComponentDefine()
  self:InitView()
end

return UIChatRoomOperatorView
