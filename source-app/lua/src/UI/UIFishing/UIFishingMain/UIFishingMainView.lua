local UIFishingMainView = BaseClass("UIFishingMainView", UIBaseView)
local base = UIBaseView
local Vibrator = CS.Vibrator
local Localization = CS.GameEntry.Localization
local RenderTexture = CS.UnityEngine.RenderTexture
local SceneOffset = 15
local FishSwimToBaitAnimLength = 1800
local FishSpineAnimLength = 8
local ScenePrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/World/FishingScene.prefab"
local FishingSceneCtrl = require("UI.UIFishing.UIFishingMain.FishingSceneCtrl")
local FishingSounds = {
  BGM = 6100002,
  AMB = 6100003,
  REAP = 6100004,
  CONFISCATE = 6100005,
  UNHOOK = 6100006,
  SWING_PRE = 6100007,
  SWING_POST = 6100008,
  HOOK = 6100009,
  STRUGGLE = 6100010,
  IDLE = 6100011,
  BAIT_PANEL = 6100012,
  BAIT_SWITCH = 6100013,
  CAST_BTN = 6100014,
  REEL_IN = 6100015,
  CENTER_HIT = 6100016
}
local State2NameString = {
  [FishingState.None] = "\230\151\160\231\138\182\230\128\129",
  [FishingState.NotStart] = "\230\156\170\229\188\128\229\167\139",
  [FishingState.Charge] = "\232\147\132\229\138\155",
  [FishingState.Wait] = "\231\173\137\229\190\133\228\184\138\233\146\169",
  [FishingState.Early] = "\230\178\161\229\146\172\233\146\169\229\176\177\230\143\144\229\137\141\230\148\182\230\157\134",
  [FishingState.Hook] = "\229\146\172\233\146\169",
  [FishingState.Unhook] = "\232\132\177\233\146\169",
  [FishingState.Reap] = "\230\148\182\232\142\183",
  [FishingState.Confiscate] = "\230\148\182\231\188\180",
  [FishingState.Reward] = "\229\143\145\229\165\150"
}
local Color2EffectPath = {
  [0] = "Assets/Main/SeasonRes/S6/Prefabs/Effect/FishingSliderPerfectEffect.prefab",
  [1] = "Assets/Main/SeasonRes/S6/Prefabs/Effect/FishingSliderGoodEffect.prefab",
  [2] = "Assets/Main/SeasonRes/S6/Prefabs/Effect/FishingSliderMissEffect.prefab"
}
local toggle_text_path = "Content/SubPanelRoot/MainRoot/Bait/ToggleText"
local toggle_path = "Content/SubPanelRoot/MainRoot/Bait/ToggleText/Toggle"
local checkmark_path = "Content/SubPanelRoot/MainRoot/Bait/ToggleText/Toggle/Checkmark"
local toggle_info_path = "Content/SubPanelRoot/MainRoot/Bait/ToggleText/ToggleInfo"
local root_fish_idle_path = "Content/SubPanelRoot/MainRoot/Bait/BtnChangeBait/Eff_ui_s6_fishing_switch_back/root_fish_idle"
local root_fish_loop_path = "Content/SubPanelRoot/MainRoot/Bait/BtnChangeBait/Eff_ui_s6_fishing_switch_back/root_fish_loop"
local eff_ui_s6_fishing_switch_path = "Content/SubPanelRoot/MainRoot/Bait/BtnChangeBait/Eff_ui_s6_fishing_switch"
local top_path = "Content/SubPanelRoot/MainRoot/Top"
local u_i_button_list_path = "Content/SubPanelRoot/MainRoot/UIButtonList"
local eff_ui_s6_fishing_btn_path = "Content/SubPanelRoot/MainRoot/Eff_ui_s6_fishing_btn"
local diaoyu_item_tengwan_path = "diaoyu_item_tengwan"
local rule_btn_path = "Content/SubPanelRoot/MainRoot/UIButtonList/RuleBtn"
local effect_root_path = "Content/SubPanelRoot/MainRoot/EffectRoot"

function UIFishingMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIFishingMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishingMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPondName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textPondOwner = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPondPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnBook = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnBook:SetOnClick(function()
    self:OnBtnBookClick()
  end)
  self.btnBag = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnBag:SetOnClick(function()
    self:OnBtnBagClick()
  end)
  self.compBar = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compBar1 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.compBar0 = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compSlider = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textBubbleTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compBait = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textBaitTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textBaitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.imgBaitIcon = self.viewSkin:AddComponent(self, UIImage, 14)
  self.compBaitBg = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.imgLowBait = self.viewSkin:AddComponent(self, UIImage, 16)
  self.btnLowBait = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnLowBait:SetOnClick(function()
    self:OnBtnLowBaitClick()
  end)
  self.imgHghBait = self.viewSkin:AddComponent(self, UIImage, 18)
  self.btnHghBait = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnHghBait:SetOnClick(function()
    self:OnBtnHghBaitClick()
  end)
  self.btnChangeBait = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnChangeBait:SetOnClick(function()
    self:OnBtnChangeBaitClick()
  end)
  self.imgChangeBaitIcon = self.viewSkin:AddComponent(self, UIImage, 21)
  self.compCountDown = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.btnCast = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnCast:SetOnClick(function()
    self:OnBtnCastClick()
  end)
  self.btnReelIn = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnReelIn:SetOnClick(function()
    self:OnBtnReelInClick()
  end)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.textChangeBaitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.textHighBaitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 27)
  self.textLowBaitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.btnPondPos = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnPondPos:SetOnClick(function()
    self:OnBtnPondPosClick()
  end)
  self.textBookBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 30)
  self.textBagBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 31)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.spineVine = self:AddComponent(UISpine, diaoyu_item_tengwan_path)
  self.spineVine:SetActive(false)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.u_i_button_list = self:AddComponent(UIBaseContainer, u_i_button_list_path)
  self.toggle_text = self:AddComponent(UITextMeshProUGUIEx, toggle_text_path)
  self.toggle_text:SetLocalText("season_mastery_s6_name_3")
  self.toggle = self:AddComponent(UIButton, toggle_path)
  self.toggle:SetOnClick(function()
    self:OnToggleClick()
  end)
  self.checkmark = self:AddComponent(UIImage, checkmark_path)
  self.toggle_info = self:AddComponent(UIButton, toggle_info_path)
  self.toggle_info:SetOnClick(function()
    local times = LuaEntry.Effect:GetGameEffect(EffectDefine.MULTI_THREAD_FISHING)
    UIUtil.ShowBubbleTips(Localization:GetString("season_mastery_s6_tips_1", times, times), self.toggle_info.transform.position, 0, 30, 0, nil, nil, {reversal = true})
  end)
  self.root_fish_idle = self:AddComponent(UIImage, root_fish_idle_path)
  self.root_fish_loop = self:AddComponent(UIImage, root_fish_loop_path)
  self.eff_ui_s6_fishing_switch = self:AddComponent(UIBaseComponent, eff_ui_s6_fishing_switch_path)
  self.eff_ui_s6_fishing_switch:SetActive(false)
  self.eff_ui_s6_fishing_btn = self:AddComponent(UIBaseContainer, eff_ui_s6_fishing_btn_path)
  self.sceneRT = self:AddComponent(UIModelView, "Scene")
  self.sceneRT.transform:Set_localScale(-CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
  self.sceneRT:SetDefaultSceneTrans(Vector3.New(0, SceneOffset, 0))
  self.sceneRT:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.sceneRT:ReInit(ScenePrefabPath)
  self.sceneRT:SetQuality(true, 5)
  self.sceneRT:SetOnLoadSceneHandler(function()
    if self.sceneRT and self.sceneRT:GetCtrl() then
      if not self.fishingSceneCtrl then
        self.fishingSceneCtrl = FishingSceneCtrl.New()
      end
      self.fishingSceneCtrl:Init(self.sceneRT:GetCtrl())
    end
  end)
  self.maskRight = self:AddComponent(UIBaseComponent, "MaskRight")
  self.maskLeft = self:AddComponent(UIBaseComponent, "MaskLeft")
  self.canvasGroup = self:AddComponent(UICanvasGroup, "Content/SubPanelRoot")
  self.canvasGroup:SetAlpha(0)
  self.canvasGroup:SetInteractable(false)
  self.btnReelIn:SetSafeClickMode(true)
  self.btnReelIn:SetSafeClickModeTime(1)
  self.textBubbleTip:SetLocalText("s6_fish_title_1")
  self.textBaitTxt:SetLocalText(393102)
  self.textBookBtn:SetLocalText("s6_fish_title_2")
  self.textBagBtn:SetLocalText("s6_fish_title_3")
  self.rule_btn = self:AddComponent(UIButton, rule_btn_path)
  self.rule_btn:SetOnClick(function()
    self:OnBtnRuleClick()
  end)
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path)
end

