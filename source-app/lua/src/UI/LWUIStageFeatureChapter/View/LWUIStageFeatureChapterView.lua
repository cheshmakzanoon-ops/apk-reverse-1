local base = UIBaseView
local LWUIStageFeatureChapterView = BaseClass("LWUIStageFeatureChapterView", base)
local Localization = CS.GameEntry.Localization
local UIStageFeatureChapterItem = require("UI.LWUIStageFeatureChapter.Component.UIStageFeatureChapterItem")
local UIStageFeatureChapterInfoTip = require("UI.LWUIStageFeatureChapter.Component.UIStageFeatureChapterInfoTip")
local compBook = {
  {
    path = "mask/Bg",
    name = "imgBg",
    type = UIRawImage
  },
  {
    path = "Title",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "StageItems/StageItem1",
    name = "itemStage1",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem2",
    name = "itemStage2",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem3",
    name = "itemStage3",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem4",
    name = "itemStage4",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem5",
    name = "itemStage5",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem6",
    name = "itemStage6",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem7",
    name = "itemStage7",
    type = UIStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem8",
    name = "itemStage8",
    type = UIStageFeatureChapterItem
  },
  {
    path = "CloseBtn",
    name = "btnClose",
    type = UIButton
  },
  {
    path = "NextBtn",
    name = "btnNext",
    type = UIButton
  },
  {
    path = "PreviousBtn",
    name = "btnPrev",
    type = UIButton
  },
  {
    path = "TipMask",
    name = "btnTipMask",
    type = UIButton
  },
  {
    path = "StageInfoTip",
    name = "tipStageInfo",
    type = UIStageFeatureChapterInfoTip
  },
  {
    path = "InfoBtn",
    name = "infoBtn",
    type = UIButton
  },
  {
    path = "ResetBtn",
    name = "resetBtn",
    type = UIButton
  },
  {
    path = "ResetBtn/resetlabel",
    name = "resetlabel",
    type = UIText
  },
  {
    path = "HelpInfoBtn",
    name = "helpInfoBtn",
    type = UIButton
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.chapterCfg = nil
end

local function ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnNext:SetOnClick(function()
    self:OnClickNextChapter()
  end)
  self.btnPrev:SetOnClick(function()
    self:OnClickPrevChapter()
  end)
  self.btnTipMask:SetOnClick(function()
    self:OnClickTipMask()
  end)
  self.btnTipMask:SetActive(false)
  self.tipStageInfo:SetActive(false)
  
  function self.tipStageInfo.onClickEnter(stageId)
    self:OnClickEnterStage(stageId)
  end
  
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.resetBtn:SetOnClick(function()
    self:OnResetChapterBtnClick()
  end)
  self.resetBtn:SetActive(false)
  self.helpInfoBtn:SetOnClick(function()
    self:OnClickHelpInfoBtn()
  end)
end

local function ComponentDestroy(self)
  self:ClearCompsByBook(compBook)
end

local function ReInit(self, params)
  self.showGuide = params and params.showGuide
  local curShowChapterCfg = DataCenter.LWStageFeatureChapterManager.chapterCfg
  local lastPlayChapterId = DataCenter.LWStageFeatureChapterManager:GetCurPlayChapterId()
  if lastPlayChapterId then
    local lastPlayChapter = DataCenter.LWStageFeatureChapterManager:GetChapterCfgData(lastPlayChapterId)
    if lastPlayChapter then
      curShowChapterCfg = lastPlayChapter
    end
  end
  self:Refresh(curShowChapterCfg)
  if params and params.autoShowTip then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:TryAutoShowTipForNextStage()
    end, 0.5)
  end
  DataCenter.LWStageFeatureChapterManager:RequestChapterStageInfo(curShowChapterCfg.id)
end

function LWUIStageFeatureChapterView:OnInfoBtnClick()
  local param = {}
  param.title = "457004"
  param.activityRulesStr = Localization:GetString("special_stage_tips_01")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function LWUIStageFeatureChapterView:OnResetChapterBtnClick()
  local todayResetTimes = DataCenter.LWStageFeatureChapterManager:GetTodayResetTimes()
  if 0 < todayResetTimes then
    UIUtil.ShowMessage(Localization:GetString("breakthough_button_05"), 2, "breakthough_button_04", "breakthough_button_03", function()
      self:ResetCurShowdChapterStages()
    end, nil, nil)
  else
    UIUtil.ShowTipsId("breakthough_tips_05")
  end
end

function LWUIStageFeatureChapterView:ResetCurShowdChapterStages()
  if not self.chapterCfg then
    return
  end
  DataCenter.LWStageFeatureChapterManager:ResetTargetChapterStages(self.chapterCfg.id)
end

function LWUIStageFeatureChapterView:FindIndexByCurChapterCfg()
  if not self.chapterCfg then
    return
  end
  local index = table.indexof(DataCenter.LWStageFeatureChapterManager.chapterCfgs, self.chapterCfg)
  if not index then
    local id = self.chapterCfg.id
    for i, chapterCfg in ipairs(DataCenter.LWStageFeatureChapterManager.chapterCfgs) do
      if chapterCfg.id == id then
        index = i
        break
      end
    end
  end
  return index
end

local function OnClickNextChapter(self)
  local index = self:FindIndexByCurChapterCfg()
  if not index then
    return
  end
  index = index + 1
  local nextChapterCfg = DataCenter.LWStageFeatureChapterManager.chapterCfgs[index]
  if nextChapterCfg then
    self:Refresh(DataCenter.LWStageFeatureChapterManager.chapterCfgs[index])
    self:TryRequestChapterStageInfo(nextChapterCfg)
  else
    UIUtil.ShowTipsId(302109)
  end
  DataCenter.LWStageFeatureChapterManager:SetCurPlayChapterId(nil)
end

local function OnClickPrevChapter(self)
  local index = self:FindIndexByCurChapterCfg()
  if not index then
    return
  end
  index = index - 1
  self:Refresh(DataCenter.LWStageFeatureChapterManager.chapterCfgs[index])
  DataCenter.LWStageFeatureChapterManager:SetCurPlayChapterId(nil)
  local chapterCfg = DataCenter.LWStageFeatureChapterManager.chapterCfgs[index]
  self:TryRequestChapterStageInfo(chapterCfg)
end

local function OnClickTipMask(self)
  self.tipStageInfo:Hide()
  self.btnTipMask:SetActive(false)
end

local function OnClickStageItem(self, stageItem, stageId, tipStyle)
  local mgr = DataCenter.LWStageFeatureChapterManager
  local isNext = mgr.nextStageId == stageId
  local isResetedNext = false
  local isStageReseted = mgr:IsStageReseted(stageId)
  if isStageReseted then
    local resetedChapterCfg = mgr:GetStageBelongsChapterCfgData(stageId)
    local resetedChapterNextStageid = mgr:GetResetedChapterNextStageId(resetedChapterCfg)
    isResetedNext = resetedChapterNextStageid == stageId
  end
  local isSkipStage = DataCenter.LWStageFeatureChapterManager:IsSkipStage(stageId)
  if isNext or isResetedNext or isSkipStage then
    self:OnClickEnterStage(stageId)
  else
    self.btnTipMask:SetActive(true)
    local stageAnchorPos = stageItem:GetAnchoredPosition()
    stageAnchorPos.x = Mathf.Clamp(stageAnchorPos.x, -180, 180)
    self.tipStageInfo:Refresh(stageId, stageAnchorPos, tipStyle)
  end
end

local function RefreshCurChapterStages(self, refreshedChapterId)
  if not self.chapterCfg or self.chapterCfg.id ~= refreshedChapterId then
    return
  end
  self:Refresh(self.chapterCfg)
end

local function Refresh(self, chapterCfg)
  if not chapterCfg then
    return
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.btnTipMask.activeSelf then
    self.tipStageInfo:Hide()
    self.btnTipMask:SetActive(false)
  end
  self.chapterCfg = chapterCfg
  local bgImgPath = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterCfg.id, "bgImg")
  local bgImgTex = CS.GameEntry.Resource:LoadAsset(bgImgPath, typeof(CS.UnityEngine.Texture2D))
  if not IsNull(bgImgTex) then
    self.imgBg:SetTexture(bgImgTex.asset)
  end
  local titleKey = LocalController:instance():getValue(TableName.LW_STAGE_FEATURE_CHAPTER, chapterCfg.id, "title")
  self.txtTitle:SetText(Localization:GetString(titleKey))
  local index = table.indexof(DataCenter.LWStageFeatureChapterManager.chapterCfgs, chapterCfg)
  self.btnPrev.gameObject:SetActive(1 < index)
  local showGuide = self.showGuide
  self.showGuide = false
  for i = 1, 8 do
    local stageItem = self["itemStage" .. i]
    local stageId = chapterCfg.stageIds[i]
    if stageId then
      stageItem:SetActive(true)
      stageItem:Refresh(stageId)
      stageItem:SetOnClick(function()
        self:OnClickStageItem(stageItem, stageId, chapterCfg.nodeTipStyleArr[i])
      end)
      stageItem.transform.localPosition = chapterCfg.nodePosArr[i]
      if showGuide and DataCenter.LWStageFeatureChapterManager.nextStageId == stageId then
        local param = {}
        param.position = stageItem.transform.position
        param.arrowType = ArrowType.Normal
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
      end
    else
      stageItem:SetActive(false)
    end
  end
  local isChapterFinish = DataCenter.LWStageFeatureChapterManager:IsChapterFinsh(self.chapterCfg)
  self.resetBtn:SetActive(isChapterFinish)
  self.resetlabel:SetText(Localization:GetString("breakthough_button_01"))
  local isHelpShareOn = DataCenter.LWStageFeatureChapterManager:IsHelpShareFunctionOn()
  if isHelpShareOn then
    self.helpInfoBtn:SetActive(true)
  else
    self.helpInfoBtn:SetActive(false)
  end
