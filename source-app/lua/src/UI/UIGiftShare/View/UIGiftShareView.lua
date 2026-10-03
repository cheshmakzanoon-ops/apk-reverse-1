local UIGiftShareView = BaseClass("UIGiftShareView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGiftSearchPrivateListItem = require("UI.UIGiftShare.Component.UIGiftSearchPrivateListItem")
local UIGiftShareSearchObjItem = require("UI.UIGiftShare.Component.UIGiftShareSearchObjItem")
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local common_bg_orange_path = "UICommonPopUpTitle/Common_bg_orange"
local tip_text_path = "UICommonPopUpTitle/Common_bg_orange/TipText"
local img_bg_path = "ImgBg"
local compBook = {
  {
    path = "ImgBg/listPrivate/scrollView",
    name = "scrollRooms",
    type = UILoopListView2
  },
  {
    path = "ImgBg/listPrivate/scrollView/Viewport/Content",
    name = "itemContent",
    type = UIBaseContainer,
    active = true
  },
  {
    path = "ImgBg/listPrivate/scrollView",
    name = "scrollView",
    type = UIScrollRect,
    active = true
  },
  {
    path = "ImgBg/listPrivate/privateListEmptyTip",
    name = "privateListEmptyTip",
    type = UIText,
    active = false
  },
  {
    path = "ImgBg/listPrivate/waitMsgImg",
    name = "waitMsgImg",
    type = UIBaseContainer,
    active = false
  }
}
local searchItemNum = 1
local __DataShells = {}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:DefineCompsByBook(compBook)
  self.privateItemList = {}
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(110073)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:CloseView()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:CloseView()
  end)
  self.bg_orange = self:AddComponent(UIBaseContainer, common_bg_orange_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.scrollRooms:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  
  function self.scrollRooms.unity_looplistview2.mOnEndDragAction()
    self:OnDragEnd()
  end
  
  self.img_bg = self:AddComponent(UIBaseContainer, img_bg_path)
  self.selectGiftId = self:GetUserData()
  DataCenter.ChatPrivateDataManager:SetToNormalData()
  self:UpdateList()
end

local function OnDestroy(self)
  self:DataDestroy()
  self.cacheRoomDic = nil
  self:StopWaitMsgTween()
  self.chat_data_param = nil
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.img_bg = nil
  self.scrollRooms.unity_looplistview2.mOnEndDragAction = nil
  self.scrollRooms:RemoveComponents(UIGiftSearchPrivateListItem)
  self.scrollRooms:RemoveComponents(UIGiftShareSearchObjItem)
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
end

function UIGiftShareView:DataDefine()
  self.normalTypeSaveData = {
    rooms = {}
  }
  self.searchTypeSaveData = {
    rooms = {}
  }
  self.isWaitingSearchResult = false
  self.isWaitingSearchTweenStop = false
end

function UIGiftShareView:DataDestroy()
  self.normalTypeSaveData = nil
  self.searchTypeSaveData = nil
  self.isWaitingSearchResult = nil
  self.isWaitingSearchTweenStop = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_INIT_PULL_DONE, self.OnInitMessagePullDone)
  self:AddUIListener(EventId.ChatPrivateSearchResultMsgBack, self.OnChatPrivateSearchResultMsgBack)
  self:AddUIListener(EventId.ChatPrivateSearchViewRefresh, self.OnChatPrivateSearchViewRefresh)
  self:AddUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  self:AddUIListener(EventId.Chat_GetFriendList, self.UpdateList)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.CHAT_INIT_PULL_DONE, self.OnInitMessagePullDone)
  self:RemoveUIListener(EventId.ChatPrivateSearchResultMsgBack, self.OnChatPrivateSearchResultMsgBack)
  self:RemoveUIListener(EventId.ChatPrivateSearchViewRefresh, self.OnChatPrivateSearchViewRefresh)
  self:RemoveUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  self:RemoveUIListener(EventId.Chat_GetFriendList, self.UpdateList)
  base.OnRemoveListener(self)
end

function UIGiftShareView:CloseView()
  self.ctrl:CloseSelf()
end

function UIGiftShareView:GetRoomLast(roomId)
  if not self.cacheRoomDic then
    self.cacheRoomDic = {}
  end
  if not self.cacheRoomDic[roomId] then
    self.cacheRoomDic[roomId] = true
    ChatInterface.getRoomMgr():GetRoomLast(roomId)
  end
end

function UIGiftShareView:OnInitMessagePullDone()
  self.cacheRoomDic = {}
end

function UIGiftShareView:OnRecycleItemFunc(loopListViewItem)
  if loopListViewItem == nil then
    return
  end
  local script = self.privateItemList[loopListViewItem]
  if script ~= nil then
    script:SetActive(false)
  end
end

function UIGiftShareView:GetItemNameSequence()
  NameCount = NameCount + 1
  return tostring(NameCount)
end

function UIGiftShareView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.itemDatas then
    return nil
  end
  local ShowInfo = self.itemDatas[index]
  local item
  if ShowInfo.isResearch == true then
    item = loopScroll:NewListViewItem("GiftItemSearchObj")
  else
    item = loopScroll:NewListViewItem("GiftItemRoomObj")
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
      targetScript = UIGiftShareSearchObjItem
    else
      targetScript = UIGiftSearchPrivateListItem
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

