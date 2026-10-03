local UIHeroExhibitPanelView = BaseClass("UIHeroExhibitPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local ResourceManager = CS.GameEntry.Resource
local UIHeroPowerDetailTipView = require("UI.UILWHero.UIHeroPowerDetailTip.View.UIHeroPowerDetailTipView")
local UIHeroExhibitPreviewPage = require("UI/UILWHero/UIHeroExhibitPanel/Component/UIHeroExhibitPreviewPage")
local UIHeroDetailPageToggle = require("UI/UILWHero/UIHeroExhibitPanel/Component/UIHeroDetailPageToggle")
local heroSpineContainerPath = "Root/CenterHeroInfo/HeroSpineContainerMask1/HeroSpineContainerMask/HeroSpineContainer"
local heroQualityIconPath = "Root/RightTopInfo/HeroQualityIcon"
local heroNameTextPath = "Root/RightTopInfo/HeroNameText"
local nickNameTextPath = "Root/RightTopInfo/HeroNameText/nickNameText"
local heroTypeIconPath = "Root/RightTopInfo/HeroTypeIcon"
local heroSkillInfoPath = "Root/CenterHeroInfo/HeroSkillInfo"
local heroSkillListPath = "Root/CenterHeroInfo/HeroSkillInfo/SkillList"
local heroSkill1Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill1"
local heroSkill2Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill2"
local heroSkill3Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill3"
local heroSkill4Path = "Root/CenterHeroInfo/HeroSkillInfo/SkillList/HeroSkill4"
local skillTxtPath = "Root/CenterHeroInfo/HeroSkillInfo/skillTxt"
local tipTxtPath = "Root/CenterHeroInfo/HeroSkillInfo/tipTxt"
local heroExhibitPreviewPagePath = "Root/CenterHeroInfo/Pages/Content/PreviewHeroExhibitPage"
local heroExhibitPreviewPageTogglePath = "Root/CenterHeroInfo/PageToggles/HeroExhibitPreviewPageToggle"
local skillPreviewPageTogglePath = "Root/CenterHeroInfo/PageToggles/SkillPreviewPageToggle"
local equipAddHpTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo/HpInfoNumber/EquipAddHpText"
local equipAddAtkTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo/AttckInfoNumber/EquipAddAttackText"
local equipAddDefTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo/DefInfoNumber/EquipAddDefText"
local hpTitleTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo/HpInfoTitleText"
local atkTitleTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo/AttackInfoTitleText"
local defTitleTextPath = "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo/HeroDefInfoTitleText"
local bgImgPath = "Bg"
local bgIconImgPath = "Bg/Icon"
local contentBgImgPath = "Root/ContentBg"
local contentBgIconImgPath = "Root/ContentBg/ContentBgIcon"
local tapToContinueTxtPath = "Root/TapToContinue"
local titleBgEffectPath = "Root/ContentBg/VFX_lightsweep"
local UrQualityIconPath = "Root/RightTopInfo/HeroQualityIcon/VFX_quality/icon_ur"
local SsrQualityIconPath = "Root/RightTopInfo/HeroQualityIcon/VFX_quality/icon_ssr"
local urEffectPath = "VFX_backside"
local HeroDetailPageType = {HeroExhibit = 1}

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl.view = self
  self:ComponentDefine()
  self:DataDefine()
  local heroParams = {}
  self.gm_appearanceId = nil
  heroParams, self.heroUuidList, self.callBack, self.isPreview, self.guideArrowData, self.showFunctionBtn, self.showTip, self.showSkill, self.uniqueWeaponLv = self:GetUserData()
  if type(heroParams) == "table" and heroParams.isGM then
    local gm_heroId = heroParams.heroId
    self.gm_appearanceId = heroParams.appearanceId
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(gm_heroId)
    self.curHeroUuid = heroData.uuid
  else
    self.curHeroUuid, self.heroUuidList, self.callBack, self.isPreview, self.guideArrowData, self.showFunctionBtn, self.showTip, self.showSkill, self.uniqueWeaponLv = self:GetUserData()
  end
  self.ctrl:SetHeroUuid(self.curHeroUuid)
  self:OnOpen()
end

local function OnDestroy(self)
  DataCenter.ArrowManager:RemoveArrow()
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearSound()
  base.OnDestroy(self)
end

local function ScrollGoToPage(self, pageType)
  self:GoToPage(pageType)
end

local function GoToPage(self, pageType)
  if self.curPageType == pageType then
    return
  end
  for i = 1, #self.pageToggles do
    if i == pageType then
      self.pageToggles[i]:SetActiveState(true)
    else
      self.pageToggles[i]:SetActiveState(false)
    end
  end
  self.heroSkillList:SetActive(true)
  self.curPageType = pageType
  self:RefreshSkillFrame(false)
  self:RefreshHeroBaseInfo()
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, "")
  self.animator:Play(CommonUtil.IsArabicAutoMirrorOpen() and "UIHeroExhibitPanel_Arabic" or "UIHeroExhibitPanel", 0, 0)
  self.btnClose = self:AddComponent(UIButton, "Root/BtnBack")
  self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.btnClose:SetActive(false)
  self.gotoFirstViewBg = self:AddComponent(UIButton, "Root/gotoFirstViewBg")
  self.gotoFirstViewBg:SetOnClick(BindCallback(self, self.OnGotoFirstViewBgClick))
  self.btnPreViewClose = self:AddComponent(UIButton, "Root/CenterBottomInfo/BtnPreBack")
  self.btnPreViewClose:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
  self.btnPreCloseText = self:AddComponent(UIText, "Root/CenterBottomInfo/BtnPreBack/PreBackBtnText")
  self.qualityIcon = self:AddComponent(UIImage, heroQualityIconPath)
  self.nameText = self:AddComponent(UIText, heroNameTextPath)
  self.nickNameText = self:AddComponent(UIText, nickNameTextPath)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.heroSkillList = self:AddComponent(UIBaseContainer, heroSkillListPath)
  self.heroSkill1 = self:AddComponent(UIHeroSkillItem, heroSkill1Path)
  self.heroSkill2 = self:AddComponent(UIHeroSkillItem, heroSkill2Path)
  self.heroSkill3 = self:AddComponent(UIHeroSkillItem, heroSkill3Path)
  self.heroSkill4 = self:AddComponent(UIHeroSkillItem, heroSkill4Path)
  self.heroSkills = {
    self.heroSkill1,
    self.heroSkill2,
    self.heroSkill3,
    self.heroSkill4
  }
  self.skillTxt = self:AddComponent(UIText, skillTxtPath)
  self.tipTxt = self:AddComponent(UIText, tipTxtPath)
  self.heroSkillInfo = self:AddComponent(UIBaseContainer, heroSkillInfoPath)
  self.heroLevelText = self:AddComponent(UIText, "Root/RightTopInfo/HeroLevelInfo/HeroLevelText")
  self.atkNumberText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo/AttckInfoNumber/CurAttackText")
  self.hpNumberText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo/HpInfoNumber/CurHpText")
  self.defNumberText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo/DefInfoNumber/CurDefText")
  self.equipAddHpText = self:AddComponent(UIText, equipAddHpTextPath)
  self.equipAddAtkText = self:AddComponent(UIText, equipAddAtkTextPath)
  self.equipAddDefText = self:AddComponent(UIText, equipAddDefTextPath)
  self.atkInfoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/HeroAttackInfo")
  self.atkInfoBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString(HeroUtils.GetHeroPropertyNameId(HeroEffectDefine.PhysicalAttack_Result))
    param.alignObject = self.atkInfoBtn
    param.width = 200
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.hpInfoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/HeroHpInfo")
  self.hpInfoBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString(HeroUtils.GetHeroPropertyNameId(HeroEffectDefine.HealPoint_Result))
    param.alignObject = self.hpInfoBtn
    param.width = 200
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.defInfoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/HeroDefInfo")
  self.defInfoBtn:SetOnClick(function()
    if self.heroData == nil then
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.title = nil
    param.content = Localization:GetString(HeroUtils.GetHeroPropertyNameId(HeroEffectDefine.PhysicalDefense_Result))
    param.alignObject = self.defInfoBtn
    param.width = 200
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.prevHeroBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/ChangeHeroArrow/ToPrevHeroArrow")
  self.prevHeroBtn:SetOnClick(function()
  end)
  self.nextHeroBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/ChangeHeroArrow/ToNextHeroArrow")
  self.nextHeroBtn:SetOnClick(function()
  end)
  self.centerBottomInfo = self:AddComponent(UIBaseContainer, "Root/CenterBottomInfo")
  self.templateHeroContainer = self:AddComponent(UIBaseContainer, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer")
  self.templateHeroGotoBtn = self:AddComponent(UIButton, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroGotoBtn")
  self.templateHeroGotoBtnText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroGotoBtn/TemplateHeroGotoBtnText")
  self.templateHeroText = self:AddComponent(UIText, "Root/CenterBottomInfo/HeroPropertyInfo/TemplateHeroContainer/TemplateHeroText")
  self.templateHeroGotoBtn:SetOnClick(function()
    if self.heroData ~= nil then
      local need = HeroUtils.GetJigsawCost(self.heroData.fragId)
      LWResourceLackUtil:GotoGoodsItemLack(self.heroData.fragId, need)
    end
  end)
  self.templateHeroGotoBtnText:SetLocalText(151112)
  self.templateHeroText:SetLocalText(151111)
  self.bgImg = self:AddComponent(UIImage, bgImgPath)
  self.bgIconImg = self:AddComponent(UIImage, bgIconImgPath)
  self.contentBgImg = self:AddComponent(UIRawImage, contentBgImgPath)
  self.contentBgIconImg = self:AddComponent(UIImage, contentBgIconImgPath)
  self.heroTypeIcon = self:AddComponent(UIImage, heroTypeIconPath)
  self.heroExhibitPreviewPage = self:AddComponent(UIHeroExhibitPreviewPage, heroExhibitPreviewPagePath)
  self.pages = {
    self.heroExhibitPreviewPage
  }
  self.heroExhibitPreviewPageToggle = self:AddComponent(UIHeroDetailPageToggle, heroExhibitPreviewPageTogglePath)
  self.pageToggles = {
    self.heroExhibitPreviewPageToggle
  }
  self.hpTitleText = self:AddComponent(UIText, hpTitleTextPath)
  self.atkTitleText = self:AddComponent(UIText, atkTitleTextPath)
  self.defTitleText = self:AddComponent(UIText, defTitleTextPath)
  self.scrollUIEventListener = self:AddComponent(UIEventTrigger, "Root/CenterHeroInfo/Pages")
  self.scrollRectCenter = self:AddComponent(UIScrollRectCenter, "Root/CenterHeroInfo/Pages")
  self.scrollRectCenter:OnCenterOnChild(BindCallback(self, ScrollGoToPage))
  self.hpTitleText:SetLocalText(154286)
  self.atkTitleText:SetLocalText(154284)
  self.defTitleText:SetLocalText(154285)
  self.skillTxt:SetLocalText(150001)
  self.titleEffectParent = self:AddComponent(UIBaseContainer, titleBgEffectPath)
  self.UrQualityIcon = self:AddComponent(UIBaseContainer, UrQualityIconPath)
  self.SsrQualityIcon = self:AddComponent(UIBaseContainer, SsrQualityIconPath)
  self.urEffectParent = self:AddComponent(UIBaseContainer, urEffectPath)
end

local function DataDefine(self)
  self.heroSpineLoadRequest = nil
  self.heroUpgradeState = -1
  self.curPageType = nil
  self.curSelectedSkillIndex = nil
  self.selectSkillCallBack = BindCallback(self, self.SelectSkillData)
  self.lastSpinePath = nil
  self.hasSetHeroData = false
end

local function ComponentDestroy(self)
  self:RemoveEffect()
  self:RemoveUrEffect()
  self.btnClose = nil
  self.gotoFirstViewBg = nil
  self.btnPreViewClose = nil
  self.btnPreCloseText = nil
  self.qualityIcon = nil
  self.nameText = nil
  self.nickNameText = nil
  self.titleEffectParent = nil
  self.heroSpineContainer = nil
  self.heroSkillList = nil
  self.heroSkill1 = nil
  self.heroSkill2 = nil
  self.heroSkill3 = nil
  self.heroSkill4 = nil
  self.heroSkills = nil
  self.heroLevelText = nil
  self.atkNumberText = nil
  self.hpNumberText = nil
  self.defNumberText = nil
  self.atkInfoBtn = nil
  self.hpInfoBtn = nil
  self.defInfoBtn = nil
  self.urEffectParent = nil
  self.prevHeroBtn = nil
  self.nextHeroBtn = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.centerBottomInfo = nil
  self.templateHeroContainer = nil
  self.templateHeroGotoBtn = nil
  self.templateHeroGotoBtnText = nil
  self.templateHeroText = nil
  self.bgImg = nil
  self.bgIconImg = nil
  self.contentBgImg = nil
  self.contentBgIconImg = nil
  self.heroTypeIcon = nil
  self.heroExhibitPreviewPage = nil
  self.pages = nil
  self.heroExhibitPreviewPageToggle = nil
  self.pageToggles = nil
  self.hpTitleText = nil
  self.atkTitleText = nil
  self.defTitleText = nil
  self.scrollUIEventListener = nil
  self.scrollRectCenter = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.UrQualityIcon = nil
  self.SsrQualityIcon = nil
end

local function DataDestroy(self)
  self.eventHandler = nil
  self.curTabIndex = 0
  self.curHeroUuid = nil
  self.callBack = nil
  self.heroTemplateData = nil
  self.expBookQualityList = nil
  self.heroUpgradeState = nil
  self.upgradeLevel = nil
  self.upgradePower = nil
  self.upgradeAtk = nil
  self.upgradeHp = nil
  self.upgradeDef = nil
  self.lastPower = nil
  self.lastAtk = nil
  self.lastHp = nil
  self.lastDef = nil
  self.curPageType = nil
  self.curSelectedSkillIndex = nil
  self.lastSpinePath = nil
  self.selectSkillCallBack = nil
  self.cachedLayerTransform = nil
  self.hasSetHeroData = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.isPreview == true then
    EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, false)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  if self.isPreview == true then
    EventManager:GetInstance():Broadcast(EventId.ToggleRecruitScene, true)
  end
end

local function RefreshHeroSkills(self)
  for i = 1, 4 do
    local skillData = self.heroData:GetHeroSkillBySlotIndex(i)
    local skillShowRedPoint = false
    if skillData ~= nil and not self.isTemplateHero and not self.isPreview then
      skillShowRedPoint = self.heroData:IsSkillCanUpgrade(skillData)
    end
    self.heroSkills[i]:SetData(skillData, {showSkillName = false, showSkillLevel = true}, self.selectSkillCallBack, false, skillShowRedPoint)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.heroSkillList.transform)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnOpen(self)
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  self.curHeroIndex = table.indexof(self.heroUuidList, self.curHeroUuid)
  self.hasSetHeroData = false
  self:RefreshPage()
  self:CheckPageToggle()
  self:SelectSkill(1)
  self:RefreshSkillFrame(false)
  GoToPage(self, HeroDetailPageType.HeroExhibit)
end

local skillItemWidth = 85

local function SetHeroType(self, heroType)
  if heroType == nil then
    heroType = 1
  end
  heroType = math.min(heroType, 3)
  heroType = math.max(heroType, 1)
  self.heroTypeIcon:LoadSprite(HeroUtils.GetHeroTypeIcon(heroType))
  self.heroTypeIcon:SetNativeSize()
end

local function SetHeroQuality(self, quality)
  if quality == nil then
    quality = 1
  end
  quality = math.min(quality, 5)
  quality = math.max(quality, 1)
  self.qualityIcon:LoadSprite(HeroUtils.GetHeroQualityTagImg(self.heroData.quality))
  self.qualityIcon:SetNativeSize()
  local qualityColor = UIUtil.GetColorByQuality(self.heroData.quality)
  self.bgImg:LoadSprite(HeroExhibitBgPath[quality])
  local path = ""
  if quality == 4 then
    self.contentBgImg:LoadSpriteAuto("Assets/Main/TextureEx/UILWHeroExhibit/purple_gradient_map.png")
    self.UrQualityIcon.gameObject:SetActive(false)
    self.SsrQualityIcon.gameObject:SetActive(true)
    self:ShowEffect(UIAssets.UIHeroDrawCardSSR)
    qualityColor = HeroExhibitBgColorQuality4
    self:RemoveUrEffect()
  elseif quality == 5 then
    self.contentBgImg:LoadSpriteAuto("Assets/Main/TextureEx/UILWHeroExhibit/gold_gradient_map.png")
    qualityColor = HeroExhibitBgColorQuality5
    self.UrQualityIcon.gameObject:SetActive(true)
    self.SsrQualityIcon.gameObject:SetActive(false)
    self:ShowEffect(UIAssets.UIHeroDrawCardUR)
    self:ShowUREffect()
  end
  self.bgIconImg:SetColor(qualityColor)
end

function UIHeroExhibitPanelView:ShowUREffect()
  self:RemoveUrEffect()
  local path = "Assets/Main/Prefabs/UI/UIHero/LWHero/Effect/Eff_ui_heroexhibit_back_ur.prefab"
  local request = ResourceManager:InstantiateAsync(path)
  local par = {}
  par.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.urEffectParent.transform, false)
    local rt = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    rt.anchorMin = Vector2.New(0, 0)
    rt.anchorMax = Vector2.New(1, 1)
    rt.offsetMin = Vector2.New(0, 0)
    rt.offsetMax = Vector2.New(0, 0)
    request.gameObject.transform:Set_localScale(1, 1, 1)
    self.urEffect = par
  end)
