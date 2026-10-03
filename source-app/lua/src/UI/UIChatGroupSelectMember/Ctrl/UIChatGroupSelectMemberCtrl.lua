local UIChatGroupSelectMemberCtrl = BaseClass("UIChatGroupSelectMemberCtrl", UIBaseCtrl)

function UIChatGroupSelectMemberCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatGroupSelectMember)
end

function UIChatGroupSelectMemberCtrl:GetCreateRoomList(roomId)
  local dataList = {}
  local rooms = ChatInterface.getRoomMgr():GetAllUnblockedPrivateRoomDatas()
  local targetRoom
  if not string.IsNullOrEmpty(roomId) then
    targetRoom = ChatInterface.getRoomData(roomId)
  end
  local stickyList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
  local shell
  for _, room in ipairs(rooms) do
    local member = room:getPrivateOtherMember()
    shell = {}
    shell.stickyTime = stickyList[tostring(member and member.uid)] or 0
    shell.uid = member.uid
    shell.room = room
    shell.notClick = ChatInterface.getGroupChatMgr():IsInviteBlocked(targetRoom, member.uid)
    shell.itemType = GroupChatItemType.SelectMember
    table.insert(dataList, shell)
  end
  return dataList
end

function UIChatGroupSelectMemberCtrl:GetRoomMemberList(roomId)
  local room = ChatInterface.getRoomData(roomId)
  local shell
  local dataList = {}
  if room and room.memberList then
    for i = 1, #room.memberList do
      shell = {}
      shell.uid = room.memberList[i]
      shell.itemType = GroupChatItemType.SelectMember
      if not string.IsNullOrEmpty(room.memberList[i]) then
        table.insert(dataList, shell)
      end
      if room.memberList[i] == LuaEntry.Player.uid then
        shell.notClick = true
      end
    end
  end
  return dataList
end

function UIChatGroupSelectMemberCtrl:GetShowInfoListByType(openType, roomId)
  if openType == GroupMemberOpenType.CreateRooom or openType == GroupMemberOpenType.InviteNewMember then
    return self:GetCreateRoomList(roomId)
  elseif roomId then
    return self:GetRoomMemberList(roomId)
  end
end

return UIChatGroupSelectMemberCtrl
