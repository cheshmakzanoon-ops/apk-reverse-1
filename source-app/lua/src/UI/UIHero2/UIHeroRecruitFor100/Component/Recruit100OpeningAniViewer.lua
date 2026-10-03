local Recruit100OpeningAniViewer = BaseClass("Recruit100OpeningAniViewer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local ResourceManager = CS.GameEntry.Resource
local Camera = CS.UnityEngine.Camera
local GameQualitySettings = require("Util.GameQualitySettings")
local OpeningAniCard = require("UI.UIHero2.UIHeroRecruitFor100.Component.Recruit100OpeningAniCard")
local TimeLineFlyCard = require("UI.UIHero2.UIHeroRecruitFor100.Component.Recruit100TimeLineFlyCard")
local DISPLAY_SCENE_PATH = "Assets/Main/Prefabs/UI/UIHero/New/HeroPreview/NewAdd00/DisplayScene_Recruit100CardOpen.prefab"
local open_ani_r_t_path = "OpenAniRT"
local plane_path = "HeroSlot/UIhero100cardopen/timeline/recruit_100/plane"
local recruit100_single_card_path = "Recruit100SingleCard"
local recruit_100_path = "HeroSlot/UIhero100cardopen/timeline/recruit_100"
local camera_path = "HeroSlot/UIhero100cardopen/timeline/recruit_100/camera"
local timeline_path = "HeroSlot/UIhero100cardopen/timeline"
local recruit100_boom_ani_root_path = "Recruit100BoomAniRoot"
local skip_text_path = "OpenAniRT/SkipBtn/SkipText"
local click_area_path = "OpenAniRT/ScreenClickArea"
local skip_btn_path = "OpenAniRT/SkipBtn"
local TIME_LINE_DISAPPEAR_TIME = 3.9

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
  self.rtImg = self:AddComponent(UIRawImage, open_ani_r_t_path)
  self.skipText = self:AddComponent(UIText, skip_text_path)
  self.skipText:SetLocalText(372228)
  self.screenClickBtn = self:AddComponent(UIButton, click_area_path)
  self.screenClickBtn:SetOnClick(function()
    self:OnScreenBtnClick()
  end)
  self.skipBtn = self:AddComponent(UIButton, skip_btn_path)
  self.skipBtn:SetOnClick(function()
    self:OnSkipBtnClick()
  end)
  self.skipBtnCanvasGroup = self.transform:Find(skip_btn_path):GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

local function ComponentDestroy(self)
  self.renderTexture = nil
  self.rtImg = nil
  if self.sceneLoaded ~= nil then
    self.sceneLoaded:Destroy()
  end
  self.sceneLoaded = nil
  if self.sceneLoading ~= nil then
    self.sceneLoading:Destroy()
  end
  self.sceneLoading = nil
  self.timeLineDirector = nil
  if not IsNull(self.singleCardTrans) then
    self.singleCardTrans.gameObject:GameObjectRecycleAll()
  end
  self.singleCardTrans = nil
  self.mainCardTrans = nil
  self.allTimeLineCard = nil
  self.cardBoomAni = nil
  self.skipText = nil
  self.screenClickBtn = nil
  self.skipBtn = nil
  self.skipBtnCanvasGroup = nil
end

local function DataDefine(self)
  self.scenePath = DISPLAY_SCENE_PATH
  self.defaultScenePos = Vector3.New(-1000, 1000, -1000)
  self.aniFinishCallback = nil
  self.allAniCardList = {}
  self.allTimeLineCardList = {}
  self.heroCardQualityInfo = nil
  self.timeLineFlyCardList = nil
  self.skipBtnDisappearTimer = nil
  self.skipBtnAniTween = nil
end

local function DataDestroy(self)
  self:StopAllTimeAndTween()
  self.scenePath = nil
  self.defaultScenePos = nil
  self.aniFinishCallback = nil
  self.allHeroCardScreenPos = nil
  self.allAniCardList = nil
  self.allTimeLineCardList = nil
  self.heroCardQualityInfo = nil
  self.timeLineFlyCardList = nil
  self.allCardBoomSlotList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function Recruit100OpeningAniViewer:StartShowOpeningAni(allHeroCardScreenPos, heroCardQualityInfo, callback)
  self.allHeroCardScreenPos = allHeroCardScreenPos
  self.aniFinishCallback = callback
  self.heroCardQualityInfo = heroCardQualityInfo
  self.gameObject:SetActive(true)
  self.rtImg:SetEnable(false)
  self.skipBtn.gameObject:SetActive(false)
  self:LoadScene()
  self.isClickScreen = false
end

function Recruit100OpeningAniViewer:DoWhenSceneLoaded()
  self:StopAllTimeAndTween()
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(true)
  end
  self:GenCardTrailAndBoomEffByHeroQuality()
  self.mainCardTrans.gameObject:SetActive(true)
  self.timeLineDirector.time = 0
  self.timeLineDirector:Play()
  self.singleCardTrans.gameObject:GameObjectRecycleAll()
  self.allAniCardList = {}
  local timeLineDuration = self.timeLineDirector.duration or TIME_LINE_DISAPPEAR_TIME
  self.recruitResultDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ExecuteTimeLineFinish()
  end, timeLineDuration)
  self.soundId = DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Recruit100Opening)
