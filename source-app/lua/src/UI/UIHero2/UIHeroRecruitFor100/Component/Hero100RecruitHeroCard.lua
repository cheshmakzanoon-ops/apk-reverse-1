local Hero100RecruitHeroCard = BaseClass("Hero100RecruitHeroCard", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroCellBig = require("UI.UIHero2.UIHeroRecruitRewardNew.Component.UIHeroRecruitCellBig")
local UIItemCell = require("UI.UIHero2.Common.UIItemCell")
local UIWorkerShowCell = require("UI.UILWWorker.UIWorkerOverviewList.Component.UIWorkerShowCell")
local Resource = CS.GameEntry.Resource
local eff_ui_recruit_jinsuiglow_path = "Root/InfoPanel/RepeatItemEffHangPoint"
local cover_eff_hang_up_point_path = "Root/CoverPanel/CoverEffHangUpPoint"
local cover_panel_path = "Root/CoverPanel"
local node_effect_root_1_path = "Root/NodeEffectRoot_1"
local doudong_effect_2_hero_path = "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/doudong_effect_2/doudong_effect_2_hero"
local fanpai_effect_2_hero_path = "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/fanpai_effect_2/fanpai_effect_2_hero"
local changzhu_effect_2_hero_path = "Root/InfoPanel/heroContent/UIHeroCellBig/NodeEffectRoot/changzhu_effect_2/changzhu_effect_2_hero"
local doudong_effect_2_worker_path = "Root/InfoPanel/workerContent/UIWorkerShowCell/Root/NodeEffectRoot/doudong_effect_2/doudong_effect_2_worker"
local fanpai_effect_2_worker_path = "Root/InfoPanel/workerContent/UIWorkerShowCell/Root/NodeEffectRoot/fanpai_effect_2/fanpai_effect_2_worker"
local changzhu_effect_2_worker_path = "Root/InfoPanel/workerContent/UIWorkerShowCell/Root/NodeEffectRoot/changzhu_effect_2/changzhu_effect_2_worker"
local u_i_worker_show_cell_path = "Root/InfoPanel/workerContent/UIWorkerShowCell"
local eff_hero100_recruit_cardfly_point_path = "Root/Eff_Hero100Recruit_Cardfly_Point"
local flipTime = 0.3
local chipTime = 0.1
local chipConvertTime = 0.25
local NORMAL_NEW_CARD_SHAKE_FLIP_TiME = 1.5
local GOLD_CARD_SHAKE_FLIP_TIME = 1
local NORMAL_FLIP_EFF_SHOW_DELAY_TIME = 0.33
local GOLD_FLIP_EFF_SHOW_DELAY_TIME = 1.033
local CARD_FLY_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_Hero100Recruit_Cardfly.prefab"
local COVER_BG_EFF_PATH_CONFIG = {
  [HeroQualityType.Genius] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_zi_beiguang_01.prefab",
  [HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_UIHero100Recruit_goldcard_idolbg.prefab"
}
local COVER_FRONT_EFF_PATH_CONFIG = {
  [HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIHero100Recruit_goldcard_idol.prefab"
}
local NEW_CARD_PATH_CONFIG_1 = {
  [HeroQualityType.Genius] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_zi_juguang_02.prefab",
  [HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_cheng_juguang_02.prefab"
}
local NEW_CARD_PATH_CONFIG_2 = {
  [HeroQualityType.Genius] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_zi_beiguang_02.prefab",
  [HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_cheng_beiguang_02.prefab"
}
local FLIP_PATH_CONFIG = {
  [HeroQualityType.Genius] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_zi_fanpai.prefab",
  [HeroQualityType.Legendary] = "Assets/_Art_LastWar/Effect/Prefab/UI/Chouka/Eff_ui_chouka_cheng_fanpai.prefab"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.rootNode = self:AddComponent(UIBaseContainer, "Root")
  self.rootCanvasGroup = self:AddComponent(UICanvasGroup, "Root")
  self.rootAni = self:AddComponent(UISimpleAnimation, "")
  self.rootAni:Enable(false)
  self.infoPanelGroup = self:AddComponent(UICanvasGroup, "Root/InfoPanel")
  self.coverPanelGroup = self:AddComponent(UICanvasGroup, cover_panel_path)
  self.heroContent = self:AddComponent(UICanvasGroup, "Root/InfoPanel/heroContent")
  self.workerContent = self:AddComponent(UICanvasGroup, "Root/InfoPanel/workerContent")
  self.itemContent = self:AddComponent(UICanvasGroup, "Root/InfoPanel/itemContent")
  self.heroCell = self:AddComponent(UIHeroCellBig, "Root/InfoPanel/heroContent/UIHeroCellBig")
  self.itemCell = self:AddComponent(UIItemCell, "Root/InfoPanel/itemContent/UIItemCell")
  self.itemNum = self:AddComponent(UIText, "Root/InfoPanel/itemContent/itemNum")
  self.nameTxt = self:AddComponent(UIText, "Root/InfoPanel/nameTxtMask/nameTxt")
  self.bg = self:AddComponent(UIImage, "Root/InfoPanel/bg")
  self.frontMask = self:AddComponent(UIImage, "Root/InfoPanel/frontMask")
  self.btn = self:AddComponent(UIButton, "")
  self.u_i_worker_show_cell = self:AddComponent(UIWorkerShowCell, u_i_worker_show_cell_path)
  self.eff_hero100_recruit_cardfly = self:AddComponent(UIVfx, eff_hero100_recruit_cardfly_point_path, CARD_FLY_EFF_PATH, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.repeatHeroEffectObj = self:AddComponent(UIBaseContainer, eff_ui_recruit_jinsuiglow_path)
  self.btn:SetOnClick(BindCallback(self, self.OnCellClick))
end

local function ComponentDestroy(self)
  self:ClearAllDynamicEff()
end

local function DataDefine(self)
  self.data = nil
  self.isFlipped = false
  self.dataIndex = nil
  self.heroUuid = nil
  self.heroId = nil
  self.nextCardItem = nil
  self.isShowHeroExhibit = false
  self.showChipConvertTimer = nil
  self.isNeedShowChipConvertAni = false
  self.flipEffShowDelayTimer = nil
  self.allEffGenDic = {}
end

local function DataDestroy(self)
  self:StopAllTimer()
  self.data = nil
  self.isFlipped = false
  self.dataIndex = nil
  self.heroUuid = nil
  self.heroId = nil
  self.nextCardItem = nil
  self.isShowHeroExhibit = nil
  self.showChipConvertTimer = nil
  self.isNeedShowChipConvertAni = nil
  self.flipEffShowDelayTimer = nil
  self.allEffGenDic = nil
end

local function UpdateView_Hero(self)
  local data = self.data
  local type = data.type
  self.rewardType = type
  self.repeatHeroUuid = type == 2
  if type == 0 then
    self:RefreshHeroUI(data)
  elseif type == 2 then
    self:RefreshHeroChipUI(data)
  else
    self:SetItemQualityView(6)
    self.nameTxt:SetText("")
  end
  if self.isFlipped then
    self:SetCardView()
  else
    self:SetCoverView()
  end
end

function Hero100RecruitHeroCard:ShowCardFlyEff()
  self.eff_hero100_recruit_cardfly:Replay()
end

local function UpdateView_Worker(self)
  local data = self.data
  local type = data.type
  self.rewardType = type
  if self.rewardType == RewardType.WORKER then
    self.workerContent:SetAlpha(1)
    local workerId = data.value.workerId
    self.u_i_worker_show_cell:SetData(workerId)
    local temp = DataCenter.WorkerTemplateManager:GetShowTemplateById(workerId)
    self.quality = temp.quality
    self.isPurpleHero = self.quality == HeroQualityType.Genius
    self.isOrangeHero = self.quality == HeroQualityType.Legendary
    self.nameTxt:SetText(temp:GetName())
    self:SetItemQualityView(self.quality)
    self:SetHeroEffectShow_New(self.quality)
  elseif self.rewardType == RewardType.GOODS then
    self.itemContent:SetAlpha(1)
    local itemId = tonumber(data.value.id)
    local add = data.value.num
    self.itemCell:SetData(RewardType.GOODS, itemId, add)
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    local color = itemTemplate.color
    local workerTemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(tonumber(itemTemplate.para2))
    self.quality = workerTemplate.quality
    self.isPurpleHero = self.quality == HeroQualityType.Genius
    self.isOrangeHero = self.quality == HeroQualityType.Legendary
    self:SetItemQualityView(color)
    self:SetHeroEffectShow_New(color)
    self.nameTxt:SetText(DataCenter.RewardManager:GetNameByType(RewardType.GOODS, itemId))
    self.itemNum:SetText("x" .. add)
  else
    self:SetItemQualityView(6)
    self.nameTxt:SetText("")
  end
  if self.isFlipped then
    self:SetCardView()
  else
    self:SetCoverView()
  end
end

function Hero100RecruitHeroCard:RefreshHeroUI(data)
  local heroUuid = data.uuid
  self.heroContent:SetAlpha(1)
  self.heroCell:SetData(heroUuid)
  self.heroCell:DisableRedPoint()
  self.heroUuid = heroUuid
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  self.quality = heroData.quality
  self.isPurpleHero = heroData.quality == HeroQualityType.Genius
  self.isOrangeHero = heroData.quality == HeroQualityType.Legendary
  self.nameTxt:SetText(heroData:GetName())
  self:SetItemQualityView(heroData.quality)
  self:SetHeroEffectShow_New(heroData.quality)
  if self.isFlipped then
    self.heroContent:SetAlpha(1)
    self.itemContent:SetAlpha(0)
  end
  self.isShowHeroExhibit = false
  if self.heroUuid ~= nil and not self.repeatHeroUuid and not self.isFlipped then
    self.isShowHeroExhibit = DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroUuid)
  end
end

function Hero100RecruitHeroCard:RefreshHeroChipUI(data)
  self.isNeedShowChipConvertAni = true
  self:RefreshHeroUI(data)
  local id = data.GoodsId
  local num = data.addNumber
  self.heroId = tonumber(data.fromHero)
  self.heroId = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.heroId)
  self.itemCell:SetData(RewardType.GOODS, id, num)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  local color = itemTemplate.color
  self:SetItemQualityView(color)
  self.nameTxt:SetText(DataCenter.RewardManager:GetNameByType(RewardType.GOODS, id))
  self.itemNum:SetText("x" .. num)
  if self.heroId ~= nil then
    self:SetHeroEffectShow_New(color)
  end
  if self.isFlipped then
    self.heroContent:SetAlpha(0)
    self.itemContent:SetAlpha(1)
  end
end

local function SetItemQualityView(self, quality)
  if quality == 6 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 2))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 1))
    self.nameTxt:SetColorRGBA(1, 0.675, 0.6, 1)
  elseif quality == 5 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 4))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 3))
    self.nameTxt:SetColorRGBA(1, 0.808, 0.294, 1)
  elseif quality == 4 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 6))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 5))
    self.nameTxt:SetColorRGBA(0.988, 0.616, 1, 1)
  elseif quality == 3 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 8))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 7))
    self.nameTxt:SetColorRGBA(0.439, 0.902, 0.945, 1)
  elseif quality == 2 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 10))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 9))
    self.nameTxt:SetColorRGBA(0.302, 0.961, 0.69, 1)
  elseif quality == 1 then
    self.bg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 12))
    self.frontMask:LoadSprite(string.format("Assets/Main/Sprites/UI/UIHeroRecruit/cfm_chouka_ka_%s.png", 11))
    self.nameTxt:SetColorRGBA(1, 1, 1, 1)
  end
