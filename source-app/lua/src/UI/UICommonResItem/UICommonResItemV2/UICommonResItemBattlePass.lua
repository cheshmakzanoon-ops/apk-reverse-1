local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemBattlePass = BaseClass("UICommonResItemBattlePass", UICommonResItemBase)
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
  self:SetItemQualityImage(DataCenter.RewardManager:GetRewardQualityBg(self.param.rewardType, self.param.itemId))
  self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
  self:SetNameText("")
end

UICommonResItemBattlePass.OnCreate = OnCreate
UICommonResItemBattlePass.OnDestroy = OnDestroy
UICommonResItemBattlePass.ComponentDefine = ComponentDefine
UICommonResItemBattlePass.ComponentDestroy = ComponentDestroy
UICommonResItemBattlePass.DataDefine = DataDefine
UICommonResItemBattlePass.DataDestroy = DataDestroy
UICommonResItemBattlePass.OnReInit = OnReInit
return UICommonResItemBattlePass
