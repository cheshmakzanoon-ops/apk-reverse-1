local UITCBoxPointRewardView = BaseClass("UITCBoxPointRewardView", UIBaseView)
local UITCBoxPointRewardStageItem = require("UI.LWUITC.UITCBoxPointReward.Component.StageItem")
local base = UIBaseView

function UITCBoxPointRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITCBoxPointRewardView:OnDestroy()
  if self.delayShow then
    self.delayShow:Stop()
    self.delayShow = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITCBoxPointRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel_btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel_btn:SetOnClick(function()
    self:OnPanel_btnClick()
  end)
  self.tip = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.stage_container = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.progress = self.viewSkin:AddComponent(self, UISlider, 4)
  self.curPoint_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.stageScrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 6)
  self.canvasGroup = self.viewSkin:AddComponent(self, UICanvasGroup, 7)
  self:SetupCustomScrollBehavior()
end

function UITCBoxPointRewardView:ComponentDestroy()
  if self.stageItems then
    for _, item in ipairs(self.stageItems) do
      self:RemoveAsyncComponent(item)
    end
  end
  self.viewSkin = nil
  self.panel_btn = nil
  self.tip = nil
  self.stage_container = nil
  self.progress = nil
  self.curPoint_txt = nil
  self.stageScrollRect = nil
  self.canvasGroup = nil
end

function UITCBoxPointRewardView:DataDefine()
  self.scoreInfo = nil
  self.scoreRewardStages = {}
  self.stageItems = {}
  self.loadedStageItemCount = 0
  self.hasScrolledToTarget = false
end

function UITCBoxPointRewardView:DataDestroy()
  self.scoreInfo = nil
  self.scoreRewardStages = {}
  self.stageItems = {}
  self.hasScrolledToTarget = false
end

function UITCBoxPointRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UITCBoxPointRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITCBoxPointRewardView:OnEnable()
  base.OnEnable(self)
  self.canvasGroup:SetShow(false)
  self:RefreshData()
end

function UITCBoxPointRewardView:RefreshData()
  self.scoreInfo = DataCenter.TacticalCardDataManager:GetScoreInfo()
  local season = DataCenter.SeasonDataManager:GetSeason()
  self.scoreRewardStages = DataCenter.TacticalCardDataManager:GetPointRewardStages(season)
  self:RefreshUI()
end

function UITCBoxPointRewardView:RefreshUI()
  local currentScore = self.scoreInfo or 0
  self.curPoint_txt:SetText(tostring(currentScore))
  self:CreateStageItems()
  self:UpdateProgress()
end

function UITCBoxPointRewardView:CreateStageItems()
  if self.stageItems then
    for _, item in ipairs(self.stageItems) do
      self:RemoveAsyncComponent(item)
    end
  end
  self.stageItems = {}
  local totalCount = #self.scoreRewardStages
  self.loadedStageItemCount = 0
  for i, stageData in ipairs(self.scoreRewardStages) do
    local stageItem = self:LoadComponentAsync(UITCBoxPointRewardStageItem, UITCBoxPointRewardStageItem.PrefabPath, self.stage_container, function(item)
      self.loadedStageItemCount = self.loadedStageItemCount + 1
      if self.loadedStageItemCount >= totalCount then
        self:OnAllStageItemsLoaded()
      end
    end)
    stageItem:SetData(stageData.goodsId or 0, stageData.goodsNum or 0, stageData.point or 0, 0)
    table.insert(self.stageItems, stageItem)
  end
  self:UpdateProgressWidth()
end

local LEFT_PADDING = 31
local ITEM_SPACING = 12
local STAGE_ITEM_GAMEOBJECT_WIDTH = 100
local LINE_WIDTH = 2

function UITCBoxPointRewardView:UpdateProgressWidth()
  local stageCount = #self.scoreRewardStages
  if stageCount <= 1 then
    self.progress:SetActive(false)
    return
  end
  self.progress:SetActive(true)
  local progressWidth = LEFT_PADDING + (stageCount - 1) * STAGE_ITEM_GAMEOBJECT_WIDTH + ITEM_SPACING * (stageCount - 1)
  if 1 <= stageCount then
    progressWidth = progressWidth + STAGE_ITEM_GAMEOBJECT_WIDTH / 2 + LINE_WIDTH / 2
  end
  self.progress:SetSizeDeltaXY(progressWidth, 27)
end