function UIFishingMainView:ComponentDestroy()
  if self.sliderEffect then
    self:GameObjectDestroy(self.sliderEffect)
    self.sliderEffect = nil
  end
  if self.sliderEffectTimer then
    self.sliderEffectTimer:Stop()
    self.sliderEffectTimer = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.timer2 then
    self.timer2:Stop()
    self.timer2 = nil
  end
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  if self.fishingSceneCtrl then
    self.fishingSceneCtrl:Destroy()
    self.fishingSceneCtrl = nil
  end
  self.spineVine:JumpToStart()
  self.spineVine = nil
  self.spineFish = nil
  self.viewSkin = nil
  self.textPondName = nil
  self.textPondOwner = nil
  self.textPondPos = nil
  self.btnBook = nil
  self.btnBag = nil
  self.compBar = nil
  self.compBar1 = nil
  self.compBar0 = nil
  self.compSlider = nil
  self.textBubbleTip = nil
  self.compBait = nil
  self.textBaitTxt = nil
  self.textBaitNum = nil
  self.imgBaitIcon = nil
  self.compBaitBg = nil
  self.imgLowBait = nil
  self.btnLowBait = nil
  self.imgHghBait = nil
  self.btnHghBait = nil
  self.btnChangeBait = nil
  self.imgChangeBaitIcon = nil
  self.compCountDown = nil
  self.btnCast = nil
  self.btnReelIn = nil
  self.btnBack = nil
  self.textChangeBaitNum = nil
  self.textHighBaitNum = nil
  self.textLowBaitNum = nil
  self.btnPondPos = nil
  self.textBookBtn = nil
  self.textBagBtn = nil
  self.textCount = nil
end

function UIFishingMainView:DataDefine()
  self.state = FishingState.None
  self.baitLevel = 0
  self.multiThread = false
  self.hookDuration = LuaEntry.DataConfig:TryGetNum("season_pond", "k4", 5) * 1000
  local colorPercent = LuaEntry.DataConfig:TryGetStr("season_pond", "k10", "0.2;0.3;0.5")
  colorPercent = string.split(colorPercent, ";")
  self.colorPercent = {}
  self.colorPercent[0] = tonumber(colorPercent[1])
  self.colorPercent[1] = tonumber(colorPercent[2]) + self.colorPercent[0]
  self.period = LuaEntry.DataConfig:TryGetNum("season_pond", "k11", 0.9)
end

function UIFishingMainView:DataDestroy()
  self.resultServerData = nil
  self.fishSpineAnimCD = nil
end

function UIFishingMainView:OnEnable()
  base.OnEnable(self)
  if self.fishingSceneCtrl then
    self.fishingSceneCtrl:ResumeBGVideo()
  end
end

function UIFishingMainView:OnDisable()
  if self.fishingSceneCtrl then
    self.fishingSceneCtrl:PauseBGVideo()
  end
  if self.struggleSoundSerialId then
    DataCenter.LWSoundManager:StopSound(self.struggleSoundSerialId)
    self.struggleSoundSerialId = nil
  end
  base.OnDisable(self)
end

function UIFishingMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FishAppear, self.OnFishAppear)
  self:AddUIListener(EventId.FishingEnd, self.OnFishingEnd)
  self:AddUIListener(EventId.FishingLoopVideoFirstStart, self.OnFishingLoopVideoFirstStart)
end

function UIFishingMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.FishAppear, self.OnFishAppear)
  self:RemoveUIListener(EventId.FishingEnd, self.OnFishingEnd)
  self:RemoveUIListener(EventId.FishingLoopVideoFirstStart, self.OnFishingLoopVideoFirstStart)
  base.OnRemoveListener(self)
end

