local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemVisitor = BaseClass("UICommonResItemVisitor", UICommonResItemBase)
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
  self:SetFlagActive(false)
  if self.param.itemId then
    self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
    self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
  elseif self.param.count then
    self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.count.itemId))
    self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.count.itemId))
  end
end

UICommonResItemVisitor.OnCreate = OnCreate
UICommonResItemVisitor.OnDestroy = OnDestroy
UICommonResItemVisitor.ComponentDefine = ComponentDefine
UICommonResItemVisitor.ComponentDestroy = ComponentDestroy
UICommonResItemVisitor.DataDefine = DataDefine
UICommonResItemVisitor.DataDestroy = DataDestroy
UICommonResItemVisitor.OnReInit = OnReInit
return UICommonResItemVisitor
