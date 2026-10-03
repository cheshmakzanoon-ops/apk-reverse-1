local base = UIBaseView
local UIStageFeatureIntegratedView = BaseClass("UIStageFeatureIntegratedView", base)
local Localization = CS.GameEntry.Localization
local UIStageFeatureChapterItem = require("UI.UIStageFeatureIntegrated.Component.UIFeatureIntegratedStageItem")
local UIStageFeatureChapterInfoTip = require("UI.UIStageFeatureIntegrated.Component.UIStageFeatureIntegratedInfoTip")
local UIStageFeatureDifficultyTab = require("UI.UIStageFeatureIntegrated.Component.UIFeatureIntegratedDifficultyTab")
local FIRST_ENTER_GUIDE_ID = 5801
local HARD_UNLOCK_GUIDE_ID = 5810
local HARD_UNLOCK_GUIDE_ID_2 = 5811
local NIGHTMARE_UNLOCK_GUIDE_ID = 5820
local NIGHTMARE_UNLOCK_GUIDE_ID_2 = 5821
local FIRST_CHAPTER_FINISH_GUIDE_ID = 5830

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.chapterCfg = nil
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.txtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.itemStage1 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 3)
  self.itemStage2 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 4)
  self.itemStage3 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 5)
  self.itemStage4 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 6)
  self.itemStage5 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 7)
  self.itemStage6 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 8)
  self.itemStage7 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 9)
  self.itemStage8 = self.viewSkin:AddComponent(self, UIStageFeatureChapterItem, 10)
  self.btnNext = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnNext:SetOnClick(function()
    self:OnBtnNextClick()
  end)
  self.btnPrev = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPrev:SetOnClick(function()
    self:OnBtnPrevClick()
  end)
  self.btnTipMask = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnTipMask:SetOnClick(function()
    self:OnBtnTipMaskClick()
  end)
  self.tipStageInfo = self.viewSkin:AddComponent(self, UIStageFeatureChapterInfoTip, 14)
  self.resetBtn = self.viewSkin:AddComponent(self, UIButton, 15)
  self.resetBtn:SetOnClick(function()
    self:OnResetBtnClick()
  end)
  self.resetlabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.helpInfoBtn = self.viewSkin:AddComponent(self, UIButton, 17)
  self.helpInfoBtn:SetOnClick(function()
    self:OnHelpInfoBtnClick()
  end)
  self.difficultyTabNormal = self.viewSkin:AddComponent(self, UIStageFeatureDifficultyTab, 18)
  self.difficultyTabHard = self.viewSkin:AddComponent(self, UIStageFeatureDifficultyTab, 19)
  self.difficultyTabNightmare = self.viewSkin:AddComponent(self, UIStageFeatureDifficultyTab, 20)
  self.btnTipMask:SetActive(false)
  self.tipStageInfo:SetActive(false)
  
  function self.tipStageInfo.onClickEnter(stageId)
    self:OnClickEnterStage(stageId)
  end
  
  self.resetBtn:SetActive(false)
  self.difficultyTabNormal:SetDifficulty(StageFeatureIntegratedDifficulty.Normal)
  self.difficultyTabHard:SetDifficulty(StageFeatureIntegratedDifficulty.Hard)
  self.difficultyTabNightmare:SetDifficulty(StageFeatureIntegratedDifficulty.Nightmare)
  self.difficultyTabNormal:SetOnClick(function()
    self:OnClickTab(StageFeatureIntegratedDifficulty.Normal)
  end)
  self.difficultyTabHard:SetOnClick(function()
    self:OnClickTab(StageFeatureIntegratedDifficulty.Hard)
  end)
  self.difficultyTabNightmare:SetOnClick(function()
    self:OnClickTab(StageFeatureIntegratedDifficulty.Nightmare)
  end)
end

