local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemHero = BaseClass("UICommonResItemHero", UICommonResItemBase)
local base = UICommonResItemBase

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(tonumber(self.param.rewardType), tonumber(self.param.itemId)))
end

local function OnClick(self)
  local heroId = self.param.itemId
  local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
  if not heroWindow then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId})
  end
end

UICommonResItemHero.OnCreate = OnCreate
UICommonResItemHero.OnDestroy = OnDestroy
UICommonResItemHero.ComponentDefine = ComponentDefine
UICommonResItemHero.ComponentDestroy = ComponentDestroy
UICommonResItemHero.DataDefine = DataDefine
UICommonResItemHero.DataDestroy = DataDestroy
UICommonResItemHero.OnReInit = OnReInit
UICommonResItemHero.OnClick = OnClick
return UICommonResItemHero
