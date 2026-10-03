local UIBFDsbDuelActHistoryPanel = BaseClass("UIBFDsbDuelActHistoryPanel", UIBaseView)
local UIBFDsbDuelActHistoryItem = require("UI.BFDsbDuel.BFDsbDuelHistory.Component.UIBFDsbDuelActHistoryItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActHistoryPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActHistoryPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActHistoryPanel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.loopListView2ScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle:SetLocalText("458022")
  self.textEmpty:SetLocalText("458282")
  self.loopListView2ScrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIBFDsbDuelActHistoryPanel:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnPanel = nil
  self.loopListView2ScrollView = nil
  self.compContent = nil
  self.textEmpty = nil
  self.textTitle = nil
  self.btnClose = nil
end

function UIBFDsbDuelActHistoryPanel:DataDefine()
  self.itemList = {}
  self.historyList = {}
  self.winCount = 0
  self.loseCount = 0
  self.totalCount = 0
  self.itemIndex = 0
  self:RequestHistoryData()
end

function UIBFDsbDuelActHistoryPanel:DataDestroy()
  self.itemList = nil
  self.historyList = nil
  self.winCount = nil
  self.loseCount = nil
  self.totalCount = nil
  self.itemIndex = nil
end

function UIBFDsbDuelActHistoryPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActHistoryUpdate, self.OnHistoryDataUpdate)
end

function UIBFDsbDuelActHistoryPanel:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActHistoryUpdate, self.OnHistoryDataUpdate)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActHistoryPanel:OnHistoryDataUpdate()
  self.historyList = BattlefieldDsbDuelUtils.ActInfo:GetBattleHistoryList()
  self:RefreshUI()
end

function UIBFDsbDuelActHistoryPanel:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActHistoryPanel:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActHistoryPanel:RequestHistoryData()
  BattlefieldDsbDuelUtils.ActInfo:SendBattleHistoryListMsg()
end

function UIBFDsbDuelActHistoryPanel:RefreshUI()
  self.textEmpty:SetActive(#self.historyList == 0)
  self.loopListView2ScrollView:SetListItemCount(#self.historyList, false, false)
  self.loopListView2ScrollView:RefreshAllShownItem()
end

function UIBFDsbDuelActHistoryPanel:ClearScroll()
  self.compContent:RemoveComponents(UIBFDsbDuelActHistoryItem)
  self.loopListView2ScrollView:ClearAllItems()
  self.loopListView2ScrollView:SetListItemCount(0, false, false)
  self.loopListView2ScrollView:RefreshAllShownItem()
  self.itemList = {}
end

function UIBFDsbDuelActHistoryPanel:OnGetItemByIndex(listview, index)
  local len = #self.historyList
  local idx = index + 1
  if idx < 1 or len < idx then
    return nil
  end
  local csItem = listview:NewListViewItem("UIBFDsbDuelActHistoryItem")
  local item = self.itemList[csItem]
  if item == nil then
    local itemIndex = self.itemIndex or 0
    local nameStr = "Item" .. itemIndex
    self.itemIndex = itemIndex + 1
    csItem.gameObject.name = nameStr
    item = self.compContent:AddComponent(UIBFDsbDuelActHistoryItem, nameStr)
    self.itemList[csItem] = item
  end
  if item ~= nil then
    item:SetData(self.historyList[idx])
  end
  return csItem
end

return UIBFDsbDuelActHistoryPanel