local function ComponentDestroy(self)
  self.viewSkin = nil
  self.imgBg = nil
  self.txtTitle = nil
  self.itemStage1 = nil
  self.itemStage2 = nil
  self.itemStage3 = nil
  self.itemStage4 = nil
  self.itemStage5 = nil
  self.itemStage6 = nil
  self.itemStage7 = nil
  self.itemStage8 = nil
  self.btnNext = nil
  self.btnPrev = nil
  self.btnTipMask = nil
  self.tipStageInfo = nil
  self.resetBtn = nil
  self.resetlabel = nil
  self.helpInfoBtn = nil
  self.difficultyTabNormal = nil
  self.difficultyTabHard = nil
  self.difficultyTabNightmare = nil
end

local function ReInit(self, params)
  local targetDiff, targetChapterCfg
  local lastPlayConfigId = DataCenter.LWIntegratedStageFeatureChapterManager:GetCurPlayChapterId()
  if lastPlayConfigId then
    targetChapterCfg = DataCenter.LWIntegratedStageFeatureChapterManager:GetChapterCfgData(lastPlayConfigId)
    if targetChapterCfg then
      targetDiff = targetChapterCfg.diff
    end
  end
  if not targetDiff then
    local priorityDiffs = {
      1,
      2,
      3
    }
    for _, diff in ipairs(priorityDiffs) do
      local diffData = DataCenter.LWIntegratedStageFeatureChapterManager.difficultyData[diff]
      if diffData and diffData.nextStageId then
        targetDiff = diff
        targetChapterCfg = DataCenter.LWIntegratedStageFeatureChapterManager:GetStageBelongsChapterCfgData(diffData.nextStageId)
        if targetChapterCfg then
          break
        end
      end
    end
  end
  if not targetDiff then
    targetDiff = 1
    local chapterList = DataCenter.LWIntegratedStageFeatureChapterManager.chapterCfgs[targetDiff]
    if chapterList and 0 < #chapterList then
      targetChapterCfg = chapterList[1]
    end
  end
  self.currentDiff = targetDiff
  self.chapterCfg = targetChapterCfg
  self.difficultyTabNormal:SetSelect(self.currentDiff == StageFeatureIntegratedDifficulty.Normal)
  self.difficultyTabHard:SetSelect(self.currentDiff == StageFeatureIntegratedDifficulty.Hard)
  self.difficultyTabNightmare:SetSelect(self.currentDiff == StageFeatureIntegratedDifficulty.Nightmare)
  self:Refresh(self.chapterCfg)
  self:CheckNeedFirstEnterGuide()
  self:CheckNeedShowUnlockGuide()
end

function UIStageFeatureIntegratedView:OnInfoBtnClick()
  local param = {}
  param.title = "457004"
  param.activityRulesStr = Localization:GetString("special_stage_tips_01")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UIStageFeatureIntegratedView:OnResetBtnClick()
  local todayResetTimes = DataCenter.LWIntegratedStageFeatureChapterManager:GetTodayResetTimes()
  if 0 < todayResetTimes then
    UIUtil.ShowMessage(Localization:GetString("breakthough_button_05"), 2, "breakthough_button_04", "breakthough_button_03", function()
      self:ResetCurShowdChapterStages()
    end, nil, nil)
  else
    UIUtil.ShowTipsId("breakthough_tips_05")
  end
end

function UIStageFeatureIntegratedView:ResetCurShowdChapterStages()
  if not self.chapterCfg then
    return
  end
  DataCenter.LWIntegratedStageFeatureChapterManager:ResetTargetChapterStages(self.currentDiff, self.chapterCfg.id)
end

local function OnBtnNextClick(self)
  local diff = self.currentDiff
  local nextSeqId = self.chapterCfg.chapterSeqId + 1
  local nextChapterCfg = DataCenter.LWIntegratedStageFeatureChapterManager:GetChapterCfgBySeq(diff, nextSeqId)
  if nextChapterCfg then
    self:Refresh(nextChapterCfg)
    DataCenter.LWIntegratedStageFeatureChapterManager:SetCurPlayChapterId(nil)
  else
    UIUtil.ShowTipsId(302109)
  end
end

local function OnBtnPrevClick(self)
  local diff = self.currentDiff
  local prevSeqId = self.chapterCfg.chapterSeqId - 1
  if prevSeqId < 1 then
    return
  end
  local prevChapterCfg = DataCenter.LWIntegratedStageFeatureChapterManager:GetChapterCfgBySeq(diff, prevSeqId)
  if prevChapterCfg then
    self:Refresh(prevChapterCfg)
    DataCenter.LWIntegratedStageFeatureChapterManager:SetCurPlayChapterId(nil)
  end