end

function Hero100RecruitHeroCard:SetHeroEffectShow_New(quality)
  local eff4Path = NEW_CARD_PATH_CONFIG_1[quality]
  self:ShowEffect(eff4Path, nil)
  local eff6Path = NEW_CARD_PATH_CONFIG_2[quality]
  self:ShowEffect(eff6Path, nil)
end

local function SetHeroEffectShow(self, quality)
end

local function CloseAllEffectShow(self)
end

local function OnCellClick(self)
  if self.callBackFunc ~= nil then
    self.callBackFunc()
  end
end

local function SetCoverView(self)
  self.coverPanelGroup:SetAlpha(1)
  self.infoPanelGroup:SetAlpha(0)
  self.repeatHeroEffectObj:SetActive(false)
  if self.isOrangeHero then
    local coverBGEff = COVER_BG_EFF_PATH_CONFIG[self.quality]
    self:ShowEffect(coverBGEff, nil)
  end
  local coverFrontEff = COVER_FRONT_EFF_PATH_CONFIG[self.quality]
  self:ShowEffect(coverFrontEff, nil)
  self.rootAni:Play("Idle")
end

local function SetCardView(self)
  self:SetNormalView()
  self.repeatHeroEffectObj:SetActive(false)
  local playAniName = self.isOrangeHero and "OrangeCard" or "PurpleCard"
  self.rootAni:SampleAnimationAtTime(playAniName, 1)
