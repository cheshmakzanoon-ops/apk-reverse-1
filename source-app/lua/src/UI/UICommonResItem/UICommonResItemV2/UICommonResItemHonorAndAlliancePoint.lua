local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemHonorAndAlliancePoint = BaseClass("UICommonResItemHonorAndAlliancePoint", UICommonResItemBase)
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
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
  self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
end

UICommonResItemHonorAndAlliancePoint.OnCreate = OnCreate
UICommonResItemHonorAndAlliancePoint.OnDestroy = OnDestroy
UICommonResItemHonorAndAlliancePoint.ComponentDefine = ComponentDefine
UICommonResItemHonorAndAlliancePoint.ComponentDestroy = ComponentDestroy
UICommonResItemHonorAndAlliancePoint.DataDefine = DataDefine
UICommonResItemHonorAndAlliancePoint.DataDestroy = DataDestroy
UICommonResItemHonorAndAlliancePoint.OnReInit = OnReInit
return UICommonResItemHonorAndAlliancePoint