end

local function OnBtnTipMaskClick(self)
  self.tipStageInfo:Hide()
  self.btnTipMask:SetActive(false)
end

local function OnClickStageItem(self, stageItem, stageId, tipStyle)
  local chapterCfg = DataCenter.LWIntegratedStageFeatureChapterManager:GetStageBelongsChapterCfgData(stageId)
  local chapterUnlocked = chapterCfg and DataCenter.LWIntegratedStageFeatureChapterManager:IsChapterUnlocked(self.currentDiff, chapterCfg.chapterSeqId) or false
  local isNext = DataCenter.LWIntegratedStageFeatureChapterManager:GetNextStageId(self.currentDiff) == stageId
  local isResetedNext = false
  local isStageReseted = DataCenter.LWIntegratedStageFeatureChapterManager:IsStageReseted(self.currentDiff, stageId)
  if isStageReseted then
    local resetedChapterCfg = chapterCfg
    local resetedChapterNextStageId = DataCenter.LWIntegratedStageFeatureChapterManager:GetResetedChapterNextStageId(self.currentDiff, resetedChapterCfg)
    isResetedNext = resetedChapterNextStageId == stageId
  end
  local isSkipStage = DataCenter.LWIntegratedStageFeatureChapterManager:IsSkipStage(self.currentDiff, stageId)
  if chapterUnlocked and isNext or isResetedNext or isSkipStage then
    self:OnClickEnterStage(stageId)
  else
  end
end

local function RefreshCurChapterStages(self, param)
  local refreshedChapterId = param and param.targetResetChapterId
  if not self.chapterCfg or self.chapterCfg.id ~= refreshedChapterId then
    return
  end
  self:Refresh(self.chapterCfg)
end

local function Refresh(self, chapterCfg)
  if not chapterCfg then
    return
  end
  self:RefreshDifficultyTab()
  if self.btnTipMask.activeSelf then
    self.tipStageInfo:Hide()
    self.btnTipMask:SetActive(false)
  end
  self.chapterCfg = chapterCfg
  local bgImgPath = LocalController:instance():getValue(TableName.LW_Integrated_Stage_Feature, chapterCfg.id, "bgImg")
  if not string.IsNullOrEmpty(bgImgPath) then
    self.imgBg:LoadSpriteAuto(bgImgPath)
  end
  local titleKey = LocalController:instance():getValue(TableName.LW_Integrated_Stage_Feature, chapterCfg.id, "title")
  self.txtTitle:SetText(Localization:GetString(titleKey, chapterCfg.chapterSeqId))
  self.btnPrev.gameObject:SetActive(self.chapterCfg.chapterSeqId > 1)
  for i = 1, 8 do
    local stageItem = self["itemStage" .. i]
    local stageId = chapterCfg.stageIds[i]
    if stageId then
      stageItem:SetActive(true)
      stageItem:Refresh(stageId, self.currentDiff)
      stageItem:SetOnClick(function()
        self:OnClickStageItem(stageItem, stageId, chapterCfg.nodeTipStyleArr[i])
      end)
      stageItem.transform.localPosition = chapterCfg.nodePosArr[i]
    else
      stageItem:SetActive(false)
    end
  end
  local isChapterFinish = DataCenter.LWIntegratedStageFeatureChapterManager:IsChapterFinsh(self.currentDiff, self.chapterCfg)
  self.resetBtn:SetActive(isChapterFinish)
  self.resetlabel:SetText(Localization:GetString("breakthough_button_01"))
  local isHelpShareOn = DataCenter.LWStageFeatureChapterManager:IsHelpShareFunctionOn()
  if isHelpShareOn and self.currentDiff > StageFeatureIntegratedDifficulty.Normal then
    self.helpInfoBtn:SetActive(true)
  else
    self.helpInfoBtn:SetActive(false)
  end
end

