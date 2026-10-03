local base = UIBaseContainer
local LWUIZoneMobilizationDonatedRewardPreviewContent = BaseClass("LWUIZoneMobilizationDonatedRewardPreviewContent", base)
local LWUIZoneMobilizationDonatedRewardPreviewItemRender = require("UI.LWUIZoneMobilization.LWUIDonatedRewardPreview.LWUIZoneMobilizationDonatedRewardPreviewItemRender")
local closeBubbleBtn_path = "CloseBubbleBtn"
local tipsText_path = "TipsText"
local stageRewardScrollView_path = "StageRewardScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RemoveStageRewardScroll()
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
  self.closeBubbleBtn = self:AddComponent(UIButton, closeBubbleBtn_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.stageRewardScrollView = self:AddComponent(UIScrollView, stageRewardScrollView_path)
  self.tipsText:SetLocalText("zone_mobilization_stage_reward_title")
  self.closeBubbleBtn:SetOnClick(function()
    self:SetActive(false)
  end)
  self.stageRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnStageRewardItemMoveIn(itemObj, index)
  end)
  self.stageRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnStageRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.closeBubbleBtn = nil
  self.tipsText = nil
  self.stageRewardScrollView = nil
end

local function DataDefine(self)
  self.stageRewardViewDataList = {}
end

local function DataDestroy(self)
  self.stageRewardViewDataList = nil
end

local function ShowView(self)
  self:RemoveStageRewardScroll()
  local donatedInfo = DataCenter.LWZoneMobilizationManager:GetZoneMobilizationDonatedInfoData()
  if donatedInfo then
    self.stageRewardViewDataList = donatedInfo.stageRewardList
    local count = table.count(self.stageRewardViewDataList)
    if 0 < count then
      self.stageRewardScrollView:SetTotalCount(count)
      self.stageRewardScrollView:RefillCells()
    end
  end
end

local function OnStageRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.stageRewardScrollView:AddComponent(LWUIZoneMobilizationDonatedRewardPreviewItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(index, self.stageRewardViewDataList[index])
  end
end

local function OnStageRewardItemMoveOut(self, itemObj, index)
  self.stageRewardScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationDonatedRewardPreviewItemRender)
end

local function RemoveStageRewardScroll(self)
  self.stageRewardScrollView:ClearCells()
  self.stageRewardScrollView:RemoveComponents(LWUIZoneMobilizationDonatedRewardPreviewItemRender)
end

LWUIZoneMobilizationDonatedRewardPreviewContent.OnCreate = OnCreate
LWUIZoneMobilizationDonatedRewardPreviewContent.OnDestroy = OnDestroy
LWUIZoneMobilizationDonatedRewardPreviewContent.OnEnable = OnEnable
LWUIZoneMobilizationDonatedRewardPreviewContent.OnDisable = OnDisable
LWUIZoneMobilizationDonatedRewardPreviewContent.ComponentDefine = ComponentDefine
LWUIZoneMobilizationDonatedRewardPreviewContent.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationDonatedRewardPreviewContent.DataDefine = DataDefine
LWUIZoneMobilizationDonatedRewardPreviewContent.DataDestroy = DataDestroy
LWUIZoneMobilizationDonatedRewardPreviewContent.ShowView = ShowView
LWUIZoneMobilizationDonatedRewardPreviewContent.OnStageRewardItemMoveIn = OnStageRewardItemMoveIn
LWUIZoneMobilizationDonatedRewardPreviewContent.OnStageRewardItemMoveOut = OnStageRewardItemMoveOut
LWUIZoneMobilizationDonatedRewardPreviewContent.RemoveStageRewardScroll = RemoveStageRewardScroll
return LWUIZoneMobilizationDonatedRewardPreviewContent