end

local function SetNormalView(self)
  self.coverPanelGroup:SetAlpha(0)
  self.infoPanelGroup:SetAlpha(1)
end

local function PlayNewHeroOpenAni(self)
  local playAniName = self.isOrangeHero and "OrangeCard" or "PurpleCard"
  self.rootAni:Enable(true)
  local _, aniTime = self.rootAni:PlayAnimationReturnTime(playAniName)
  local flipTime = self.isOrangeHero and GOLD_CARD_SHAKE_FLIP_TIME or NORMAL_NEW_CARD_SHAKE_FLIP_TiME
  local showExhibitRatio = self.isOrangeHero and 0.7 or 0.8
  self.hideCoverAreaTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:SetNormalView()
  end, flipTime)
  local showHeroExhibitDelayTime = aniTime * showExhibitRatio
  self.waitShakeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ShowHeroExhibitAni()
  end, showHeroExhibitDelayTime)
  if not self.isOrangeHero then
    local coverBGEff = COVER_BG_EFF_PATH_CONFIG[self.quality]
    self:ShowEffect(coverBGEff, nil)
  end
  self:ShowFlipEff()
end

local function PlayRepeatHeroOpenAni(self)
  self:ShowFlipEff()
  local playAniName = self.isOrangeHero and "OrangeCard" or "FlipCard"
  self.rootAni:Enable(true)
  local _, aniTime = self.rootAni:PlayAnimationReturnTime(playAniName)
  local needTime = self.isOrangeHero and GOLD_CARD_SHAKE_FLIP_TIME or flipTime
  self.hideCoverAreaTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:SetNormalView()
    local eff = self.isOrangeHero and SoundAssetId.Recruit100OrangeFlip or SoundAssetId.Recruit100NormalFlip
    DataCenter.LWSoundManager:PlayEffect(eff)
  end, needTime)
  if self.isHeroDraw then
    if self.isNeedShowChipConvertAni then
      self.showChipConvertTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.heroContent:SetAlpha(0)
        self.itemContent:SetAlpha(1)
        self.repeatHeroEffectObj:SetActive(true)
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Recruit100CardConvert)
      end, needTime + chipConvertTime)
    end
  else
    self.showChipConvertTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.repeatHeroEffectObj:SetActive(true)
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Recruit100CardConvert)
    end, needTime)
  end
  local nextCardFlipTime = needTime
  return nextCardFlipTime