function UIStageFeatureIntegratedView:RefreshDifficultyTab()
  self.difficultyTabNormal:Refresh()
  self.difficultyTabHard:Refresh()
  self.difficultyTabNightmare:Refresh()
end

function UIStageFeatureIntegratedView:OnClickTab(index)
  if self.currentDiff == index then
    return
  end
  self.currentDiff = index
  self.difficultyTabNormal:SetSelect(self.currentDiff == StageFeatureIntegratedDifficulty.Normal)
  self.difficultyTabHard:SetSelect(self.currentDiff == StageFeatureIntegratedDifficulty.Hard)
  self.difficultyTabNightmare:SetSelect(self.currentDiff == StageFeatureIntegratedDifficulty.Nightmare)
  local chapterCfg = self:GetDefaultChapterForDiff(self.currentDiff)
  if chapterCfg then
    self:Refresh(chapterCfg)
  end
  self:CheckNeedHowToPlayGuide()
end

local function OnClickEnterStage(self, stageId)
  local satistify = true
  local sign_up_day = self.chapterCfg.sign_up_day
  local main_building_level = self.chapterCfg.main_building_level
  local regTime = LuaEntry.Player.regTime
  local regZero = regTime - (regTime + UITimeManager:GetInstance().changeDeltaTime) % 86400000
  local now = UITimeManager:GetInstance():GetServerTime()
  local regDiff = now - regZero
  local regDay = regDiff / 86400000 + 1
  if sign_up_day > regDay then
    local remain = Mathf.Floor(sign_up_day - regDay)
    local diff = 86400000 - (now + UITimeManager:GetInstance().changeDeltaTime) % 86400000 + remain * 86400000
    local time = UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(diff)
    local tipMsg = Localization:GetString("activity_commander_tips2", time)
    UIUtil.ShowMessage(tipMsg, 1, nil, 801037)
    return
  end
  local curLevel = DataCenter.BuildManager.MainLv
  if main_building_level > curLevel then
    local buildingNameKey = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), BuildingTypes.FUN_BUILD_MAIN, "name")
    local tipMsg = Localization:GetString(800371, Localization:GetString(buildingNameKey), tostring(main_building_level))
    UIUtil.ShowMessage(tipMsg, 2, 801037, 393010, function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end)
    return
  end
  if satistify then
    local param = {}
    param.type = PVEType.Parkour
    param.levelId = tonumber(stageId)
    param.fromChapter = true
    param.memRecord = true
    param.isIntegratedStage = true
    param.integratedStageDifficulty = self.currentDiff
    local inStageFeatureScene = DataCenter.StageFeatureSceneManager:IsInScene()
    if inStageFeatureScene then
      param.enterType = PVEEnterType.StageFeatureScene
      param.stageFeatureTabType = TrailTowerTabType.IntegratedStageFeatureChapter
      DataCenter.StageFeatureSceneManager:ExitBeforeBattle()
    end
    DataCenter.LWBattleManager:Enter(param)
    if not inStageFeatureScene then
      DataCenter.LWIntegratedStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = true
    end
    DataCenter.LWIntegratedStageFeatureChapterManager:SetCurPlayChapterId(self.chapterCfg.id)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.STAGE_FEATURE_Integrated_RESET, self.RefreshCurChapterStages)
  self:AddUIListener(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptHelpResult)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.STAGE_FEATURE_Integrated_RESET, self.RefreshCurChapterStages)
  self:RemoveUIListener(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptHelpResult)
end

function UIStageFeatureIntegratedView:OnHelpInfoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpInfo)
  PostEventLog.Track(PostEventLog.Defines.C_clickHelpInfoBtn)
end

function UIStageFeatureIntegratedView:OnAcceptHelpResult()
  self:Refresh(self.chapterCfg)
end

function UIStageFeatureIntegratedView:GetDefaultChapterForDiff(diff)
  local mgr = DataCenter.LWIntegratedStageFeatureChapterManager
  local diffData = mgr.difficultyData[diff]
  if diffData and diffData.nextStageId then
    local chapterCfg = mgr.stageIdToChapterCfg[diffData.nextStageId]
    if chapterCfg then
      return chapterCfg
    end
  end
  local chapterList = mgr.chapterCfgs[diff]
  if chapterList and 0 < #chapterList then
    return chapterList[1]
  end
  return nil
