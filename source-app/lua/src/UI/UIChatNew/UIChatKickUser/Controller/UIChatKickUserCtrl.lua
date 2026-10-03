local UIChatKickUserCtrl = BaseClass("UIChatKickUserCtrl", UIBaseCtrl)

function UIChatKickUserCtrl:__init()
  self._chatRoomId = nil
end

function UIChatKickUserCtrl:GetRoomData()
  if self._chatRoomId == nil then
    return nil
  end
  local roomdata = ChatInterface.getRoomData(self._chatRoomId)
  return roomdata
end

function UIChatKickUserCtrl:GetChatRoomMemberIds()
  local roomdata = self:GetRoomData()
  if roomdata == nil then
    return {}
  end
  return roomdata.memberList or {}
end

function UIChatKickUserCtrl:GetUserInfoById(userid)
  if string.IsNullOrEmpty(userid) then
    return nil
  end
  return ChatInterface.getUserData(userid)
end

function UIChatKickUserCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatKickUser)
end

return UIChatKickUserCtrl
