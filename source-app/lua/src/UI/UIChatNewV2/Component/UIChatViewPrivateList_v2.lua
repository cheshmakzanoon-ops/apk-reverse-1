local base = UIBaseContainer
local UIChatViewPrivateList_v2 = BaseClass("UIChatViewPrivateList_v2", base)
local UIPrivateRoomItem = require("UI.UIChatNewV2.Component.UIChatViewPrivateListItem_v2")
local UIChatViewSearchObjItem_v2 = require("UI.UIChatNewV2.Component.UIChatViewSearchObjItem_v2")
local startMaxCount = 20
local compBook = {
  {
    path = "scrollView",
    name = "scrollRooms",
    type = UILoopListView2
  },
  {
    path = "scrollView/Viewport/Content",
    name = "itemContent",
    type = UIBaseContainer,
    active = true
  },
  {
    path = "scrollView",
    name = "scrollView",
    type = UIScrollRect,
    active = true
  },
  {
    path = "privateListEmptyTip",
    name = "privateListEmptyTip",
    type = UIText,
    active = false
  },
  {
    path = "waitMsgImg",
    name = "waitMsgImg",
    type = UIBaseContainer,
    active = false
  }
}
local searchItemNum = 1
local __DataShells = {}

local function __ClearShellState(shell)
  if not shell then
    return
  end
  if shell.__slideTween then
    shell.__slideTween:Kill()
    shell.__slideTween = nil
  end
  shell.__slideWeight = 0
end

local function __SlideItemBoard(shell, isSlideToTargetPos)
  if shell.__slideWeight == 0 and isSlideToTargetPos == false then
    return
  end
  local slideTargetWeight = CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1
  if shell.__slideWeight == slideTargetWeight and isSlideToTargetPos == true then
    return
  end
  if shell.__slideTween then
    shell.__slideTween:Kill()
  end
  shell.__slideTween = CS.DG.Tweening.DOTween.To(function()
    return shell.__slideWeight
  end, function(v)
    shell.__slideWeight = v
  end, isSlideToTargetPos and slideTargetWeight or 0, 0.2):OnComplete(function()
    shell.__slideTween = nil
  end):SetEase(CS.DG.Tweening.Ease.OutCubic)
end

local function __ComparePrivateRoom(shell1, shell2)
  if shell1.stickyTime == shell2.stickyTime then
    return shell1.room.lastMsgTime > shell2.room.lastMsgTime
  end
  return shell1.stickyTime > shell2.stickyTime
end

function UIChatViewPrivateList_v2:GetRoomLast(roomId)
  if not self.cacheRoomDic then
    self.cacheRoomDic = {}
  end
  if not self.cacheRoomDic[roomId] then
    self.cacheRoomDic[roomId] = true
    ChatInterface.getRoomMgr():GetRoomLast(roomId)
  end
end

function UIChatViewPrivateList_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_INIT_PULL_DONE, self.OnInitMessagePullDone)
  self:AddUIListener(EventId.ChatPrivateSearchResultMsgBack, self.OnChatPrivateSearchResultMsgBack)
  self:AddUIListener(EventId.ChatPrivateSearchViewRefresh, self.OnChatPrivateSearchViewRefresh)
  self:AddUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
end

function UIChatViewPrivateList_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_INIT_PULL_DONE, self.OnInitMessagePullDone)
  self:RemoveUIListener(EventId.ChatPrivateSearchResultMsgBack, self.OnChatPrivateSearchResultMsgBack)
  self:RemoveUIListener(EventId.ChatPrivateSearchViewRefresh, self.OnChatPrivateSearchViewRefresh)
  self:RemoveUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  base.OnRemoveListener(self)
end

function UIChatViewPrivateList_v2:OnInitMessagePullDone()
  self.cacheRoomDic = {}
end

