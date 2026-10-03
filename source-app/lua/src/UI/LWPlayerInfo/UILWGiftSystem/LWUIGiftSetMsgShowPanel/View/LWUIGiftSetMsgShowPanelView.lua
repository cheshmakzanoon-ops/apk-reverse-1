local base = UIBaseView
local LWUIGiftSetMsgShowPanelView = BaseClass("LWUIGiftSetMsgShowPanelView", base)
local LWUIGiftSetMsgItem = require("UI.LWPlayerInfo.UILWGiftSystem.LWUIGiftSetMsgShowPanel.Component.LWUIGiftSetMsgItem")
local closePanel_path = "panel"
local noLogTxt_path = "Root/MiddleContent/noLogTxt"
local scrollView_path = "Root/MiddleContent/ScrollView"
local closeBtn_path = "Root/Common_img_title/CloseBtn"

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
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.noLogTxt = self:AddComponent(UIText, noLogTxt_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWUIGiftSetMsgItem)
  self.closePanel = nil
end

local function DataDefine(self)
  self.list = {}
  local data = self:GetUserData() or {}
  self.targetUid = data.targetUid
  self.itemId = data.itemId
  self.showData = data.showData
  self.requestId = nil
end

local function DataDestroy(self)
  self.list = {}
  self.targetUid = nil
  self.itemId = nil
  self.requestId = nil
end

function LWUIGiftSetMsgShowPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GiftReceivingFilterMsgHistory, self.OnDataReceive)
end

function LWUIGiftSetMsgShowPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.GiftReceivingFilterMsgHistory, self.OnDataReceive)
  base.OnRemoveListener(self)
end

function LWUIGiftSetMsgShowPanelView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(LWUIGiftSetMsgItem, itemObj)
  if cellItem ~= nil then
    cellItem:RefreshView(index, self.list[index], self.showData)
  end
  if 20 <= index and index == #self.list then
    self:RequestMore()
  end
end

function LWUIGiftSetMsgShowPanelView:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, LWUIGiftSetMsgItem)
end

function LWUIGiftSetMsgShowPanelView:RefreshView()
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

function LWUIGiftSetMsgShowPanelView:RequestMore()
  if self.requestId and self.requestId ~= 0 and self.requestId == #self.list then
    return
  end
  self.requestId = #self.list
  DataCenter.GiftSystemManager:RequestReceivingHistoryById(nil, self.itemId, #self.list + 1, #self.list + 20, 1)
end

function LWUIGiftSetMsgShowPanelView:OnDataReceive(list)
  if #list == 0 then
    return
  end
  table.insertto(self.list, list)
  self:RefreshView()
end

LWUIGiftSetMsgShowPanelView.OnCreate = OnCreate
LWUIGiftSetMsgShowPanelView.OnDestroy = OnDestroy
LWUIGiftSetMsgShowPanelView.OnEnable = OnEnable
LWUIGiftSetMsgShowPanelView.OnDisable = OnDisable
LWUIGiftSetMsgShowPanelView.ComponentDefine = ComponentDefine
LWUIGiftSetMsgShowPanelView.ComponentDestroy = ComponentDestroy
LWUIGiftSetMsgShowPanelView.DataDefine = DataDefine
LWUIGiftSetMsgShowPanelView.DataDestroy = DataDestroy
return LWUIGiftSetMsgShowPanelView
