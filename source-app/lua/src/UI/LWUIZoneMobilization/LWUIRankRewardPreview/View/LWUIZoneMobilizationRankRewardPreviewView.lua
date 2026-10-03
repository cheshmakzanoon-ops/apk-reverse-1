local base = UIBaseView
local LWUIZoneMobilizationRankRewardPreviewView = BaseClass("LWUIZoneMobilizationRankRewardPreviewView", base)
local LWUIZoneMobilizationRankRewardPreviewTabItemRender = require("UI.LWUIZoneMobilization.LWUIRankRewardPreview.Component.LWUIZoneMobilizationRankRewardPreviewTabItemRender")
local LWUIZoneMobilizationRankRewardPreviewItemRender = require("UI.LWUIZoneMobilization.LWUIRankRewardPreview.Component.LWUIZoneMobilizationRankRewardPreviewItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local tabScrollView_path = "PopUpContent/TabScrollView"
local rewardScrollView_path = "PopUpContent/RewardScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
  self:ClearTabScroll()
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
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.tabScrollView = self:AddComponent(UIScrollView, tabScrollView_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.titleText:SetLocalText("zone_mobilization_alliance_rank_reward_title")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnTabItemMoveIn(itemObj, index)
  end)
  self.tabScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnTabItemMoveOut(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.tabScrollView = nil
  self.rewardScrollView = nil
end

local function DataDefine(self)
  self.curRankType = ZoneMobilizationRankType.Donated
  self.tabViewDataList = {
    {
      tabType = ZoneMobilizationRankType.Donated,
      tabName = "zone_mobilization_donate_rank_reward_title"
    },
    {
      tabType = ZoneMobilizationRankType.Damage,
      tabName = "zone_mobilization_damage_rank_reward_title"
    }
  }
  self.tabViewItemRenderDict = {}
  self.showRewardList = {}
end

local function DataDestroy(self)
  self.curRankType = nil
  self.tabViewDataList = nil
  self.tabViewItemRenderDict = nil
  self.showRewardList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetZoneMobilizationRankRewardPreviewData, self.OnGetRankRewardPreviewData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetZoneMobilizationRankRewardPreviewData, self.OnGetRankRewardPreviewData)
  base.OnRemoveListener(self)
end

local function OnGetRankRewardPreviewData(self)
  self:RefreshCurRankTypeRewardView()
end

local function InitData(self)
  self.curRankType = self:GetUserData()
  SFSNetwork.SendMessage(MsgDefines.ZoneMobilizationRankRewardPreview)
  local tabCount = table.count(self.tabViewDataList)
  if 0 < tabCount then
    self.tabScrollView:SetTotalCount(tabCount)
    self.tabScrollView:RefillCells()
  end
  self:RefreshCurRankTypeRewardView()
end

local function RefreshCurRankTypeRewardView(self)
  self:ClearRewardScroll()
  self.showRewardList = DataCenter.LWZoneMobilizationManager:GetRankRewardPreviewDataByType(self.curRankType)
  local rewardCount = table.count(self.showRewardList)
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
end

local function OnTabItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.tabScrollView:AddComponent(LWUIZoneMobilizationRankRewardPreviewTabItemRender, itemObj)
  if itemRender ~= nil then
    local tableData = self.tabViewDataList[index]
    itemRender:InitData(tableData, self.curRankType)
    self.tabViewItemRenderDict[tableData.tabType] = itemRender
  end
end

local function OnTabItemMoveOut(self, itemObj, index)
  self.tabScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationRankRewardPreviewTabItemRender)
end

local function ClearTabScroll(self)
  self.tabScrollView:ClearCells()
  self.tabScrollView:RemoveComponents(LWUIZoneMobilizationRankRewardPreviewTabItemRender)
  self.tabViewItemRenderDict = {}
end

local function OnTabItemClick(self, newRankType)
  if self.curRankType == newRankType then
    return
  end
  if self.tabViewItemRenderDict[self.curRankType] ~= nil then
    self.tabViewItemRenderDict[self.curRankType]:SetSelectState(false)
  end
  self.curRankType = newRankType
  if self.tabViewItemRenderDict[newRankType] ~= nil then
    self.tabViewItemRenderDict[newRankType]:SetSelectState(true)
  end
  self:RefreshCurRankTypeRewardView()
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(LWUIZoneMobilizationRankRewardPreviewItemRender, itemObj)
  if itemRender ~= nil then
    local rewardData = self.showRewardList[index]
    itemRender:InitData(rewardData)
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationRankRewardPreviewItemRender)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(LWUIZoneMobilizationRankRewardPreviewItemRender)
end

LWUIZoneMobilizationRankRewardPreviewView.OnCreate = OnCreate
LWUIZoneMobilizationRankRewardPreviewView.OnDestroy = OnDestroy
LWUIZoneMobilizationRankRewardPreviewView.OnEnable = OnEnable
LWUIZoneMobilizationRankRewardPreviewView.OnDisable = OnDisable
LWUIZoneMobilizationRankRewardPreviewView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationRankRewardPreviewView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationRankRewardPreviewView.DataDefine = DataDefine
LWUIZoneMobilizationRankRewardPreviewView.DataDestroy = DataDestroy
LWUIZoneMobilizationRankRewardPreviewView.OnAddListener = OnAddListener
LWUIZoneMobilizationRankRewardPreviewView.OnRemoveListener = OnRemoveListener
LWUIZoneMobilizationRankRewardPreviewView.OnGetRankRewardPreviewData = OnGetRankRewardPreviewData
LWUIZoneMobilizationRankRewardPreviewView.InitData = InitData
LWUIZoneMobilizationRankRewardPreviewView.RefreshCurRankTypeRewardView = RefreshCurRankTypeRewardView
LWUIZoneMobilizationRankRewardPreviewView.OnTabItemMoveIn = OnTabItemMoveIn
LWUIZoneMobilizationRankRewardPreviewView.OnTabItemMoveOut = OnTabItemMoveOut
LWUIZoneMobilizationRankRewardPreviewView.ClearTabScroll = ClearTabScroll
LWUIZoneMobilizationRankRewardPreviewView.OnTabItemClick = OnTabItemClick
LWUIZoneMobilizationRankRewardPreviewView.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIZoneMobilizationRankRewardPreviewView.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIZoneMobilizationRankRewardPreviewView.ClearRewardScroll = ClearRewardScroll
return LWUIZoneMobilizationRankRewardPreviewView