end

function Hero100RecruitHeroCard:ShowFlipEff()
  local flipEffShowDelayTime = self.isOrangeHero and GOLD_FLIP_EFF_SHOW_DELAY_TIME or NORMAL_FLIP_EFF_SHOW_DELAY_TIME
  self.flipEffShowDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    local eff5Path = FLIP_PATH_CONFIG[self.quality]
    self:ShowEffect(eff5Path, nil)
  end, flipEffShowDelayTime)
end

local function ShowHeroExhibitAni(self)
  if self.heroUuid then
    local showTip = ""
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, self.heroUuid, {
      self.heroUuid
    }, nil, true, nil, nil, showTip)
  end
end

local function SetData(self, data, isHeroDraw, callBackFunc)
  self.data = data.heroData
  self.isFlipped = data.isFlipped
  self.dataIndex = data.dataIndex
  self.isHeroDraw = isHeroDraw
  self.callBackFunc = callBackFunc
  self:InitCardState()
  self:InitAllEffGenDic()
  self:ClearAllDynamicEff()
  self.workerContent:SetAlpha(0)
  self.heroContent:SetAlpha(0)
  self.itemContent:SetAlpha(0)
  if self.isHeroDraw then
    self.heroUuid = nil
    self.heroId = nil
    self:UpdateView_Hero()
  else
    self:UpdateView_Worker()
  end
