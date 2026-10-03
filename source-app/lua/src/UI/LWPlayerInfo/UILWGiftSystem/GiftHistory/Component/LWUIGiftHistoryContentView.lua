local base = UIBaseContainer
local LWUIGiftHistoryContentView = BaseClass("LWUIGiftHistoryContentView", base)
local LWUIGiftHistoryItemView = require("UI.LWPlayerInfo.UILWGiftSystem.GiftHistory.Component.LWUIGiftHistoryItemView")
local noLogTxt_path = "MiddleContent/noLogTxt"
local scrollView_path = "MiddleContent/ScrollView"
local closeBtn_path = "Common_img_title/CloseBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  self:RequestMore()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.TranslateResultSaveDataManager:ClearAllDoingState(TranslateSaveDataFuncType.GiftHistory)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.noLogTxt = self:AddComponent(UIText, noLogTxt_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(BindCallback(self.view.ctrl, self.view.ctrl.CloseSelf))
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWUIGiftHistoryItemView)
  self.noLogTxt = nil
  self.scrollView = nil
  self.closeBtn = nil
end

local function DataDefine(self)
  self.list = {}
  local data = self.view:GetUserData() or {}
  self.targetUid = data.targetUid
  self.itemId = data.itemId
  self.requestId = nil
end

local function DataDestroy(self)
  self.list = {}
  self.targetUid = nil
  self.itemId = nil
  self.requestId = nil
end

function LWUIGiftHistoryContentView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GiftSystemReceivingHistory, self.OnDataReceive)
  self:AddUIListener(EventId.GiftSystemHistoryRefresh, self.ForceRefreshHistory)
end

function LWUIGiftHistoryContentView:OnRemoveListener()
  self:RemoveUIListener(EventId.GiftSystemReceivingHistory, self.OnDataReceive)
  self:RemoveUIListener(EventId.GiftSystemHistoryRefresh, self.ForceRefreshHistory)
  base.OnRemoveListener(self)
end

function LWUIGiftHistoryContentView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(LWUIGiftHistoryItemView, itemObj)
  if cellItem ~= nil then
    cellItem:RefreshView(index, self.list[index])
  end
  if 20 <= index and index == #self.list then
    self:RequestMore()
  end
end

function LWUIGiftHistoryContentView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, LWUIGiftHistoryItemView)
end

function LWUIGiftHistoryContentView:RefreshView()
  local dataCount = self.dataCount or 0
  self.dataCount = #self.list
  if self.dataCount > 0 then
    self.noLogTxt:SetActive(false)
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(self.dataCount)
    self.scrollView:RefillCells(math.max(dataCount - 5, 1), true)
  else
    self.noLogTxt:SetActive(true)
    self.scrollView:SetActive(false)
  end
end

function LWUIGiftHistoryContentView:RequestMore()
  if self.requestId and self.requestId ~= 0 and self.requestId == #self.list then
    return
  end
  self.requestId = #self.list
  DataCenter.GiftSystemManager:RequestReceivingHistoryById(self.targetUid, self.itemId, #self.list + 1, #self.list + 20)
end

function LWUIGiftHistoryContentView:OnDataReceive(list)
  if #list == 0 then
    return
  end
  table.insertto(self.list, list)
  self:RefreshView()
end

function LWUIGiftHistoryContentView:ForceRefreshHistory(data)
  self.list = {}
  self.targetUid = data.targetUid
  self.itemId = data.itemId
  self.requestId = nil
  self:RequestMore()
end

LWUIGiftHistoryContentView.OnCreate = OnCreate
LWUIGiftHistoryContentView.OnDestroy = OnDestroy
LWUIGiftHistoryContentView.OnEnable = OnEnable
LWUIGiftHistoryContentView.OnDisable = OnDisable
LWUIGiftHistoryContentView.ComponentDefine = ComponentDefine
LWUIGiftHistoryContentView.ComponentDestroy = ComponentDestroy
LWUIGiftHistoryContentView.DataDefine = DataDefine
LWUIGiftHistoryContentView.DataDestroy = DataDestroy
return LWUIGiftHistoryContentView