end

function UIHeroExhibitPanelView:ShowEffect(path)
  self:RemoveEffect()
  self.allEffect = ResourceManager:InstantiateAsync(path)
  self.allEffect:completed("+", function(req)
    if req.isError then
      return
    end
    req.gameObject:SetActive(true)
    req.gameObject.transform:SetParent(self.titleEffectParent.transform)
    req.gameObject.transform:Set_localPosition(0, 0, 0)
    req.gameObject.transform:Set_localScale(CommonUtil.ArabicAutoMirrorFactor() * 1, 1, 1)
  end)
end

function UIHeroExhibitPanelView:RemoveEffect()
  if self.allEffect ~= nil then
    self.allEffect:Destroy()
    self.allEffect = nil
  end
end

function UIHeroExhibitPanelView:RemoveUrEffect()
  if self.urEffect ~= nil then
    local request = self.urEffect.request
    request:Destroy()
  end
  self.urEffect = nil
end

local function CheckPageToggle(self)
  if self.heroData == nil then
    return
  end
  if self.isTemplateHero == true or self.isPreview == true then
    self.enableEquipFunction = false
    self.scrollRectCenter:Init(0, 0)
    self.scrollRectCenter:CenterOn(1)
    return
  end
  self.scrollRectCenter:Init(0, 0)
  if self.enableEquipFunction == false then
    self.scrollRectCenter:CenterOn(1)
  else
    self.scrollRectCenter:CenterOn(2)
  end
