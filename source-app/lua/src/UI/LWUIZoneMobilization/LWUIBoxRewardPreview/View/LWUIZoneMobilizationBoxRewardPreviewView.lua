local base = UIBaseView
local LWUIZoneMobilizationBoxRewardPreviewView = BaseClass("LWUIZoneMobilizationBoxRewardPreviewView", base)
local LWUIZoneMobilizationBoxRewardPreviewItemRender = require("UI.LWUIZoneMobilization.LWUIBoxRewardPreview.Component.LWUIZoneMobilizationBoxRewardPreviewItemRender")
local ParamData = {
  position = Vector2.zero,
  arrowDeltaY = 0,
  showRewardList = {}
}
LWUIZoneMobilizationBoxRewardPreviewView.ParamDataClass = DataClass("ParamDataClass", ParamData)
local content_path = "Content"
local tipsText_path = "Content/TipsText"
local rewardScrollView_path = "Content/RewardScrollView"
local panelBtn_path = "Panel"
local imgArrow_path = "ImgArrow"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
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
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.imgArrow = self:AddComponent(UIBaseContainer, imgArrow_path)
  self.tipsText:SetLocalText("zone_mobilization_stage_reward_title")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.content = nil
  self.tipsText = nil
  self.rewardScrollView = nil
  self.panelBtn = nil
  self.imgArrow = nil
end

local function DataDefine(self)
  self.panelParam = nil
end

local function DataDestroy(self)
  self.panelParam = nil
end

local function InitData(self)
  self.panelParam = self:GetUserData()
  local contentDeltaY = -6
  local contentDeltaX = 10
  local arrowPosX = self.panelParam.position.x
  local arrowPosY = self.panelParam.position.y + self.panelParam.arrowDeltaY
  self.imgArrow:SetPositionXYZ(arrowPosX, arrowPosY)
  local uiContainerRect = UIManager:GetInstance():GetUIContainerRect()
  local parentWidth = uiContainerRect.sizeDelta.x
  local halfParentSizeW = parentWidth / 2
  local halfContentSizeW = self.content:GetSizeDelta().x / 2
  local maxX = halfParentSizeW - halfContentSizeW
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentAnchorX = anchoredPosition.x
  local contentAnchorY = anchoredPosition.y + contentDeltaY
  if maxX <= anchoredPosition.x then
    contentAnchorX = maxX - contentDeltaX
  elseif anchoredPosition.x <= -maxX then
    contentAnchorX = -maxX + contentDeltaX
  end
  self.content:SetAnchoredPositionXY(contentAnchorX, contentAnchorY)
  self:ClearRewardScroll()
  local rewardCount = table.count(self.panelParam.showRewardList)
  if 0 < rewardCount then
    self.rewardScrollView:SetTotalCount(rewardCount)
    self.rewardScrollView:RefillCells()
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(LWUIZoneMobilizationBoxRewardPreviewItemRender, itemObj)
  if itemRender ~= nil then
    itemRender:InitData(self.panelParam.showRewardList[index])
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, LWUIZoneMobilizationBoxRewardPreviewItemRender)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(LWUIZoneMobilizationBoxRewardPreviewItemRender)
end

LWUIZoneMobilizationBoxRewardPreviewView.OnCreate = OnCreate
LWUIZoneMobilizationBoxRewardPreviewView.OnDestroy = OnDestroy
LWUIZoneMobilizationBoxRewardPreviewView.OnEnable = OnEnable
LWUIZoneMobilizationBoxRewardPreviewView.OnDisable = OnDisable
LWUIZoneMobilizationBoxRewardPreviewView.ComponentDefine = ComponentDefine
LWUIZoneMobilizationBoxRewardPreviewView.ComponentDestroy = ComponentDestroy
LWUIZoneMobilizationBoxRewardPreviewView.DataDefine = DataDefine
LWUIZoneMobilizationBoxRewardPreviewView.DataDestroy = DataDestroy
LWUIZoneMobilizationBoxRewardPreviewView.InitData = InitData
LWUIZoneMobilizationBoxRewardPreviewView.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIZoneMobilizationBoxRewardPreviewView.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIZoneMobilizationBoxRewardPreviewView.ClearRewardScroll = ClearRewardScroll
return LWUIZoneMobilizationBoxRewardPreviewView
