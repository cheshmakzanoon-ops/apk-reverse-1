local DecoUpgradeStar = BaseClass("DecoUpgradeStar", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local progress_text_path = "ProgressText"
local star_img_path = "StarImg"
local click_btn_path = "ClickBtn"
local eff_ui_decoration_star_01_path = "Eff_ui_decoration_star_01"
local eff_ui_decoration_star_02_path = "Eff_ui_decoration_star_02"
local eff_ui_decoration_star_03_path = "Eff_ui_decoration_star_03"

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
  if not IsNull(self.rectTransform) then
    self.rectTransform:Set_anchorMin(0, 0.5)
    self.rectTransform:Set_anchorMax(0, 0.5)
  end
  self.progressText = self:AddComponent(UIText, progress_text_path)
  self.starImg = self:AddComponent(UIImage, star_img_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.progress1StarUnlockObj = self:AddComponent(UIBaseContainer, eff_ui_decoration_star_01_path)
  self.progress2StarUnlockObj = self:AddComponent(UIBaseContainer, eff_ui_decoration_star_02_path)
  self.progress3StarUnlockObj = self:AddComponent(UIBaseContainer, eff_ui_decoration_star_03_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.unlockEffList = {}
  table.insert(self.unlockEffList, self.progress1StarUnlockObj)
  table.insert(self.unlockEffList, self.progress2StarUnlockObj)
  table.insert(self.unlockEffList, self.progress3StarUnlockObj)
end

local function DataDestroy(self)
  self.unlockEffList = nil
  if self.showUnlockEffTimer then
    self.showUnlockEffTimer:Stop()
    self.showUnlockEffTimer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function DecoUpgradeStar:SetData(progressData, maxProgressInfo, curProgress, progressWidth, showUnlockStarTipFun, refreshFromUpgrade)
  self.progressData = progressData
  self.maxProgressInfo = maxProgressInfo
  self.curProgress = curProgress
  self.progressWidth = progressWidth
  self.showUnlockStarTipFun = showUnlockStarTipFun
  self.curStarProgress = 0
  if self.progressData then
    self.curStarProgress = self.progressData.stage_need
  end
  self.maxProgress = 1
  if self.maxProgressInfo then
    self.maxProgress = self.maxProgressInfo.stage_need
  end
  self.isLastStar = self.curStarProgress == self.maxProgress
  self:RefreshPos()
  self:RefreshView(refreshFromUpgrade)
end

function DecoUpgradeStar:RefreshPos()
  if IsNull(self.rectTransform) then
    return
  end
  local realProgress = self.curStarProgress / self.maxProgress
  if CommonUtil.IsArabicAutoMirrorOpen() then
    realProgress = 1 - realProgress
  end
  local targetPosX = self.progressWidth * Mathf.Clamp(realProgress, 0, 1)
  self.rectTransform:Set_anchoredPosition(targetPosX, 0)
end

function DecoUpgradeStar:RefreshView(refreshFromUpgrade)
  self.progressText:SetText(self.curStarProgress)
  if not self.progressData then
    return
  end
  local isUnlock = self:IsUnlock()
  CS.UIGray.SetGray(self.starImg.transform, not isUnlock, true)
  if not string.IsNullOrEmpty(self.progressData.stage_icon) then
    self.starImg:LoadSprite(self.progressData.stage_icon)
  end
  if not self.showUnlockEffTimer then
    for _, v in ipairs(self.unlockEffList) do
      v:SetActive(false)
    end
    local isLevelUp = self.curProgress == 0 and self.isLastStar
    local isStarUnlock = self.curProgress == self.curStarProgress
    if refreshFromUpgrade and (isStarUnlock or isLevelUp) then
      local curProgressIndex = self.progressData.progressIndex
      if self.unlockEffList[curProgressIndex] ~= nil then
        self.unlockEffList[curProgressIndex]:SetActive(true)
      end
      self.showUnlockEffTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.unlockEffList[curProgressIndex]:SetActive(false)
        self.showUnlockEffTimer = nil
      end)
    end
  end
end

function DecoUpgradeStar:IsUnlock()
  return self.curProgress >= self.curStarProgress
end

function DecoUpgradeStar:OnClick()
  if not self.showUnlockStarTipFun or not self.progressData then
    return
  end
  local starScreenPos = PosConverse.UIWorldToScreenPos(self.transform.position)
  self.showUnlockStarTipFun(starScreenPos, self.progressData)
end

DecoUpgradeStar.OnCreate = OnCreate
DecoUpgradeStar.OnDestroy = OnDestroy
DecoUpgradeStar.OnEnable = OnEnable
DecoUpgradeStar.OnDisable = OnDisable
DecoUpgradeStar.ComponentDefine = ComponentDefine
DecoUpgradeStar.ComponentDestroy = ComponentDestroy
DecoUpgradeStar.DataDefine = DataDefine
DecoUpgradeStar.DataDestroy = DataDestroy
DecoUpgradeStar.OnAddListener = OnAddListener
DecoUpgradeStar.OnRemoveListener = OnRemoveListener
return DecoUpgradeStar
