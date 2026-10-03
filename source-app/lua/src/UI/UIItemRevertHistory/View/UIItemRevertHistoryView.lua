local UIItemRevertHistoryView = BaseClass("UIItemRevertHistoryView", UIBaseView)
local base = UIBaseView
local UIItemRevertHistoryAuto = require("UI.UIItemRevertHistory.Auto.UIItemRevertHistoryAuto")
local UIItemRevertHistoryItemComView = require("UI.UIItemRevertHistory.Component.UIItemRevertHistoryItemComView")

function UIItemRevertHistoryView:OnCreate()
  base.OnCreate(self)
  self.binder = UIItemRevertHistoryAuto.New()
  self.binder:bind(self)
  self.itemScrollRect:AddValueChangeListener(function(vec)
    self:OnScrollValueChanged(vec)
  end)
  self.btn_panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_LW_Btn_Close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self:LoadInitialHistory()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  self.itemGridInfinityScrollView:Init(bindFunc1, bindFunc2)
  self.itemGridInfinityScrollView:SetItemCount(0)
  self.txt_textNone:SetActive(true)
end

function UIItemRevertHistoryView:LoadInitialHistory()
  self.historyRecords = {}
  self.recordIdSet = {}
  self.currentPage = 0
  self.hasMoreRecords = true
  self.itemList = {}
  self:FetchHistoryRecords(0)
end

function UIItemRevertHistoryView:FetchHistoryRecords(page)
  if self.isLoading then
    return
  end
  self.isLoading = true
  SFSNetwork.SendMessage(MsgDefines.ItemRevertMainView, page, 1)
end

function UIItemRevertHistoryView:LoadMoreHistory()
  if not self.hasMoreRecords or self.isLoading then
    return
  end
  self:FetchHistoryRecords(self.currentPage + 1)
end

function UIItemRevertHistoryView:HistoryRecordsCallback(message)
  self.isLoading = false
  local newRecords = message.revertInfos or {}
  self.currentPage = message.page or self.currentPage
  local addedCount = 0
  for _, record in ipairs(newRecords) do
    local recordId = record.id
    if not self.recordIdSet[recordId] then
      self.recordIdSet[recordId] = true
      table.insert(self.historyRecords, record)
      addedCount = addedCount + 1
    end
  end
  self.hasMoreRecords = #newRecords == 20 and 0 < addedCount
  local itemCount = #self.historyRecords
  if 0 < itemCount then
    self.itemGridInfinityScrollView:SetItemCount(itemCount)
    self.txt_textNone:SetActive(false)
  else
    self.txt_textNone:SetActive(true)
  end
end

function UIItemRevertHistoryView:OnInitScroll(go, index)
  local item = self.itemScrollRect:AddComponent(UIItemRevertHistoryItemComView, go)
  self.itemList[go] = item
end

function UIItemRevertHistoryView:OnUpdateScroll(go, index)
  local cellItem = self.itemList[go]
  cellItem:UpdateData(self.historyRecords[index + 1])
  cellItem:SetActive(true)
end

function UIItemRevertHistoryView:ClearItemCell()
  self.itemScrollRect:RemoveComponents(UIItemRevertHistoryItemComView)
  self.itemGridInfinityScrollView:DestroyChildNode()
end

function UIItemRevertHistoryView:OnScrollValueChanged(value)
  if value.y < 0.1 then
    self:LoadMoreHistory()
  end
end

function UIItemRevertHistoryView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.itemList = nil
  self.historyRecords = nil
  self:ClearItemCell()
  self.itemScrollRect = nil
  self.itemGridInfinityScrollView = nil
  base.OnDestroy(self)
end

function UIItemRevertHistoryView:OnAddListener()
  base.OnAddListener(self)
end

function UIItemRevertHistoryView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIItemRevertHistoryView
