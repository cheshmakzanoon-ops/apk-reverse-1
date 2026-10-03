local UILWAllianceInviteShareCtrl = BaseClass("UILWAllianceInviteShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceInviteShare, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomShow
  })
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetChatList(self)
  local _chatRoomManager = ChatInterface.getRoomMgr()
  local rooms = {}
  local r1 = _chatRoomManager:GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY)
  local r2 = _chatRoomManager:GetRoomDataByGroup(ChatGroupType.GROUP_LANGUAGE)
  if r1 then
    table.insert(rooms, r1)
  end
  if r2 then
    table.insert(rooms, r2)
  end
  return rooms
end

UILWAllianceInviteShareCtrl.CloseSelf = CloseSelf
UILWAllianceInviteShareCtrl.Close = Close
UILWAllianceInviteShareCtrl.GetChatList = GetChatList
return UILWAllianceInviteShareCtrl
