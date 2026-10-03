local UIChatGroupSelectMemberView = BaseClass("UIChatGroupSelectMemberView", UIBaseView)
local SelectMemberList = require("UI.UIChatGroupSelectMember.Component.SelectMemberList")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local base = UIBaseView
local MemberConfig = {
  [GroupMemberOpenType.CreateRooom] = {
    max = 20,
    min = 2,
    titleText = "group_create_title",
    btnText = "110006"
  },
  [GroupMemberOpenType.GroupMembersOut] = {
    max = 20,
    min = 1,
    titleText = "group_list_operate_title2",
    btnText = "110006"
  },
  [GroupMemberOpenType.GroupMembersMakeOver] = {
    max = 1,
    min = 1,
    titleText = "group_list_operate_title3",
    btnText = "110006"
  },
  [GroupMemberOpenType.InviteNewMember] = {
    max = 20,
    min = 1,
    titleText = "group_list_operate_title1",
    btnText = "110006"
  }
}

function UIChatGroupSelectMemberView:OnCreate()
  base.OnCreate(self)
  DataCenter.ChatPrivateDataManager:OnToNormalType()
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIChatGroupSelectMemberView:OnDestroy()
  DataCenter.ChatPrivateDataManager:OnToNormalType()
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatGroupSelectMemberView:ComponentDefine()
  self.layoutRoot = self:AddComponent(UIBaseContainer, "Root")
  self.btnBack = self:AddComponent(UIButton, "Root/bottom/btnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnSelect = self:AddComponent(UIButton, "Root/bottom/selectBtn")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.tipBtn = self:AddComponent(UIButton, "Root/top/tipBtn")
  self.tipBtn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "Root/top/TxtTitle")
  self.btnText = self:AddComponent(UITextMeshProUGUIEx, "Root/bottom/selectBtn/btnBatchDelText")
  self.selectMemberList = self:AddComponent(SelectMemberList, "Root/middle/Scroll_View_mainView")
end

function UIChatGroupSelectMemberView:OnTipBtnClick()
  if self.openType ~= GroupMemberOpenType.CreateRooom and self.openType ~= GroupMemberOpenType.InviteNewMember then
    return
  end
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt(true)
  local str
  if serverListInt then
    for i, v in pairs(serverListInt) do
      if string.IsNullOrEmpty(str) then
        str = "#" .. v
      else
        str = str .. " " .. "#" .. v
      end
    end
  end
  local text = str and Localization:GetString("group_create_des") .. "\n" .. Localization:GetString("group_create_des_s") .. str or Localization:GetString("group_create_des")
  UIUtil.ShowMessage(text, 0)
end

function UIChatGroupSelectMemberView:ComponentDestroy()
  self.imgSearchInputFieldEx = nil
  self.btnSearch = nil
  self.btnDel = nil
  self.btnBack = nil
  self.btnSelect = nil
  self.loopListView2ScrollViewMainView = nil
end

function UIChatGroupSelectMemberView:DataDefine()
end

local function __ComparePrivateRoom(shell1, shell2)
  if shell1.stickyTime == shell2.stickyTime then
    return shell1.room.lastMsgTime > shell2.room.lastMsgTime
  end
  return shell1.stickyTime > shell2.stickyTime
end

function UIChatGroupSelectMemberView:GetInfos()
  local showInfoList = {}
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    local rooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
    if rooms and 0 < #rooms then
      for i = 1, #rooms do
        if rooms[i]:isPrivateChat() then
          table.insert(showInfoList, {
            uid = rooms[i]:getPrivateOtherMember().uid,
            itemType = GroupChatItemType.SelectMember
          })
        end
      end
    end
  else
    showInfoList = self.ctrl:GetShowInfoListByType(self.openType, self.roomId)
  end
  if self.openType == GroupMemberOpenType.CreateRooom or self.openType == GroupMemberOpenType.InviteNewMember or viewShowType == ChatPrivateListShowType.Search then
    local rooms = ChatInterface.getRoomMgr():GetAllUnblockedPrivateRoomDatas()
    local updateData = {
      search = {
        isSearch = true,
        itemType = GroupChatItemType.Search
      },
      normalTypeShowFunc = function()
        self:SetNormalTypeShow()
      end,
      searchTypeShowFunc = function()
        self:SetSearchTypeShow()
      end,
      needFindNum = #rooms,
      itemType = GroupChatItemType.Search,
      isSearch = true
    }
    if viewShowType ~= ChatPrivateListShowType.Search then
      table.sort(showInfoList, __ComparePrivateRoom)
    end
    table.insert(showInfoList, 1, updateData)
  end
  return showInfoList
end

