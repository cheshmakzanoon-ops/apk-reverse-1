local UITCCardBoxResultPanelView = BaseClass("UITCCardBoxResultPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Settings = CS.GameEntry.Setting
local CardBaseItem = require("UI.LWUITCCardMain.Component.CardEntity.TCCardBaseItem")
local DOTween = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local Sequence = CS.DG.Tweening.Sequence
local PANEL_PHASE = require("UI.LWUITC.UITCCardBoxResultPanel.CardBoxResultPhase")
local UIModelView = require("Framework.UI.Component.UIModelView")
local CARD_BOX_GREEN_PATH = "Assets/Main/Prefabs/TacticalCard/A_build_UI_kapai_01.prefab"
local CARD_BOX_BLUE_PATH = "Assets/Main/Prefabs/TacticalCard/A_build_UI_kapai_02.prefab"
local CARD_BOX_PURPLE_PATH = "Assets/Main/Prefabs/TacticalCard/A_build_UI_kapai_03.prefab"
local CARD_BOX_GOLD_PATH = "Assets/Main/Prefabs/TacticalCard/A_build_UI_kapai_04.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local retData = self:GetUserData()
  if table.IsNullOrEmpty(retData) then
    self.ctrl:CloseSelf()
    return
  end
  self:SetData(retData.cardUuids, retData.boxId, retData.newUuids or {})
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_TacticalCard_Show, false)
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

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.TacticalCardBoxResultSkipPhase, self.OnTacticalCardBoxResultSkipPhase)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.TacticalCardBoxResultSkipPhase, self.OnTacticalCardBoxResultSkipPhase)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.drawing = self:AddComponent(UICanvasGroup, "Root/Content/drawing")
  self.result = self:AddComponent(UICanvasGroup, "Root/Content/result")
  self.back_btn = self:AddComponent(UIButton, "Root/Content/BtnBack")
  self.back_btn:SetOnClick(function()
    self:OnBack_btnClick()
  end)
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/drawing/curCardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/drawing/cardType_txt")
  self.openAll_btn = self:AddComponent(UIButton, "Root/Content/drawing/open_btn")
  self.openAll_btn:SetOnClick(function()
    self:OnOpenAll_btnClick()
  end)
  self.cardResult = self:AddComponent(UIBaseContainer, "Root/Content/drawing/cardResult")
  self.remainDrawCnt_txt = self:AddComponent(UITextMeshProUGUIEx, "Root/Content/drawing/remainDraw/cnt_txt")
  self.remainDrawBox_icon = self:AddComponent(UIImage, "Root/Content/drawing/remainDraw/box_icon")
  self.drawedCoreCard = self:AddComponent(UIBaseContainer, "Root/Content/result/cards_area/viewport/content/coreCards")
  self.drawedNormalCard = self:AddComponent(UIBaseContainer, "Root/Content/result/cards_area/viewport/content/normalCards")
  self.coreCardGrid = self:AddComponent(UIBaseContainer, "Root/Content/result/cards_area/viewport/content/coreCards/coreCardGrid")
  self.normalCardGrid = self:AddComponent(UIBaseContainer, "Root/Content/result/cards_area/viewport/content/normalCards/normalCardGrid")
  self.remainDraw_btn = self:AddComponent(UIButton, "Root/Content/drawing/remainDraw")
  self.remainDraw_btn:SetOnClick(function()
    self:OnRemainDraw_btnClick()
  end)
  self.animator = self:AddComponent(UISimpleAnimation, "")
  self.cardFlyTrailVfx = self:AddComponent(UIVfx, "Root/Content/drawing/cardResult/VX_trail")
  self.cardBoxDrawRT = self:AddComponent(UIModelView, "Root/Content/drawing/cardBoxDrawRT")
  self.openResultBtn = self:AddComponent(UIButton, "Root/Content/drawing/openResultBtn")
  self.openResultBtn:SetOnClick(function()
    self:OnOpenAll_btnClick()
  end)
  self.openResultBtn:SetActive(false)
end

local function ComponentDestroy(self)
  self:RemoveDrawingCard()
  self:ClearCardItems()
  self.drawing = nil
  self.result = nil
  self.back_btn = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.openAll_btn = nil
  self.cardResult = nil
  self.remainDrawCnt_txt = nil
  self.remainDrawBox_icon = nil
  self.drawedCoreCard = nil
  self.drawedNormalCard = nil
  self.coreCardGrid = nil
  self.normalCardGrid = nil
  self.remainDraw_btn = nil
  if self.boxTween then
    self.boxTween:Kill()
    self.boxTween = nil
  end
  if self.cardTween then
    self.cardTween:Kill()
    self.cardTween = nil
  end
  if self.resultTween then
    self.resultTween:Kill()
    self.resultTween = nil
  end
