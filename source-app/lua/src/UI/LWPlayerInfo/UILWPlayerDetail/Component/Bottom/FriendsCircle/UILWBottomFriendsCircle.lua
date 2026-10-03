local UILWFriendsCircleMessageArea = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.FriendsCircle.UILWFriendsCircleMessageArea")
local UILWBottomFriendsCircle = BaseClass("UILWBottomFriendsCircle", UIBaseContainer)
local UILWFriendsCircleTitle = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.FriendsCircle.UILWFriendsCircleTitle")
local base = UIBaseContainer

function UILWBottomFriendsCircle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWBottomFriendsCircle:OnEnable()
  base.OnEnable(self)
end

function UILWBottomFriendsCircle:ComponentDefine()
  self.messageArea = self:AddComponent(UILWFriendsCircleMessageArea, "Scroll_View_mainView")
  self.circleTitle = self:AddComponent(UILWFriendsCircleTitle, "titleLayout")
  self.notMsgCom = self:AddComponent(UIBaseContainer, "notMsg")
  self.notMsgText = self:AddComponent(UIText, "notMsg/Text")
  self.notMsgText:SetLocalText("moment_empty_des")
  self:ShowFriendsCircle(false)
  self.messageArea:SetCircle(self)
  self.isKid = 0
end

function UILWBottomFriendsCircle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ONE_ROOM_HISTORY_MSG, self.OnHistoryOneRoomMsg)
end

function UILWBottomFriendsCircle:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ONE_ROOM_HISTORY_MSG, self.OnHistoryOneRoomMsg)
  base.OnRemoveListener(self)
end

function UILWBottomFriendsCircle:OnHistoryOneRoomMsg(tempData)
  if self:IsCoppaLimit() then
    return
  end
  if tempData.roomId == self.circleRoomId then
    local tempRoom = ChatInterface.getRoomData(tempData.roomId)
    if table.count(tempRoom.msgs) > 0 then
      self.messageArea:RefreshRoomData(tempData.roomId)
    else
      self:ShowFriendsCircle(false)
    end
  end
end

function UILWBottomFriendsCircle:ShowFriendsCircle(isOn)
  self.notMsgCom:SetActive(not isOn)
end

function UILWBottomFriendsCircle:ReInit(data)
  self.isKid = data.isKid or 0
  if self:IsCoppaLimit() then
    return
  end
  if not data then
    self.messageArea:RefreshRoomData()
    self:ShowFriendsCircle(false)
    self:DataDestroy()
    return
  end
  self.data = data
  if self.data then
    self.circleRoomId = ChatManager2:GetInstance().Room:GetFriendsCircleRoomId(data.uid)
    self.circleTitle:ReInit(self.circleRoomId, data)
    ChatManager2:GetInstance().Room:CreateChatRoom(self.circleRoomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_REQUEST_HISTORY_MSG_COMMAND, self.circleRoomId)
    self:ShowFriendsCircle(true)
    self.messageArea:RefreshRoomData(self.circleRoomId)
  else
    self.messageArea:RefreshRoomData()
    self:ShowFriendsCircle(false)
  end
  if string.IsNullOrEmpty(self.circleRoomId) then
    return
  end
  if self.data.uid == LuaEntry.Player.uid then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM, self.circleRoomId)
  end
end

function UILWBottomFriendsCircle:OnTopPull()
end

function UILWBottomFriendsCircle:OnBottomPull()
end

function UILWBottomFriendsCircle:ComponentDestroy()
  self.messageArea = nil
  self.circleTitle = nil
end

function UILWBottomFriendsCircle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWBottomFriendsCircle:DataDestroy()
  if self.circleRoomId then
    if self.data and self.data.uid == LuaEntry.Player.uid then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, self.circleRoomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM)
    end
    ChatManager2:GetInstance().Room:RemoveRoomData(self.circleRoomId)
  end
  self.data = nil
  self.circleRoomId = nil
end

function UILWBottomFriendsCircle:IsCoppaLimit()
  if CoppaUtil.IsCoppaLimit() or self.isKid == 2 then
    self.notMsgText:SetLocalText(CoppaUtil.GetCoppaDialogId())
    self.messageArea:RefreshRoomData()
    self:ShowFriendsCircle(false)
    return true
  end
  return false
end

return UILWBottomFriendsCircle