function UIChatGroupSelectMemberView:InitView()
  local windData = self:GetUserData()
  self.openType = windData.openType
  self.roomId = windData.roomId
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutRoot.rectTransform)
  local showInfoList = self:GetInfos()
  self.selectMemberList:RefreshList(showInfoList, self.openType)
  local titleTextStr = MemberConfig[self.openType].titleText
  local btnTextStr = MemberConfig[self.openType].btnText
  self.titleText:SetLocalText(titleTextStr)
  self.btnText:SetLocalText(btnTextStr)
  self.tipBtn:SetActive(self.openType == GroupMemberOpenType.CreateRooom or self.openType == GroupMemberOpenType.InviteNewMember)
  UIGray.SetGray(self.btnSelect.transform, true, false)
end

function UIChatGroupSelectMemberView:DataDestroy()
  self.openType = nil
end

function UIChatGroupSelectMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  self:AddUIListener(EventId.ChatPrivateSearchResultMsgBack, self.PrivateChatShowChange)
  self:AddUIListener(EventId.CHAT_REMOVE_KICKEDROOM, self.OnRemoveKickedRoom)
end

function UIChatGroupSelectMemberView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  self:RemoveUIListener(EventId.ChatPrivateSearchResultMsgBack, self.PrivateChatShowChange)
  self:RemoveUIListener(EventId.CHAT_REMOVE_KICKEDROOM, self.OnRemoveKickedRoom)
  base.OnRemoveListener(self)
end

function UIChatGroupSelectMemberView:SetSearchTypeShow()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    return
  end
  DataCenter.ChatPrivateDataManager:OnToSearchType()
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
end

function UIChatGroupSelectMemberView:SetNormalTypeShow()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
    return
  end
  DataCenter.ChatPrivateDataManager:OnToNormalType()
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
end

function UIChatGroupSelectMemberView:OnRemoveKickedRoom(data)
  if data and data.roomId == self.roomId then
    self.ctrl:CloseSelf()
  end
end

function UIChatGroupSelectMemberView:PrivateChatShowChange()
  local showInfoList = self:GetInfos()
  for i = 1, #showInfoList do
    if self.uidDic and showInfoList[i].uid and self.uidDic[showInfoList[i].uid] then
      showInfoList[i].isOn = true
    end
  end
  self.selectMemberList:RefreshList(showInfoList, self.openType)
end

function UIChatGroupSelectMemberView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIChatGroupSelectMemberView:UpdatePlayer(uid, isOn)
  if not self.uidDic then
    self.uidDic = {}
  end
  if isOn then
    self.uidDic[uid] = isOn
  else
    self.uidDic[uid] = nil
  end
  local meberCount = table.count(self.uidDic)
  local min = MemberConfig[self.openType].min
  local max = MemberConfig[self.openType].max
  if self.openType == GroupMemberOpenType.CreateRooom or self.openType == GroupMemberOpenType.InviteNewMember then
    min = LuaEntry.DataConfig:TryGetNum("chat_group_limit", "k1")
    max = LuaEntry.DataConfig:TryGetNum("chat_group_limit", "k2")
  end
  if meberCount >= min and meberCount <= max then
    UIGray.SetGray(self.btnSelect.transform, false, true)
  else
    UIGray.SetGray(self.btnSelect.transform, true, false)
  end
end

function UIChatGroupSelectMemberView:GetSelectUidList()
  local uidList = {}
  for uid, isOn in pairs(self.uidDic) do
    if isOn then
      table.insert(uidList, uid)
    end
  end
  return uidList
end

function UIChatGroupSelectMemberView:OnBtnSelectClick()
  local list = self:GetSelectUidList()
  local room
  if self.roomId then
    room = ChatInterface.getRoomData(self.roomId)
  end
  if self.openType == GroupMemberOpenType.GroupMembersMakeOver then
    local _userinfo = ChatInterface.getUserData(list[1])
    local name = _userinfo:GetUserName()
    local param = {
      tipText = Localization:GetString("group_owner_trans_tips1", name),
      btnNum = 1,
      text1 = "110006",
      sureAction = function()
        ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatRoomChangeLeder, room.roomId, room.group, list[1])
      end,
      showToggle = false
    }
    UIUtil.ShowSecondMessageByParam(param)
  elseif self.openType == GroupMemberOpenType.CreateRooom then
    ChatInterface.getGroupChatMgr():SendCreateRoom(list)
  elseif self.openType == GroupMemberOpenType.GroupMembersOut then
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomKick, room.roomId, room.group, list)
  elseif self.openType == GroupMemberOpenType.InviteNewMember then
    ChatInterface.getGroupChatMgr():SendInvitation(list, room)
  end
  self.ctrl:CloseSelf()
end

return UIChatGroupSelectMemberView