end

local function DataDefine(self)
  self.drawResults = nil
  self.coreCards = {}
  self.normalCards = {}
  self.totalCardCount = 0
  self.currentDrawIndex = 0
  self.transitionCoroutine = nil
  self.coreCardItems = {}
  self.normalCardItems = {}
  self.boxTween = nil
  self.cardTween = nil
  self.resultTween = nil
  self.isAnimating = false
  self.cardBoxLoadComplete = false
end

local function DataDestroy(self)
  self.drawResults = nil
  self.coreCards = nil
  self.normalCards = nil
  self.coreCardItems = nil
  self.normalCardItems = nil
  self.clickCardCallback = nil
  self.cardBoxLoadComplete = nil
end

function UITCCardBoxResultPanelView:RemoveDrawingCard()
  if self.drawingCardRequest then
    self.cardResult:RemoveAllComponentes()
    self.drawingCardRequest:Destroy()
    self.drawingCardRequest = nil
  end
end

function UITCCardBoxResultPanelView:SetData(drawResults, boxId, newCardUuids)
  self.drawResults = drawResults or {}
  self.totalCardCount = #self.drawResults
  if self.transitionCoroutine then
    self.transitionCoroutine = nil
  end
  self.newCardMap = {}
  for _, uuid in ipairs(newCardUuids) do
    self.newCardMap[uuid] = true
  end
  local skipAnimation = Settings:GetBool("TCCardBox_SkipAnimation", false)
  if skipAnimation or self.totalCardCount == 0 then
    self:ShowResultPhase()
  else
    self:ShowDrawingPhase(boxId)
  end
end

function UITCCardBoxResultPanelView:PlayBoxOpenAnimation(onComplete)
  if self.boxTween then
    self.boxTween:Kill()
  end
  self.remainDrawBox_icon:SetActive(true)
  self.remainDrawBox_icon:SetLocalScaleXYZ(0.8, 0.8, 0.8)
  self.remainDrawBox_icon:SetLocalScaleXYZ(0, 0, 0)
  local sequence = DOTween.Sequence()
  sequence:Append(self.remainDrawBox_icon.transform:DOScale(Vector3(1.2, 1.2, 1.2), 0.3):SetEase(Ease.OutBack))
  sequence:Append(self.remainDrawBox_icon.transform:DOShakeRotation(0.5, 10, 5, 90))
  sequence:Append(self.remainDrawBox_icon.transform:DOScale(Vector3(0.9, 0.9, 0.9), 0.2))
  sequence:OnComplete(function()
    if onComplete then
      onComplete()
    end
  end)
  self.boxTween = sequence
  sequence:Play()
end

function UITCCardBoxResultPanelView:ShowDrawingPhase(boxId)
  self.ctrl:SetPhase(PANEL_PHASE.Drawing)
  self.currentDrawIndex = 0
  local boxTemplate = DataCenter.TacticalCardDataManager:GetBoxTemplate(boxId)
  if boxTemplate then
    self.remainDrawBox_icon:LoadSpriteAuto(boxTemplate:GetIcon())
  end
  self.drawing:SetActive(true)
  self.result:SetActive(false)
  self.back_btn:SetActive(false)
  self.openAll_btn:SetActive(true)
  self.remainDraw_btn:SetActive(true)
  self.remainDrawBox_icon:SetActive(true)
  self:UpdateRemainCount()
  self.remainDrawBox_icon:SetLocalScaleXYZ(0, 0, 0)
  self.remainDrawBox_icon:SetActive(true)
  self.animator:Play("in")
  self:ShowCardBox(function()
    local quality = boxTemplate:GetQuality()
    local modelPath = self:GetCardBoxPath(quality)
    self.cardBoxDrawRT:ChangeModel(modelPath, function(status, model)
      if status == true then
        self.cardBoxDrawRT:PlayAni("idle")
        self.cardBoxLoadComplete = true
      end
    end)
  end)
end

function UITCCardBoxResultPanelView:UpdateRemainCount()
  local remainCount = self.totalCardCount - self.currentDrawIndex
  self.remainDrawCnt_txt:SetText(tostring(remainCount))
  self.remainDrawCnt_txt.transform:DOPunchScale(Vector3(0.3, 0.3, 0.3), 0.3, 2, 0.5)
end

