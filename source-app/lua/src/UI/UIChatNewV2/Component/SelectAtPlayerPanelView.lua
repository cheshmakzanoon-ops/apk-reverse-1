local SelectAtPlayerPanelView = BaseClass("SelectAtPlayerPanelView", UIBaseContainer)
local SelectAtPlayerPanelItem = require("UI.UIChatNewV2.Component.SelectAtPlayerPanelItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ScrollViewHeight = 320
local ScrollViewItemHeight = 93
local compBook = {
  {
    path = "scrollView",
    name = "scrollRooms",
    type = UILoopListView2
  },
  {
    path = "scrollView/Viewport/Content",
    name = "itemContent",
    type = UIBaseContainer
  },
  {
    path = "scrollView",
    name = "scrollView",
    type = UIScrollRect
  },
  {
    path = "CloseBtn",
    name = "closeBtn",
    type = UIButton
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.closeBtn:SetOnClick(function()
    self:SetActive(false)
  end)
end

local function ComponentDestroy(self)
  self.itemContent:RemoveComponents(SelectAtPlayerPanelItem)
  self:ClearCompsByBook(compBook)
end

local function DataDefine(self)
  self._objList = {}
  self.list = {}
  self.filter = ""
  self.chatFilters = {}
  self.currentRoom = nil
end

local function DataDestroy(self)
  self._objList = {}
  self.list = {}
  self.filter = ""
  self.chatFilters = {}
  self.currentRoom = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.AllianceMember, self.RefreshScrollView)
  self:AddUIListener(ChatEventEnum.CHAT_ATALL_COUNT, self.UpdateAtAllState)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(ChatEventEnum.AllianceMember, self.RefreshScrollView)
  self:RemoveUIListener(ChatEventEnum.CHAT_ATALL_COUNT, self.UpdateAtAllState)
  base.OnRemoveListener(self)
end

function SelectAtPlayerPanelView:UpdateAtAllState(data)
  if not data or not self.currentRoom then
    return
  end
  if data.roomId ~= self.currentRoom.roomId then
    return
  end
  local roomData = ChatInterface.getRoomMgr():GetRoomData(self.currentRoom.roomId)
  local count = 0
  if roomData then
    count = roomData.atAllCount
  end
  for i, item in pairs(self._objList) do
    item:UpdateAtAll(count)
  end
end

function SelectAtPlayerPanelView:InitView()
  self.scrollRooms:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
end

function SelectAtPlayerPanelView:OnGetItemByIndex(listView, index)
  self.prefabIndex = self.prefabIndex or 0
  local prefabName = self:GetItemPrefabName(index)
  local item = listView:NewListViewItem(prefabName)
  if item == nil then
    return nil
  end
  
  local function SelectFunc(i)
    self:OnSelectPlayer(i)
  end
  
  if self._objList[item] ~= nil then
    self._objList[item]:SetActive(true)
    self._objList[item]:UpdateItem(self.list[index + 1], index, SelectFunc)
  else
    local script = self:GetItemScript(index)
    if script == nil then
      return
    end
    local objectName = prefabName .. "_" .. tostring(self.prefabIndex) .. "_" .. tostring(index)
    item.gameObject.name = tostring(objectName)
    self.prefabIndex = self.prefabIndex + 1
    local temp = self.itemContent:AddComponent(script, item.gameObject)
    temp:SetActive(true)
    temp:UpdateItem(self.list[index + 1], index, SelectFunc)
    self._objList[item] = temp
  end
  return item
end

function SelectAtPlayerPanelView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self._objList[loopListViewItem]
  if script ~= nil and script.OnRecycleItem then
    script:OnRecycleItem()
    script:SetActive(false)
  end
end

function SelectAtPlayerPanelView:GetItemPrefabName(index)
  return "SelectAtPlayerItem"
end

function SelectAtPlayerPanelView:GetItemScript(index)
  return SelectAtPlayerPanelItem
end

function SelectAtPlayerPanelView:RefreshChatFilter(room)
  self:FetchAllianceMember()
  self.chatFilters = {}
  if room == nil then
    return
  end
  self.currentRoom = room
  local chatMessages = room:GetMsgs()
  local count = #chatMessages
  for i = count, math.max(count - 100, 1), -1 do
    local chatData = chatMessages[i]
    if self.chatFilters[chatData.senderUid] == nil then
      self.chatFilters[chatData.senderUid] = i
    end
  end
  if ChatInterface.GetAtAllPermission(self.currentRoom) then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatGetRoomQuerAtAllTimes, self.currentRoom.roomId)
  end
end

function SelectAtPlayerPanelView:RefreshScrollView(filter)
  if filter ~= nil then
    self.filter = filter
  end
  self.list = self:GetFilterPlayerList(self.filter)
  self.scrollRooms:SetListItemCount(#self.list, false, false)
  self.scrollRooms:RefreshAllShownItem()
  local y = ScrollViewHeight
  if #self.list <= 3 then
    y = ScrollViewItemHeight * #self.list
  end
  self:SetSizeDeltaY(y)
end

function SelectAtPlayerPanelView:GetFilterPlayerList(filter)
  local toAtPlayers = {}
  if self.currentRoom then
    if self.currentRoom.group == ChatGroupType.GROUP_ALLIANCE_MANAGER then
      toAtPlayers = table.mergeArray(toAtPlayers, DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(4))
      toAtPlayers = table.mergeArray(toAtPlayers, DataCenter.AllianceMemberDataManager:GetAllianceMemberListByRank(5))
    elseif self.currentRoom.group == ChatGroupType.GROUP_ALLIANCE then
      toAtPlayers = DataCenter.AllianceMemberDataManager:GetAllMember()
    elseif self.currentRoom.group == ChatGroupType.GROUP_CUSTOM_GROUP then
      local memberList = self.currentRoom.memberList
      for _, uid in ipairs(memberList) do
        local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(uid)
        if chatUserInfo then
          table.insert(toAtPlayers, {
            uid = uid,
            pic = chatUserInfo.headPic,
            picVer = chatUserInfo.headPicVer,
            headSkinId = chatUserInfo.headSkinId,
            headSkinET = chatUserInfo.headSkinET,
            name = chatUserInfo.userName
          })
        end
      end
    end
  end
  local list = {}
  local filterPosList = {}
  filter = string.lower(filter)
  table.walk(toAtPlayers, function(k, v)
    if v.uid ~= LuaEntry.Player.uid then
      local pos = 0
      if not string.IsNullOrEmpty(filter) then
        local showName, hasRemark = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(v.uid, v.name)
        if hasRemark then
          pos = string.find(string.lower(showName), filter, 1, true)
          if pos then
            table.insert(list, v)
          end
        else
          pos = string.find(string.lower(v.name), filter, 1, true)
          if pos then
            table.insert(list, v)
          end
        end
      else
        table.insert(list, v)
      end
      filterPosList[v.uid] = pos
    end
  end)
  table.sort(list, function(a, b)
    local aPos = filterPosList[a.uid] or 0
    local bPos = filterPosList[b.uid] or 0
    if aPos ~= bPos then
      return aPos < bPos
    end
    local aChat = self.chatFilters[a.uid] or 0
    local bChat = self.chatFilters[b.uid] or 0
    if aChat ~= bChat then
      return aChat > bChat
    end
    if a.online ~= b.online then
      return a.online
    elseif a.online then
      return a.uid < b.uid
    elseif a.offLineTime ~= b.offLineTime then
      return a.offLineTime > b.offLineTime
    else
      return a.uid < b.uid
    end
  end)
  if self.currentRoom and ChatInterface.GetAtAllPermission(self.currentRoom) then
    local allName = Localization:GetString("at_all_text1")
    local roomData = ChatInterface.getRoomMgr():GetRoomData(self.currentRoom.roomId)
    local count = 0
    if roomData then
      count = roomData.atAllCount
    end
    table.insert(list, 1, {
      atAll = true,
      name = allName,
      uid = "atAll",
      atAllCount = count
    })
  end
  return list
end

function SelectAtPlayerPanelView:FetchAllianceMember()
  local force = DataCenter.AllianceMemberDataManager:HasMemberChanged()
  DataCenter.AllianceMemberDataManager:TryInitMemberList(force)
end

function SelectAtPlayerPanelView:OnSelectPlayer(index)
  local player = self.list[index + 1]
  EventManager:GetInstance():Broadcast(EventId.CHAT_ON_INPUT_ADD_AT_PLAYER, player)
end

SelectAtPlayerPanelView.OnCreate = OnCreate
SelectAtPlayerPanelView.OnDestroy = OnDestroy
SelectAtPlayerPanelView.OnEnable = OnEnable
SelectAtPlayerPanelView.OnDisable = OnDisable
SelectAtPlayerPanelView.ComponentDefine = ComponentDefine
SelectAtPlayerPanelView.ComponentDestroy = ComponentDestroy
SelectAtPlayerPanelView.DataDefine = DataDefine
SelectAtPlayerPanelView.DataDestroy = DataDestroy
SelectAtPlayerPanelView.OnAddListener = OnAddListener
SelectAtPlayerPanelView.OnRemoveListener = OnRemoveListener
return SelectAtPlayerPanelView
