local UIGroupChatSettingCtrl = BaseClass("UIGroupChatSettingCtrl", UIBaseCtrl)
local Member = {
  lanageKey = "",
  type = GroupChatSettingType.GroupMembers,
  itemType = GroupChatItemType.MemberList
}
local MakeOver = {
  lanageKey = "group_setting_btn_trans",
  type = GroupChatSettingType.MakeOver,
  itemType = GroupChatItemType.GroupSettingItem
}
local Rename = {
  lanageKey = "group_setting_name",
  type = GroupChatSettingType.ReName,
  itemType = GroupChatItemType.GroupSettingItem
}
local push = {
  lanageKey = "2900056",
  type = GroupChatSettingType.push,
  itemType = GroupChatItemType.GroupSettingItem
}
local Exit = {
  lanageKey = "group_setting_btn_leave",
  type = GroupChatSettingType.Exit,
  itemType = GroupChatItemType.GroupSettingItem
}
local Report = {
  lanageKey = "report_group",
  type = GroupChatSettingType.Report,
  itemType = GroupChatItemType.GroupSettingItem
}
local RoomTop = {
  lanageKey = "convo_top_set",
  type = GroupChatSettingType.RoomTop,
  itemType = GroupChatItemType.GroupSettingItem
}
local isMuted = {
  lanageKey = "convo_not_disturb_set",
  type = GroupChatSettingType.IsMuted,
  itemType = GroupChatItemType.GroupSettingItem
}
local ownerConfig = {
  Member,
  Rename,
  push,
  RoomTop,
  isMuted,
  MakeOver,
  Report,
  Exit
}
local OtherConfig = {
  Member,
  Rename,
  push,
  RoomTop,
  isMuted,
  Report,
  Exit
}

function UIGroupChatSettingCtrl:GetSettingConfig(room)
  local memberList = {}
  for i = 1, #room.memberList do
    if room.memberList[i] ~= LuaEntry.Player.uid then
    end
    if not string.IsNullOrEmpty(room.memberList[i]) and room.memberList[i] ~= room.owner then
      table.insert(memberList, {
        uid = room.memberList[i]
      })
    end
  end
  table.insert(memberList, 1, {
    uid = room.owner,
    isOwner = true
  })
  if room.owner == LuaEntry.Player.uid then
    ownerConfig[1].memberList = memberList
    table.insert(memberList, {
      openType = GroupMemberOpenType.InviteNewMember,
      roomId = room.roomId
    })
    table.insert(memberList, {
      openType = GroupMemberOpenType.GroupMembersOut,
      roomId = room.roomId
    })
    return ownerConfig
  else
    OtherConfig[1].memberList = memberList
    table.insert(memberList, {
      openType = GroupMemberOpenType.InviteNewMember,
      roomId = room.roomId
    })
    return OtherConfig
  end
end

function UIGroupChatSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGroupChatSetting)
end

return UIGroupChatSettingCtrl
