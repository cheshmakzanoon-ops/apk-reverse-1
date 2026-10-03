local base = UIBaseContainer
local LWUIZoneMobilizationRankRewardPreviewItemRender = BaseClass("LWUIZoneMobilizationRankRewardPreviewItemRender", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local rankBg_path = "RankBg"
local topThreeIcon_path = "TopThreeIcon"
local topThreeText_path = "TopThreeIcon/TopThreeText"
local rankText_path = "RankText"
local rewardScrollView_path = "RewardScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
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
  self.rankBg = self:AddComponent(UIImage, rankBg_path)
  self.topThreeIcon = self:AddComponent(UIImage, topThreeIcon_path)
  self.topThreeText = self:AddComponent(UIText, topThreeText_path)
  self.rankText = self:AddComponent(UIText, rankText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.rankBg = nil
  self.topThreeIcon = nil
  self.topThreeText = nil
  self.rankText = nil
  self.rewardScrollView = nil
end

local function DataDefine(self)
  self.rewardPreviewData = nil
end

local function DataDestroy(self)
  self.rewardPreviewData = nil
end

local function InitData(self, data)
  self.rewardPreviewData = data
  if self.rewardPreviewData.maxRank <= 3 then
    self.topThreeIcon:SetActive(true)
    self.topThreeText:SetText(self.rewardPreviewData.maxRank)
    self.rankText:SetActive(false)
    self.rankBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_%s.png", self.rewardPreviewData.maxRank))
    self.topThreeIcon:LoadSprite(string.format(LoadPath.LWCommonPath, string.format("FX_wordboss_paihangbang_icon_huizhang0%s", self.rewardPreviewData.maxRank)))
  else
    self.topThreeIcon:SetActive(false)
    self.rankText:SetActive(true)
    self.rankText:SetText(self.rewardPreviewData.minRank .. "-" .. self.rewardPreviewData.maxRank)
    self.rankBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self:ClearRewardScroll()
  local rewardCount = table.count(self.rewardPreviewData.rewardList)
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:SetLocalScaleXYZ(0.84, 0.84, 0.84)
    itemRender:ReInit(self.rewardPreviewData.rewardList[index])
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UICommonResItem)
end

LWUIZoneMobilizationRankRewardPreviewItemRender.OnCreate = OnCreate
LWUIZoneMobilizationRankRewardPreviewItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationRankRewardPreviewItemRender.OnEnable = OnEnable
LWUIZoneMobilizationRankRewardPreviewItemRender.OnDisable = OnDisable
LWUIZoneMobilizationRankRewardPreviewItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationRankRewardPreviewItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationRankRewardPreviewItemRender.DataDefine = DataDefine
LWUIZoneMobilizationRankRewardPreviewItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationRankRewardPreviewItemRender.InitData = InitData
LWUIZoneMobilizationRankRewardPreviewItemRender.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIZoneMobilizationRankRewardPreviewItemRender.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIZoneMobilizationRankRewardPreviewItemRender.ClearRewardScroll = ClearRewardScroll
return LWUIZoneMobilizationRankRewardPreviewItemRender