function UIChatViewPrivateList_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIChatViewPrivateList_v2:OnDestroy()
  self:StopWaitMsgTween()
  self:ComponentDestroy()
  self.cacheRoomDic = nil
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChatViewPrivateList_v2:OnDisable()
  base.OnDisable(self)
  if not self.itemDatas then
    return
  end
  for _, shell in pairs(__DataShells) do
    __ClearShellState(shell)
    shell.room = nil
  end
end

function UIChatViewPrivateList_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.privateItemList = {}
  self.itemIncNo = 1
  self.cacheRoomDic = {}
  self.itemMap = {}
  self.scrollRooms:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  
  function self.scrollRooms.unity_looplistview2.mOnEndDragAction()
    self:OnDragEnd()
  end
end

function UIChatViewPrivateList_v2:DataDefine()
  self.normalTypeSaveData = {
    rooms = {}
  }
  self.searchTypeSaveData = {
    rooms = {}
  }
  self.isWaitingSearchResult = false
  self.isWaitingSearchTweenStop = false
end

function UIChatViewPrivateList_v2:DataDestroy()
  self.normalTypeSaveData = nil
  self.searchTypeSaveData = nil
  self.isWaitingSearchResult = nil
  self.isWaitingSearchTweenStop = nil
end

function UIChatViewPrivateList_v2:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self.privateItemList[loopListViewItem]
  if script ~= nil then
    script:SetActive(false)
  end
end

function UIChatViewPrivateList_v2:GetItemNameSequence()
  NameCount = NameCount + 1
  return tostring(NameCount)
end

function UIChatViewPrivateList_v2:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.itemDatas then
    return nil
  end
  local ShowInfo = self.itemDatas[index]
  local item
  if ShowInfo.isResearch == true then
    item = loopScroll:NewListViewItem("itemSearchObj")
  else
    item = loopScroll:NewListViewItem("itemTemplate_TMP")
  end
  if not item then
    return
  end
  local script = self.privateItemList[item]
  if script then
    script:SetActive(true)
  else
    local targetScript
    if ShowInfo.isResearch == true then
      targetScript = UIChatViewSearchObjItem_v2
    else
      targetScript = UIPrivateRoomItem
    end
    script = self.itemContent:GetComponent(item.gameObject.name, targetScript)
    if script == nil then
      local objectName = self:GetItemNameSequence()
      item.gameObject.name = objectName
      script = self.itemContent:AddComponent(targetScript, item.gameObject)
    end
    script:SetActive(true)
    self.privateItemList[item] = script
  end
  if ShowInfo.isResearch == true then
    local needFindNum = 0
    if self.normalTypeSaveData and self.normalTypeSaveData.rooms then
      needFindNum = #self.normalTypeSaveData.rooms
    end
    script:UpdateItem(ShowInfo, function()
      self:SetNormalTypeShow()
    end, function()
      self:SetSearchTypeShow()
    end, needFindNum)
  else
    script:UpdateItem(ShowInfo)
  end
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search and 1 < index and index == #self.itemDatas then
    DataCenter.ChatPrivateSearchDataManager:TryCreateMoreRoomData()
  end
  return item
end

