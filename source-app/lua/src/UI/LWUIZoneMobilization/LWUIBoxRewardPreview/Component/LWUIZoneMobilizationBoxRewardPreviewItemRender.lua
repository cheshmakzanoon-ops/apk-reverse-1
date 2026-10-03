local base = UIBaseContainer
local LWUIZoneMobilizationBoxRewardPreviewItemRender = BaseClass("LWUIZoneMobilizationBoxRewardPreviewItemRender", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local resObj_path = "UICommonResItem"
local itemNameText_path = "ItemNameText"
local itemNumText_path = "ItemNumText"

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
  self.resObj = self:AddComponent(UIBaseContainer, resObj_path)
  self.itemNameText = self:AddComponent(UIText, itemNameText_path)
  self.itemNumText = self:AddComponent(UIText, itemNumText_path)
  self.rewardItemRender = self:AddComponent(UICommonResItem, resObj_path)
end

local function ComponentDestroy(self)
  self.resObj = nil
  self.itemNameText = nil
  self.itemNumText = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function InitData(self, itemData)
  if not itemData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local rewardData = self.rewardItemRender:ParseInfo(itemData)
  local itemNameStr = DataCenter.RewardManager:GetNameByType(rewardData.rewardType, rewardData.itemId)
  local count = rewardData.count
  self.itemNameText:SetText(itemNameStr)
  self.itemNumText:SetText(count)
end

LWUIZoneMobilizationBoxRewardPreviewItemRender.OnCreate = OnCreate
LWUIZoneMobilizationBoxRewardPreviewItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationBoxRewardPreviewItemRender.OnEnable = OnEnable
LWUIZoneMobilizationBoxRewardPreviewItemRender.OnDisable = OnDisable
LWUIZoneMobilizationBoxRewardPreviewItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationBoxRewardPreviewItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationBoxRewardPreviewItemRender.DataDefine = DataDefine
LWUIZoneMobilizationBoxRewardPreviewItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationBoxRewardPreviewItemRender.InitData = InitData
return LWUIZoneMobilizationBoxRewardPreviewItemRender