function UIFishingMainView:OnFishingLoopVideoFirstStart()
  if not self.spineVine then
    return
  end
  self.fishSpineAnimCD = FishSpineAnimLength
  self.canvasGroup:FadeIn(2)
  self.canvasGroup:SetInteractable(true)
end

function UIFishingMainView:RefreshBait()
  local itemId, cost = DataCenter.FishMetaManager:GetBaitItemIdAndCost(self.baitLevel)
  local have = DataCenter.ItemData:GetItemCount(itemId)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemplate then
    self.imgBaitIcon:LoadSpriteAsync(string.format(LoadPath.ItemPath, itemTemplate.icon))
    self.imgChangeBaitIcon:LoadSpriteAsync(string.format(LoadPath.ItemPath, itemTemplate.icon))
  end
  self.textChangeBaitNum:SetText(have)
  if self.multiThread then
    cost = cost * LuaEntry.Effect:GetGameEffect(EffectDefine.MULTI_THREAD_FISHING)
    cost = toInt(cost)
  end
  self.textBaitNum:SetText("\195\151" .. cost)
end

function UIFishingMainView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function UIFishingMainView:OnBtnPondPosClick()
  if self.jumpWorldPos and self.jumpServerId then
    GoToUtil.GotoWorldPos(self.jumpWorldPos, nil, nil, nil, self.jumpServerId)
    self.ctrl:CloseSelf()
  end
end

function UIFishingMainView:OnToggleClick()
  DataCenter.LWSoundManager:PlaySound(6100021, false)
  local times = LuaEntry.Effect:GetGameEffect(EffectDefine.MULTI_THREAD_FISHING)
  if times <= 1 then
    UIUtil.ShowTipsId("season_mastery_s6_tips_8")
    return
  end
  self.multiThread = not self.multiThread
  self.checkmark:SetActive(self.multiThread)
  self:RefreshBait()
end

function UIFishingMainView:OnBtnLowBaitClick()
  if self.baitLevel ~= 0 then
    self.eff_ui_s6_fishing_switch:SetActive(false)
    self.root_fish_idle:SetActive(false)
    self.root_fish_loop:SetActive(true)
    self.eff_ui_s6_fishing_switch:SetActive(true)
    DataCenter.LWSoundManager:PlaySound(FishingSounds.BAIT_SWITCH, false)
  end
  self.baitLevel = 0
  self:RefreshBait()
  self.compBaitBg:SetActive(false)
end

function UIFishingMainView:OnBtnHghBaitClick()
  if self.baitLevel ~= 1 then
    self.eff_ui_s6_fishing_switch:SetActive(false)
    self.root_fish_idle:SetActive(false)
    self.root_fish_loop:SetActive(true)
    self.eff_ui_s6_fishing_switch:SetActive(true)
    DataCenter.LWSoundManager:PlaySound(FishingSounds.BAIT_SWITCH, false)
  end
  self.baitLevel = 1
  self:RefreshBait()
  self.compBaitBg:SetActive(false)
end

function UIFishingMainView:OnBtnChangeBaitClick()
  local itemId0 = DataCenter.FishMetaManager:GetBaitItemIdAndCost(0)
  local have0 = DataCenter.ItemData:GetItemCount(itemId0)
  local itemTemplate0 = DataCenter.ItemTemplateManager:GetItemTemplate(itemId0)
  if itemTemplate0 then
    self.imgLowBait:LoadSpriteAsync(string.format(LoadPath.ItemPath, itemTemplate0.icon))
  end
  local itemId1 = DataCenter.FishMetaManager:GetBaitItemIdAndCost(1)
  local have1 = DataCenter.ItemData:GetItemCount(itemId1)
  local itemTemplate1 = DataCenter.ItemTemplateManager:GetItemTemplate(itemId1)
  if itemTemplate1 then
    self.imgHghBait:LoadSpriteAsync(string.format(LoadPath.ItemPath, itemTemplate1.icon))
  end
  self.textLowBaitNum:SetText(have0)
  self.textHighBaitNum:SetText(have1)
  local isActive = not self.compBaitBg:GetActive()
  self.compBaitBg:SetActive(isActive)
  if isActive then
    DataCenter.LWSoundManager:PlaySound(FishingSounds.BAIT_PANEL, false)
  end
end

