local base = UIBaseView
local GoldTreeReward = BaseClass("GoldTreeReward", base)
local Localization = CS.GameEntry.Localization
local GoldTreeRewardItem = require("UI.LWSeason.LWSeasonGoldTree.Component.GoldTreeRewardItem")
local btnBack_path = "root/btnBack"
local btnHelp_path = "root/imgTopBg/helpBtn"
local txtTitle_path = "root/imgTopBg/txtTitle"
local scroll_path = "root/content/rankScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.btnHelp = self:AddComponent(UIButton, btnHelp_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.txtTitle:SetLocalText("season_s4_golden_tree_UI_33")
  self.btnHelp:SetOnClick(function()
    local strTips = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("rank_reward_help") or ""
    if not string.IsNullOrEmpty(strTips) then
      UIUtil.ShowIntro(Localization:GetString(2000047), Localization:GetString(2000048), Localization:GetString(strTips))
    end
  end)
  self.scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnBack = nil
  self.btnHelp = nil
  self.txtTitle = nil
  self.scroll = nil
end

local function DataDefine(self)
  self:RefreshView()
end

local function DataDestroy(self)
end

function GoldTreeReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GoldTreePowerRank, self.RefreshView)
end

function GoldTreeReward:OnRemoveListener()
  self:RemoveUIListener(EventId.GoldTreePowerRank, self.RefreshView)
  base.OnRemoveListener(self)
end

function GoldTreeReward:RefreshView()
  self:ClearScroll()
  local data = DataCenter.SeasonGoldTreeManager.rankData
  self.showDatalist = data and data.rankRewardArr or {}
  if self.showDatalist and #self.showDatalist > 0 then
    self.scroll:SetTotalCount(#self.showDatalist)
    self.scroll:RefillCells()
  end
end

function GoldTreeReward:ClearScroll()
  self.scroll:RemoveComponents(GoldTreeRewardItem)
  self.scroll:ClearCells()
  self.showDatalist = {}
end

function GoldTreeReward:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll:AddComponent(GoldTreeRewardItem, itemObj)
  cellItem:SetData(self.showDatalist[index], index)
end

function GoldTreeReward:OnItemMoveOut(itemObj, index)
  self.scroll:RemoveComponent(itemObj.name, GoldTreeRewardItem)
end

GoldTreeReward.OnCreate = OnCreate
GoldTreeReward.OnDestroy = OnDestroy
GoldTreeReward.OnEnable = OnEnable
GoldTreeReward.OnDisable = OnDisable
GoldTreeReward.ComponentDefine = ComponentDefine
GoldTreeReward.ComponentDestroy = ComponentDestroy
GoldTreeReward.DataDefine = DataDefine
GoldTreeReward.DataDestroy = DataDestroy
return GoldTreeReward