end

function Hero100RecruitHeroCard:InitCardState()
  if self.isFlipped then
    self.rootAni:SampleAnimationAtTime("FlipCard", 1)
  else
    self.rootAni:SampleAnimationAtTime("FlipCard", 0)
  end
  self.rootNode:SetActive(true)
  self.rootCanvasGroup:SetAlpha(1)
  self.rootNode:SetLocalScaleXYZ(1, 1, 1)
  self.rootNode:SetEulerAnglesXYZ(0, 0, 0)
end

function Hero100RecruitHeroCard:InitAllEffGenDic()
  self.allEffGenDic = self.allEffGenDic or {}
  if table.count(self.allEffGenDic) > 0 then
    return
  end
  self.coverEffBG = self:AddComponent(UIVfx, node_effect_root_1_path, nil, {
    lifeType = UIVfxLifeType.Stay
  })
  self.allEffGenDic[COVER_BG_EFF_PATH_CONFIG[HeroQualityType.Genius]] = self.coverEffBG
  self.allEffGenDic[COVER_BG_EFF_PATH_CONFIG[HeroQualityType.Legendary]] = self.coverEffBG
  self.coverEffFront = self:AddComponent(UIVfx, cover_eff_hang_up_point_path, nil, {
    lifeType = UIVfxLifeType.Stay
  })
  self.allEffGenDic[COVER_FRONT_EFF_PATH_CONFIG[HeroQualityType.Legendary]] = self.coverEffFront
  local effect4Path = self.isHeroDraw and doudong_effect_2_hero_path or doudong_effect_2_worker_path
  self.effect4 = self:AddComponent(UIVfx, effect4Path, nil, {
    lifeType = UIVfxLifeType.Stay
  })
  self.allEffGenDic[NEW_CARD_PATH_CONFIG_1[HeroQualityType.Genius]] = self.effect4
  self.allEffGenDic[NEW_CARD_PATH_CONFIG_1[HeroQualityType.Legendary]] = self.effect4
  local effect5Path = self.isHeroDraw and fanpai_effect_2_hero_path or fanpai_effect_2_worker_path
  self.effect5 = self:AddComponent(UIVfx, effect5Path, nil, {
    lifeType = UIVfxLifeType.DestroyAfterOnce
  })
  self.allEffGenDic[FLIP_PATH_CONFIG[HeroQualityType.Genius]] = self.effect5
  self.allEffGenDic[FLIP_PATH_CONFIG[HeroQualityType.Legendary]] = self.effect5
  local effect6Path = self.isHeroDraw and changzhu_effect_2_hero_path or changzhu_effect_2_worker_path
  self.effect6 = self:AddComponent(UIVfx, effect6Path, nil, {
    lifeType = UIVfxLifeType.Stay
  })
  self.allEffGenDic[NEW_CARD_PATH_CONFIG_2[HeroQualityType.Genius]] = self.effect6
  self.allEffGenDic[NEW_CARD_PATH_CONFIG_2[HeroQualityType.Legendary]] = self.effect6
end

function Hero100RecruitHeroCard:ClearAllDynamicEff()
  if IsNull(self.coverEffBG) then
    return
  end
  self.coverEffBG:ClearRes()
  self.coverEffFront:ClearRes()
  self.effect4:ClearRes()
  self.effect5:ClearRes()
  self.effect6:ClearRes()
end

