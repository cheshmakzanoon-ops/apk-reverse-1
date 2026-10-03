local base = UIBaseContainer
local UIChatViewNoticeList = BaseClass("UIChatViewNoticeList", base)
local ChatPinAllianceNoticeItemCell = require("UI.UIChatNew.Component.ChatPinAllianceNoticeItemCell")
local itemName = "ChatPinNoticeItem"

function UIChatViewNoticeList:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self:ReInit()
end

function UIChatViewNoticeList:OnDestroy()
  self.noticeDataList = nil
  self.curBuildIndex = nil
  self.slot = nil
  self.noticelList = nil
  self.ScrollContent:RemoveComponents(ChatPinAllianceNoticeItemCell)
  self.ScrollLoopListView:ClearAllItems()
  base.OnDestroy(self)
end

function UIChatViewNoticeList:OnEnable()
  base.OnEnable(self)
end

function UIChatViewNoticeList:OnDisable()
  base.OnDisable(self)
end

function UIChatViewNoticeList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatAlNoticeShowTypeChange, self.AlNoticeShowChange)
  self:AddUIListener(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET, self.AlNoticeShowChange)
end

function UIChatViewNoticeList:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatAlNoticeShowTypeChange, self.AlNoticeShowChange)
  self:RemoveUIListener(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET, self.AlNoticeShowChange)
  base.OnRemoveListener(self)
end

function UIChatViewNoticeList:InitData()
  self.curBuildIndex = nil
  self.noticeDataList = {}
  self.slot = nil
  self.showType = ChatAlNoticeShowType.Normal
  self.itemIndex = 0
  self.ScrollContent = self:AddComponent(UIBaseContainer, "Viewport/Content")
  self.ScrollLoopListView = self:AddComponent(UILoopListView2, "")
  self.ScrollLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

function UIChatViewNoticeList:ReInit()
  self.showType = DataCenter.ChatVieweDataManager:GetAlNoticeShowType()
  local room = self.view:GetSelectedRoom()
  local isPinned = false
  if room and room.category == ChatRoomCategory.ALLIANCE and room.group == "notice" then
    isPinned = room.noticeTab == 2
    self.noticeDataList = self.view.ctrl:GetNoticeDataList(isPinned)
    if self.noticeDataList and #self.noticeDataList >= 0 then
      self.ScrollLoopListView:SetListItemCount(#self.noticeDataList, false, false)
      self.ScrollLoopListView:RefreshAllShownItem()
      self.ScrollLoopListView:MovePanelToItemIndex(0, 0)
    end
  end
end

function UIChatViewNoticeList:OnGetItemByIndex(listView, index)
  if index < 0 or index >= #self.noticeDataList then
    return nil
  end
  index = index + 1
  local item = listView:NewListViewItem(itemName)
  if item == nil then
    Logger.LogError("\232\161\168\230\131\133\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 ChatPinNoticeItem")
    return
  end
  local script = self.ScrollContent:GetComponent(item.gameObject.name, ChatPinAllianceNoticeItemCell)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.ScrollContent:AddComponent(ChatPinAllianceNoticeItemCell, objectName)
  end
  script:SetActive(true)
  script:SetType(NoticeItemType.NoticeList)
  script:ReInit(self.noticeDataList[index], false, true)
  script:SetLoopScrollData(self.ScrollLoopListView, index)
  script:SetShowType(self.showType)
  return item
end

function UIChatViewNoticeList:AlNoticeShowChange()
  self.showType = DataCenter.ChatVieweDataManager:GetAlNoticeShowType()
  self.ScrollLoopListView:RefreshAllShownItem()
end

return UIChatViewNoticeList