function UIGiftShareView:OnDragEnd()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
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

function UIGiftShareView:RefreshScrollView()
  self.scrollRooms:SetListItemCount(#self.itemDatas, false, false)
  self.scrollRooms:RefreshAllShownItem()
end

function UIGiftShareView:StopWaitMsgTween()
  if self.tween ~= nil then
    self.tween:Kill()
    self.tween = nil
  end
end

function UIGiftShareView:Update100MS()
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

function UIGiftShareView:UpdateList()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  self.normalTypeSaveData.rooms = ChatInterface.getRoomMgr():GetAllUnblockedPrivateRoomDatas(false)
  if viewShowType == ChatPrivateListShowType.Normal then
    self:RefreshShowContent()
  elseif viewShowType == ChatPrivateListShowType.Search then
    local isReset = DataCenter.ChatPrivateSearchDataManager:TryReGetRoomDataForReInit()
    if isReset then
      local searchTxt = DataCenter.ChatPrivateSearchDataManager.sendSearchTxt
      DataCenter.ChatPrivateSearchDataManager:OnSearchStart(searchTxt)
      SFSNetwork.SendMessage(MsgDefines.SearchChatRoomV3, searchTxt, 0)
    end
    local searchRooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
    local roomFilter = {}
    for i = 1, #searchRooms do
      local data = searchRooms[i]
      if data.group ~= ChatGroupType.GROUP_CUSTOM_GROUP then
        table.insert(roomFilter, data)
      end
    end
    self.searchTypeSaveData = {rooms = roomFilter}
    self:RefreshShowContent()
  end
end

function UIGiftShareView:SetNormalTypeShow()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
    return
  end
  DataCenter.ChatPrivateDataManager:OnToNormalType()
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
end

function UIGiftShareView:SetSearchTypeShow()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Search then
    return
  end
  DataCenter.ChatPrivateDataManager:OnToSearchType()
  local searchRooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  local roomFilter = {}
  for i = 1, #searchRooms do
    local data = searchRooms[i]
    if data.group ~= ChatGroupType.GROUP_CUSTOM_GROUP then
      table.insert(roomFilter, data)
    end
  end
  self.searchTypeSaveData = {rooms = roomFilter}
  self.isWaitingSearchResult = false
  self.isWaitingSearchTweenStop = false
  EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
end

function UIGiftShareView:OnChatPrivateSearchResultMsgBack()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType ~= ChatPrivateListShowType.Search then
    return
  end
  local searchRooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  local roomFilter = {}
  for i = 1, #searchRooms do
    local data = searchRooms[i]
    if data.group ~= ChatGroupType.GROUP_CUSTOM_GROUP then
      table.insert(roomFilter, data)
    end
  end
  self.searchTypeSaveData = {rooms = roomFilter}
  self.isWaitingSearchResult = false
  self:RefreshShowContent()
end

function UIGiftShareView:OnChatPrivateSearchViewRefresh()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType ~= ChatPrivateListShowType.Search then
    return
  end
  local searchRooms = DataCenter.ChatPrivateSearchDataManager:GetSearchResultRoomsData()
  local roomFilter = {}
  for i = 1, #searchRooms do
    local data = searchRooms[i]
    if data.group ~= ChatGroupType.GROUP_CUSTOM_GROUP then
      table.insert(roomFilter, data)
    end
  end
  self.searchTypeSaveData = {rooms = roomFilter}
  self.isWaitingSearchResult = true
  self.isWaitingSearchTweenStop = true
  self:RefreshShowContent()
end

function UIGiftShareView:PrivateChatShowChange()
  self:RefreshShowContent()
end

local function __ComparePrivateRoom(shell1, shell2)
  if shell1.stickyTime == shell2.stickyTime then
    return shell1.room.lastMsgTime > shell2.room.lastMsgTime
  end
  return shell1.stickyTime > shell2.stickyTime
end

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

function UIGiftShareView:RefreshShowContent()
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
    local roomSet = self.normalTypeSaveData
    self.itemDatas = {}
    local stickyList = CommonUtil.PlayerPrefsGetTable("PRIVATE_CHAT_STICKY_LIST", {})
    for _, room in ipairs(roomSet.rooms) do
      local shell = __DataShells[room.roomId]
      if not shell then
        shell = {__slideTween = nil, __slideWeight = 0}
        __DataShells[room.roomId] = shell
      end
      local member = room:getPrivateOtherMember()
      shell.stickyTime = stickyList[tostring(member and member.uid)] or 0
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
  end
end

UIGiftShareView.OnCreate = OnCreate
UIGiftShareView.OnDestroy = OnDestroy
UIGiftShareView.OnEnable = OnEnable
UIGiftShareView.OnDisable = OnDisable
UIGiftShareView.OnAddListener = OnAddListener
UIGiftShareView.OnRemoveListener = OnRemoveListener
return UIGiftShareView
