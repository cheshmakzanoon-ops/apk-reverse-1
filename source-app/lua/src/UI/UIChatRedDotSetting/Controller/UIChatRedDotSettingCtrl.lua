local UIChatRedDotSettingCtrl = BaseClass("UIChatRedDotSettingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatRedDotSetting)
end

function UIChatRedDotSettingCtrl:GetAllRoom()
  local roomList = {}
  local room
  self.redTypeDic = ChatManager2:GetInstance().Room:GetRoomGroupRedDotTypeDic()
  local redType
  local groupDic = DataCenter.GroupChatSetTemplateManager:GetAllChatGroup()
  local template
  for i, group in pairs(groupDic) do
    for i, roomType in pairs(group) do
      if group ~= ChatGroupType.GROUP_CUSTOM then
        room = ChatManager2:GetInstance().Room:GetRoomDataByGroup(roomType)
        if room and room.category ~= ChatRoomCategory.PRIVATE then
          template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(roomType)
          redType = 1
          if self.redTypeDic[room.group] then
            redType = self.redTypeDic[room.group]
          elseif template and template.dots_type <= UnreadNotificationType.NoNotification then
            redType = template.dots_type
          end
          table.insert(roomList, {room = room, redType = redType})
        end
      end
    end
  end
  local tempA, tempB
  table.sort(roomList, function(a, b)
    tempA = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(a.room.group)
    tempB = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(b.room.group)
    tempA = tempA and tempA.sort or 1000
    tempB = tempB and tempB.sort or 1000
    return tempA < tempB
  end)
  return roomList
end

UIChatRedDotSettingCtrl.CloseSelf = CloseSelf
return UIChatRedDotSettingCtrl