function UITCCardBoxResultPanelView:OnRemainDraw_btnClick()
  if not self.ctrl:IsInDrawingPhase() or self.currentDrawIndex >= self.totalCardCount or self.isAnimating then
    return
  end
  if not self.cardBoxLoadComplete then
    return
  end
  if self.drawingCardRequest then
    self.cardResult:RemoveAllComponentes()
    self.drawingCardRequest:Destroy()
    self.drawingCardRequest = nil
  end
  self.isAnimating = true
  self.cardBoxDrawRT:PlayAni("open")
  self.cardName_txt:SetActive(false)
  self.cardType_txt:SetActive(false)
  self.openBoxAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.openBoxAniTimer then
      self.openBoxAniTimer:Stop()
      self.openBoxAniTimer = nil
    end
    self.currentDrawIndex = self.currentDrawIndex + 1
    local currentCardUuid = self.drawResults[self.currentDrawIndex]
    local cardData = DataCenter.TacticalCardDataManager:GetCardData(currentCardUuid)
    if not cardData then
      Logger.LogError("cardData is nil, cardUuid: " .. currentCardUuid)
    end
    local template = cardData.template
    self.cardName_txt:SetLocalText(template.name or "Unknown Card")
    self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(template.type))
    self.cardName_txt:SetActive(true)
    self.cardType_txt:SetActive(true)
    self:InitClickCardCallback()
    self.drawingCardRequest = TacticalCardUtil.CreateOneCardItem(self, cardData:GetCardType(), self.cardResult, function(cardItem)
      local displayConfig = {}
      displayConfig.isShowLv = false
      cardItem:SetActive(true)
      cardItem:SetData(cardData, displayConfig)
      if self.newCardMap[cardUuid] then
        cardItem:ShowNewTag()
      else
        cardItem:HideNewTag()
      end
      cardItem:ShowOpenBoxSingeVfx()
      cardItem:ShowOpenBoxSingleFrontVfx()
      cardItem:SetClickFunc(self.clickCardCallback)
      if cardData:GetCardType() == TacticalCardType.Core then
        cardItem:SetLocalScaleXYZ(0.7, 0.7, 0.7)
      else
        cardItem:SetLocalScaleXYZ(1, 1, 1)
      end
      local quality = cardData:GetCardQuality()
      self.cardFlyTrailVfx:PlayByOnce(self:GetCardFlyTrailPath(quality))
    end)
    self:UpdateRemainCount()
    self.animator:Stop()
    self.animator:Play("draw")
    self.openBoxAniTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.openBoxAniTimer then
        self.openBoxAniTimer:Stop()
        self.openBoxAniTimer = nil
      end
      self.isAnimating = false
      if self.currentDrawIndex >= self.totalCardCount then
        self.remainDraw_btn:SetActive(false)
        self.remainDrawBox_icon:SetActive(false)
        self.openAll_btn:SetActive(false)
        self.openResultBtn:SetActive(true)
        self:DelayShowResult()
      else
        self.cardBoxDrawRT:PlayAni("idle")
      end
    end, 0.5)
  end, 0.5)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_TacticalCard_Open, false)
end

function UITCCardBoxResultPanelView:DelayShowResult()
  self.openBoxAniTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.openBoxAniTimer then
      self.openBoxAniTimer:Stop()
      self.openBoxAniTimer = nil
    end
    self:OnOpenAll_btnClick()
  end, 1)
end

function UITCCardBoxResultPanelView:PlayCardDrawAnimation(cardUuid, onComplete)
  if self.cardTween then
    self.cardTween:Kill()
  end
  self:RemoveDrawingCard()
  local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
  if not cardData then
    Logger.LogError("cardData is nil, cardUuid: " .. cardUuid)
    if onComplete then
      onComplete()
    end
    return
  end
  self:InitClickCardCallback()
  self.drawingCardRequest = TacticalCardUtil.CreateOneCardItem(self, cardData:GetCardType(), self.cardResult, function(cardItem)
    cardItem:SetActive(true)
    cardItem:SetData(cardData)
    if self.newCardMap[cardUuid] then
      cardItem:ShowNewTag()
    else
      cardItem:HideNewTag()
    end
    cardItem:SetClickFunc(self.clickCardCallback)
    local boxPos = self.remainDrawBox_icon:GetPosition()
    local targetPos = self.cardResult:GetPosition()
    cardItem:SetPositionXYZ(boxPos.x, boxPos.y, boxPos.z)
    cardItem:SetLocalScaleXYZ(0.2, 0.2, 0.2)
    cardItem:SetEulerAnglesXYZ(0, 0, -30)
    local sequence = DOTween.Sequence()
    sequence:Append(cardItem.transform:DOMove(targetPos, 0.6):SetEase(Ease.OutBack))
    sequence:Join(cardItem.transform:DOScale(Vector3(1, 1, 1), 0.6):SetEase(Ease.OutBack))
    sequence:Join(cardItem.transform:DORotate(Vector3(0, 0, 0), 0.6, CS.DG.Tweening.RotateMode.FastBeyond360):SetEase(Ease.OutBack))
    sequence:Append(cardItem.transform:DOPunchScale(Vector3(0.2, 0.2, 0), 0.3, 2, 0.5))
    sequence:OnComplete(function()
      if onComplete then
        onComplete()
      end
    end)
    self.cardTween = sequence
    sequence:Play()
  end)
