local LWUIMigrationView_PersonMarketPage = BaseClass("LWUIMigrationView_PersonMarketPage", UIBaseContainer)
local base = UIBaseContainer
local LWUIMigration_MarketItem = require("UI.LWUIMigration.Component.LWUIMigrationView_MarketItem")
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local empty_text_path = "EmptyText"

function LWUIMigrationView_PersonMarketPage:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
end

function LWUIMigrationView_PersonMarketPage:OnDestroy()
  self.content:RemoveComponents(LWUIMigration_MarketItem)
  self.scroll_view:ClearAllItems()
  self.scroll_view = nil
  self.content = nil
  self.empty_text = nil
  self.list = nil
  self.items = nil
  base.OnDestroy(self)
end

function LWUIMigrationView_PersonMarketPage:OnDisable()
  DataCenter.ActMigrationManager:UpdateMarketTime()
  base.OnDisable(self)
end

function LWUIMigrationView_PersonMarketPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationGetMarketList, self.RefreshList)
end

function LWUIMigrationView_PersonMarketPage:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationGetMarketList, self.RefreshList)
  base.OnRemoveListener(self)
end

function LWUIMigrationView_PersonMarketPage:SetData()
  self.scroll_view:SetActive(false)
  self.empty_text:SetActive(true)
  DataCenter.ActMigrationManager:ReqMarket()
end

function LWUIMigrationView_PersonMarketPage:RefreshData()
end

function LWUIMigrationView_PersonMarketPage:RefreshList(list)
  self.list = list or {}
  local cnt = #self.list
  self.scroll_view:SetActive(0 < cnt)
  self.empty_text:SetActive(cnt == 0)
  if 0 < cnt then
    self.scroll_view:SetListItemCount(cnt, false, false)
  end
end

function LWUIMigrationView_PersonMarketPage:OnGetItemByIndex(loopScroll, index)
  local cnt = self.list ~= nil and #self.list or 0
  index = index + 1
  if index < 1 or cnt < index then
    return nil
  end
  local csItem = loopScroll:NewListViewItem("LWUIMigration_MarketItem")
  local script = self.items[csItem]
  if script == nil then
    local prefabIndex = self.prefabIndex or 0
    local nameStr = "Cell" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = nameStr
    script = self.content:AddComponent(LWUIMigration_MarketItem, nameStr)
    script:SetActive(true)
    self.items[csItem] = script
  end
  script:SetData(self.list[index])
  return csItem
end

return LWUIMigrationView_PersonMarketPage
