local base = UIBaseView
local LWUIEasyStageFeatureChapterView = BaseClass("LWUIEasyStageFeatureChapterView", base)
local Localization = CS.GameEntry.Localization
local UIEasyStageFeatureChapterItem = require("UI.LWUIEasyStageFeatureChapter.Component.UIEasyStageFeatureChapterItem")
local UIEasyStageFeatureChapterInfoTip = require("UI.LWUIEasyStageFeatureChapter.Component.UIEasyStageFeatureChapterInfoTip")
local UIStageFeatureChapterRewardItem = require("UI.LWUIEasyStageFeatureChapter.Component.UIStageFeatureChapterRewardItem")
local UIStageFeatureBoxTip = require("UI.LWUIEasyStageFeatureChapter.Component.UIStageFeatureBoxTip")
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
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem2",
    name = "itemStage2",
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem3",
    name = "itemStage3",
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem4",
    name = "itemStage4",
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem5",
    name = "itemStage5",
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem6",
    name = "itemStage6",
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem7",
    name = "itemStage7",
    type = UIEasyStageFeatureChapterItem
  },
  {
    path = "StageItems/StageItem8",
    name = "itemStage8",
    type = UIEasyStageFeatureChapterItem
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
    type = UIEasyStageFeatureChapterInfoTip
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
    path = "RewardGroup",
    name = "rewardGroup",
    type = UIImage
  },
  {
    path = "RewardGroup/RewardProgress",
    name = "rewardProgress",
    type = UISlider
  },
  {
    path = "RewardGroup/ProgressTitle",
    name = "progressTitle",
    type = UIText
  },
  {
    path = "RewardGroup/RewardItems/RewardItem1",
    name = "rewardItem1",
    type = UIStageFeatureChapterRewardItem
  },
  {
    path = "RewardGroup/RewardItems/RewardItem2",
    name = "rewardItem2",
    type = UIStageFeatureChapterRewardItem
  },
  {
    path = "RewardGroup/RewardItems/RewardItem3",
    name = "rewardItem3",
    type = UIStageFeatureChapterRewardItem
  },
  {
    path = "RewardGroup/RewardItems/RewardItem4",
    name = "rewardItem4",
    type = UIStageFeatureChapterRewardItem
  },
  {
    path = "RewardTip",
    name = "rewardTip",
    type = UIStageFeatureBoxTip
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.curChapterDoneStageNum = 0
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.curChapterDoneStageNum = 0
  self.chapterCfg = nil
end

local function ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.btnClose:SetOnClick(function()
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
  end)
  self.resetBtn:SetActive(false)
  self.rewardGroup:SetActive(LuaEntry.Player:IsEasyStageFeatureBoxRewardB())
end

local function ComponentDestroy(self)
  self:ClearCompsByBook(compBook)
end

local function ReInit(self, params)
  self.showGuide = params and params.showGuide
  local curShowChapterCfg = DataCenter.LWEasyStageFeatureChapterManager.chapterCfg
  local lastPlayChapterId = DataCenter.LWEasyStageFeatureChapterManager:GetCurPlayChapterId()
  if lastPlayChapterId then
    local lastPlayChapter = DataCenter.LWEasyStageFeatureChapterManager:GetChapterCfgData(lastPlayChapterId)
    if lastPlayChapter then
      curShowChapterCfg = lastPlayChapter
    end
  end
  self:Refresh(curShowChapterCfg)
end

function LWUIEasyStageFeatureChapterView:OnInfoBtnClick()
  local param = {}
  param.title = "457004"
  param.activityRulesStr = Localization:GetString("special_stage_tips_01")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

local function OnClickNextChapter(self)
  local index = self:FindIndexByCurChapterCfg()
  if not index then
    return
  end
  index = index + 1
  local nextChapterCfg = DataCenter.LWEasyStageFeatureChapterManager.chapterCfgs[index]
  if nextChapterCfg then
    self:Refresh(DataCenter.LWEasyStageFeatureChapterManager.chapterCfgs[index])
  else
    UIUtil.ShowTipsId(302109)
  end
  DataCenter.LWEasyStageFeatureChapterManager:SetCurPlayChapterId(nil)
end

local function OnClickPrevChapter(self)
  local index = self:FindIndexByCurChapterCfg()
  if not index then
    return
  end
  index = index - 1
  self:Refresh(DataCenter.LWEasyStageFeatureChapterManager.chapterCfgs[index])
  DataCenter.LWEasyStageFeatureChapterManager:SetCurPlayChapterId(nil)
end

function LWUIEasyStageFeatureChapterView:FindIndexByCurChapterCfg()
  if not self.chapterCfg then
    return
  end
  local index = table.indexof(DataCenter.LWEasyStageFeatureChapterManager.chapterCfgs, self.chapterCfg)
  if not index then
    local id = self.chapterCfg.id
    for i, chapterCfg in ipairs(DataCenter.LWEasyStageFeatureChapterManager.chapterCfgs) do
      if chapterCfg.id == id then
        index = i
        break
      end
    end
  end
  return index
end

local function OnClickTipMask(self)
  self.tipStageInfo:Hide()
  self.btnTipMask:SetActive(false)
end

local function OnClickStageItem(self, stageItem, stageId, tipStyle)
  local mgr = DataCenter.LWEasyStageFeatureChapterManager
  local isNext = mgr.nextStageId == stageId
  if isNext then
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
  if self.btnTipMask.activeSelf then
    self.tipStageInfo:Hide()
    self.btnTipMask:SetActive(false)
  end
  self.chapterCfg = chapterCfg
  local tableName = LuaEntry.Player:GetABTestTableName(TableName.LW_EASY_STAGE_FEATURE_CHAPTER)
  local bgImgPath = LocalController:instance():getValue(tableName, chapterCfg.id, "bgImg")
  local bgImgTex = CS.GameEntry.Resource:LoadAsset(bgImgPath, typeof(CS.UnityEngine.Texture2D))
  if not IsNull(bgImgTex) then
    self.imgBg:SetTexture(bgImgTex.asset)
  end
  local titleKey = LocalController:instance():getValue(tableName, chapterCfg.id, "title")
  self.txtTitle:SetText(Localization:GetString(titleKey))
  local index = table.indexof(DataCenter.LWEasyStageFeatureChapterManager.chapterCfgs, chapterCfg)
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
      if showGuide and DataCenter.LWEasyStageFeatureChapterManager.nextStageId == stageId then
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
  local stages = self.chapterCfg.stageIds
  local doneNum = 0
  for i, stageId in ipairs(stages) do
    if DataCenter.LWEasyStageFeatureChapterManager.doneStageIds[stageId] then
      doneNum = doneNum + 1
    end
  end
  self.curChapterDoneStageNum = doneNum
  self.progressTitle:SetLocalText("activity_breakthrough_tips_72", self.curChapterDoneStageNum or 0, #self.chapterCfg.stageIds)
  self:RefreshRewardBox(chapterCfg)
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
      param.stageFeatureTabType = TrailTowerTabType.EasyStageFeatureChapter
      DataCenter.StageFeatureSceneManager:ExitBeforeBattle()
    end
    DataCenter.LWBattleManager:Enter(param)
    if not inStageFeatureScene then
      DataCenter.LWEasyStageFeatureChapterManager.autoOpenMapUIWhenBackToCity = true
    end
    DataCenter.LWEasyStageFeatureChapterManager.enteredStageId = param.levelId
    DataCenter.LWEasyStageFeatureChapterManager:SetCurPlayChapterId(self.chapterCfg.id)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.StageFeatureRewardBoxUpdate, self.OnBoxRewardUpdate)
end

local function OnRemoveListener(self)
  self:AddUIListener(EventId.StageFeatureRewardBoxUpdate, self.OnBoxRewardUpdate)
  base.OnRemoveListener(self)
end

function LWUIEasyStageFeatureChapterView:OnClickRewardBox(index)
  if not self.chapterCfg then
    return
  end
  local boxDatas = self.chapterCfg.boxDatas
  local boxData = boxDatas[index]
  if boxData then
    if not boxData.Got and boxData.TargetCompleteNum <= self.curChapterDoneStageNum then
      SFSNetwork.SendMessage(MsgDefines.LwPlaneFeatureChapterBoxReward, tonumber(self.chapterCfg.id))
    elseif not boxData.Got then
      local param = UIStageFeatureBoxTip.ParamDataClass.New()
      param.index = index or 1
      param.rewardList = DataCenter.RewardTemplateManager:GetList(boxData.RewardId) or {}
      self.rewardTip:SetData(param)
      self.rewardTip:Show()
    end
  end
end

function LWUIEasyStageFeatureChapterView:OnBoxRewardUpdate(chapterId)
  if not self.chapterCfg or self.chapterCfg.id ~= chapterId then
    return
  end
  self:RefreshRewardBox(self.chapterCfg)
end

function LWUIEasyStageFeatureChapterView:RefreshRewardBox(chapterCfg)
  local boxRewardB = LuaEntry.Player:IsEasyStageFeatureBoxRewardB()
  self.rewardGroup:SetActive(boxRewardB)
  if boxRewardB and chapterCfg ~= nil then
    self.rewardProgress:SetValue(self.curChapterDoneStageNum / #chapterCfg.stageIds)
    for i = 1, 4 do
      local boxItem = self["rewardItem" .. i]
      local boxData = chapterCfg.boxDatas[i]
      boxItem:Refresh(boxData, self.curChapterDoneStageNum >= boxData.TargetCompleteNum)
      local boxIndex = i
      boxItem:SetOnClick(function()
        self:OnClickRewardBox(boxIndex)
      end)
    end
  end
end

LWUIEasyStageFeatureChapterView.OnCreate = OnCreate
LWUIEasyStageFeatureChapterView.OnDestroy = OnDestroy
LWUIEasyStageFeatureChapterView.ComponentDefine = ComponentDefine
LWUIEasyStageFeatureChapterView.ComponentDestroy = ComponentDestroy
LWUIEasyStageFeatureChapterView.OnClickNextChapter = OnClickNextChapter
LWUIEasyStageFeatureChapterView.OnClickPrevChapter = OnClickPrevChapter
LWUIEasyStageFeatureChapterView.OnClickTipMask = OnClickTipMask
LWUIEasyStageFeatureChapterView.OnClickStageItem = OnClickStageItem
LWUIEasyStageFeatureChapterView.OnClickEnterStage = OnClickEnterStage
LWUIEasyStageFeatureChapterView.Refresh = Refresh
LWUIEasyStageFeatureChapterView.RefreshCurChapterStages = RefreshCurChapterStages
LWUIEasyStageFeatureChapterView.ReInit = ReInit
LWUIEasyStageFeatureChapterView.OnAddListener = OnAddListener
LWUIEasyStageFeatureChapterView.OnRemoveListener = OnRemoveListener
return LWUIEasyStageFeatureChapterView
