local UIWorkerDrawCardItem = BaseClass("UIWorkerDrawCardItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonTipsView = require("UI.UICommonTips.View.UICommonTipsView")
local Localization = CS.GameEntry.Localization
local WorkerData = require("DataCenter.WorkerData.WorkerData")
local tweenRoot_path = "tweenRoot"
local effectContent_path = "tweenRoot/effectContent"
local effect1_path = "tweenRoot/effectContent/effect1"
local effect2_path = "tweenRoot/effectContent/effect2"
local effectContent2_path = "tweenRoot/effectContent2"
local effect3_path = "tweenRoot/effectContent2/effect3"
local effect4_path = "tweenRoot/effectContent2/effect4"
local effectContent3_path = "tweenRoot/effectContent3"
local defaultBg_path = "tweenRoot/defaultBg"
local workerBg_path = "tweenRoot/workerBg"
local workerImg_path = "tweenRoot/workerBg/mask/workerImg"
local newPoint_path = "tweenRoot/workerBg/newPoint"
local beSelectContent_path = "tweenRoot/workerBg/beSelectContent"
local beGetContent_path = "tweenRoot/beGetContent"
local whiteMask_path = "tweenRoot/whiteMask"
local blackMask_path = "tweenRoot/blackMask"

local function OnCreate(self)
  base.OnCreate(self)
  self.showData = nil
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ComponentDefine(self)
  self.tweenRoot = self:AddComponent(UIBaseContainer, tweenRoot_path)
  self.tweenRootAni = self.tweenRoot.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  self.tweenRootAni.enabled = false
  self.effectContent = self:AddComponent(UIBaseContainer, effectContent_path)
  self.effectContent2 = self:AddComponent(UIBaseContainer, effectContent2_path)
  self.effectContent3 = self:AddComponent(UIBaseContainer, effectContent3_path)
  self.effect1 = self:AddComponent(UIBaseContainer, effect1_path)
  self.effect2 = self:AddComponent(UIBaseContainer, effect2_path)
  self.effect3 = self:AddComponent(UIBaseContainer, effect3_path)
  self.effect4 = self:AddComponent(UIBaseContainer, effect4_path)
  self.defaultBg = self:AddComponent(UIBaseContainer, defaultBg_path)
  self.workerBg = self:AddComponent(UIImage, workerBg_path)
  self.workerImg = self:AddComponent(UIRawImage, workerImg_path)
  self.newPoint = self:AddComponent(UIBaseContainer, newPoint_path)
  self.beSelectContent = self:AddComponent(UIBaseContainer, beSelectContent_path)
  self.beGetContent = self:AddComponent(UIBaseContainer, beGetContent_path)
  self.bgBtn = self:AddComponent(UIButton, "")
  self.whiteMask = self:AddComponent(UICanvasGroup, whiteMask_path)
  self.blackMask = self:AddComponent(UIBaseContainer, blackMask_path)
  self.bgBtn:SetOnClick(BindCallback(self, self.OnBgBtnClick))
end

local function ComponentDestroy(self)
  self.tweenRoot = nil
  self.tweenRootAni = nil
  self.effectContent = nil
  self.effectContent2 = nil
  self.effectContent3 = nil
  self.effect1 = nil
  self.effect2 = nil
  self.effect3 = nil
  self.effect4 = nil
  self.defaultBg = nil
  self.workerBg = nil
  self.workerImg = nil
  self.newPoint = nil
  self.beSelectContent = nil
  self.beGetContent = nil
  self.bgBtn = nil
  self.whiteMask = nil
  self.blackMask = nil
end

local function OnBgBtnClick(self)
  if self.showData == nil then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.WorkerLotteryCommonTipClose)
  local template = DataCenter.WorkerTemplateManager:GetTemplateById(self.showData.id)
  if template == nil then
    return
  end
  local workerData = WorkerData.New()
  local message = {}
  message.firstName = template.first_name
  message.lastName = template.last_name
  message.cfgId = self.showData.id
  workerData:UpdateInfo(message)
  local param = UICommonTipsView.ParamDataClass.New()
  param.title = workerData:GetName()
  local describe, text = WorkerUtil.GetEffectText(tonumber(workerData.peculiarity), tonumber(workerData.peculiarityVlue), true)
  param.content = describe .. string.format("<color=green>%s</color>", text)
  param.position = self.bgBtn:GetPosition()
  param.deltaY = -120
  self:PlayMoveAni()
  EventManager:GetInstance():Broadcast(EventId.WorkerLotteryCommonTipOpen, param)
end

local function SetData(self, val)
  self.showData = val
  local template = DataCenter.WorkerTemplateManager:GetTemplateById(self.showData.id)
  if template == nil then
    return
  end
  local modelId = template.appearance
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(modelId)
  local appearCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
  if appearCfg == nil then
    return
  end
  local quality = template.quality
  if quality == WorkerQualityType.Genius then
    self.effect1:SetActive(true)
    self.effect3:SetActive(true)
    self.effect2:SetActive(false)
    self.effect4:SetActive(false)
  elseif quality == WorkerQualityType.Legendary then
    self.effect1:SetActive(false)
    self.effect3:SetActive(false)
    self.effect2:SetActive(true)
    self.effect4:SetActive(true)
  else
    self.effect1:SetActive(false)
    self.effect3:SetActive(false)
    self.effect2:SetActive(false)
    self.effect4:SetActive(false)
  end
  local qualityBgName = WorkerDrawCardQualityBgName[quality]
  self.workerBg:LoadSprite(qualityBgName)
  local path = LoadPath.LWHeroBodyPath
  local iconName = appearCfg.pose_icon_path
  self.workerImg:LoadSpriteAuto(path .. iconName .. ".png")
  self.newPoint:SetActive(self.showData.isNew)
  self.beGetContent:SetActive(self.showData.isDraw)
  self:SetBlackMaskVal(self.showData.isDraw)
  self.beSelectContent:SetActive(false)
