local base = UIBaseContainer
local LWUIZoneMobilizationDonatedRewardPreviewItemRender = BaseClass("LWUIZoneMobilizationDonatedRewardPreviewItemRender", base)
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local desText_path = "DesText"
local rewardScrollView_path = "RewardScrollView"
local alreadyReceiveState_path = "AlreadyReceiveState"
local bg_path = "Bg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveRewardScroll()
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
  self.desText = self:AddComponent(UIText, desText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.alreadyReceiveState = self:AddComponent(UIBaseContainer, alreadyReceiveState_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.desText = nil
  self.rewardScrollView = nil
  self.alreadyReceiveState = nil
  self.bg = nil
end

local function DataDefine(self)
  self.index = 0
  self.template = nil
  self.stageRewardInfo = nil
  self.rewardShowViewDataList = {}
end

local function DataDestroy(self)
  self.index = nil
  self.template = nil
  self.stageRewardInfo = nil
  self.rewardShowViewDataList = nil
end

local function InitData(self, index, data)
  self.index = index
  self.stageRewardInfo = data
  self.template = DataCenter.LWZoneMobilizationStageTemplateManager:GetTemplate(self.stageRewardInfo.target)
  self.desText:SetLocalText("zone_mobilization_stage_end_reward", self.template.stage_show)
  local hasAlreadyReceive = self.stageRewardInfo.state == TaskState.Received
  self.alreadyReceiveState:SetActive(hasAlreadyReceive)
  if hasAlreadyReceive then
    self.bg:SetColorRGBA255(221, 242, 186, 255)
  else
    self.bg:SetColorRGBA255(241, 237, 235, 255)
  end
  self:RemoveRewardScroll()
  self.rewardShowViewDataList = self.template:GetStageRewardShowData()
  local count = table.count(self.rewardShowViewDataList)
  if 0 < count then
    self.rewardScrollView:SetTotalCount(count)
    self.rewardScrollView:RefillCells()
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(UICommonResItem, itemObj)
  if itemRender ~= nil then
    itemRender:SetLocalScaleXYZ(0.85, 0.85, 0.85)
    itemRender:ReInit(self.rewardShowViewDataList[index])
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

local function RemoveRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(UICommonResItem)
end

LWUIZoneMobilizationDonatedRewardPreviewItemRender.OnCreate = OnCreate
LWUIZoneMobilizationDonatedRewardPreviewItemRender.OnDestroy = OnDestroy
LWUIZoneMobilizationDonatedRewardPreviewItemRender.OnEnable = OnEnable
LWUIZoneMobilizationDonatedRewardPreviewItemRender.OnDisable = OnDisable
LWUIZoneMobilizationDonatedRewardPreviewItemRender.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDonatedRewardPreviewItemRender.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDonatedRewardPreviewItemRender.DataDefine = DataDefine
LWUIZoneMobilizationDonatedRewardPreviewItemRender.DataDestroy = DataDestroy
LWUIZoneMobilizationDonatedRewardPreviewItemRender.InitData = InitData
LWUIZoneMobilizationDonatedRewardPreviewItemRender.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIZoneMobilizationDonatedRewardPreviewItemRender.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIZoneMobilizationDonatedRewardPreviewItemRender.RemoveRewardScroll = RemoveRewardScroll
return LWUIZoneMobilizationDonatedRewardPreviewItemRender