end

function Recruit100OpeningAniViewer:ShowCardBoom()
  if not self.allHeroCardScreenPos then
    return
  end
  self.cardBoomAni.transform.position = self.mainCardTrans.position
  self.mainCardTrans.gameObject:SetActive(false)
  local allCardCount = math.min(#self.allHeroCardScreenPos, #self.allCardBoomSlotList)
  for i = 1, allCardCount do
    local targetScreenPos = self.allHeroCardScreenPos[i]
    local followRoot = self.allCardBoomSlotList[i]
    local name = "cardItem_" .. i
    local card = self.singleCardTrans.gameObject:GameObjectSpawn(self.carBoomTrans)
    card.transform:SetParent(followRoot)
    card.name = name
    local openingAniCard = OpeningAniCard.New()
    openingAniCard:Init(card)
    openingAniCard:SetData(targetScreenPos, self.sceneCamera)
    table.insert(self.allAniCardList, openingAniCard)
  end
  allCardCount = 1
  self.cardBoomAni.enabled = true
  self.cardBoomAni:Play(string.format("Recruit100CardBoomAni_%s", allCardCount), 0, 0)
end

function Recruit100OpeningAniViewer:ShowCardFlyTarget()
  self.cardBoomAni.enabled = false
  for _, v in ipairs(self.allAniCardList) do
    v:FlyToTargetPos()
  end
end

function Recruit100OpeningAniViewer:LoadScene()
  if self.sceneLoading then
    return
  end
  if self.sceneLoaded and self.sceneCamera then
    self:OnRenderTexture(self.sceneCamera)
    self:DoWhenSceneLoaded()
    return
  end
  local scenePath = DISPLAY_SCENE_PATH
  local request = ResourceManager:InstantiateAsync(scenePath)
  self.sceneLoading = request
  request:completed("+", function()
    if request.isError then
      self.sceneLoading = nil
      self:DoWhenSceneLoaded(self)
      return
    end
    self.sceneObj = request.gameObject
    self.sceneObj:SetActive(true)
    self.sceneObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.sceneObj.transform:Set_position(self.defaultScenePos.x, self.defaultScenePos.y, self.defaultScenePos.z)
    local camera = self.sceneObj.transform:Find(camera_path):GetComponentInChildren(typeof(Camera))
    self.timeLineCardRoot = self.sceneObj.transform:Find(recruit_100_path)
    self.timeLineDirector = self.sceneObj.transform:Find(timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.mainCardTrans = self.sceneObj.transform:Find(plane_path):GetComponent(typeof(CS.UnityEngine.Transform))
    self.singleCardTrans = self.sceneObj.transform:Find(recruit100_single_card_path):GetComponent(typeof(CS.UnityEngine.Transform))
    self.singleCardTrans.gameObject:GameObjectCreatePool()
    self.cardBoomAni = self.sceneObj.transform:Find(recruit100_boom_ani_root_path):GetComponent(typeof(CS.UnityEngine.Animator))
    self.allCardBoomSlotList = {}
    local cardSlotCount = self.cardBoomAni.transform.childCount
    for i = 0, cardSlotCount - 1 do
      local slotTrans = self.cardBoomAni.transform:GetChild(i)
      table.insert(self.allCardBoomSlotList, slotTrans)
    end
    self.sceneLoading = nil
    self.sceneLoaded = request
    self.sceneCamera = camera
    self:CollectAllTimeLineCard()
    self:ToggleSceneCamera(true)
    self:DoWhenSceneLoaded(self)
  end)
end

function Recruit100OpeningAniViewer:CollectAllTimeLineCard()
  if not self.timeLineCardRoot then
    return
  end
  self.allTimeLineCardList = {}
  local startChildIndex = 1
  local endChildIndex = 25
  for i = startChildIndex, endChildIndex do
    local cardObj = self.timeLineCardRoot.transform:GetChild(i)
    if not IsNull(cardObj) then
      table.insert(self.allTimeLineCardList, cardObj)
    end
  end
end

function Recruit100OpeningAniViewer:GenCardTrailAndBoomEffByHeroQuality()
  if self.timeLineFlyCardList then
    for _, v in ipairs(self.timeLineFlyCardList) do
      v:ClearAll()
    end
  end
  self.timeLineFlyCardList = {}
  for k, v in ipairs(self.allTimeLineCardList) do
    local index = k
    local carObj = self.allTimeLineCardList[index]
    if IsNull(carObj) then
      break
    end
    local quality = self.heroCardQualityInfo[index] or math.random(HeroQualityType.Outstanding, HeroQualityType.Genius)
    local timeLineFlyCard = TimeLineFlyCard.New()
    timeLineFlyCard:Init(k, carObj, quality)
    table.insert(self.timeLineFlyCardList, timeLineFlyCard)
  end
end

function Recruit100OpeningAniViewer:ToggleSceneCamera(b)
  local sceneCamera = self.sceneCamera
  if not IsNull(sceneCamera) then
    sceneCamera.gameObject:SetActive(b)
    if b then
      self:OnRenderTexture(sceneCamera)
    else
      sceneCamera.targetTexture = nil
    end
  end
end

function Recruit100OpeningAniViewer:OnRenderTexture(camera)
  if camera == nil then
    Logger.LogError("OnRenderTexture camera is nil!")
    return
  end
  if self.renderTexture == nil then
    local rtImgWidth = self.rtImg.rectTransform.rect.width
    local rtImgHeight = self.rtImg.rectTransform.rect.height
    local rtHeight = math.ceil(DefaultScreenHeight)
    local rtWidth = math.ceil(DefaultScreenHeight / (rtImgHeight / rtImgWidth))
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(math.floor(rtWidth), math.floor(rtHeight), 24, rtFormat)
    self.renderTexture.name = "Recruit100RT"
    self.rtImg:SetTexture(self.renderTexture)
    self.rtImg:SetColor(Color.white)
  end
  self.rtImg:SetEnable(true)
  camera.targetTexture = self.renderTexture
end

function Recruit100OpeningAniViewer:StopAllTimeAndTween()
  if self.recruitResultDelayTimer then
    self.recruitResultDelayTimer:Stop()
    self.recruitResultDelayTimer = nil
  end
  if self.skipBtnDisappearTimer then
    self.skipBtnDisappearTimer:Stop()
    self.skipBtnDisappearTimer = nil
  end
  if self.skipBtnAniTween then
    self.skipBtnAniTween:Kill()
    self.skipBtnAniTween = nil
  end
end

function Recruit100OpeningAniViewer:ExecuteTimeLineFinish()
  self:StopAllTimeAndTween()
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if not IsNull(self.sceneObj) then
    self.sceneObj:SetActive(false)
  end
  if self.aniFinishCallback then
    self.aniFinishCallback()
  end
  self.aniFinishCallback = nil
  self.soundId = nil
end

function Recruit100OpeningAniViewer:OnScreenBtnClick()
  self.skipBtn.gameObject:SetActive(true)
  if not IsNull(self.skipBtnCanvasGroup) and self.skipBtnAniTween == nil and self.skipBtnDisappearTimer == nil then
    self.skipBtnCanvasGroup.alpha = 0
    self.skipBtnAniTween = self.skipBtnCanvasGroup:DOFade(1, 0.5)
    self.skipBtnAniTween:OnComplete(function()
      self.skipBtnAniTween = nil
    end)
  end
  self.skipBtnDisappearTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.skipBtnAniTween then
      self.skipBtnAniTween:Kill()
    end
    if not IsNull(self.skipBtnCanvasGroup) and self.skipBtnAniTween == nil then
      self.skipBtnAniTween = self.skipBtnCanvasGroup:DOFade(0, 0.5)
      self.skipBtnAniTween:OnComplete(function()
        self.skipBtn.gameObject:SetActive(false)
        self.skipBtnAniTween = nil
      end)
    end
    self.skipBtnDisappearTimer = nil
  end, 2)
end

function Recruit100OpeningAniViewer:OnSkipBtnClick()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
  end
  self:ExecuteTimeLineFinish()
end

Recruit100OpeningAniViewer.OnCreate = OnCreate
Recruit100OpeningAniViewer.OnDestroy = OnDestroy
Recruit100OpeningAniViewer.OnEnable = OnEnable
Recruit100OpeningAniViewer.OnDisable = OnDisable
Recruit100OpeningAniViewer.ComponentDefine = ComponentDefine
Recruit100OpeningAniViewer.ComponentDestroy = ComponentDestroy
Recruit100OpeningAniViewer.DataDefine = DataDefine
Recruit100OpeningAniViewer.DataDestroy = DataDestroy
Recruit100OpeningAniViewer.OnAddListener = OnAddListener
Recruit100OpeningAniViewer.OnRemoveListener = OnRemoveListener
return Recruit100OpeningAniViewer