end

local function RefreshHeroBaseInfo(self)
  if self.heroData == nil then
    return
  end
end

local function ClearSound(self)
  if self.soundHandle then
    DataCenter.LWSoundManager:StopSound(self.soundHandle)
    self.soundHandle = nil
  end
  if self.soundHandle2 then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.soundHandle2, 0.1)
    self.soundHandle2 = nil
  end
  if self.soundDelay then
    self.soundDelay:Stop()
    self.soundDelay = nil
  end
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
end

local HeroExtraSound = {
  [50009] = 80010,
  [40020] = 80011,
  [40008] = 80032,
  [40010] = 80033,
  [50023] = 80033,
  [50006] = 80114,
  [50014] = 80115,
  [50015] = 80116,
  [50016] = 80117,
  [50008] = 80118,
  [50010] = 80119,
  [50017] = 80120,
  [50021] = 80123,
  [40018] = 80124,
  [50022] = 80125,
  [40015] = 80126,
  [40007] = 80127,
  [40013] = 80128,
  [40016] = 80129,
  [40012] = 80130,
  [50025] = 80130,
  [40006] = 80131,
  [50018] = 80134,
  [50013] = 80135,
  [50019] = 80136,
  [50020] = 80137,
  [50007] = 80138,
  [40009] = 80139,
  [50027] = 80150,
  [40019] = 80150
}

