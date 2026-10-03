local AfterPunchaseRewardItem = BaseClass("AfterPunchaseRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local commonResItem_path = "UICommonResItem"
local obj_path = ""
local blackBg_path = "BlackBg"

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
  self.obj = self:AddComponent(UIBaseContainer, obj_path)
  self.resItem = self:AddComponent(UICommonResItem, commonResItem_path)
  self.blackBg = self:AddComponent(UIImage, blackBg_path)
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.blackBg = nil
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

local function SetData(self, rewardData, isBuy)
  self.rewardData = rewardData
  self.isBuy = isBuy
  self.resItem:ReInit(self.rewardData)
  self.blackBg:SetActive(self.isBuy == true)
end

AfterPunchaseRewardItem.OnCreate = OnCreate
AfterPunchaseRewardItem.OnDestroy = OnDestroy
AfterPunchaseRewardItem.ComponentDefine = ComponentDefine
AfterPunchaseRewardItem.ComponentDestroy = ComponentDestroy
AfterPunchaseRewardItem.DataDefine = DataDefine
AfterPunchaseRewardItem.DataDestroy = DataDestroy
AfterPunchaseRewardItem.OnAddListener = OnAddListener
AfterPunchaseRewardItem.OnRemoveListener = OnRemoveListener
AfterPunchaseRewardItem.SetData = SetData
return AfterPunchaseRewardItem
