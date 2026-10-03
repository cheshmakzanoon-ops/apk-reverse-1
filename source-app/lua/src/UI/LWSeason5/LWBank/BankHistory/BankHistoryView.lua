local base = UIBaseView
local BankHistory = BaseClass("BankHistory", base)
local Localization = CS.GameEntry.Localization
local BankHistoryItem = require("UI.LWSeason5.LWBank.Component.BankHistoryItem")
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local lastRequestTime = 0
local panelBtn_path = "panel"
local closeBtn_path = "Root/Common_img_title/CloseBtn"
local scrollView_path = "Root/MiddleContent/ScrollView"
local content_path = "Root/MiddleContent/ScrollView/Viewport/Content"
local selectCom_path = "Root/MiddleContent/CommonSelectCom"
local noLogTxt_path = "Root/MiddleContent/noLogTxt"
local bankBtn_path = "Root/MiddleContent/bankBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.selectCom = self:AddComponent(UIBaseContainer, selectCom_path)
  self.noLogTxt = self:AddComponent(UIBaseContainer, noLogTxt_path)
  self.bankBtn = self:AddComponent(UIButton, bankBtn_path)
  self.panelBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.closeBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.selectCom = self:AddComponent(CommonSelectCom, selectCom_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.bankBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankCity)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.panelBtn = nil
  self.closeBtn = nil
  self.scrollView = nil
  self.content = nil
  self.selectCom = nil
  self.noLogTxt = nil
  self.bankBtn = nil
end

local function DataDefine(self)
  self.items = {}
  self.listDataDic = {}
  self.listData = nil
  self.selectServerId = 0
end

local function DataDestroy(self)
end

function BankHistory:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BankHistoryAdd, self.BankHistoryAdd)
end

function BankHistory:OnRemoveListener()
  self:RemoveUIListener(EventId.BankHistoryAdd, self.BankHistoryAdd)
  base.OnRemoveListener(self)
end

function BankHistory:ClearScroll()
  self.scrollView:ClearAllItems()
  self.content:RemoveComponents(BankHistoryItem)
end

function BankHistory:InitView()
  self.data = self:GetUserData()
  self._descList = {
    Localization:GetString("s5_bank_ui69"),
    Localization:GetString("s5_bank_ui70"),
    Localization:GetString("s5_bank_ui71"),
    Localization:GetString("s5_bank_ui72")
  }
  local theData = {}
  theData.isTop = false
  theData.itemList = {}
  theData.itemList[1] = {
    type = 1,
    des = self._descList[1]
  }
  theData.itemList[2] = {
    type = 2,
    des = self._descList[2]
  }
  theData.itemList[3] = {
    type = 3,
    des = self._descList[3]
  }
  theData.itemList[4] = {
    type = 4,
    des = self._descList[4]
  }
  self.selectCom:Init(theData, function(d, i)
    return self:SelectTierChange(d, i)
  end)
  self.selectCom:SetIndex(1)
  self:SelectTierChange(nil, 1)
  self.curSelect = 1
end

function BankHistory:SelectTierChange(data, index)
  if self.curSelect == index then
    return true
  end
  self.curSelect = index
  self:RefreshView()
  return true
end

function BankHistory:RefreshView()
  self.page = -1
  self.pageEnd = false
  self.showDatalist = {}
  self.dataCount = 0
  self:ClearScroll()
  self.scrollView:SetListItemCount(self.dataCount, true, true)
  self.scrollView:RefreshAllShownItem()
  self.noLogTxt:SetActive(true)
  self:RequestNextPage()
end

local __nameCount = 0

function BankHistory:TryGetScrollItem(listview, index)
  index = index + 1
  local data = self.showDatalist[index]
  if not data then
    return nil
  end
  local csItem = listview:NewListViewItem("BankHistoryItem")
  local theItem = self.items[csItem]
  if not theItem then
    __nameCount = __nameCount + 1
    csItem.name = string.format("%s_%d", "BankHistoryItem", __nameCount)
    theItem = self.content:AddComponent(BankHistoryItem, csItem.name)
    self.items[csItem] = theItem
  end
  theItem:ReInit(data, index)
  if index >= self.dataCount - 5 then
    self:RequestNextPage()
  end
  return csItem
end

function BankHistory:RequestNextPage()
  if not (not self.pageEnd and self.page) or Time.time - lastRequestTime < 0.5 then
    return
  end
  lastRequestTime = Time.time
  SFSNetwork.SendMessage(MsgDefines.LwRqUserBankLog, self.page + 1, self.curSelect)
end

function BankHistory:BankHistoryAdd(t)
  if not (t and t.pageId and t.pageSize) or not t.list then
    return
  end
  if t.logTypeCode and t.logTypeCode ~= self.curSelect then
    return
  end
  if t.pageId == self.page then
    return
  end
  self.page = t.pageId
  if #t.list < t.pageSize then
    self.pageEnd = true
  end
  local index = self.dataCount
  for i, v in ipairs(t.list) do
    index = index + 1
    self.showDatalist[index] = v
  end
  self.dataCount = index
  self.scrollView:SetListItemCount(self.dataCount, false, false)
  self.scrollView:RefreshAllShownItem()
  self:UpdateTabNames(t.typeCountInfo)
  if self.dataCount > 0 then
    self.noLogTxt:SetActive(false)
  elseif self.pageEnd then
    self.noLogTxt:SetActive(true)
  end
end

function BankHistory:UpdateTabNames(typeCountInfo)
  if table.IsNullOrEmpty(typeCountInfo) then
    return
  end
  for i, v in pairs(typeCountInfo) do
    if 0 < v and self._descList[i] then
      local newDesc = string.format("%s(%d)", self._descList[i], v)
      self.selectCom:UpdateItemDescByIndex(i, newDesc)
    end
  end
end

BankHistory.OnCreate = OnCreate
BankHistory.OnDestroy = OnDestroy
BankHistory.OnEnable = OnEnable
BankHistory.OnDisable = OnDisable
BankHistory.ComponentDefine = ComponentDefine
BankHistory.ComponentDestroy = ComponentDestroy
BankHistory.DataDefine = DataDefine
BankHistory.DataDestroy = DataDestroy
return BankHistory
