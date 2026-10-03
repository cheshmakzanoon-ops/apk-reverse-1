local UIActEpidemicRewardSheetPersonalRewardItem = BaseClass("UIActEpidemicRewardSheetPersonalRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self.rewards = nil
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
  self.textScoreName = self:AddComponent(UITextMeshProUGUIEx, "ScoreName")
  self.imgBg = self:AddComponent(UIImage, "Bg")
  self.scrollViewScrollView = self:AddComponent(UIScrollView, "ScrollView")
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.textScoreName = nil
  self.imgBg = nil
  self.scrollViewScrollView = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActEpidemicRewardSheetPersonalRewardItem:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local showId = self.rewards[index]
  local cellItem = self.scrollViewScrollView:AddComponent(UICommonResItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(showId)
  end
end

function UIActEpidemicRewardSheetPersonalRewardItem:OnItemMoveOut(itemObj, index)
  if self.scrollViewScrollView then
    self.scrollViewScrollView:RemoveComponent(itemObj.name, UICommonResItem)
  end
end

function UIActEpidemicRewardSheetPersonalRewardItem:ClearScroll()
  if self.scrollViewScrollView then
    self.scrollViewScrollView:ClearCells()
    self.scrollViewScrollView:RemoveComponents(UICommonResItem)
  end
end

local BG_MY = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_5.png"
local BG_OTHER = "Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png"

function UIActEpidemicRewardSheetPersonalRewardItem:ReInit(index, data)
  self.textScoreName:SetText(data.score or 0)
  self.rewards = DataCenter.ActMeteoriteBattleManager:GetRewardsById(data.rewardId)
  self.imgBg:LoadSprite(data.my and BG_MY or BG_OTHER)
  if 0 < #self.rewards then
    self.scrollViewScrollView:SetTotalCount(#self.rewards)
    self.scrollViewScrollView:RefillCells()
  end
end

UIActEpidemicRewardSheetPersonalRewardItem.OnCreate = OnCreate
UIActEpidemicRewardSheetPersonalRewardItem.OnDestroy = OnDestroy
UIActEpidemicRewardSheetPersonalRewardItem.OnEnable = OnEnable
UIActEpidemicRewardSheetPersonalRewardItem.OnDisable = OnDisable
UIActEpidemicRewardSheetPersonalRewardItem.ComponentDefine = ComponentDefine
UIActEpidemicRewardSheetPersonalRewardItem.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardSheetPersonalRewardItem.DataDefine = DataDefine
UIActEpidemicRewardSheetPersonalRewardItem.DataDestroy = DataDestroy
UIActEpidemicRewardSheetPersonalRewardItem.OnAddListener = OnAddListener
UIActEpidemicRewardSheetPersonalRewardItem.OnRemoveListener = OnRemoveListener
return UIActEpidemicRewardSheetPersonalRewardItem
