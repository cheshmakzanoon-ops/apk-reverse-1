local base = UIBaseContainer
local LWUIBerserkBossRankRewardPreviewItemRender = BaseClass("LWUIBerserkBossRankRewardPreviewItemRender", base)
local rewardBg_path = "RewardBg"
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
  self.rewardBg = self:AddComponent(UIImage, rewardBg_path)
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
  self.rewardBg = nil
  self.topThreeIcon = nil
  self.topThreeText = nil
  self.rankText = nil
  self.rewardScrollView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, data, selfCurRank)
  self.rankRewardData = data
  if self.rankRewardData.rankLow == self.rankRewardData.rankHigh and self.rankRewardData.rankHigh <= 3 then
    self.topThreeIcon:SetActive(true)
    self.topThreeIcon:LoadSprite(string.format(LoadPath.UILWBerserkBoss, string.format("FX_wordboss_paihangbang_icon_huizhang0%s", self.rankRewardData.rankHigh)))
    self.rankText:SetText("")
    self.topThreeText:SetText(self.rankRewardData.rankHigh)
  else
    self.topThreeIcon:SetActive(false)
    self.rankText:SetText(string.format("%s-%s", self.rankRewardData.rankLow, self.rankRewardData.rankHigh))
  end
  self:ClearRewardScroll()
  local dataCount = table.count(self.rankRewardData.reward)
  if 0 < dataCount then
    self.rewardScrollView:SetTotalCount(dataCount)
    self.rewardScrollView:RefillCells()
  end
  if selfCurRank >= self.rankRewardData.rankLow and selfCurRank <= self.rankRewardData.rankHigh then
    self.rewardBg:SetColorRGBA255(250, 212, 156)
  elseif self.rankRewardData.rankLow == self.rankRewardData.rankHigh and self.rankRewardData.rankHigh == 1 then
    self.rewardBg:SetColorRGBA255(251, 221, 85)
  else
    self.rewardBg:SetColorRGBA255(241, 237, 235)
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:SetLocalScaleXYZ(0.8, 0.8, 1)
    itemRender:ReInit(self.rankRewardData.reward[index])
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UICommonResItem)
end

LWUIBerserkBossRankRewardPreviewItemRender.OnCreate = OnCreate
LWUIBerserkBossRankRewardPreviewItemRender.OnDestroy = OnDestroy
LWUIBerserkBossRankRewardPreviewItemRender.OnEnable = OnEnable
LWUIBerserkBossRankRewardPreviewItemRender.OnDisable = OnDisable
LWUIBerserkBossRankRewardPreviewItemRender.ComponentDefine = ComponentDefine
LWUIBerserkBossRankRewardPreviewItemRender.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRankRewardPreviewItemRender.DataDefine = DataDefine
LWUIBerserkBossRankRewardPreviewItemRender.DataDestroy = DataDestroy
LWUIBerserkBossRankRewardPreviewItemRender.InitData = InitData
LWUIBerserkBossRankRewardPreviewItemRender.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIBerserkBossRankRewardPreviewItemRender.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIBerserkBossRankRewardPreviewItemRender.ClearRewardScroll = ClearRewardScroll
return LWUIBerserkBossRankRewardPreviewItemRender
