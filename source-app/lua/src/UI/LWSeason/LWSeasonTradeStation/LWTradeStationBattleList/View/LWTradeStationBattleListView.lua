local base = UIBaseView
local LWTradeStationBattleListView = BaseClass("LWTradeStationBattleListView", base)
local Localization = CS.GameEntry.Localization
local TradeStationBattleDetailItem = require("UI.LWSeason.LWSeasonTradeStation.LWTradeStationBattleList.Component.TradeStationBattleDetailItem")
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")
local title_path = "PopUpTitle/Common_img_title/titleText"
local closeBtn_path = "PopUpTitle/CloseBtn"
local itemPrefab_path = "PopUpTitle/Item"
local lordObj_path = "PopUpTitle/lord"
local lordHead_path = "PopUpTitle/lord/playerParent/LordUIPlayerHead"
local lordName_path = "PopUpTitle/lord/lordName"
local endTimeDes_path = "PopUpTitle/endTimeDes"
local infoDes_path = "PopUpTitle/infoDes"
local maskBtn_path = "panel"
local scrollView_1_path = "PopUpTitle/ScrollView_1"
local scrollContent_path = "PopUpTitle/ScrollView_1/Viewport/Content"
local scrollViewY1 = 630
local scrollViewY2 = 820
local NameCount = 0
local coutndownStr = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.data = self:GetUserData()
  self:Refresh()
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
  self.title = self:AddComponent(UIText, title_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.itemPrefab = self:AddComponent(TradeStationBattleDetailItem, itemPrefab_path)
  self.lordObj = self:AddComponent(UIBaseContainer, lordObj_path)
  self.lordHead = self:AddComponent(UIBaseContainer, lordHead_path)
  self.lordName = self:AddComponent(UIText, lordName_path)
  self.endTimeDes = self:AddComponent(UIText, endTimeDes_path)
  self.infoDes = self:AddComponent(UIText, infoDes_path)
  self.maskBtn = self:AddComponent(UIButton, maskBtn_path)
  self.scrollView_1 = self:AddComponent(UILoopListView2, scrollView_1_path)
  self.scrollContent = self:AddComponent(UIBaseContainer, scrollContent_path)
  DataCenter.SeasonTradeDataManager:ChangeSkin(self:AddComponent(UIDynamicSkin, ""), true)
  self.lordHeadCom = self:AddComponent(UICommonHead, lordHead_path)
  coutndownStr = Localization:GetString("season_s3_trade_city029")
  self.maskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scrollView_1:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearCells()
  self.title = nil
  self.closeBtn = nil
  self.itemPrefab = nil
  self.lordObj = nil
  self.lordHead = nil
  self.lordName = nil
  self.endTimeDes = nil
  self.infoDes = nil
  self.maskBtn = nil
  self.scrollView_1 = nil
  self.scrollContent = nil
end

local function DataDefine(self)
  NameCount = 0
  self.cells = {}
end

local function DataDestroy(self)
end

function LWTradeStationBattleListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TradeStationBattleInfoChange, self.BattleDataChange)
end

function LWTradeStationBattleListView:OnRemoveListener()
  self:RemoveUIListener(EventId.TradeStationBattleInfoChange, self.BattleDataChange)
  base.OnRemoveListener(self)
end

function LWTradeStationBattleListView:BattleDataChange(data)
  if self.data and data and self.data.tradeId == data.tradeId then
    self.data = data
    self.rankList = self.data:CalcPlayerOccupyInfo()
    if self.rankList and #self.rankList > 0 then
      self.dataCount = #self.rankList
      self.scrollView_1:SetListItemCount(self.dataCount, false, false)
      self.scrollView_1:RefreshAllShownItem()
    end
  end
end

function LWTradeStationBattleListView:Refresh()
  if self.data then
    self.endTime = self.data.battleEndTime / 1000
    self.lordObj:SetActive(self.data:HasLord())
    if self.data:HasLord() then
      self.lordHeadCom:SetHeadAndFrame(self.data.uid, self.data.pic, self.data.picVer, false, self.data.headSkinId, self.data.headSkinET)
      local strUser = UIUtil.FormatServerAllianceName(self.data.serverId, self.data.alAbbr, self.data.lordName)
      self.lordName:SetText(Localization:GetString("season_s3_trade_city028") .. strUser)
    else
    end
    self:RefreshRankList()
    self:Update1000MS()
    self.infoDes:SetLocalText("season_s3_tradingpost_ui_inf001")
  else
    self.endTime = nil
    self.lordObj:SetActive(false)
    self.endTimeDes:SetText("")
    self.infoDes:SetLocalText("")
  end
end

function LWTradeStationBattleListView:Update1000MS()
  if self.endTime and self.endTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      self.endTimeDes:SetText(coutndownStr .. UITimeManager:GetInstance():SecondToFmtString(deltaTime))
    else
      self.endTimeDes:SetText(coutndownStr .. "00:00:00")
    end
  end
  self.rankList = self.data:CalcPlayerOccupyInfo()
  if self.rankList and 0 < #self.rankList then
    self.dataCount = #self.rankList
    self.scrollView_1:SetListItemCount(self.dataCount, false, false)
    self.scrollView_1:RefreshAllShownItem()
  end
end

function LWTradeStationBattleListView:RefreshRankList()
  self.rankList = self.data:CalcPlayerOccupyInfo()
  if self.rankList and #self.rankList > 0 then
    self.dataCount = #self.rankList
    self.scrollView_1:SetListItemCount(self.dataCount, false, false)
    self.scrollView_1:RefreshAllShownItem()
  end
end

function LWTradeStationBattleListView:TryGetScrollItem(listview, index)
  local dataList = self.rankList
  index = index + 1
  if index < 1 or dataList == nil or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("Item")
  local item = self.cells[csItem]
  if item == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. tostring(NameCount)
    csItem.gameObject.name = nameStr
    item = self.scrollContent:AddComponent(TradeStationBattleDetailItem, nameStr)
    self.cells[csItem] = item
  end
  if item ~= nil then
    item:ReInit(index, self.rankList[index], self.data.maxPoint)
  end
  return csItem
end

function LWTradeStationBattleListView:ClearCells()
  self.scrollContent:RemoveComponents(TradeStationBattleDetailItem)
  self.scrollView_1:ClearAllItems()
  self.cells = {}
end

LWTradeStationBattleListView.OnCreate = OnCreate
LWTradeStationBattleListView.OnDestroy = OnDestroy
LWTradeStationBattleListView.OnEnable = OnEnable
LWTradeStationBattleListView.OnDisable = OnDisable
LWTradeStationBattleListView.ComponentDefine = ComponentDefine
LWTradeStationBattleListView.ComponentDestroy = ComponentDestroy
LWTradeStationBattleListView.DataDefine = DataDefine
LWTradeStationBattleListView.DataDestroy = DataDestroy
return LWTradeStationBattleListView