function UIFishingMainView:OnBtnCastClick()
  if self.state == FishingState.NotStart then
    local itemId, cost = DataCenter.FishMetaManager:GetBaitItemIdAndCost(self.baitLevel)
    local have = DataCenter.ItemData:GetItemCount(itemId)
    if self.multiThread then
      cost = cost * LuaEntry.Effect:GetGameEffect(EffectDefine.MULTI_THREAD_FISHING)
      cost = toInt(cost)
    end
    if have < cost then
      UIUtil.ShowTipsId(120021)
    else
      DataCenter.LWSoundManager:PlaySound(FishingSounds.CAST_BTN, false)
      self:EnterState(FishingState.Charge)
    end
  elseif self.state == FishingState.Charge then
    local itemId, cost = DataCenter.FishMetaManager:GetBaitItemIdAndCost(self.baitLevel)
    local have = DataCenter.ItemData:GetItemCount(itemId)
    if self.multiThread then
      cost = cost * LuaEntry.Effect:GetGameEffect(EffectDefine.MULTI_THREAD_FISHING)
      cost = toInt(cost)
    end
    if have < cost then
      UIUtil.ShowTipsId(120021)
    else
      DataCenter.LWSoundManager:PlaySound(FishingSounds.CAST_BTN, false)
      self:EnterState(FishingState.Wait)
    end
  end
end

function UIFishingMainView:OnBtnReelInClick()
  DataCenter.LWSoundManager:PlaySound(FishingSounds.REEL_IN, false)
  if self.state == FishingState.Wait then
    self:Fail(FishingState.Early)
  elseif self.state == FishingState.Hook then
    DataCenter.FishingDataManager:FishingReelIn(self.color or 0)
  end
end

function UIFishingMainView:OnBtnBookClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  local pondId, serverId = DataCenter.FishingDataManager:GetCurPondIdAndServerId()
  if pondId then
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(pondId, serverId)
    if cityTemplate then
      local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBook, {anim = true}, campId, cityTemplate.level)
      return
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBook, {anim = true})
end

function UIFishingMainView:OnBtnBagClick()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishBag, {anim = true})
end

function UIFishingMainView:Init()
  self:EnterState(FishingState.NotStart)
  local pondId, serverId = DataCenter.FishingDataManager:GetCurPondIdAndServerId()
  if not pondId then
    return
  end
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(pondId, serverId)
  if cityTemplate then
    self.textPondName:SetLocalText("s6_pond_name", cityTemplate.level or 1)
    self.jumpServerId = cityTemplate:GetServerIdByEnum(ServerEnum.Source)
    self.jumpWorldPos = SceneUtils.TileToWorld(cityTemplate.pos, ForceChangeScene.World)
    self.textPondPos:SetText(string.format("#%d (%d,%d)", self.jumpServerId, cityTemplate.pos.x, cityTemplate.pos.y))
  else
    self.textPondName:SetText("")
    self.textPondPos:SetText("")
  end
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(pondId, serverId)
  if cityInfo then
    self.textPondOwner:SetText(UIUtil.FormatServerAllianceName(cityInfo.occupyServerId, cityInfo.abbr, cityInfo.allianceName))
  else
    self.textPondOwner:SetText("")
  end
  self.checkmark:SetActive(self.multiThread)
end

