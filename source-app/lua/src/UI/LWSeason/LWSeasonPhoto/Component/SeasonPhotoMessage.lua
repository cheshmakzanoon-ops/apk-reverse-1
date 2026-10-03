local base = UIBaseContainer
local SeasonPhotoMessage = BaseClass("SeasonPhotoMessage", base)
local SeasonPhotoMessageItem = require("UI.LWSeason.LWSeasonPhoto.Component.SeasonPhotoMessageItem")
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local text_empty_path = "ScrollView/TextEmpty"

function SeasonPhotoMessage:OnCreate()
  base.OnCreate(self)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.text_empty = self:AddComponent(UITextMeshProUGUIEx, text_empty_path)
  self.items = {}
  self.scroll_view:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.firstShow = true
end

function SeasonPhotoMessage:OnDestroy()
  self.items = {}
  self.content:RemoveComponents(SeasonPhotoMessageItem)
  self.scroll_view:ClearAllItems()
  self.scroll_view = nil
  self.content = nil
  self.dataList = nil
  self.text_empty = nil
  base.OnDestroy(self)
end

function SeasonPhotoMessage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoCommentView, self.RefreshView)
  self:AddUIListener(EventId.SeasonPhotoTranslateRefresh, self.OnTranslateRefresh)
  self:AddUIListener(EventId.SeasonPhotoCommentChange, self.SeasonPhotoCommentChange)
end

function SeasonPhotoMessage:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoCommentView, self.RefreshView)
  self:RemoveUIListener(EventId.SeasonPhotoTranslateRefresh, self.OnTranslateRefresh)
  self:RemoveUIListener(EventId.SeasonPhotoCommentChange, self.SeasonPhotoCommentChange)
  base.OnRemoveListener(self)
end

function SeasonPhotoMessage:SetPhotoInfo(season, allianceId, canEdit)
  self.season = season
  self.allianceId = allianceId
  self.canEdit = canEdit and DataCenter.SeasonPhotoManager:CanEditPhoto(self.season, self.allianceId, true, false)
  if not string.IsNullOrEmpty(allianceId) then
    SFSNetwork.SendMessage(MsgDefines.SeasonPhotoCommentView, season, allianceId)
  end
  self.EnableAnimation = true
  self:RefreshView()
end

function SeasonPhotoMessage:RefreshView()
  local data = DataCenter.SeasonPhotoManager:GetCommentData(self.season, self.allianceId)
  self.EnableAnimation = true
  if data ~= nil and table.count(data) > 0 then
    table.sort(data, function(a, b)
      return a.refreshTime > b.refreshTime
    end)
    self.dataList = data
    self.scroll_view:SetListItemCount(#data, true, false)
    self.scroll_view:RefreshAllShownItem()
    self.text_empty:SetActive(false)
  else
    self.dataList = nil
    self.content:RemoveComponents(SeasonPhotoMessageItem)
    self.scroll_view:ClearAllItems()
    self.text_empty:SetActive(true)
  end
  self.EnableAnimation = nil
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoCommentRefresh, self)
end

function SeasonPhotoMessage:ShareMessage()
  DataCenter.SeasonPhotoManager:SharePhoto(self.season, self.allianceId, true)
end

function SeasonPhotoMessage:OnItemSizeChanged(index)
  if self.dataList ~= nil and table.count(self.dataList) > 0 then
    self.scroll_view:OnItemSizeChanged(index - 1)
  end
end

function SeasonPhotoMessage:Update100MS()
  if self.firstShow == true and self.dataList then
    self:RefreshView()
    self.firstShow = false
  end
end

function SeasonPhotoMessage:TryGetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local data = dataList[index]
  local csItem = listview:NewListViewItem("SeasonPhotoMessageItem")
  local cellItem = self.items[csItem]
  if cellItem == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    cellItem = self.content:AddComponent(SeasonPhotoMessageItem, nameStr)
    self.items[csItem] = cellItem
  end
  if cellItem ~= nil then
    cellItem:ReInit(index, data, self.season, self.allianceId, self.canEdit, self)
    if self.EnableAnimation then
      cellItem:ShowFadeInEffect()
    end
  end
  return csItem
end

function SeasonPhotoMessage:OnTranslateRefresh()
  if self.dataList then
    self.scroll_view:RefreshAllShownItem()
  end
end

function SeasonPhotoMessage:SeasonPhotoCommentChange()
  if self.dataList then
    self.scroll_view:RefreshAllShownItem()
  end
end

return SeasonPhotoMessage
