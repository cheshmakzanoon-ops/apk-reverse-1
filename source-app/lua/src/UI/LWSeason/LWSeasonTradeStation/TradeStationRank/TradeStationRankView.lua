local base = UIBaseView
local TradeStationRankView = BaseClass("TradeStationRankView", base)
local LWSeasonTrendsRankItem = require("UI.LWSeason.LWSeasonTrendsRank.Component.LWSeasonTrendsRankItem")
local btnBack_path = "Root/BottomBar/BtnBack"
local title_path = "Root/TopBar/TextTitle"
local emptyDes_path = "emptyDes"
local rankDes_path = "Root/ScrollView/select/rankDes"
local nameDes_path = "Root/ScrollView/select/nameDes"
local powerDes_path = "Root/ScrollView/select/powerDes"
local scrollView_path = "Root/ScrollView"
local selfItem_path = "Root/SelfData"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceTradeRankMessage)
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
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.rankDes = self:AddComponent(UIText, rankDes_path)
  self.nameDes = self:AddComponent(UIText, nameDes_path)
  self.powerDes = self:AddComponent(UIText, powerDes_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.selfItem = self:AddComponent(UIBaseContainer, selfItem_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title:SetLocalText("season_s3_activity_1000072_desc07")
  self.rankDes:SetLocalText("302043")
  self.nameDes:SetLocalText("390288")
  self.powerDes:SetLocalText("season_s3_activity_1000072_desc08")
  self.selfItem = self:AddComponent(LWSeasonTrendsRankItem, selfItem_path)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.btnBack = nil
  self.title = nil
  self.emptyDes = nil
  self.rankDes = nil
  self.nameDes = nil
  self.powerDes = nil
  self.scrollView = nil
  self.selfItem = nil
end

local function DataDefine(self)
  self.rankList = {}
end

local function DataDestroy(self)
end

function TradeStationRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAllianceTradeRank, self.OnGetAllianceTradeRank)
end

function TradeStationRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetAllianceTradeRank, self.OnGetAllianceTradeRank)
  base.OnRemoveListener(self)
end

function TradeStationRankView:RefreshView()
  self:ClearScroll()
  local count = self.rankList and #self.rankList or 0
  if 0 < count then
    self.scrollView:SetTotalCount(count)
    self.scrollView:RefillCells()
  end
  self.emptyDes:SetActive(count <= 0)
  self:RefreshSelfContent()
end

function TradeStationRankView:OnGetAllianceTradeRank(data)
  self.rankList = data.list or {}
  self.selfData = data.selfData
  self:RefreshView()
end

function TradeStationRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(LWSeasonTrendsRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetItemShow(0, self.rankList[index], false)
  end
end

function TradeStationRankView:OnRankItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, LWSeasonTrendsRankItem)
end

function TradeStationRankView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(LWSeasonTrendsRankItem)
end

function TradeStationRankView:RefreshSelfContent()
  if not self.selfData then
    self.selfItem:SetActive(false)
    return
  end
  self.selfItem:SetItemShow(0, self.selfData, true)
  self.selfItem:SetActive(true)
end

function TradeStationRankView:OnAllianceDetailClick(serverId, allianceId, allianceName)
  UIUtil.TryShowAllianceInfo(serverId, allianceId, allianceName)
end

TradeStationRankView.OnCreate = OnCreate
TradeStationRankView.OnDestroy = OnDestroy
TradeStationRankView.OnEnable = OnEnable
TradeStationRankView.OnDisable = OnDisable
TradeStationRankView.ComponentDefine = ComponentDefine
TradeStationRankView.ComponentDestroy = ComponentDestroy
TradeStationRankView.DataDefine = DataDefine
TradeStationRankView.DataDestroy = DataDestroy
return TradeStationRankView
