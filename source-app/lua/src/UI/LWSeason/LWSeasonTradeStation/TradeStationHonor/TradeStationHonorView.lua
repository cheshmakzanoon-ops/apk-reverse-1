local base = UIBaseView
local TradeStationHonorView = BaseClass("TradeStationHonorView", base)
local TradeStationHonorItemLine = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHonor.Component.TradeStationHonorItemLine")
local TradeStationHonorTitleItem = require("UI.LWSeason.LWSeasonTradeStation.TradeStationHonor.Component.TradeStationHonorTitleItem")
local btnBack_path = "Root/BottomBar/BtnBack"
local title_path = "Root/TopBar/TextTitle"
local btnInfo_path = "Root/TopBar/InfoBtn"
local scrollView_path = "Root/bg/ScrollView"
local content_path = "Root/bg/ScrollView/Viewport/Content"
local emptyDes_path = "Root/bg/emptyDes"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.GetUserTradeHonorListMessage)
  self:RefreshView()
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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.title = self:AddComponent(UIText, title_path)
  self.btnInfo = self:AddComponent(UIButton, btnInfo_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.title:SetLocalText("season_s3_activity_1000072_desc32")
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnInfo:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.TradeStationTitle, {anim = true})
  end)
  self.scrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnBack = nil
  self.title = nil
  self.btnInfo = nil
  self.scrollView = nil
  self.content = nil
  self.emptyDes = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.dataList = {}
end

local function DataDestroy(self)
end

function TradeStationHonorView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetUserTradeHonorList, self.OnGetUserTradeHonorList)
end

function TradeStationHonorView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetUserTradeHonorList, self.OnGetUserTradeHonorList)
  base.OnRemoveListener(self)
end

function TradeStationHonorView:RefreshView()
  local count = self.dataList and #self.dataList
  if self.dataList then
    self.scrollView:SetListItemCount(count, true, false)
    self.scrollView:RefreshAllShownItem()
    self.scrollView:SetActive(true)
    self.emptyDes:SetActive(false)
  else
    self.scrollView:SetActive(false)
    self.emptyDes:SetActive(true)
  end
end

local function SortTradeLevelHonor(a, b)
  return a.level > b.level
end

function TradeStationHonorView:OnGetUserTradeHonorList(userTradeLevelHonorArr)
  self.dataList = {}
  local index = 1
  for i, v in ipairs(userTradeLevelHonorArr) do
    local empty = table.IsNullOrEmpty(v.userTradeHonorArr)
    self.dataList[index] = {
      level = v.level,
      empty = empty,
      isTitle = true
    }
    index = index + 1
    if not empty then
      local list, indexLine = {}, 1
      self.dataList[index] = list
      index = index + 1
      for j, vv in ipairs(v.userTradeHonorArr) do
        if 3 < indexLine then
          list, indexLine = {}, 1
          self.dataList[index] = list
          index = index + 1
        end
        list[indexLine] = vv
        indexLine = indexLine + 1
      end
    end
  end
  self:RefreshView()
end

function TradeStationHonorView:ClearScroll()
  self.content:RemoveComponents(TradeStationHonorItemLine)
  self.content:RemoveComponents(TradeStationHonorTitleItem)
  self.scrollView:ClearAllItems()
end

function TradeStationHonorView:GetScrollItem(listView, index)
  local count = table.count(self.dataList)
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local data = self.dataList[index]
  local scriptItem = TradeStationHonorItemLine
  if data.isTitle then
    scriptItem = TradeStationHonorTitleItem
  end
  local item = listView:NewListViewItem(scriptItem.__cname)
  local script = self.content:GetComponent(item.gameObject.name, scriptItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(scriptItem, objectName)
  end
  script:ReInit(data)
  script:SetActive(true)
  return item
end

TradeStationHonorView.OnCreate = OnCreate
TradeStationHonorView.OnDestroy = OnDestroy
TradeStationHonorView.OnEnable = OnEnable
TradeStationHonorView.OnDisable = OnDisable
TradeStationHonorView.ComponentDefine = ComponentDefine
TradeStationHonorView.ComponentDestroy = ComponentDestroy
TradeStationHonorView.DataDefine = DataDefine
TradeStationHonorView.DataDestroy = DataDestroy
return TradeStationHonorView