end

local function SetNormalState(self)
  self:CloseMoveAni()
  self.tweenRoot:SetLocalPosition(Vector3.zero)
  self.tweenRoot:SetLocalScale(Vector3.one)
  self.beSelectContent:SetActive(false)
  self.whiteMask:SetAlpha(0)
  self.effectContent:SetActive(true)
  self.effectContent2:SetActive(true)
  self.workerBg:SetActive(true)
  self.workerImg:SetActive(true)
  self.blackMask:SetActive(false)
  self.effectContent3:SetActive(false)
  self.tweenRootAni.enabled = true
  self.tweenRootAni.speed = 1
  self.tweenRootAni:Play("Eff_UIHeroRecruit_chouka", 0, 1)
  self.tweenRootAni.speed = 0
  self.tweenRootAni.enabled = false
  if self.showData == nil then
    return
  end
  self.newPoint:SetActive(self.showData.isNew)
  self:SetBlackMaskVal(self.showData.isDraw)
end

local function SetAniEndState(self)
  self.tweenRootAni.enabled = true
  self.tweenRootAni.speed = 1
  self.tweenRootAni:Play("Eff_UIHeroRecruit_chouka", 0, 1)
  self.tweenRootAni.speed = 0
  TimerManager:GetInstance():DelayInvoke(function()
    self.tweenRootAni.enabled = false
  end, 0.05)
end

local function CloseMoveAni(self)
  if self.moveAniSeq ~= nil then
    self.moveAniSeq:Kill()
    self.moveAniSeq = nil
  end
end

local function PlayMoveAni(self)
  self:CloseMoveAni()
  self:SetNormalState()
  local moveY = 30
  local moveTime = 0.2
  local doScale = 1.1
  self.beSelectContent:SetActive(true)
  self.moveAniSeq = DOTween.Sequence()
  self.moveAniSeq:Append(self.tweenRoot.transform:DOScale(doScale, moveTime))
  self.moveAniSeq:OnComplete(function()
    self:CloseMoveAni()
  end)
end

local function PlayPrePosMoveAni(self)
  self:CloseMoveAni()
  local moveY = 0
  local moveTime = 0.2
  local doScale = 1
  self.beSelectContent:SetActive(false)
  self.moveAniSeq = DOTween.Sequence()
  self.moveAniSeq:Append(self.tweenRoot.transform:DOScale(doScale, moveTime))
  self.moveAniSeq:OnComplete(function()
    self:SetNormalState()
    self:CloseMoveAni()
  end)
end

local function PlayRefreshAni(self)
  self:CloseMoveAni()
  self:SetNormalState()
  local delayTime = (self.showData.index - 1) * 0.3
  local anitime = 2
  self.tweenRootAni.enabled = true
  self.tweenRootAni.speed = 1
  self.tweenRootAni:Play("Eff_UIHeroRecruit_chouka", 0, 0)
  self.tweenRootAni.speed = 0
  self.moveAniSeq = DOTween.Sequence()
  self.moveAniSeq:AppendInterval(delayTime)
  self.moveAniSeq:AppendCallback(function()
    self.tweenRootAni:Play("Eff_UIHeroRecruit_chouka", 0, 0)
    self.tweenRootAni.speed = 1
  end)
  self.moveAniSeq:AppendInterval(anitime)
  self.moveAniSeq:OnComplete(function()
    self.tweenRootAni:Play("Eff_UIHeroRecruit_chouka", 0, 1)
    self.tweenRootAni.speed = 0
    self.tweenRootAni.enabled = false
    self:CloseMoveAni()
  end)
end

local function SetDrawCardState(self)
  self.effectContent:SetActive(false)
  self.effectContent2:SetActive(false)
  self.newPoint:SetActive(false)
end

local function SetBlackMaskVal(self, val)
  if val then
    self.workerBg:SetColor(HalfColor)
    self.workerImg:SetColor(HalfColor)
  else
    self.workerBg:SetColor(WhiteColor)
    self.workerImg:SetColor(WhiteColor)
  end
end

UIWorkerDrawCardItem.OnCreate = OnCreate
UIWorkerDrawCardItem.OnDestroy = OnDestroy
UIWorkerDrawCardItem.DataDefine = DataDefine
UIWorkerDrawCardItem.DataDestroy = DataDestroy
UIWorkerDrawCardItem.ComponentDefine = ComponentDefine
UIWorkerDrawCardItem.ComponentDestroy = ComponentDestroy
UIWorkerDrawCardItem.OnBgBtnClick = OnBgBtnClick
UIWorkerDrawCardItem.SetData = SetData
UIWorkerDrawCardItem.SetNormalState = SetNormalState
UIWorkerDrawCardItem.SetAniEndState = SetAniEndState
UIWorkerDrawCardItem.CloseMoveAni = CloseMoveAni
UIWorkerDrawCardItem.PlayMoveAni = PlayMoveAni
UIWorkerDrawCardItem.PlayPrePosMoveAni = PlayPrePosMoveAni
UIWorkerDrawCardItem.PlayRefreshAni = PlayRefreshAni
UIWorkerDrawCardItem.SetDrawCardState = SetDrawCardState
UIWorkerDrawCardItem.SetBlackMaskVal = SetBlackMaskVal
return UIWorkerDrawCardItem
