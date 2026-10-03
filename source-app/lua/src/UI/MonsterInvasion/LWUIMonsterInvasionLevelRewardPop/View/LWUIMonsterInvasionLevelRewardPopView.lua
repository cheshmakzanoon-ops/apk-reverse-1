local LWUIMonsterInvasionLevelRewardPopView = BaseClass("LWUIMonsterInvasionLevelRewardPopView", UIBaseView)
local LWUIMonsterInvasionLevelRewardCell = require("UI.MonsterInvasion.LWUIMonsterInvasionLevelRewardPop.Component.LWUIMonsterInvasionLevelRewardCellComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local close_btn_path = "UICommonPopUpTitle/safearea/BtnClose"
local scroll_view_path = "rewardObj/ScrollView"
local bg_btn_path = "UICommonPopUpTitle/panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshList()
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
  self.bgBtn = self:AddComponent(UIButton, bg_btn_path)
  self.bgBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.bgBtn = nil
end

local function DataDefine(self)
  self.actId = self:GetUserData()
  self.showDatalist = {}
end

local function DataDestroy(self)
  self.showDatalist = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function LWUIMonsterInvasionLevelRewardPopView:RefreshList()
  self:ClearScroll()
  local data = DataCenter.ActivityMonsterInvasionDataManager:GetRewardListData()
  self.showDatalist = data
  if self.showDatalist ~= nil and #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  end
end

function LWUIMonsterInvasionLevelRewardPopView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LWUIMonsterInvasionLevelRewardCell, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function LWUIMonsterInvasionLevelRewardPopView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LWUIMonsterInvasionLevelRewardCell)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LWUIMonsterInvasionLevelRewardCell)
  self.showDatalist = {}
end

LWUIMonsterInvasionLevelRewardPopView.OnCreate = OnCreate
LWUIMonsterInvasionLevelRewardPopView.OnDestroy = OnDestroy
LWUIMonsterInvasionLevelRewardPopView.OnEnable = OnEnable
LWUIMonsterInvasionLevelRewardPopView.OnDisable = OnDisable
LWUIMonsterInvasionLevelRewardPopView.ComponentDefine = ComponentDefine
LWUIMonsterInvasionLevelRewardPopView.ComponentDestroy = ComponentDestroy
LWUIMonsterInvasionLevelRewardPopView.DataDefine = DataDefine
LWUIMonsterInvasionLevelRewardPopView.DataDestroy = DataDestroy
LWUIMonsterInvasionLevelRewardPopView.OnAddListener = OnAddListener
LWUIMonsterInvasionLevelRewardPopView.OnRemoveListener = OnRemoveListener
LWUIMonsterInvasionLevelRewardPopView.ClearScroll = ClearScroll
return LWUIMonsterInvasionLevelRewardPopView
