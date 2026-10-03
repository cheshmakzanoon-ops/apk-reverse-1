local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIRewardPreviewTipView = BaseClass("UIRewardPreviewTipView", base)
local UIRewardPreviewItem = require("UI.UIRewardPreviewTip.Component.UIRewardPreviewItem")
local tipsText_path = "Root/ImgBg/Content/TipsText"
local rewardScrollView_path = "Root/ImgBg/Content/RewardScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.scoreLayout = self:AddComponent(UILayoutElement, rewardScrollView_path)
end

local function ComponentDestroy(self)
  self.tipsText = nil
  self.rewardScrollView = nil
  base.ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshShow(self)
  base.RefreshShow(self)
  self:ClearRewardScroll()
  self.tipsText:SetText(self.param.tipsText or "")
  self.scoreLayout:SetPreferredHeight(self.param.scrollHeight or 328)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bgRoot.rectTransform)
  local rewardCount = table.count(self.param.showRewardList)
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(UIRewardPreviewItem, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(self.param.showRewardList[index])
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, UIRewardPreviewItem)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UIRewardPreviewItem)
end

UIRewardPreviewTipView.OnCreate = OnCreate
UIRewardPreviewTipView.OnDestroy = OnDestroy
UIRewardPreviewTipView.OnEnable = OnEnable
UIRewardPreviewTipView.OnDisable = OnDisable
UIRewardPreviewTipView.ComponentDefine = ComponentDefine
UIRewardPreviewTipView.ComponentDestroy = ComponentDestroy
UIRewardPreviewTipView.DataDefine = DataDefine
UIRewardPreviewTipView.DataDestroy = DataDestroy
UIRewardPreviewTipView.RefreshShow = RefreshShow
UIRewardPreviewTipView.OnRewardItemMoveIn = OnRewardItemMoveIn
UIRewardPreviewTipView.OnRewardItemMoveOut = OnRewardItemMoveOut
UIRewardPreviewTipView.ClearRewardScroll = ClearRewardScroll
return UIRewardPreviewTipView