function UIFishingMainView:EnterState(state)
  Logger.LogCustom("\231\138\182\230\128\129\232\189\172\230\141\162:" .. State2NameString[self.state] .. "->" .. State2NameString[state], nil, "Fishing")
  if self.state == state then
    return
  end
  if self.struggleSoundSerialId then
    DataCenter.LWSoundManager:StopSound(self.struggleSoundSerialId)
    self.struggleSoundSerialId = nil
  end
  if self.fishingSceneCtrl then
    self.fishingSceneCtrl:EnterState(state)
  end
  self.state = state
  self.stateEnterTime = UITimeManager:GetInstance():GetServerTime()
  self.compBar:SetActive(false)
  self.btnReelIn:SetActive(false)
  self.btnCast:SetActive(false)
  self.eff_ui_s6_fishing_btn:SetActive(false)
  self.compBait:SetActive(false)
  self.root_fish_idle:SetActive(true)
  self.root_fish_loop:SetActive(false)
  self.eff_ui_s6_fishing_switch:SetActive(false)
  self.top:SetActive(false)
  self.u_i_button_list:SetActive(false)
  self.compCountDown:SetActive(false)
  if state == FishingState.NotStart then
    self.btnCast:SetActive(true)
    self.eff_ui_s6_fishing_btn:SetActive(true)
    self.compBait:SetActive(true)
    self.top:SetActive(true)
    self.u_i_button_list:SetActive(true)
    self.compBaitBg:SetActive(false)
    self:RefreshBait()
    self.fishSwimToBaitTime = nil
    self.hookStartTime = nil
    self.hookEndTime = nil
    self.reason = nil
  elseif state == FishingState.Charge then
    DataCenter.LWSoundManager:PlaySound(FishingSounds.SWING_PRE, false)
    self.btnCast:SetActive(true)
    self.eff_ui_s6_fishing_btn:SetActive(true)
    self.compBar:SetActive(true)
    self.compBait:SetActive(true)
    self.top:SetActive(true)
    self.u_i_button_list:SetActive(true)
    self.compBaitBg:SetActive(false)
    self:RefreshBait()
    local width = self.compBar:GetSizeDeltaXY()
    self.compBar0:SetSizeDeltaX(width * self.colorPercent[0])
    self.compBar1:SetSizeDeltaX(width * self.colorPercent[1])
    local startX = -width * CommonUtil.ArabicAutoMirrorFactor() / 2
    local endX = width * CommonUtil.ArabicAutoMirrorFactor() / 2
    self.compSlider:SetAnchoredPositionXY(startX, 0, true)
    if self.tweenSeq then
      self.tweenSeq:Kill()
    end
    self.tweenSeq = DOTween.Sequence()
    self.tweenSeq:Append(self.compSlider.transform:DOAnchorPosX(endX, self.period):SetEase(CS.DG.Tweening.Ease.Linear))
    self.tweenSeq:SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
  elseif state == FishingState.Wait then
    DataCenter.LWSoundManager:PlaySound(DataCenter.SeasonFactionWarDataManager.myCampId == 1 and 6100008 or 6100049, false)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.LWSoundManager:PlaySound(FishingSounds.REEL_IN, false)
      self.btnReelIn:SetActive(true)
    end, 0.5)
    self.eff_ui_s6_fishing_btn:SetActive(true)
    self.hookStartTime = nil
    self.hookEndTime = nil
    if self.tweenSeq then
      self.tweenSeq:Kill()
      self.tweenSeq = nil
    end
    local x = self.compSlider:GetAnchoredPositionX()
    local width = self.compBar:GetSizeDeltaXY()
    local percent = math.abs(x * 2 / width)
    if percent < self.colorPercent[0] then
      self.color = 0
      DataCenter.LWSoundManager:PlaySound(FishingSounds.CENTER_HIT, false)
    elseif percent < self.colorPercent[1] then
      self.color = 1
    else
      self.color = 2
    end
    self:ShowSliderEffect()
    Logger.LogCustom("\233\177\188\231\154\132\233\162\156\232\137\178\239\188\136012\229\175\185\229\186\148\231\153\189\233\187\132\231\129\176\239\188\137:" .. self.color, nil, "Fishing")
    DataCenter.FishingDataManager:FishingCast(self.baitLevel, self.multiThread)
  elseif state == FishingState.Early then
    DataCenter.LWSoundManager:PlaySound(DataCenter.SeasonFactionWarDataManager.myCampId == 1 and 6100006 or 6100048, false)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:EnterState(FishingState.NotStart)
    end, 2.73)
  elseif state == FishingState.Hook then
    DataCenter.LWSoundManager:PlaySound(DataCenter.SeasonFactionWarDataManager.myCampId == 1 and 6100009 or 6100050, false)
    self.struggleSoundSerialId = DataCenter.LWSoundManager:PlaySound(FishingSounds.STRUGGLE, true)
    self.btnReelIn:SetActive(true)
    self.eff_ui_s6_fishing_btn:SetActive(true)
    if self.color == 0 then
      Vibrator.HeavyImpact()
    elseif self.color == 1 then
      Vibrator.MediumImpact()
    elseif self.color == 2 then
      Vibrator.LightImpact()
    end
    self:Update1000MS()
    self.compCountDown:SetActive(true)
  elseif state == FishingState.Unhook then
    DataCenter.LWSoundManager:PlaySound(DataCenter.SeasonFactionWarDataManager.myCampId == 1 and 6100006 or 6100048, false)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:EnterState(FishingState.NotStart)
    end, 2.73)
  elseif state == FishingState.Reap then
    DataCenter.LWSoundManager:PlaySound(DataCenter.SeasonFactionWarDataManager.myCampId == 1 and 6100004 or 6100047, false)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.resultServerData then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishingResult, {anim = true}, self.resultServerData)
      end
    end, 0.6)
    self.timer2 = TimerManager:GetInstance():DelayInvoke(function()
      self:EnterState(FishingState.NotStart)
    end, 1.6)
  elseif state == FishingState.Confiscate then
    DataCenter.LWSoundManager:PlaySound(FishingSounds.CONFISCATE, false)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      if self.resultServerData then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishingResult, {anim = true}, self.resultServerData)
      end
    end, 1)
    self.timer2 = TimerManager:GetInstance():DelayInvoke(function()
      self:EnterState(FishingState.NotStart)
    end, 2)
  elseif state == FishingState.Reward then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:EnterState(FishingState.NotStart)
    end, 1.6)
  end