local function PlayShowAni(self)
  self:StopAllTimer()
  if self.isShowHeroExhibit then
    self:PlayNewHeroOpenAni()
    self:PlayExhibitSoundEff()
    return nil
  end
  local dutation = self:PlayRepeatHeroOpenAni()
  local isRepeatHeroChip
  if self.isHeroDraw then
    isRepeatHeroChip = self.data.type == 2
    if isRepeatHeroChip then
      dutation = dutation + chipTime
    end
  else
    isRepeatHeroChip = self.data.type == RewardType.GOODS
  end
  local w, h = self:GetSizeDeltaXY()
  local cardTopPos = Vector3.New(self.transform.position.x, self.transform.position.y + h / 2, self.transform.position.z)
  local screenPos = PosConverse.UIWorldToScreenPos(cardTopPos)
  return dutation, screenPos, isRepeatHeroChip
end

local function PlayExhibitSoundEff(self)
  local effId = self.isOrangeHero and SoundAssetId.Recruit100OrangeFlip or SoundAssetId.Recruit100NormalFlip
  DataCenter.LWSoundManager:PlayEffect(effId)
end

function Hero100RecruitHeroCard:StopAllTimer()
  if self.waitShakeTimer then
    self.waitShakeTimer:Stop()
    self.waitShakeTimer = nil
  end
  if self.showChipConvertTimer then
    self.showChipConvertTimer:Stop()
    self.showChipConvertTimer = nil
  end
  if self.hideCoverAreaTimer then
    self.hideCoverAreaTimer:Stop()
    self.hideCoverAreaTimer = nil
  end
  if self.flipEffShowDelayTimer then
    self.flipEffShowDelayTimer:Stop()
    self.flipEffShowDelayTimer = nil
  end
end

function Hero100RecruitHeroCard:ShowEffect(effPath, duration)
  if not effPath then
    return
  end
  local showEff = self.allEffGenDic[effPath]
  if not showEff then
    return
  end
  local params
  if duration then
    params = {}
    params.duration = duration
    showEff:Play(effPath, params)
  else
    showEff:PlayByStay(effPath)
  end
end

function Hero100RecruitHeroCard:SetIsFlippedState(state)
  self.isFlipped = state
  if self.view and self.view.heroRowContent then
    self.view.heroRowContent:SetCardIsFlippedState(self.dataIndex, state)
  end
end

Hero100RecruitHeroCard.OnCreate = OnCreate
Hero100RecruitHeroCard.OnDestroy = OnDestroy
Hero100RecruitHeroCard.OnEnable = OnEnable
Hero100RecruitHeroCard.OnDisable = OnDisable
Hero100RecruitHeroCard.ComponentDefine = ComponentDefine
Hero100RecruitHeroCard.ComponentDestroy = ComponentDestroy
Hero100RecruitHeroCard.DataDefine = DataDefine
Hero100RecruitHeroCard.DataDestroy = DataDestroy
Hero100RecruitHeroCard.UpdateView_Hero = UpdateView_Hero
Hero100RecruitHeroCard.UpdateView_Worker = UpdateView_Worker
Hero100RecruitHeroCard.OnCellClick = OnCellClick
Hero100RecruitHeroCard.SetCoverView = SetCoverView
Hero100RecruitHeroCard.SetCardView = SetCardView
Hero100RecruitHeroCard.SetNormalView = SetNormalView
Hero100RecruitHeroCard.PlayNewHeroOpenAni = PlayNewHeroOpenAni
Hero100RecruitHeroCard.ShowHeroExhibitAni = ShowHeroExhibitAni
Hero100RecruitHeroCard.SetData = SetData
Hero100RecruitHeroCard.SetHeroEffectShow = SetHeroEffectShow
Hero100RecruitHeroCard.CloseAllEffectShow = CloseAllEffectShow
Hero100RecruitHeroCard.SetItemQualityView = SetItemQualityView
Hero100RecruitHeroCard.PlayShowAni = PlayShowAni
Hero100RecruitHeroCard.PlayExhibitSoundEff = PlayExhibitSoundEff
Hero100RecruitHeroCard.PlayRepeatHeroOpenAni = PlayRepeatHeroOpenAni
return Hero100RecruitHeroCard