local function RefreshPage(self)
  self:ClearSound()
  local soundAsset
  local soundDelayTime = 0
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curHeroUuid)
  if self.heroData == nil then
    local itemTemplateData = DataCenter.HeroTemplateManager:GetTemplate(self.curHeroUuid)
    if itemTemplateData ~= nil then
      if self.heroTemplateData == nil then
        self.heroTemplateData = HeroInfo.New()
      end
      self.heroTemplateData:UpdateFromTemplate(toInt(itemTemplateData.id), nil, nil, nil, self.uniqueWeaponLv)
      self.heroData = self.heroTemplateData
      self.isTemplateHero = true
      soundAsset = itemTemplateData.sound_show
      soundDelayTime = itemTemplateData.sound_show_delay
    else
      self.ctrl.CloseSelf()
    end
  else
    self.isTemplateHero = false
    local meta = self.heroData.meta
    if meta then
      soundAsset = meta.sound_show
      soundDelayTime = meta.sound_show_delay
    end
  end
  if not string.IsNullOrEmpty(soundAsset) then
    if 0 < soundDelayTime then
      self.soundDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.soundDelay = nil
        self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
      end, soundDelayTime)
    else
      self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
    end
  end
  self.nameText:SetText(self.heroData:GetBigName())
  self.nickNameText:SetText(self.heroData:GetNickName())
  RefreshHeroBaseInfo(self)
  SetHeroType(self, self.heroData.heroType)
  SetHeroQuality(self, self.heroData.quality)
  if not self.hasSetHeroData then
    self.heroExhibitPreviewPage:SetData(self.heroData, self.gm_appearanceId)
    self.hasSetHeroData = true
  end
  local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.heroData.modelId)
  if self.gm_appearanceId then
    newAppearanceId = self.gm_appearanceId
  end
  local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
  if self.lastSpinePath ~= spinePath then
    if self.heroSpineLoadRequest ~= nil then
      self.heroSpineLoadRequest:Destroy()
      self.heroSpineLoadRequest = nil
    end
    local request = ResourceManager:InstantiateAsync(spinePath)
    self.heroSpineLoadRequest = request
    request:completed("+", function()
      if request.isError or request.gameObject == nil then
        self.heroSpineLoadRequest = nil
        return
      end
      request.gameObject:SetActive(true)
      local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTransform ~= nil then
        local spineScale = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_scale")
        local spinePos = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_pos")
        rectTransform:SetParent(self.heroSpineContainer.transform)
        rectTransform:Set_localScale(spineScale, spineScale, 1)
        rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
        if self.heroData.quality == 5 then
          self.delaySound = TimerManager:GetInstance():DelayInvoke(function()
            self.delaySound = nil
            self.soundHandle = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_HeroRecruit_UR_Logo, false)
          end, 1)
        elseif self.heroData.quality == 4 then
          self.delaySound = TimerManager:GetInstance():DelayInvoke(function()
            self.delaySound = nil
            self.soundHandle = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_HeroRecruit_SSR_Logo, false)
          end, 1)
        end
        local extraSoundId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "hero_showtime_sound_id")
        if extraSoundId ~= 0 then
          self.soundHandle2 = DataCenter.LWSoundManager:PlaySound(extraSoundId, false)
        elseif HeroExtraSound[self.heroData.heroId] then
          self.soundHandle2 = DataCenter.LWSoundManager:PlaySound(HeroExtraSound[self.heroData.heroId], false)
        end
      end
    end)
    self.lastSpinePath = spinePath
  end
  self.centerBottomInfo:SetActive(false)
  self.btnClose:SetActive(false)
  self.btnPreViewClose:SetActive(false)
  self.heroLevelText:SetText(self.heroData.level)
  if self.showSkill == nil or self.showSkill == true then
    self.heroSkillInfo:SetActive(true)
    RefreshHeroSkills(self)
  else
    self.heroSkillInfo:SetActive(false)
  end
  if self.isTemplateHero == true then
    if self.showFunctionBtn == true or self.showFunctionBtn == nil then
      self.templateHeroContainer:SetActive(true)
    else
      self.templateHeroContainer:SetActive(false)
    end
  elseif self.isPreview == true then
    self.btnPreViewClose:SetActive(true)
    self.btnPreCloseText:SetLocalText(800326)
  else
    self.templateHeroContainer:SetActive(false)
  end
  self:CheckArrowBtns()
  self.tipTxt:SetText(self.showTip)
