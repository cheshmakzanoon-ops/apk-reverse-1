local UIGroupChatSettingView = BaseClass("UIGroupChatSettingView", UIBaseView)
local GroupChatLoopListCom = require("UI.UIGroupChatSetting.Component.GroupChatLoopList")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIGroupChatSettingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIGroupChatSettingView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGroupChatSettingView:ComponentDefine()
  self.btnBack = self:AddComponent(UIButton, "Root/bottom/btnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.layoutRoot = self:AddComponent(UIBaseContainer, "Root")
  self.settingList = self:AddComponent(GroupChatLoopListCom, "Root/middle/Scroll_View_mainView")
end

function UIGroupChatSettingView:ReInit()
  self.room = ChatManager2:GetInstance().Room:GetRoomData(self.room.roomId)
  self.config = self.ctrl:GetSettingConfig(self.room)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutRoot.rectTransform)
  self.settingList:RefreshList(self.room, self.config)
  self.pushIsOn = DataCenter.PushSettingsManager:GetGroupChatPushSetting(self.room.roomId)
end

function UIGroupChatSettingView:ComponentDestroy()
  self.btnBack = nil
  self.settingList = nil
end

function UIGroupChatSettingView:DataDefine()
  self.room = self:GetUserData()
  if self.room then
    self.pushIsOn = DataCenter.PushSettingsManager:GetGroupChatPushSetting(self.room.roomId)
    self.muted = ChatInterface.getGroupChatMgr():GetIsNotDisturbingRoom(self.room.roomId)
    self.topRoom = ChatInterface.getRoomMgr():GetRoomIsTop(self.room.roomId, ChatGroupType.GROUP_CUSTOM_GROUP)
  end
end

function UIGroupChatSettingView:DataDestroy()
  self.pushIsOn = nil
  self.topRoom = nil
  self.muted = nil
  self.room = nil
end

function UIGroupChatSettingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_ROOM_MEMBER_CHANGE, self.OnRoomChangeOwner)
  self:AddUIListener(EventId.CHAT_CHANGE_OWNER, self.OnRoomChangeOwner)
  self:AddUIListener(EventId.CHAT_REMOVE_KICKEDROOM, self.OnRemoveKickedRoom)
end

function UIGroupChatSettingView:OnRemoveKickedRoom(data)
  if self.room and data and data.roomId == self.room.roomId then
    self.ctrl:CloseSelf()
  end
end

function UIGroupChatSettingView:OnRoomChangeOwner(changeData)
  if changeData.roomId == self.room.roomId then
    self:ReInit()
  end
end

function UIGroupChatSettingView:OnSliderSwitched(isOn, settingType)
  if settingType == GroupChatSettingType.push then
    self.pushIsOn = isOn
  elseif settingType == GroupChatSettingType.RoomTop then
    self.topRoom = isOn
  elseif settingType == GroupChatSettingType.IsMuted then
    self.muted = isOn
  end
end

function UIGroupChatSettingView:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_ROOM_MEMBER_CHANGE, self.OnRoomChangeOwner)
  self:RemoveUIListener(EventId.CHAT_CHANGE_OWNER, self.OnRoomChangeOwner)
  self:RemoveUIListener(EventId.CHAT_REMOVE_KICKEDROOM, self.OnRemoveKickedRoom)
  base.OnRemoveListener(self)
end

function UIGroupChatSettingView:OnBtnBackClick()
  local pushSetting = DataCenter.PushSettingsManager:GetGroupChatPushSetting(self.room.roomId)
  local muted = ChatInterface.getGroupChatMgr():GetIsNotDisturbingRoom(self.room.roomId)
  local roomTop = ChatInterface.getRoomMgr():GetRoomIsTop(self.room.roomId, ChatGroupType.GROUP_CUSTOM_GROUP)
  if pushSetting ~= self.pushIsOn then
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatPushSetElement, self.room.roomId, self.pushIsOn and 1 or 0)
  end
  if self.muted ~= muted then
    ChatInterface.getGroupChatMgr():SetRoomNotDisturbing(self.room.roomId, self.muted)
  end
  if self.topRoom ~= roomTop then
    ChatInterface.getRoomMgr():RoomTop(self.room.roomId, ChatGroupType.GROUP_CUSTOM_GROUP, self.topRoom)
  end
  self.ctrl:CloseSelf()
end

return UIGroupChatSettingView