end

function UIFishingMainView:OnFishAppear(msg)
  self.fishId = msg.fishId
  self.hookStartTime = msg.fishingStartTime
  self.hookEndTime = self.hookStartTime + self.hookDuration
  self.fishSwimToBaitTime = self.hookStartTime - FishSwimToBaitAnimLength
  if self.fishingSceneCtrl then
    self.fishingSceneCtrl:OnFishAppear(self.fishId)
  end
end

function UIFishingMainView:Update()
  if self.state == FishingState.Wait then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.hookEndTime and now > self.hookEndTime then
      self:Fail(FishingState.Unhook)
    elseif self.fishSwimToBaitTime and now > self.fishSwimToBaitTime then
      self.fishSwimToBaitTime = nil
      if self.fishingSceneCtrl then
        self.fishingSceneCtrl:FishSwimToBait()
      end
    elseif self.hookStartTime and now > self.hookStartTime then
      self.hookStartTime = nil
      self:EnterState(FishingState.Hook)
    end
  elseif self.state == FishingState.Hook then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.hookEndTime and now >= self.hookEndTime then
      self:Fail(FishingState.Unhook)
    end
  end
end

function UIFishingMainView:Update1000MS()
  if self.state == FishingState.Charge then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now - self.stateEnterTime >= 30000 then
      self:EnterState(FishingState.NotStart)
    end
  elseif self.state == FishingState.Hook then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.hookEndTime and now < self.hookEndTime then
      local diff = self.hookEndTime - now
      self.textCount:SetText(diff // 1000 + 1)
    end
  end
  if self.fishSpineAnimCD then
    self.fishSpineAnimCD = self.fishSpineAnimCD - 1
    if self.fishSpineAnimCD <= 0 then
      self.fishSpineAnimCD = FishSpineAnimLength
    end
  end
end

function UIFishingMainView:Fail(reason)
  local now = UITimeManager:GetInstance():GetServerTime()
  if reason == FishingState.Unhook then
    Logger.LogCustom("\232\182\133\230\151\182\233\128\154\231\159\165\229\144\142\231\171\175\230\148\182\230\157\134,now:" .. now .. " hookStartTime:" .. (self.hookStartTime or 0) .. " hookEndTime:" .. (self.hookEndTime or 0))
  elseif reason == FishingState.Early then
    Logger.LogCustom("\230\143\144\229\137\141\230\148\182\230\157\134\233\128\154\231\159\165\229\144\142\231\171\175\230\148\182\230\157\134,now:" .. now .. " hookStartTime:" .. (self.hookStartTime or 0) .. " hookEndTime:" .. (self.hookEndTime or 0))
  end
  self.hookStartTime = nil
  self.hookEndTime = nil
  self.reason = reason
  DataCenter.FishingDataManager:FishingReelIn(-1)
end

function UIFishingMainView:OnFishingEnd(msg)
  self.resultServerData = nil
  local fishResArr = msg.fishResArr
  if self.multiThread and fishResArr and 0 < #fishResArr then
    local hasConfiscated = false
    local hasCaught = false
    local itemRewards = {}
    local fishRewards = {}
    local haveCrocodile = false
    for _, res in ipairs(fishResArr) do
      if res.result == 1 then
        hasConfiscated = true
      elseif res.result == 2 then
        hasCaught = true
      end
      if res.reward and 0 < #res.reward then
        for _, r in ipairs(res.reward) do
          table.insert(itemRewards, r)
        end
      end
      if not res.reward and res.fishId then
        if not haveCrocodile and DataCenter.FishMetaManager:IsCrocodile(res.fishId) then
          haveCrocodile = true
        end
        table.insert(fishRewards, {
          rewardType = RewardType.FISH,
          itemId = res.fishId,
          count = 1,
          isFish = true,
          isConfiscate = res.result == 1
        })
      end
    end
    if hasConfiscated then
      self:EnterState(FishingState.Confiscate)
    elseif hasCaught then
      self:EnterState(FishingState.Reap)
    else
      if self.reason == FishingState.Early then
        self.reason = nil
        self:EnterState(FishingState.Early)
      else
        self:EnterState(FishingState.Unhook)
      end
      return
    end
    local rewardList = {}
    if 0 < #itemRewards then
      local rewardMsg = {reward = itemRewards}
      DataCenter.RewardManager:AddRewardsAndRes(rewardMsg)
      rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(itemRewards) or {}
    end
    if not haveCrocodile then
      rewardList = table.mergeArray(rewardList, fishRewards)
      local windowsParam = {}
      for _, res in ipairs(fishResArr) do
        if res.updateWeight then
          table.insert(windowsParam, SafePack(UIWindowNames.UIFishingResult, {anim = true}, res))
        end
      end
      if 0 < #windowsParam then
        table.insert(windowsParam, 1, SafePack(UIWindowNames.UIFishingReward, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, {
          rewardList = rewardList,
          title = Localization:GetString("128027")
        }))
        DataCenter.UIChainWindowManager:OpenWindowsChain(windowsParam)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFishingReward, {
          anim = true,
          playEffect = false,
          UIMainAnim = UIMainAnimType.LeftRightBottomHide
        }, {
          rewardList = rewardList,
          title = Localization:GetString("128027")
        })
      end
    end
    return
  end
  if msg.escape == 1 then
    if self.reason == FishingState.Early then
      self.reason = nil
      self:EnterState(FishingState.Early)
    else
      self:EnterState(FishingState.Unhook)
    end
  else
    local singleRes = fishResArr and fishResArr[1]
    if not singleRes then
      Logger.LogError("FishingEnd singleRes is nil")
      return
    end
    local notCrocodile = not DataCenter.FishMetaManager:IsCrocodile(singleRes.fishId)
    if singleRes.result == 1 then
      self.resultServerData = notCrocodile and singleRes
      self:EnterState(FishingState.Confiscate)
    elseif singleRes.result == 2 then
      if singleRes.reward and 0 < #singleRes.reward then
        self:EnterState(FishingState.Reward)
        DataCenter.RewardManager:AddRewardsAndRes(singleRes)
        DataCenter.RewardManager:ShowCommonReward(singleRes)
      else
        self.resultServerData = notCrocodile and singleRes
        self:EnterState(FishingState.Reap)
      end
    end
  end
end

function UIFishingMainView:OnBtnRuleClick()
  DataCenter.LWSoundManager:PlaySound(6100024, false)
  local param = {}
  param.howToPlayList = {600006}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UIFishingMainView:ShowSliderEffect()
  if self.sliderEffectTimer then
    self.sliderEffectTimer:Stop()
    self.sliderEffectTimer = nil
  end
  if self.sliderEffect then
    self:GameObjectDestroy(self.sliderEffect)
    self.sliderEffect = nil
  end
  self.sliderEffect = self:GameObjectInstantiateAsync(Color2EffectPath[self.color], function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local trans = go.transform
    trans:SetParent(self.effect_root.transform)
    trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    trans:Set_anchoredPosition(0, 0, 0)
    self.sliderEffectTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.sliderEffect then
        self:GameObjectDestroy(self.sliderEffect)
        self.sliderEffect = nil
      end
    end, 2)
  end)
end

return UIFishingMainView