end

function UIStageFeatureIntegratedView:GetCurDifficulty()
  return self.currentDiff or StageFeatureIntegratedDifficulty.Normal
end

function UIStageFeatureIntegratedView:CheckNeedFirstEnterGuide()
  if not DataCenter.LWGuideFlowManager:ReadDone(FIRST_ENTER_GUIDE_ID) then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(FIRST_ENTER_GUIDE_ID)
  end
end

function UIStageFeatureIntegratedView:CheckNeedShowUnlockGuide()
  local mrg = DataCenter.LWIntegratedStageFeatureChapterManager
  local chapterCfg = mrg:GetChapterCfgBySeq(1, 1)
  local isFinishedFirstChapter = false
  if chapterCfg then
    isFinishedFirstChapter = mrg:IsChapterFinsh(1, chapterCfg)
  end
  if isFinishedFirstChapter and not DataCenter.LWGuideFlowManager:ReadDone(FIRST_CHAPTER_FINISH_GUIDE_ID) then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(FIRST_CHAPTER_FINISH_GUIDE_ID)
  elseif mrg:IsDifficultyUnlocked(StageFeatureIntegratedDifficulty.Hard) and not DataCenter.LWGuideFlowManager:ReadDone(HARD_UNLOCK_GUIDE_ID) then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(HARD_UNLOCK_GUIDE_ID)
  elseif mrg:IsDifficultyUnlocked(StageFeatureIntegratedDifficulty.Nightmare) and not DataCenter.LWGuideFlowManager:ReadDone(NIGHTMARE_UNLOCK_GUIDE_ID) then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(NIGHTMARE_UNLOCK_GUIDE_ID)
  end
end

function UIStageFeatureIntegratedView:CheckNeedHowToPlayGuide()
  local mrg = DataCenter.LWIntegratedStageFeatureChapterManager
  if self.currentDiff == StageFeatureIntegratedDifficulty.Hard and not DataCenter.LWGuideFlowManager:ReadDone(HARD_UNLOCK_GUIDE_ID_2) then
    if mrg:IsDifficultyUnlocked(StageFeatureIntegratedDifficulty.Hard) then
      DataCenter.LWGuideFlowManager:TryTriggerFlexibly(HARD_UNLOCK_GUIDE_ID_2)
    end
  elseif self.currentDiff == StageFeatureIntegratedDifficulty.Nightmare and not DataCenter.LWGuideFlowManager:ReadDone(NIGHTMARE_UNLOCK_GUIDE_ID_2) and mrg:IsDifficultyUnlocked(StageFeatureIntegratedDifficulty.Nightmare) then
    DataCenter.LWGuideFlowManager:TryTriggerFlexibly(NIGHTMARE_UNLOCK_GUIDE_ID_2)
  end
end

UIStageFeatureIntegratedView.OnCreate = OnCreate
UIStageFeatureIntegratedView.OnDestroy = OnDestroy
UIStageFeatureIntegratedView.ComponentDefine = ComponentDefine
UIStageFeatureIntegratedView.ComponentDestroy = ComponentDestroy
UIStageFeatureIntegratedView.OnBtnNextClick = OnBtnNextClick
UIStageFeatureIntegratedView.OnBtnPrevClick = OnBtnPrevClick
UIStageFeatureIntegratedView.OnBtnTipMaskClick = OnBtnTipMaskClick
UIStageFeatureIntegratedView.OnClickStageItem = OnClickStageItem
UIStageFeatureIntegratedView.OnClickEnterStage = OnClickEnterStage
UIStageFeatureIntegratedView.Refresh = Refresh
UIStageFeatureIntegratedView.RefreshCurChapterStages = RefreshCurChapterStages
UIStageFeatureIntegratedView.ReInit = ReInit
UIStageFeatureIntegratedView.OnAddListener = OnAddListener
UIStageFeatureIntegratedView.OnRemoveListener = OnRemoveListener
return UIStageFeatureIntegratedView
