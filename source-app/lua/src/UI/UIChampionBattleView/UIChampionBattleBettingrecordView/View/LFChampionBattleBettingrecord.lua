local LFChampionBattleBettingrecord = BaseClass("LFChampionBattleBettingrecord", UIBaseView)
local LFChampionBattleBettingrecordItem = require("UI.UIChampionBattleView.UIChampionBattleBettingrecordView.Component.LFChampionBattleBettingrecordItem")
local LFChampionBattleBettingrecordItem2 = require("UI.UIChampionBattleView.UIChampionBattleBettingrecordView.Component.LFChampionBattleBettingrecordItem2")
local LFChampionBattleBettingrecordItem3 = require("UI.UIChampionBattleView.UIChampionBattleBettingrecordView.Component.LFChampionBattleBettingrecordItem3")
local base = UIBaseView
local mask_btn_path = "maskBgBtn"
local close_btn_path = "bg/closeBtn"
local titleTxt_path = "bg/content/titleTxt"
local CheerText_path = "bg/content/Top/CheerText"
local AmountText_path = "bg/content/Top/AmountText"
local OddsText_path = "bg/content/Top/OddsText"
local TimeText_path = "bg/content/Top/TimeText"
local loopListView2_path = "bg/content/loopListView2"

local function OnRefreshData(self, msg)
  if msg == nil then
    return
  end
  self.dataList = DataCenter.ActChampionBattleManager:SwitchRecordsData(msg)
  self:ShowSuperScroll()
  self:ReloadData()
end

local function ShowSuperScroll(self)
  self.loopListView2:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

local function GetScrollItem(self, listview, index)
  if index < 0 or index >= self:GetRowCount() then
    return nil
  end
  local rewardItem
  if self.objList == nil then
    self.objList = {}
  end
  local data = self.dataList[index + 1]
  if data == nil then
    return
  end
  local item, luaTemplate
  if data.type == 1 then
    item = listview:NewListViewItem("LFChampionBattleBettingrecordItem")
    luaTemplate = LFChampionBattleBettingrecordItem
  elseif data.type == 2 then
    item = listview:NewListViewItem("LFChampionBattleBettingrecordItem2")
    luaTemplate = LFChampionBattleBettingrecordItem2
  elseif data.type == 3 then
    item = listview:NewListViewItem("LFChampionBattleBettingrecordItem3")
    luaTemplate = LFChampionBattleBettingrecordItem3
  end
  table.walk(self.objList, function(key, objItem)
    if objItem.obj ~= nil and objItem.obj == item then
      rewardItem = objItem.luaItem
    end
  end)
  if rewardItem == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    rewardItem = self._scrollviewContent:AddComponent(luaTemplate, nameStr)
    self.objList[#self.objList + 1] = {obj = item, luaItem = rewardItem}
  end
  rewardItem:SetData(data)
  return item
end

local function GetRowCount(self)
  local count = 0
  if self.dataList ~= nil then
    count = #self.dataList
  end
  return count
end

local function ReloadData(self)
  self.loopListView2:SetListItemCount(self:GetRowCount(), false)
  self.loopListView2:RefreshAllShownItem()
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.ActChampionBattleManager:SendChampionBattleBetRecordCmd()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.mask_btn = self:AddComponent(UIButton, mask_btn_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.CheerText = self:AddComponent(UIText, CheerText_path)
  self.AmountText = self:AddComponent(UIText, AmountText_path)
  self.OddsText = self:AddComponent(UIText, OddsText_path)
  self.TimeText = self:AddComponent(UIText, TimeText_path)
  self.loopListView2 = self:AddComponent(UILoopListView2, loopListView2_path)
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.objList = nil
  self.mask_btn = nil
  self.close_btn = nil
  self.titleTxt = nil
  self.CheerText = nil
  self.AmountText = nil
  self.OddsText = nil
  self.TimeText = nil
  self.loopListView2 = nil
end

local function DataDestroy(self)
  self.dataList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnWorldInputPointDown, self.OnRefreshData)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnWorldInputPointDown, self.OnRefreshData)
end

LFChampionBattleBettingrecord.OnCreate = OnCreate
LFChampionBattleBettingrecord.OnDestroy = OnDestroy
LFChampionBattleBettingrecord.ComponentDefine = ComponentDefine
LFChampionBattleBettingrecord.DataDefine = DataDefine
LFChampionBattleBettingrecord.ComponentDestroy = ComponentDestroy
LFChampionBattleBettingrecord.DataDestroy = DataDestroy
LFChampionBattleBettingrecord.OnAddListener = OnAddListener
LFChampionBattleBettingrecord.OnRemoveListener = OnRemoveListener
LFChampionBattleBettingrecord.OnRefreshData = OnRefreshData
LFChampionBattleBettingrecord.ShowSuperScroll = ShowSuperScroll
LFChampionBattleBettingrecord.GetScrollItem = GetScrollItem
LFChampionBattleBettingrecord.GetRowCount = GetRowCount
LFChampionBattleBettingrecord.ReloadData = ReloadData
return LFChampionBattleBettingrecord