end

local function TryAutoShowTipForNextStage(self)
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
    local inStageFeatureScene = DataCenter.StageFeatureSceneManager:IsInScene()
    if inStageFeatureScene then
      param.enterType = PVEEnterType.StageFeatureScene
      param.stageFeatureTabType = TrailTowerTabType.StageFeatureChapter
      DataCenter.StageFeatureSceneManager:ExitBeforeBattle()
    end
    DataCenter.LWBattleManager:Enter(param)
    if not inStageFeatureScene then
      DataCenter.LWStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = true
    end
    DataCenter.LWStageFeatureChapterManager:SetCurPlayChapterId(self.chapterCfg.id)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.STAGE_FEATURE_CHAPTER_RESET, self.RefreshCurChapterStages)
  self:AddUIListener(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptHelpResult)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.STAGE_FEATURE_CHAPTER_RESET, self.RefreshCurChapterStages)
  self:RemoveUIListener(EventId.PlaneFeatureAcceptResultSuccess, self.OnAcceptHelpResult)
end

local function TryRequestChapterStageInfo(self, targetChapterCfg)
  if targetChapterCfg == nil then
    return
  end
  local currentChapterCfg = DataCenter.LWStageFeatureChapterManager:GetStageBelongsChapterCfgData(DataCenter.LWStageFeatureChapterManager.nextStageId)
  if currentChapterCfg and targetChapterCfg.id <= currentChapterCfg.id then
    local isChapterFinish = DataCenter.LWStageFeatureChapterManager:IsChapterFinsh(targetChapterCfg)
    if not isChapterFinish then
      DataCenter.LWStageFeatureChapterManager:RequestChapterStageInfo(targetChapterCfg.id)
    end
  end
