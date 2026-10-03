local UIFeatureIntegratedStageItem = BaseClass("UIFeatureIntegratedStageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.iconNode = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.imgNext = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgLock = self.viewSkin:AddComponent(self, UIImage, 3)
  self.imgLockSmall = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgPass = self.viewSkin:AddComponent(self, UIImage, 5)
  self.txtName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.lockText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.lockTip = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.btnClick = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnClick:SetOnClick(function()
    self:OnClick()
  end)
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.iconNode = nil
  self.imgNext = nil
  self.imgLock = nil
  self.imgLockSmall = nil
  self.imgPass = nil
  self.txtName = nil
  self.lockText = nil
  self.lockTip = nil
  self.btnClick = nil
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.fadeTween = nil
  if self.dropTween then
    self.dropTween:Kill()
  end
  self.dropTween = nil
  self.canvasGroup = nil
  self.onClick = nil
end

local function __FadeIn(self, drop)
  if self.fadeTween then
    self.fadeTween:Kill()
  end
  self.canvasGroup.alpha = 0
  self.fadeTween = self.canvasGroup:DOFade(1, 0.5)
  if self.dropTween then
    self.dropTween:Kill()
  end
  if drop then
    self.iconNode.transform.anchoredPosition = Vector2.New(0, 50)
    self.dropTween = self.iconNode.transform:DOAnchorPosY(0, 0.25):SetDelay(0.25):SetEase(CS.DG.Tweening.Ease.InQuad)
  end
end

local function GetRegDay()
  local regTime = LuaEntry.Player.regTime
  local regZero = regTime - (regTime + UITimeManager:GetInstance().changeDeltaTime) % 86400000
  local now = UITimeManager:GetInstance():GetServerTime()
  local regDiff = now - regZero
  return regDiff / 86400000 + 1
end

local function IsRegDayEnough(self, chapterCfg)
  local regDay = GetRegDay()
  return regDay >= chapterCfg.sign_up_day
end

local function GetRemainMs(self, chapterCfg)
  local sign_up_day = chapterCfg.sign_up_day
  local regDay = GetRegDay()
  if sign_up_day <= regDay then
    return 0
  end
  local remain = Mathf.Floor(sign_up_day - regDay)
  local now = UITimeManager:GetInstance():GetServerTime()
  return 86400000 - (now + UITimeManager:GetInstance().changeDeltaTime) % 86400000 + remain * 86400000
end

local function UpdateCountdownText(self)
  local remainMs = self:GetRemainMs(self.chapterCfg)
  if remainMs <= 0 then
    self.isShowingCountdown = false
    if self.diff and self.stageId then
      self:Refresh(self.stageId, self.diff)
    end
    return
  end
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(remainMs)
  self.lockText:SetLocalText("frontline_unity_unlock_desc_03", timeStr)
  self.lockTip:SetActive(true)
end

local function GetUnlockConditionText(self, chapterCfg)
  local isForceUnlock = DataCenter.LWIntegratedStageFeatureChapterManager:IsForceUnlock(self.diff, chapterCfg)
  local isPreChapterFinish = false
  local targetConfig
  if chapterCfg.unlock_pre_chapter and chapterCfg.unlock_pre_chapter > 0 then
    targetConfig = DataCenter.LWIntegratedStageFeatureChapterManager:GetChapterCfgData(chapterCfg.unlock_pre_chapter)
    if targetConfig then
      isPreChapterFinish = DataCenter.LWIntegratedStageFeatureChapterManager:IsChapterEverFinished(targetConfig.diff, targetConfig)
    end
  end
  if targetConfig and not isPreChapterFinish and not isForceUnlock then
    local text = ""
    if targetConfig.diff == StageFeatureIntegratedDifficulty.Normal then
      text = Localization:GetString("frontline_unity_rank_01")
    elseif targetConfig.diff == StageFeatureIntegratedDifficulty.Hard then
      text = Localization:GetString("frontline_unity_rank_02")
    else
      text = Localization:GetString("frontline_unity_rank_03")
    end
    local lastStageId = targetConfig.stageIds[#targetConfig.stageIds]
    local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature)
    local stageOrder = GetTableData(tableName, lastStageId, "order") or 0
    return Localization:GetString("frontline_unity_unlock_desc_01", text, stageOrder)
  end
  local curMainLv = DataCenter.BuildManager.MainLv
  if curMainLv < chapterCfg.main_building_level then
    return Localization:GetString("frontline_unity_unlock_desc_02", chapterCfg.main_building_level)
  end
  return ""
end

local function Refresh(self, stageId, diff)
  local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
  self.txtName:SetText(tostring(order))
  local mgr = DataCenter.LWIntegratedStageFeatureChapterManager
  self.diff = diff
  self.stageId = stageId
  self:RefreshItemIcon()
  local chapterCfg = mgr:GetStageBelongsChapterCfgData(stageId)
  local isPassed = mgr:IsStageDone(diff, stageId)
  local isSkipStage = mgr:IsSkipStage(diff, stageId)
  self.chapterCfg = chapterCfg
  local chapterUnlocked = chapterCfg and mgr:IsChapterUnlocked(diff, chapterCfg.chapterSeqId) or false
  self.lockTip:SetActive(false)
  self.isShowingCountdown = false
  self.imgLockSmall:SetActive(not chapterUnlocked)
  self.txtName:SetActive(chapterUnlocked or isPassed or isSkipStage)
  if not chapterUnlocked and not isPassed and not isSkipStage then
    self.imgLock:SetActive(true)
    self.imgNext:SetActive(false)
    self.imgPass:SetActive(false)
    __FadeIn(self, false)
    if mgr:IsFirstStageOfFirstChapter(stageId) then
      if not self:IsRegDayEnough(chapterCfg) then
        self.isShowingCountdown = true
        self:UpdateCountdownText()
      else
        local conditionText = self:GetUnlockConditionText(chapterCfg)
        self.lockText:SetText(conditionText)
        self.lockTip:SetActive(true)
      end
    end
    return
  end
  local isNext = mgr:GetNextStageId(diff) == stageId
  local isResetedNext = false
  local isStageReseted = mgr:IsStageReseted(diff, stageId)
  if isStageReseted then
    local resetedChapterCfg = mgr:GetStageBelongsChapterCfgData(stageId)
    local resetedChapterNextStageId = mgr:GetResetedChapterNextStageId(diff, resetedChapterCfg)
    isResetedNext = resetedChapterNextStageId == stageId
  end
  isResetedNext = isResetedNext or isSkipStage
  self.imgNext:SetActive(isNext or isResetedNext)
  self.imgPass:SetActive(isPassed)
  local isLock = not isNext and not isPassed and not isResetedNext
  self.imgLock:SetActive(isLock)
  __FadeIn(self, isNext)
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function Update1000MS(self)
  if self.isShowingCountdown then
    self:UpdateCountdownText()
  end
end

local function RefreshItemIcon(self)
  self.imgNext:LoadSpriteAuto(StageFeatureIntegratedItemNextIcon[self.diff])
  self.imgLock:LoadSpriteAuto(StageFeatureIntegratedItemLockIcon[self.diff])
  self.imgPass:LoadSpriteAuto(StageFeatureIntegratedItemPassIcon[self.diff])
end

UIFeatureIntegratedStageItem.OnCreate = OnCreate
UIFeatureIntegratedStageItem.OnDestroy = OnDestroy
UIFeatureIntegratedStageItem.Refresh = Refresh
UIFeatureIntegratedStageItem.OnClick = OnClick
UIFeatureIntegratedStageItem.SetOnClick = SetOnClick
UIFeatureIntegratedStageItem.Update1000MS = Update1000MS
UIFeatureIntegratedStageItem.IsRegDayEnough = IsRegDayEnough
UIFeatureIntegratedStageItem.GetUnlockConditionText = GetUnlockConditionText
UIFeatureIntegratedStageItem.GetRemainMs = GetRemainMs
UIFeatureIntegratedStageItem.UpdateCountdownText = UpdateCountdownText
UIFeatureIntegratedStageItem.RefreshItemIcon = RefreshItemIcon
UIFeatureIntegratedStageItem.ComponentDefine = ComponentDefine
UIFeatureIntegratedStageItem.ComponentDestroy = ComponentDestroy
return UIFeatureIntegratedStageItem