function UIChatViewPrivateList_v2:OnDragEnd()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal or viewShowType == ChatPrivateListShowType.BatchDel then
    if ChatManager2:GetInstance().Room:GetIsNewPrivateList() then
      local containerTrans = self.scrollRooms.unity_looplistview2.ContainerTrans
      if containerTrans.localPosition.y > containerTrans.rect.size.y - self.scrollRooms.rectTransform.rect.size.y then
        ChatInterface.getRoomMgr():GetNewPrivateList(#self.itemDatas)
      end
    end
  elseif viewShowType == ChatPrivateListShowType.Search then
    local containerTrans = self.scrollRooms.unity_looplistview2.ContainerTrans
    if containerTrans.localPosition.y > containerTrans.rect.size.y - self.scrollRooms.rectTransform.rect.size.y then
      DataCenter.ChatPrivateSearchDataManager:TryCreateMoreRoomData()
    end
  end
end

function UIChatViewPrivateList_v2:ComponentDestroy()
  self.scrollRooms.unity_looplistview2.mOnEndDragAction = nil
  self.scrollRooms:RemoveComponents(UIPrivateRoomItem)
  self.scrollRooms:RemoveComponents(UIChatViewSearchObjItem_v2)
  self:ClearCompsByBook(compBook)
end

function UIChatViewPrivateList_v2:RefreshScrollView()
  self.scrollRooms:SetListItemCount(#self.itemDatas, false, false)
  self.scrollRooms:RefreshAllShownItem()
end

function UIChatViewPrivateList_v2:StopWaitMsgTween()
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
end

function UIChatViewPrivateList_v2:Update100MS()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search and self.isWaitingSearchTweenStop and self.isWaitingSearchResult == false then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local minTime = DataCenter.ChatPrivateSearchDataManager:GetWaitTweenMinTime()
    if curTime > minTime then
      self.isWaitingSearchTweenStop = false
      self:RefreshShowContent()
    end
  end
end

function UIChatViewPrivateList_v2:UpdateList(roomSet)
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  self.normalTypeSaveData = roomSet
  if viewShowType == ChatPrivateListShowType.Normal or viewShowType == ChatPrivateListShowType.BatchDel then
    self:RefreshShowContent()
  elseif viewShowType == ChatPrivateListShowType.Search then
    local isReset = DataCenter.ChatPrivateSearchDataManager:TryReGetRoomDataForReInit()
    if isReset then
      local searchTxt = DataCenter.ChatPrivateSearchDataManager.sendSearchTxt
      DataCenter.ChatPrivateSearchDataManager:OnSearchStart(searchTxt)
      SFSNetwork.SendMessage(MsgDefines.SearchChatRoomV3, searchTxt, 0)
    end
    self.searchTypeSaveData = {
      rooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
    }
    self:RefreshShowContent()
  end
end

function UIChatViewPrivateList_v2:SetNormalTypeShow()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
    return
  end
  DataCenter.ChatPrivateDataManager:OnToNormalType()
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
end

function UIChatViewPrivateList_v2:SetSearchTypeShow()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    return
  end
  DataCenter.ChatPrivateDataManager:OnToSearchType()
  self.searchTypeSaveData = {
    rooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  }
  self.isWaitingSearchResult = false
  self.isWaitingSearchTweenStop = false
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
end

function UIChatViewPrivateList_v2:OnChatPrivateSearchResultMsgBack()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType ~= ChatPrivateListShowType.Search then
    return
  end
  self.searchTypeSaveData = {
    rooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  }
  self.isWaitingSearchResult = false
  self:RefreshShowContent(true)
end

function UIChatViewPrivateList_v2:OnChatPrivateSearchViewRefresh()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType ~= ChatPrivateListShowType.Search then
    return
  end
  self.searchTypeSaveData = {
    rooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  }
  self.isWaitingSearchResult = true
  self.isWaitingSearchTweenStop = true
  self:RefreshShowContent(true)
end

function UIChatViewPrivateList_v2:PrivateChatShowChange()
  self:RefreshShowContent(true)
end

function UIChatViewPrivateList_v2:RefreshShowContent()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
    local roomSet = self.normalTypeSaveData
    self.itemDatas = {}
    local stickyList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
    local stickyList2 = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_GROUPCHAT_STICKY_LIST", {})
    for _, room in ipairs(roomSet.rooms) do
      local shell = __DataShells[room.roomId]
      if not shell then
        shell = {__slideTween = nil, __slideWeight = 0}
        __DataShells[room.roomId] = shell
      end
      if room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
        shell.stickyTime = stickyList2[room.roomId] or 0
      else
        local member = room:getPrivateOtherMember()
        shell.stickyTime = stickyList[tostring(member and member.uid)] or 0
      end
      shell.room = room
      shell.parent = self
      table.insert(self.itemDatas, shell)
    end
    table.sort(self.itemDatas, __ComparePrivateRoom)
    table.insert(self.itemDatas, 1, {isResearch = true})
    self.scrollView:StopMovement()
    self:RefreshScrollView()
    for _, shell in pairs(__DataShells) do
      if not shell.room or not table.indexof(roomSet.rooms, shell.room) then
        __ClearShellState(shell)
      end
    end
    self.privateListEmptyTip:SetActive(false)
    self.waitMsgImg:SetActive(false)
  elseif viewShowType == ChatPrivateListShowType.Search then
    local roomSet = self.searchTypeSaveData
    self.itemDatas = {}
    if self.isWaitingSearchTweenStop then
      table.insert(self.itemDatas, 1, {isResearch = true})
      self.scrollView:StopMovement()
      self:RefreshScrollView()
      for _, shell in pairs(__DataShells) do
        if not shell.room or not table.indexof(roomSet.rooms, shell.room) then
          __ClearShellState(shell)
        end
      end
      self.privateListEmptyTip:SetActive(false)
      self:StopWaitMsgTween()
      self.waitMsgImg:SetActive(true)
      self.tween = self.waitMsgImg.transform:DOLocalRotate(Vector3(0, 0, -360), 1, CS.DG.Tweening.RotateMode.LocalAxisAdd):SetLoops(-1, CS.DG.Tweening.LoopType.Restart)
    else
      for _, room in ipairs(roomSet.rooms) do
        local shell = __DataShells[room.roomId]
        if not shell then
          shell = {__slideTween = nil, __slideWeight = 0}
          __DataShells[room.roomId] = shell
        end
        shell.room = room
        table.insert(self.itemDatas, shell)
      end
      table.insert(self.itemDatas, 1, {isResearch = true})
      self.scrollView:StopMovement()
      self:RefreshScrollView()
      for _, shell in pairs(__DataShells) do
        if not shell.room or not table.indexof(roomSet.rooms, shell.room) then
          __ClearShellState(shell)
        end
      end
      self.privateListEmptyTip:SetActive(#self.itemDatas <= searchItemNum)
      self:StopWaitMsgTween()
      self.waitMsgImg:SetActive(false)
    end
  elseif viewShowType == ChatPrivateListShowType.BatchDel then
    local roomSet = self.normalTypeSaveData
    self.itemDatas = {}
    local stickyList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
    local stickyList2 = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_GROUPCHAT_STICKY_LIST", {})
    for _, room in ipairs(roomSet.rooms) do
      local shell = __DataShells[room.roomId]
      if not shell then
        shell = {__slideTween = nil, __slideWeight = 0}
        __DataShells[room.roomId] = shell
      end
      shell.__slideTween = nil
      shell.__slideWeight = 0
      if room.group == ChatGroupType.GROUP_CUSTOM_GROUP then
        shell.stickyTime = stickyList2[room.roomId] or 0
      else
        local member = room:getPrivateOtherMember()
        shell.stickyTime = stickyList[tostring(member and member.uid)] or 0
      end
      shell.room = room
      shell.parent = self
      table.insert(self.itemDatas, shell)
    end
    table.sort(self.itemDatas, __ComparePrivateRoom)
    self.scrollView:StopMovement()
    self:RefreshScrollView()
    for _, shell in pairs(__DataShells) do
      if not shell.room or not table.indexof(roomSet.rooms, shell.room) then
        __ClearShellState(shell)
      end
    end
    self.privateListEmptyTip:SetActive(false)
    self.waitMsgImg:SetActive(false)
  end
end

function UIChatViewPrivateList_v2:OnItemSlideToTargetPos(shell, isSlideToTargetPos)
  if isSlideToTargetPos then
    for _, loopShell in pairs(__DataShells) do
      if loopShell ~= shell then
        if CommonUtil.IsArabicAutoMirrorOpen() then
          if loopShell.__slideWeight < 0 then
            __SlideItemBoard(loopShell, false)
          end
        elseif loopShell.__slideWeight > 0 then
          __SlideItemBoard(loopShell, false)
        end
      end
    end
  end
  __SlideItemBoard(shell, isSlideToTargetPos)
end

return UIChatViewPrivateList_v2