function UITCBoxPointRewardView:UpdateProgress()
  if not self.scoreInfo or #self.scoreRewardStages == 0 then
    self.progress:SetValue(0)
    return
  end
  local currentScore = self.scoreInfo or 0
  local stageCount = #self.scoreRewardStages
  local stagePositions = {}
  for i = 1, stageCount do
    local stageX = LEFT_PADDING + (i - 1) * (STAGE_ITEM_GAMEOBJECT_WIDTH + ITEM_SPACING) + STAGE_ITEM_GAMEOBJECT_WIDTH / 2
    local totalWidth = LEFT_PADDING + (stageCount - 1) * STAGE_ITEM_GAMEOBJECT_WIDTH + ITEM_SPACING * (stageCount - 1) + STAGE_ITEM_GAMEOBJECT_WIDTH / 2 + LINE_WIDTH / 2
    stagePositions[i] = stageX / totalWidth
  end
  local progressValue = 0
  for i = 1, stageCount do
    if currentScore >= self.scoreRewardStages[i].point then
      progressValue = stagePositions[i]
    else
      if 1 < i then
        do
          local prevPoint = self.scoreRewardStages[i - 1].point
          local currPoint = self.scoreRewardStages[i].point
          local ratio = (currentScore - prevPoint) / (currPoint - prevPoint)
          progressValue = stagePositions[i - 1] + ratio * (stagePositions[i] - stagePositions[i - 1])
        end
        break
      end
      do
        local ratio = currentScore / self.scoreRewardStages[i].point
        progressValue = ratio * stagePositions[i]
      end
      break
    end
  end
  self.progress:SetValue(math.max(0, math.min(1, progressValue)))
end

function UITCBoxPointRewardView:SetupCustomScrollBehavior()
  self.stageScrollRect:AddValueChangeListener(function()
    local currentPos = self.stageScrollRect:GetHorizontalNormalizedPosition()
    if CommonUtil and CommonUtil.IsArabicAutoMirrorOpen() then
      if 1 < currentPos then
        self.stageScrollRect:SetHorizontalNormalizedPosition(0)
      end
    elseif currentPos < 0 then
      self.stageScrollRect:SetHorizontalNormalizedPosition(0)
    end
  end)
end

function UITCBoxPointRewardView:OnAllStageItemsLoaded()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.stageScrollRect.transform)
  if not self.hasScrolledToTarget then
    self:ScrollToTargetStage()
    self.hasScrolledToTarget = true
  end
end

function UITCBoxPointRewardView:ScrollToTargetStage()
  local targetIndex = self:GetNextUnclaimedStageIndex()
  if 0 < targetIndex then
    self:ScrollToStageIndex(targetIndex)
  end
end

function UITCBoxPointRewardView:GetNextUnclaimedStageIndex()
  local currentScore = self.scoreInfo or 0
  for i, stageData in ipairs(self.scoreRewardStages) do
    if currentScore >= stageData.point and stageData.claimState ~= 1 then
      return i
    end
  end
  for i, stageData in ipairs(self.scoreRewardStages) do
    if currentScore < stageData.point then
      return i
    end
  end
  return #self.scoreRewardStages
end

function UITCBoxPointRewardView:ScrollToStageIndex(index)
  local stageItemsCount = #self.stageItems
  if not self.stageScrollRect or index <= 0 or index > stageItemsCount then
    return
  end
  local targetDisplayIndex = math.max(0, index - 1)
  local contentTotalWidth = LEFT_PADDING + stageItemsCount * STAGE_ITEM_GAMEOBJECT_WIDTH + ITEM_SPACING * (stageItemsCount - 1)
  local leftPadding = 0
  if 1 <= targetDisplayIndex then
    leftPadding = LEFT_PADDING
  end
  local targetItemX = leftPadding + (targetDisplayIndex - 1) * (STAGE_ITEM_GAMEOBJECT_WIDTH + ITEM_SPACING)
  local viewportWidth = self.stageScrollRect.transform.rect.width
  local scrollableWidth = math.max(0, contentTotalWidth - viewportWidth)
  local normalizedPos = 0
  if 0 < scrollableWidth then
    normalizedPos = targetItemX / scrollableWidth
    normalizedPos = math.min(normalizedPos, 1)
    normalizedPos = math.max(normalizedPos, 0)
  end
  if self.delayShow then
    self.delayShow:Stop()
    self.delayShow = nil
  end
  self.delayShow = TimerManager:GetInstance():DelayFrameInvoke(function()
    self.stageScrollRect:SetHorizontalNormalizedPosition(normalizedPos)
    self.canvasGroup:SetShow(true)
  end, 2)
end

function UITCBoxPointRewardView:OnScoreInfoChanged()
  self:RefreshData()
end

function UITCBoxPointRewardView:OnPanel_btnClick()
  self.ctrl:CloseSelf()
end

return UITCBoxPointRewardView