end

function UITCCardBoxResultPanelView:OnDrawAnimationComplete(cardUuid)
  local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
  if not cardData then
    Logger.LogError("cardData is nil, cardUuid: " .. cardUuid)
    return
  end
  local template = cardData.template
  self.cardName_txt:SetLocalText(template.name or "Unknown Card")
  self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(template.type))
end

function UITCCardBoxResultPanelView:OnOpenAll_btnClick()
  if not self.ctrl:IsInDrawingPhase() or self.isAnimating then
    return
  end
  if self.openBoxAniTimer then
    self.openBoxAniTimer:Stop()
    self.openBoxAniTimer = nil
  end
  self:ShowResultPhase()
end

function UITCCardBoxResultPanelView:TransitionToResultPhase()
  self.ctrl:SetPhase(PANEL_PHASE.Result)
  self.result:SetAlpha(0)
  self.result:SetActive(true)
  self.back_btn:SetActive(true)
  self.drawing:SetActive(true)
  self:PrepareResultData()
  self:ShowResultCards()
  local sequence = DOTween.Sequence()
  sequence:Insert(0, self.drawing:FadeOut(0.5))
  sequence:InsertCallback(1, function()
    self.drawing:SetActive(false)
  end)
  sequence:Insert(0.2, self.result:FadeIn(0.5))
  self.resultTween = sequence
  sequence:Play()
end

function UITCCardBoxResultPanelView:PrepareResultData()
  self:ClearCardItems()
  self.coreCards = {}
  self.normalCards = {}
  for _, cardUuid in ipairs(self.drawResults) do
    local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
    if cardData then
      if cardData:GetCardType() == TacticalCardType.Core then
        table.insert(self.coreCards, cardData)
      else
        table.insert(self.normalCards, cardData)
      end
    else
      Logger.LogError("cardData is nil, cardUuid: " .. cardUuid)
    end
  end
  self.drawedCoreCard:SetActive(#self.coreCards > 0)
  self.drawedNormalCard:SetActive(#self.normalCards > 0)
end

function UITCCardBoxResultPanelView:ShowResultCards()
  local coreCardCount = #self.coreCards
  local normalCardCount = #self.normalCards
  self:DelayCreateResultCards(1, coreCardCount + normalCardCount, 0.03, function(index)
    if index <= coreCardCount then
      local cardItem = self:CreateCardItem(self.coreCards[index], self.coreCardGrid)
      table.insert(self.coreCardItems, cardItem)
    else
      local cardItem = self:CreateCardItem(self.normalCards[index - coreCardCount], self.normalCardGrid)
      table.insert(self.normalCardItems, cardItem)
    end
  end)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_TacticalCard_Reward, false)
end

function UITCCardBoxResultPanelView:DelayCreateResultCards(index, total, delayTime, callback)
  if total < index then
    return
  end
  self.delayCreateCardReq = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayCreateCardReq then
      self.delayCreateCardReq:Stop()
      self.delayCreateCardReq = nil
    end
    if callback then
      callback(index)
    end
    if index < total then
      self:DelayCreateResultCards(index + 1, total, delayTime, callback)
    end
  end, delayTime)
end

function UITCCardBoxResultPanelView:ShowResultPhase()
  self.ctrl:SetPhase(PANEL_PHASE.Result)
  self.animator:Play("result")
  self.drawing:SetActive(false)
  self.result:SetActive(true)
  self.back_btn:SetActive(true)
  self.result:SetAlpha(1)
  self:PrepareResultData()
  self:ShowResultCards()
end

function UITCCardBoxResultPanelView:InitClickCardCallback()
  if not self.clickCardCallback then
    function self.clickCardCallback(cId, cUuid, cLevel, cStar, cData)
      local params = {}
      
      params.cardDataList = {cData}
      params.equipCardFunc = nil
      UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardEquipConfirm, {anim = true}, params)
    end
  end
end

