local base = UIBaseView
local TradeStationTitleView = BaseClass("TradeStationTitleView", base)
local TradeTitleItem = require("UI.LWSeason.LWSeasonTradeStation.TradeStationTitle.Component.TradeTitleItem")
local panelBtn_path = "panel"
local closeBtn_path = "PopUpContent/CloseBtn"
local content_path = "PopUpContent/Content/Content"
local tradeTitleItem_path = "PopUpContent/Content/Content/TradeTitleItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView(true)
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tradeTitleItem = self:AddComponent(UIBaseContainer, tradeTitleItem_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panelBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.itemObj = self.tradeTitleItem.gameObject
  self.itemObj:GameObjectCreatePool()
  self.itemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.content:RemoveComponents(TradeTitleItem)
  self.itemObj:GameObjectRecycleAll()
  self.panelBtn = nil
  self.closeBtn = nil
  self.content = nil
  self.tradeTitleItem = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeStationTitleView:RefreshView(init)
  self.content:RemoveComponents(TradeTitleItem)
  self.itemObj:GameObjectRecycleAll()
  local list = DataCenter.SeasonTradeDataManager:GetTitleList()
  if not list then
    return
  end
  local theItem, goItem
  local selfTitle = DataCenter.SeasonTradeDataManager:GetSelfTitle(init)
  for i = #list, 1, -1 do
    goItem = self.itemObj:GameObjectSpawn(self.content.transform)
    goItem.name = string.format("TradeTitleItem_%d", i)
    theItem = self.content:AddComponent(TradeTitleItem, goItem.name)
    theItem:ReInit(i, list[i], selfTitle)
    goItem:SetActive(true)
  end
end

function TradeStationTitleView:GetNewUserInfoSucc()
end

TradeStationTitleView.OnCreate = OnCreate
TradeStationTitleView.OnDestroy = OnDestroy
TradeStationTitleView.OnEnable = OnEnable
TradeStationTitleView.OnDisable = OnDisable
TradeStationTitleView.ComponentDefine = ComponentDefine
TradeStationTitleView.ComponentDestroy = ComponentDestroy
TradeStationTitleView.DataDefine = DataDefine
TradeStationTitleView.DataDestroy = DataDestroy
return TradeStationTitleView