end

function LWUIStageFeatureChapterView:OnClickHelpInfoBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpInfo)
  PostEventLog.Track(PostEventLog.Defines.C_clickHelpInfoBtn)
end

function LWUIStageFeatureChapterView:OnAcceptHelpResult()
  self:Refresh(self.chapterCfg)
end

LWUIStageFeatureChapterView.OnCreate = OnCreate
LWUIStageFeatureChapterView.OnDestroy = OnDestroy
LWUIStageFeatureChapterView.ComponentDefine = ComponentDefine
LWUIStageFeatureChapterView.ComponentDestroy = ComponentDestroy
LWUIStageFeatureChapterView.OnClickNextChapter = OnClickNextChapter
LWUIStageFeatureChapterView.OnClickPrevChapter = OnClickPrevChapter
LWUIStageFeatureChapterView.OnClickTipMask = OnClickTipMask
LWUIStageFeatureChapterView.OnClickStageItem = OnClickStageItem
LWUIStageFeatureChapterView.OnClickEnterStage = OnClickEnterStage
LWUIStageFeatureChapterView.Refresh = Refresh
LWUIStageFeatureChapterView.RefreshCurChapterStages = RefreshCurChapterStages
LWUIStageFeatureChapterView.TryAutoShowTipForNextStage = TryAutoShowTipForNextStage
LWUIStageFeatureChapterView.ReInit = ReInit
LWUIStageFeatureChapterView.OnAddListener = OnAddListener
LWUIStageFeatureChapterView.OnRemoveListener = OnRemoveListener
LWUIStageFeatureChapterView.TryRequestChapterStageInfo = TryRequestChapterStageInfo
return LWUIStageFeatureChapterView