end

local function CheckArrowBtns(self)
end

local function OnBtnCloseClick(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.openTime + 2300 then
    return
  end
  if self.callBack ~= nil then
    self.callBack()
  end
  self.ctrl.CloseSelf()
end

local function OnGotoFirstViewBgClick(self)
  self:OnBtnCloseClick()
end

local function OnHeroUpgradeBtnClick(self)
end

local function SelectSkillData(self, skillData, skillItem)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < self.openTime + 2300 then
    return
  end
  if skillData == nil then
    return
  end
  self:SelectSkill(skillData.slotIndex)
  self:RefreshSkillFrame(false)
  if skillData:IsShowSkillPreviewBtn() then
    local heroId = self.heroData.heroId
    local selectedSkillInfo = self.heroData:GetHeroSkillBySlotIndex(self.curSelectedSkillIndex)
    local skillId = selectedSkillInfo:GetId()
    local skillLv = selectedSkillInfo:GetLevel()
    local skillMaxLv = selectedSkillInfo:GetMaxLevel()
    local weaponLv = self.heroData:GetUniqueWeaponLv()
    local awakenLv = self.heroData:GetHeroAwakenRankLevel()
    local skinId = self.heroData:GetSkinId()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv, weaponLv, awakenLv, skinId)
  end
end

