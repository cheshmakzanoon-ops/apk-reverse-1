local base = UIBaseContainer
local AssistanceHistoryContent = BaseClass("AssistanceHistoryContent", base)
local AssistanceHistoryItem = require("UI.LWPlayerInfo.UILWPlayerThumbsUpHistory.Component.AssistanceHistoryItem")
local noLogTxt_path = "MiddleContent/noLogTxt"
local scrollView_path = "MiddleContent/ScrollView"
local history_item_path = "MiddleContent/HistoryItem"

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
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.history_item = self:AddComponent(UIBaseContainer, history_item_path)
  self.history_item:SetActive(false)
end

local function ComponentDestroy(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(AssistanceHistoryItem)
  self.noLogTxt = nil
  self.scrollView = nil
  self.history_item = nil
end

local function DataDefine(self)
  self.list = {}
  self.requestId = nil
end

local function DataDestroy(self)
  self.list = {}
  self.requestId = nil
end

function AssistanceHistoryContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AssistanceOwnerReceivinghistory, self.OnDataReceive)
end

function AssistanceHistoryContent:OnRemoveListener()
  self:RemoveUIListener(EventId.AssistanceOwnerReceivinghistory, self.OnDataReceive)
  base.OnRemoveListener(self)
end

function AssistanceHistoryContent:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(AssistanceHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:RefreshView(index, self.list[index])
  end
  if 20 <= index and index == #self.list then
    self:RequestMore()
  end
end

function AssistanceHistoryContent:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, AssistanceHistoryItem)
end

function AssistanceHistoryContent:RefreshView()
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

function AssistanceHistoryContent:RequestMore()
  if self.requestId and self.requestId ~= 0 and self.requestId == #self.list then
    return
  end
  self.requestId = #self.list
  SFSNetwork.SendMessage(MsgDefines.AssistanceOwnerReceivinghistory, {
    startIndex = #self.list + 1,
    endIndex = #self.list + 20
  })
end

function AssistanceHistoryContent:OnDataReceive(list)
  if list == nil or #list == 0 then
    return
  end
  table.insertto(self.list, list)
  self:RefreshView()
end

function AssistanceHistoryContent:ForceRefreshHistory(data)
  self.list = {}
  self.targetUid = data.targetUid
  self.itemId = data.itemId
  self.requestId = nil
  self:RequestMore()
end

AssistanceHistoryContent.OnCreate = OnCreate
AssistanceHistoryContent.OnDestroy = OnDestroy
AssistanceHistoryContent.OnEnable = OnEnable
AssistanceHistoryContent.OnDisable = OnDisable
AssistanceHistoryContent.ComponentDefine = ComponentDefine
AssistanceHistoryContent.ComponentDestroy = ComponentDestroy
AssistanceHistoryContent.DataDefine = DataDefine
AssistanceHistoryContent.DataDestroy = DataDestroy
return AssistanceHistoryContent