function UITCCardBoxResultPanelView:CreateCardItem(cardData, parent, callback)
  self:InitClickCardCallback()
  local cardItem = TacticalCardUtil.CreateOneCardItem(self, cardData:GetCardType(), parent, function(cardItem)
    local displayConfig = {}
    displayConfig.isShowLv = false
    cardItem:SetData(cardData, displayConfig)
    cardItem:SetActive(true)
    if self.newCardMap[cardData.uuid] then
      cardItem:ShowNewTag()
    else
      cardItem:HideNewTag()
    end
    if cardData:GetCardType() == TacticalCardType.Core then
      cardItem:SetLocalScaleXYZ(0.7, 0.7, 0.7)
    else
      cardItem:SetLocalScaleXYZ(0.85, 0.85, 0.85)
    end
    if callback then
      callback(cardItem)
    end
    cardItem:SetClickFunc(self.clickCardCallback)
    cardItem:ShowOpenBoxVfx()
    cardItem:PlayAni("Open")
  end)
  return cardItem
end

function UITCCardBoxResultPanelView:ClearCardItems()
  if self.delayCreateCardReq then
    self.delayCreateCardReq:Stop()
    self.delayCreateCardReq = nil
  end
  self.coreCardGrid:RemoveAllComponentes()
  self.normalCardGrid:RemoveAllComponentes()
  if self.coreCardItems then
    for _, item in pairs(self.coreCardItems) do
      item:Destroy()
    end
    self.coreCardItems = {}
  end
  if self.normalCardItems then
    for _, item in pairs(self.normalCardItems) do
      item:Destroy()
    end
    self.normalCardItems = {}
  end
end

local function OnBack_btnClick(self)
  self.back_btn.transform:DOScale(Vector3(0.9, 0.9, 0.9), 0.1):OnComplete(function()
    self.back_btn.transform:DOScale(Vector3(1, 1, 1), 0.1):OnComplete(function()
      self.ctrl:CloseSelf()
    end)
  end)
end

function UITCCardBoxResultPanelView:ShowCardBox(callback)
  self.cardBoxDrawRT:SetRTSize(600, 600)
  self.cardBoxDrawRT:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.cardBoxDrawRT:SetOnLoadSceneHandler(callback)
  self.cardBoxDrawRT:ReInit(SceneAssets.TCCardBox)
end

function UITCCardBoxResultPanelView:GetCardBoxPath(quality)
  if quality == TacticalCardQualityType.Green then
    return CARD_BOX_GREEN_PATH
  elseif quality == TacticalCardQualityType.Blue then
    return CARD_BOX_BLUE_PATH
  elseif quality == TacticalCardQualityType.Purple then
    return CARD_BOX_PURPLE_PATH
  elseif quality == TacticalCardQualityType.Orange then
    return CARD_BOX_GOLD_PATH
  end
  return CARD_BOX_GREEN_PATH
end

function UITCCardBoxResultPanelView:GetCardFlyTrailPath(quality)
  if quality == TacticalCardQualityType.Green then
    return VfxAssets.TCCardOpenBoxCardTrailVfx_Green
  elseif quality == TacticalCardQualityType.Blue then
    return VfxAssets.TCCardOpenBoxCardTrailVfx_Blue
  elseif quality == TacticalCardQualityType.Purple then
    return VfxAssets.TCCardOpenBoxCardTrailVfx_Purple
  elseif quality == TacticalCardQualityType.Orange then
    return VfxAssets.TCCardOpenBoxCardTrailVfx_Gold
  end
  return VfxAssets.TCCardOpenBoxCardTrailVfx_Green
end

function UITCCardBoxResultPanelView:OnTacticalCardBoxResultSkipPhase()
  self:OnOpenAll_btnClick()
end

UITCCardBoxResultPanelView.OnCreate = OnCreate
UITCCardBoxResultPanelView.OnDestroy = OnDestroy
UITCCardBoxResultPanelView.OnEnable = OnEnable
UITCCardBoxResultPanelView.OnDisable = OnDisable
UITCCardBoxResultPanelView.ComponentDefine = ComponentDefine
UITCCardBoxResultPanelView.ComponentDestroy = ComponentDestroy
UITCCardBoxResultPanelView.DataDefine = DataDefine
UITCCardBoxResultPanelView.DataDestroy = DataDestroy
UITCCardBoxResultPanelView.OnAddListener = OnAddListener
UITCCardBoxResultPanelView.OnRemoveListener = OnRemoveListener
UITCCardBoxResultPanelView.OnBack_btnClick = OnBack_btnClick
return UITCCardBoxResultPanelView