local function SelectSkill(self, skillSlotIndex)
  if skillSlotIndex == nil then
    return
  end
  if skillSlotIndex == self.curSelectedSkillIndex then
    return
  end
  self.curSelectedSkillIndex = skillSlotIndex
end

local function RefreshSkillFrame(self, isShow)
  for i = 1, 4 do
    self.heroSkills[i]:SetSelected(isShow and i == self.curSelectedSkillIndex)
  end
end

local function OnSkillItemClick(self, skillData)
end

UIHeroExhibitPanelView.OnCreate = OnCreate
UIHeroExhibitPanelView.OnDestroy = OnDestroy
UIHeroExhibitPanelView.OnEnable = OnEnable
UIHeroExhibitPanelView.OnDisable = OnDisable
UIHeroExhibitPanelView.OnAddListener = OnAddListener
UIHeroExhibitPanelView.OnRemoveListener = OnRemoveListener
UIHeroExhibitPanelView.ComponentDefine = ComponentDefine
UIHeroExhibitPanelView.DataDefine = DataDefine
UIHeroExhibitPanelView.ComponentDestroy = ComponentDestroy
UIHeroExhibitPanelView.DataDestroy = DataDestroy
UIHeroExhibitPanelView.OnOpen = OnOpen
UIHeroExhibitPanelView.OnBtnCloseClick = OnBtnCloseClick
UIHeroExhibitPanelView.OnGotoFirstViewBgClick = OnGotoFirstViewBgClick
UIHeroExhibitPanelView.CheckArrowBtns = CheckArrowBtns
UIHeroExhibitPanelView.RefreshPage = RefreshPage
UIHeroExhibitPanelView.OnHeroUpgradeBtnClick = OnHeroUpgradeBtnClick
UIHeroExhibitPanelView.OnSkillItemClick = OnSkillItemClick
UIHeroExhibitPanelView.GoToPage = GoToPage
UIHeroExhibitPanelView.ScrollGoToPage = ScrollGoToPage
UIHeroExhibitPanelView.SelectSkill = SelectSkill
UIHeroExhibitPanelView.SelectSkillData = SelectSkillData
UIHeroExhibitPanelView.RefreshHeroBaseInfo = RefreshHeroBaseInfo
UIHeroExhibitPanelView.CheckPageToggle = CheckPageToggle
UIHeroExhibitPanelView.RefreshSkillFrame = RefreshSkillFrame
UIHeroExhibitPanelView.ClearSound = ClearSound
return UIHeroExhibitPanelView
