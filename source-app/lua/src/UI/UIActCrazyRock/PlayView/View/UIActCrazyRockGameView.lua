local UIActCrazyRockGameView = BaseClass("UIActCrazyRockGameView", UIBaseView)
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local RockGamePlayerComponent = require("UI.UIActCrazyRock.PlayView.Component.RockGamePlayerComponent")
local UIModelView = require("Framework.UI.Component.UIModelView")
local RockGamePlayerAniMachine = require("UI.UIActCrazyRock.PlayView.Component.AniMachine.RockGamePlayerAniMachine")
local RockGameMonsterAniMachine = require("UI.UIActCrazyRock.PlayView.Component.AniMachine.RockGameMonsterAniMachine")
local GameQualitySettings = require("Util.GameQualitySettings")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NeedLoadWaitRefreshSkinType = {
  SingleNoteImg = 1,
  ContinueNoteFrameImg1 = 2,
  ContinueNoteFrameImg2 = 3,
  ContinueNoteEff = 4
}
local rock_game_player_path = "root/RockGamePlayer"
local song_progress_path = "root/SongProgress"
local score_value_text_path = "root/ScoreArea/ScoreValueText"
local node_combo_path = "root/Bg/node_combo"
local combo_value_text_path = "root/Bg/node_combo/ComboValueText"
local normal_evn_eff_path = "root/Bg/VX_enviroment/NormalEvnEff"
local continue_evn_eff_path = "root/Bg/VX_enviroment/ContinueEvnEff"
local game_r_t_path = "root/GameRT"
local score_add_root_path = "root/ScoreArea/ScoreValueText/ScoreAddRoot"
local song_name_text_path = "root/ScoreArea/SongNameText"
local score_text_path = "root/ItemRoot/ScoreText"
local score_area_path = "root/ScoreArea"
local colon_text_path = "root/ScoreArea/ColonText"
local btn_back_path = "root/BottomBar/BtnBack"
local offset_top_area_path = "root/OffsetTopArea"
local offset_info_btn_path = "root/OffsetTopArea/OffsetInfoBtn"
local pause_root_path = "root/PauseRoot"
local quit_btn_path = "root/PauseRoot/layout/QuitBtn"
local continue_btn_path = "root/PauseRoot/layout/ContinueBtn"
local keep_clicking_path = "root/KeepClicking"
local player_point_path = "ModelRoot/PlayerPoint"
local monster_point_path = "ModelRoot/MonsterPoint"
local p_c_desc_path = "root/PCDesc"
local eff_yyj_sangshi_dianliu1_path = "root/Bg/Line/ElectricityEffPool/Eff_yyj_sangshi_dianliu1"
local eff_yyj_sangshi_dianliu2_path = "root/Bg/Line/ElectricityEffPool/Eff_yyj_sangshi_dianliu2"
local eff_yyj_sangshi_dianliu3_path = "root/Bg/Line/ElectricityEffPool/Eff_yyj_sangshi_dianliu3"
local SCENE_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActMusicFestival2025/ActCrazyRock/GamePlayScene/MusicSceneRoot.prefab"
local BLANK_TIME = 3000
local SCORE_ROLL_TIME = 1
local OFFSET_DISAPPEAR_EFF_DURATION = 3
local NOTE_OFFSET_INTERVAL = 5
local OFFSET_NOTE_SPRITE_PATH = "Assets/Main/Sprites/UI/ActCrazyRock_Sprite/Common/wxy_25xinnian_jiaozhun_baitiao.png"
local line_path = "root/Bg/Line"
local bg_up_path = "root/Bg/BgUp"
local bg_path = "root/Bg/Bg"
local normal_atk_eff_path = "ModelRoot/PlayerPoint/PlayerEffPoint/NormalAtkEff_%s"
local magic_be_hit_eff_path = "ModelRoot/MonsterPoint/MonsterEffPoint/MagicBeHitEff"
local sound1_path = "root/Bg/node_combo/Sound1"
local sound2_path = "root/Bg/node_combo/Sound2"
local sound3_path = "root/Bg/node_combo/Sound3"
local sound4_path = "root/Bg/node_combo/Sound4"
local combo_text_path = "root/Bg/node_combo/ComboText"
local b_g_top_path = "AudioTrack/BG/BGTop"
local b_g_bottom_path = "AudioTrack/BG/BGBottom"
local circle_img1_path = "root/RockGamePlayer/AudioTrack/Destination/CircleImg1"
local circle_img2_path = "root/RockGamePlayer/AudioTrack/Destination/CircleImg2"
local hit_img_path = "root/RockGamePlayer/HitButton/HitImg"
local normal_note_item_path = "root/RockGamePlayer/ItemRoot/NormalNoteItem"
local note_b_g_path = "root/RockGamePlayer/ItemRoot/ContinueNoteItem/NoteBG"
local count_down_progress_path = "root/RockGamePlayer/ItemRoot/ContinueNoteItem/CountDownProgress"
local continue_eff_path = "root/RockGamePlayer/ItemRoot/ContinueNoteItem/continueEff"
local hit_button_path = "root/RockGamePlayer/HitButton"
local audio_track_path = "root/RockGamePlayer/AudioTrack"
local preview_pos_path = "root/RockGamePlayer/AudioTrack/PreviewPos"
local cur_pos_path = "root/RockGamePlayer/AudioTrack/CurPos"
local node_set_offset_area_path = "root/NodeSetOffsetArea"
local destination_path = "root/RockGamePlayer/AudioTrack/Destination"
local offset_frame_img_path = "root/OffsetFrameImg"
local offset_eff_point_path = "root/OffsetEffPoint"
local eff_ui_newyear2026_music_q_t_e_path = "root/ItemRoot/Eff_ui_Newyear2026_Music_QTE"
local eff_ui_newyear2026_music_q_t_e_miss_path = "root/ItemRoot/Eff_ui_Newyear2026_Music_QTE_Miss"
local v_x_enviroment_path = "root/Bg/VX_enviroment"
local left_btn_path = "root/NodeSetOffsetArea/LeftBtn"
local right_btn_path = "root/NodeSetOffsetArea/RightBtn"
local confirm_btn_path = "root/NodeSetOffsetArea/ConfirmBtn"
local offset_input_text_path = "root/NodeSetOffsetArea/OffsetInputText"
local COMBO_TEXT_COLOR_CONFIG = {
  [1] = "#EAE6EB",
  [2] = "#EB86FF",
  [3] = "#FFB645"
}

function UIActCrazyRockGameView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local params = self:GetUserData()
  self.activityId = params.activityId
  self.songId = params.songId
  self.showId = params.showId or 1
  self.isEditorModel = params.isEditor
  self.curGamePlayModel = params.gamePlayModel
  self.actData = DataCenter.ActCrazyRockDataManager:GetActDataById(toInt(self.activityId))
  self.songData = DataCenter.ActCrazyRockDataManager:GetSongData(self.songId)
  self.pauseRoot:SetActive(false)
  self:LoadNoteOffsetData()
  self:RefreshView()
end

function UIActCrazyRockGameView:OnDestroy()
  DataCenter.ArrowManager:RemoveArrow()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActCrazyRockGameView:OnEnable()
  EventManager:GetInstance():Broadcast(EventId.MusicGameViewOpen)
  DataCenter.LWUIBGMManager:RegisterUIBGMPlay(UIPlayBgmType.CrazyRockGame)
  base.OnEnable(self)
end

function UIActCrazyRockGameView:OnDisable()
  EventManager:GetInstance():Broadcast(EventId.MusicGameViewClose)
  DataCenter.LWUIBGMManager:RemoveUIBGMPlay(UIPlayBgmType.CrazyRockGame)
  if CommonUtil.IsEditor() and self.isEditorModel then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGMPanel, {anim = true})
  end
  base.OnDisable(self)
end

function UIActCrazyRockGameView:ComponentDefine()
  self.gamePlayerCpt = self:AddComponent(RockGamePlayerComponent, rock_game_player_path)
  self.gamePlayerCpt:BlindSuccessHitCallback(function(hitRet)
    self:OnSuccessHit(hitRet)
  end)
  self.gamePlayerCpt:BlindBreakComboCallback(function(noteItem)
    self:OnBreakCombo(noteItem)
  end)
  self.gamePlayerCpt:BlindEnterClickAreaCallback(function(noteItem)
    self:OnEnterClickArea(noteItem)
  end)
  self.gamePlayerCpt:BlindExitClickAreaCallback(function(noteItem)
    self:OnExitClickArea(noteItem)
  end)
  self.gamePlayerCpt:BlindOnNoteItemFinishCallback(function(noteItem, hitRet)
    self:OnNoteItemFinish(noteItem, hitRet)
  end)
  self.gamePlayerCpt:BlindFinishCallback(function(finalScore, hitSaveData)
    self:OnMusicFinish(finalScore, hitSaveData)
  end)
  self.songProgress = self:AddComponent(UISlider, song_progress_path)
  self.songNameText = self:AddComponent(UIText, song_name_text_path)
  self.scoreValueText = self:AddComponent(UIText, score_value_text_path)
  self.nodeCombo = self:AddComponent(UIBaseContainer, node_combo_path)
  self.comboSimpleAni = self:AddComponent(UISimpleAnimation, node_combo_path)
  self.comboValueText = self:AddComponent(UIText, combo_value_text_path)
  self.normalEvnEff = self:AddComponent(UIBaseContainer, normal_evn_eff_path)
  self.continueEvnEff = self:AddComponent(UIBaseContainer, continue_evn_eff_path)
  self.gameRT = self:AddComponent(UIModelView, game_r_t_path)
  self.scoreArea = self:AddComponent(UIBaseContainer, score_area_path)
  self.offsetTopArea = self:AddComponent(UIBaseComponent, offset_top_area_path)
  self.colonTextObj = self:AddComponent(UIBaseContainer, colon_text_path)
  self.scoreRoot = self:AddComponent(UIBaseContainer, score_add_root_path)
  self.scoreText = self:AddComponent(UIText, score_text_path)
  self.scoreText.gameObject:GameObjectCreatePool()
  self.btnBack = self:AddComponent(UIButton, btn_back_path)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.pauseRoot = self:AddComponent(UIBaseContainer, pause_root_path)
  self.quitBtn = self:AddComponent(UIButton, quit_btn_path)
  self.continueBtn = self:AddComponent(UIButton, continue_btn_path)
  self.quitBtn:SetOnClick(function()
    self:OnQuitBtnClick()
  end)
  self.continueBtn:SetOnClick(function()
    self:OnContinueBtnClick()
  end)
  self.keepClickingTips = self:AddComponent(UIBaseContainer, keep_clicking_path)
  self.keepClickingTips:SetActive(false)
  self.p_c_desc = self:AddComponent(UITextMeshProUGUIEx, p_c_desc_path)
  self.p_c_desc:SetLocalText("activity_concert_64")
  self.eff_yyj_sangshi_dianliu1 = self:AddComponent(UIBaseContainer, eff_yyj_sangshi_dianliu1_path)
  self.eff_yyj_sangshi_dianliu2 = self:AddComponent(UIBaseContainer, eff_yyj_sangshi_dianliu2_path)
  self.eff_yyj_sangshi_dianliu3 = self:AddComponent(UIBaseContainer, eff_yyj_sangshi_dianliu3_path)
  self.playerAniMachine = RockGamePlayerAniMachine.New()
  self.monsterAniMachine = RockGameMonsterAniMachine.New()
  self.bannerTopImg = self:AddComponent(UIRawImage, bg_up_path)
  self.bannerBottomImg = self:AddComponent(UIRawImage, bg_path)
  self.imgImg = self:AddComponent(UIRawImage, line_path)
  self.comboImg1 = self:AddComponent(UIImage, sound1_path)
  self.comboImg2 = self:AddComponent(UIImage, sound2_path)
  self.comboImg3 = self:AddComponent(UIImage, sound3_path)
  self.comboImg4 = self:AddComponent(UIImage, sound4_path)
  self.comboText = self:AddComponent(UIText, combo_text_path)
  self.bgTopImg = self:TryAddComponent(UIImage, b_g_top_path)
  self.bgBottomImg = self:TryAddComponent(UIImage, b_g_bottom_path)
  self.circleImg1 = self:TryAddComponent(UIImage, circle_img1_path)
  self.circleImg2 = self:TryAddComponent(UIImage, circle_img2_path)
  self.hitBtnImg = self:TryAddComponent(UIImage, hit_img_path)
  self.singleNoteImg = self:TryAddComponent(UIImage, normal_note_item_path)
  self.continueCircleImg1 = self:TryAddComponent(UIImage, note_b_g_path)
  self.continueCircleImg2 = self:TryAddComponent(UIImage, count_down_progress_path)
  self.continueEffPoint = self:TryAddComponent(UIBaseComponent, continue_eff_path)
  self.offsetFrameImg = self:TryAddComponent(UIBaseComponent, offset_frame_img_path)
  self.offsetNoteDisappearEff = self:AddComponent(UIBaseComponent, eff_ui_newyear2026_music_q_t_e_path)
  self.offsetNoteDisappearEff.gameObject:GameObjectCreatePool()
  self.offsetNoteMissDisappearEff = self:AddComponent(UIBaseComponent, eff_ui_newyear2026_music_q_t_e_miss_path)
  self.offsetNoteMissDisappearEff.gameObject:GameObjectCreatePool()
  self.noteRoot = self:AddComponent(UIBaseComponent, offset_eff_point_path)
  self.enviromentEffRoot = self:AddComponent(UIBaseComponent, v_x_enviroment_path)
  self.noteOffsetRightLongPressBtn = self:AddComponent(UILongPressTrigger, left_btn_path)
  self.noteOffsetRightLongPressBtn:SetCallback(function()
    return self:ChangeNoteOffsetValue(-1)
  end)
  self.noteOffsetLeftLongPressBtn = self:AddComponent(UILongPressTrigger, right_btn_path)
  self.noteOffsetLeftLongPressBtn:SetCallback(function()
    return self:ChangeNoteOffsetValue(1)
  end)
  self.noteOffsetConfirmBtn = self:AddComponent(UIButton, confirm_btn_path)
  self.noteOffsetConfirmBtn:SetOnClick(function()
    self:SaveNoteOffsetData()
  end)
  self.noteOffsetInputText = self:AddComponent(UIInput, offset_input_text_path)
  self.noteOffsetInputText:SetOnEndEdit(function(value)
    self:OnNoteOffsetValueChange(value)
  end)
  self.curPos = self:TryAddComponent(UIBaseComponent, cur_pos_path)
  self.prevPos = self:TryAddComponent(UIBaseComponent, preview_pos_path)
  self.offsetInfoBtn = self:AddComponent(UIButton, offset_info_btn_path)
  self.offsetInfoBtn:SetOnClick(function()
    self:OpenOffsetIntroPanel()
  end)
end

function UIActCrazyRockGameView:ComponentDestroy()
  self.playerAniMachine:Destroy()
  self.monsterAniMachine:Destroy()
  self.playerAniMachine = nil
  self.monsterAniMachine = nil
  self.scoreText.gameObject:GameObjectRecycleAll()
  if self.scoreRollTween then
    self.scoreRollTween:Kill()
    self.scoreRollTween = nil
  end
  self.offsetNoteDisappearEff.gameObject:GameObjectRecycleAll()
  self.offsetNoteMissDisappearEff.gameObject:GameObjectRecycleAll()
end

function UIActCrazyRockGameView:DataDefine()
  self.allScoreCptList = {}
  self.allScoreTimerDic = {}
  self.electricityEffPool = {
    {
      go = self.eff_yyj_sangshi_dianliu1,
      isFree = true
    },
    {
      go = self.eff_yyj_sangshi_dianliu2,
      isFree = true
    },
    {
      go = self.eff_yyj_sangshi_dianliu3,
      isFree = true
    }
  }
  self.electricityEffTimerList = {}
  self.modeDisPlayConfig = {}
  local normalDisPlayConfig = {}
  normalDisPlayConfig.hitBtnPos = Vector3.New(0, -620, 0)
  normalDisPlayConfig.hitBtnMinAnchor = Vector2.New(0.5, 0.5)
  normalDisPlayConfig.hitBtnMaxAnchor = Vector2.New(0.5, 0.5)
  normalDisPlayConfig.hitBtnScale = 1
  normalDisPlayConfig.audioTrackPos = Vector3.New(0, -360, 0)
  normalDisPlayConfig.audioTrackMinAnchor = Vector2.New(0.5, 1)
  normalDisPlayConfig.audioTrackMaxAnchor = Vector2.New(0.5, 1)
  normalDisPlayConfig.curNodePos = Vector3.New(0, -314, 0)
  self.modeDisPlayConfig[CrazyRockGameMode.Normal] = normalDisPlayConfig
  local offsetDisPlayConfig = {}
  offsetDisPlayConfig.hitBtnPos = Vector3.New(0, 83, 0)
  offsetDisPlayConfig.hitBtnMinAnchor = Vector2.New(0.5, 0)
  offsetDisPlayConfig.hitBtnMaxAnchor = Vector2.New(0.5, 0)
  offsetDisPlayConfig.hitBtnScale = 0.62
  offsetDisPlayConfig.audioTrackPos = Vector3.New(0, 136, 0)
  offsetDisPlayConfig.audioTrackMinAnchor = Vector2.New(0.5, 0.5)
  offsetDisPlayConfig.audioTrackMaxAnchor = Vector2.New(0.5, 0.5)
  offsetDisPlayConfig.curNodePos = Vector3.New(0, 11, 0)
  self.modeDisPlayConfig[CrazyRockGameMode.Offset] = offsetDisPlayConfig
  if self.offsetDisappearTimerList then
    for _, v in ipairs(self.offsetDisappearTimerList) do
      v:Stop()
    end
    self.offsetDisappearTimerList = nil
  end
  self.guideFlag = false
end

function UIActCrazyRockGameView:DataDestroy()
  self.allScoreCptList = nil
  self.scoreRoot:RemoveAllComponentes()
  if self.allScoreTimerDic then
    for _, timer in pairs(self.allScoreTimerDic) do
      timer:Stop()
    end
    self.allScoreTimerDic = nil
  end
  self.electricityEffPool = nil
  self.eff_yyj_sangshi_dianliu1 = nil
  self.eff_yyj_sangshi_dianliu2 = nil
  self.eff_yyj_sangshi_dianliu3 = nil
  if self.electricityEffTimerList then
    for _, timer in pairs(self.electricityEffTimerList) do
      timer:Stop()
    end
    self.electricityEffTimerList = nil
  end
  if self.forceLoadGameTimer then
    self.forceLoadGameTimer:Stop()
    self.forceLoadGameTimer = nil
  end
  self.guideFlag = nil
end

function UIActCrazyRockGameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MusicGameActorAniSpeedChange, self.OnActSpeedChange)
  self:AddUIListener(EventId.MusicGameSetSceneEffState, self.OnSetSceneEffState)
  self:AddUIListener(EventId.MusicGameSetOffsetSuccess, self.OnMusicGameSetOffsetSuccess)
  self:AddUIListener(EventId.OpenUI, self.OnOpenUIAction)
end

function UIActCrazyRockGameView:OnRemoveListener()
  self:RemoveUIListener(EventId.MusicGameActorAniSpeedChange, self.OnActSpeedChange)
  self:RemoveUIListener(EventId.MusicGameSetSceneEffState, self.OnSetSceneEffState)
  self:RemoveUIListener(EventId.MusicGameSetOffsetSuccess, self.OnMusicGameSetOffsetSuccess)
  self:RemoveUIListener(EventId.OpenUI, self.OnOpenUIAction)
  base.OnRemoveListener(self)
end

function UIActCrazyRockGameView:RefreshView()
  if not self.songId then
    self.ctrl:CloseSelf()
    Logger.LogError("UIActCrazyRockGameView:RefreshView, songId is nil")
    return
  end
  local params = {}
  params.blankTime = BLANK_TIME
  params.songId = self.songId
  params.isEditorModel = self.isEditorModel
  params.noteOffset = self:GetCurCustomOffset()
  params.isLoop = self.curGamePlayModel == CrazyRockGameMode.Offset
  self.isShowModel = self:GetCurIsShowModel() and not self:IsLowQuality()
  if self.songData and self.songData.blank_time then
    params.blankTime = self.songData.blank_time
  end
  if not CS.UnityEngine.Application.isEditor then
    params.isEditorModel = false
  end
  self:RefreshSkin()
  self:RefreshTransformByGameMode()
  self.songProgress:SetValue(0)
  self.nodeCombo:SetActive(false)
  self:ChangeSceneStyle(false)
  self:SetTotalScoreText(0)
  self:RefreshRTSceneBg()
  self:SetShowHideState4GameAbout(true)
  self:OnComboChanged(0)
  self.loadGameFlag = false
  
  function self.enterLoadFunc()
    if self.guideFlag then
      return
    end
    if not self:IsAllNeedWaitSkinAssetsLoadFinish() then
      return
    end
    if self.loadGameFlag then
      return
    end
    self.loadGameFlag = true
    if self.forceLoadGameTimer then
      self.forceLoadGameTimer:Stop()
      self.forceLoadGameTimer = nil
    end
    self.gamePlayerCpt:ChangeGameState(CrazyRockGameState.Load, params)
    if self.songData then
      self.songNameText:SetLocalText(self.songData.songNameKey)
    else
      self.songNameText:SetText("")
    end
    self:RefreshNoteOffsetView()
  end
  
  self.guideFlag = false
  if self.activityId and self:IsNormalGamePlayMode() then
    self.guideFlag = DataCenter.ActCrazyRockDataManager:CheckOpenGamePlay(self.activityId, function()
      self.guideFlag = false
      self.enterLoadFunc()
    end)
  end
  if not self.guideFlag then
    self.enterLoadFunc()
  end
  self.isAlreadyShowClickTips = false
  if Config.IsPC() or CS.UnityEngine.Application.isEditor then
    EventSystem.current:SetSelectedGameObject(nil)
  end
  if self.forceLoadGameTimer then
    self.forceLoadGameTimer:Stop()
    self.forceLoadGameTimer = nil
  end
  self.forceLoadGameTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.allNeedWaitLoadList = nil
    self.enterLoadFunc()
  end, 3)
end

function UIActCrazyRockGameView:RefreshRTSceneBg()
  if self.curGamePlayModel == CrazyRockGameMode.Offset or not self.isShowModel then
    self.gameRT:SetActive(false)
    return
  end
  self.gameRT:SetActive(true)
  self.gameRT:Clear()
  self.gameRT:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.gameRT:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.gameRT:ReInit(SCENE_PREFAB_PATH)
  self.gameRT:SetOnLoadSceneHandler(function()
    local playerPointRoot = self.gameRT:GetSceneNode(player_point_path)
    local monsterPointRoot = self.gameRT:GetSceneNode(monster_point_path)
    local aniSpeed = self:GetActAniSpeed()
    
    local function getRtNodeFunc(path)
      return self.gameRT:GetSceneNode(path)
    end
    
    self:GeneratePrefab(self.playerModelPath, playerPointRoot.transform, function(trans)
      local effPathParams = {}
      effPathParams.idleEffPath = self.playerIdleEffPointPath
      effPathParams.atkEffPath = self.playerAtkEffPointPath
      self.playerAniMachine:Init(trans, aniSpeed, getRtNodeFunc, effPathParams)
    end)
    self:GeneratePrefab(self.monsterModelPath, monsterPointRoot.transform, function(trans)
      self.monsterAniMachine:Init(trans, aniSpeed, getRtNodeFunc)
    end)
    self:GenerateHitEff()
  end)
end

function UIActCrazyRockGameView:GenerateHitEff()
  local continueAtkHitEffPoint = {}
  for i = 1, 3 do
    local effPoint = self.gameRT:GetSceneNode(string.format(normal_atk_eff_path, i))
    table.insert(continueAtkHitEffPoint, effPoint)
  end
  if continueAtkHitEffPoint and not string.IsNullOrEmpty(self.continueEffPath) then
    for _, v in ipairs(continueAtkHitEffPoint) do
      self:GeneratePrefab(self.continueEffPath, v.transform)
    end
  end
  local normalAtkHitEffPoint = self.gameRT:GetSceneNode(magic_be_hit_eff_path)
  if normalAtkHitEffPoint and not string.IsNullOrEmpty(self.normalHitPath) then
    self:GeneratePrefab(self.normalHitPath, normalAtkHitEffPoint.transform)
  end
end

function UIActCrazyRockGameView:GeneratePrefab(path, parentTrans, callback)
  if not path then
    Logger.LogError("UIActCrazyRockGameView:GeneratePrefab. path is nil")
    return
  end
  self:GameObjectInstantiateAsync(path, function(req)
    if req.isError then
      return
    end
    local obj = req.gameObject
    local trans = obj.transform
    trans:SetParent(parentTrans)
    trans.localScale = Vector3.one
    trans.localPosition = Vector3.zero
    if callback then
      callback(trans)
    end
  end)
end

function UIActCrazyRockGameView:Update100MS()
  if not self.gamePlayerCpt then
    return
  end
  if self.gamePlayerCpt:GetCurState() ~= CrazyRockGameState.InGame then
    return
  end
  local songProgress = self.gamePlayerCpt:GetCurSongPlayProgress()
  self.songProgress:SetValue(songProgress)
end

function UIActCrazyRockGameView:OnSuccessHit(hitRet)
  local scoreFromHit = hitRet.score
  local scoreType = hitRet.scoreType
  local comboCount = hitRet.comboCount
  local comboLv = hitRet.comboLv
  self:OnScoreChanged(hitRet)
  self:OnComboChanged(comboCount, comboLv)
  self:PlayDancerAniAfterHit(hitRet)
  self:PlayElectricityEff(hitRet)
end

function UIActCrazyRockGameView:OnBreakCombo(noteItem)
  self:OnComboChanged(0)
  if self:IsNormalGamePlayMode() and self.isShowModel then
    self.playerAniMachine:OnBreakCombo(noteItem)
    self.monsterAniMachine:OnBreakCombo(noteItem)
  end
end

function UIActCrazyRockGameView:OnEnterClickArea(noteItem)
  if self:IsNormalGamePlayMode() and self.isShowModel and noteItem and noteItem:GetNoteType() == CrazyRockNoteType.Continue then
    self:ChangeSceneStyle(true)
    self.playerAniMachine:OnEnterContinueClickState()
    self.monsterAniMachine:OnEnterContinueClickState()
    if not self.isAlreadyShowClickTips then
      self:ShowClickTips(noteItem.noteData)
    end
  end
end

function UIActCrazyRockGameView:OnExitClickArea(noteItem)
  if self:IsNormalGamePlayMode() and self.isShowModel and noteItem and noteItem:GetNoteType() == CrazyRockNoteType.Continue then
    self:ChangeSceneStyle(false)
    self.playerAniMachine:OnExitContinueClickState()
    self.monsterAniMachine:OnExitContinueClickState()
    self:HideClickTips()
  end
end

function UIActCrazyRockGameView:OnNoteItemFinish(noteItem, hitRet)
  if not noteItem then
    return
  end
  if self:IsNormalGamePlayMode() and self.isShowModel then
    if noteItem:GetNoteType() == CrazyRockNoteType.Continue then
      self:ChangeSceneStyle(false)
      self:HideClickTips()
    end
    self.playerAniMachine:OnNoteItemFinish(noteItem:GetNoteType())
    self.monsterAniMachine:OnNoteItemFinish(noteItem:GetNoteType())
  end
  self:CheckGenOffsetNoteEff(noteItem, hitRet)
end

function UIActCrazyRockGameView:CheckGenOffsetNoteEff(noteItem, hitRet)
  if self.curGamePlayModel ~= CrazyRockGameMode.Offset or not noteItem then
    return
  end
  local effObj
  local hitTimePosAfterOffset = hitRet.hitTimePos + (self.noteOffset or 0)
  local score = 0
  local scoreType = CrazyRockScoreType.Perfect
  if noteItem and noteItem.noteData then
    score, scoreType = noteItem.noteData:GetScoreInfoByHitPos(hitTimePosAfterOffset, hitRet.hitType)
  end
  if scoreType == CrazyRockScoreType.Perfect then
    effObj = self:GetOffsetNoteDisappearEff(OFFSET_DISAPPEAR_EFF_DURATION)
  else
    effObj = self:GetOffsetNoteMissDisappearEff(OFFSET_DISAPPEAR_EFF_DURATION)
  end
  if effObj then
    effObj.transform.position = noteItem.transform.position
  end
end

function UIActCrazyRockGameView:OnMusicFinish(finalScore, hitSaveData)
  if not self.activityId then
    self.ctrl:CloseSelf()
    Logger.LogError("UIActCrazyRockGameView:OnMusicFinish, activityId is nil")
    return
  end
  local params = {}
  params.activityId = self.activityId
  params.songId = self.songId
  params.actions = hitSaveData
  params.score = finalScore or 0
  SFSNetwork.SendMessage(MsgDefines.MusicGameOver, params)
  self:SetShowHideState4GameAbout(false)
  self.pauseRoot:SetActive(false)
  self.p_c_desc:SetActive(false)
end

function UIActCrazyRockGameView:SetShowHideState4GameAbout(isShow)
  self.gameRT:SetEnable(isShow and self:IsNormalGamePlayMode())
  self.songProgress:SetActive(isShow and self:IsNormalGamePlayMode())
  self.gamePlayerCpt:SetActive(isShow)
  self.scoreArea:SetActive(isShow and self:IsNormalGamePlayMode())
  self.offsetTopArea:SetActive(isShow and self:IsOffsetMode())
  self.nodeCombo:SetActive(isShow and self:IsNormalGamePlayMode())
  self.btnBack:SetActive(isShow)
end

function UIActCrazyRockGameView:IsOffsetMode()
  return self.curGamePlayModel == CrazyRockGameMode.Offset
end

function UIActCrazyRockGameView:IsNormalGamePlayMode()
  return self.curGamePlayModel == CrazyRockGameMode.Normal
end

function UIActCrazyRockGameView:ChangeSceneStyle(isContinue)
  if not self.normalEvnEff.activeSelf and not isContinue then
    self.normalEvnEff:SetActive(true)
  end
  if self.normalEvnEff.activeSelf and isContinue then
    self.normalEvnEff:SetActive(false)
  end
  if not self.continueEvnEff.activeSelf and isContinue then
    self.continueEvnEff:SetActive(true)
  end
  if self.continueEvnEff.activeSelf and not isContinue then
    self.continueEvnEff:SetActive(false)
  end
end

function UIActCrazyRockGameView:OnScoreChanged(hitRet)
  self:SetTotalScoreText(hitRet.totalScore, true)
  if hitRet and hitRet.addScore and hitRet.addScore > 0 then
    self:PlayScoreAddAni(hitRet.addScore)
  end
end

function UIActCrazyRockGameView:SetTotalScoreText(value, withAni)
  if self.scoreRollTween then
    self.scoreRollTween:Kill()
    self.scoreRollTween = nil
  end
  if not withAni then
    self.scoreValueText:SetText(value)
    return
  end
  local curScore = toInt(self.scoreValueText:GetText())
  local toScore = value
  
  local function Getter()
    return curScore
  end
  
  local function Setter(v)
    curScore = v
  end
  
  self.scoreRollTween = DOTween.To(Getter, Setter, toScore, SCORE_ROLL_TIME):OnUpdate(function()
    self.scoreValueText:SetText(toInt(curScore))
  end):OnComplete(function()
    self.scoreRollTween = nil
    self.scoreValueText:SetText(value)
  end)
end

function UIActCrazyRockGameView:PlayScoreAddAni(score)
  local cpt = self:GetScoreCptFromPool()
  cpt:SetText(score)
  local disappearTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.allScoreTimerDic[cpt] = nil
    self:ReturnScoreCptToPool(cpt)
  end, SCORE_ROLL_TIME)
  self.allScoreTimerDic[cpt] = disappearTimer
end

function UIActCrazyRockGameView:OnComboChanged(comboCount, comboLv)
  if not self:IsNormalGamePlayMode() then
    return
  end
  if comboCount <= 0 then
    self.nodeCombo:SetActive(false)
    return
  end
  self.nodeCombo:SetActive(true)
  if self.comboSimpleAni:IsPlaying("Play") then
    self.comboSimpleAni:Rewind("Play")
  else
    self.comboSimpleAni:Play("Play")
  end
  self.comboValueText:SetText(comboCount)
  comboLv = comboLv or 1
  if table.containsKey(COMBO_TEXT_COLOR_CONFIG, comboLv) then
    self.comboValueText:SetColorHex(COMBO_TEXT_COLOR_CONFIG[comboLv])
  end
end

function UIActCrazyRockGameView:PlayDancerAniAfterHit(hitRet)
  if self:IsNormalGamePlayMode() and self.isShowModel then
    local isHeavyAttack = self.playerAniMachine:CheckHeavyAttack(hitRet)
    hitRet.isHeavyAttack = isHeavyAttack
    local params
    local isPreAtk = self.playerAniMachine:OnPlayerSuccessHit(hitRet)
    if isPreAtk then
      params = {}
      params.isPreAtk = isPreAtk
    end
    self.monsterAniMachine:OnPlayerSuccessHit(hitRet, params)
  end
end

function UIActCrazyRockGameView:PlayElectricityEff(hitRet)
  if hitRet.hitType ~= CrazyRockHitType.SingleNoteHit then
    return
  end
  if hitRet.scoreType ~= CrazyRockScoreType.Perfect then
    return
  end
  for i, v in ipairs(self.electricityEffPool) do
    if v.isFree then
      v.isFree = false
      v.go:SetActive(true)
      local timer = TimerManager:GetInstance():DelayInvoke(function()
        if self.electricityEffPool then
          v.isFree = true
          v.go:SetActive(false)
        end
      end, 1)
      table.insert(self.electricityEffTimerList, timer)
      return
    end
  end
end

function UIActCrazyRockGameView:GetScoreCptFromPool()
  if #self.allScoreCptList <= 0 then
    local obj = self.scoreText.gameObject:GameObjectSpawn()
    local name = tostring(NameCount)
    obj.name = name
    NameCount = NameCount + 1
    obj.transform:SetParent(self.scoreRoot.transform)
    obj.transform:Set_localScale(1, 1, 1)
    local cpt = self.scoreRoot:AddComponent(UIText, name)
    return cpt
  end
  local cpt = self.allScoreCptList[1]
  cpt.gameObject:SetActive(true)
  table.remove(self.allScoreCptList, 1)
  return cpt
end

function UIActCrazyRockGameView:ReturnScoreCptToPool(cpt)
  table.insert(self.allScoreCptList, cpt)
  cpt.gameObject:SetActive(false)
end

function UIActCrazyRockGameView:OnActSpeedChange(params)
  if not params then
    return
  end
  if self:IsNormalGamePlayMode() and self.isShowModel then
    self.playerAniMachine:SetAniSpeed(params.aniSpeed or 1)
    self.monsterAniMachine:SetAniSpeed(params.aniSpeed or 1)
  end
end

function UIActCrazyRockGameView:OnBtnBackClick()
  if self.curGamePlayModel == CrazyRockGameMode.Normal then
    self.pauseRoot:SetActive(true)
    self.gamePlayerCpt:PauseGame()
    return
  elseif self.curGamePlayModel == CrazyRockGameMode.Offset then
    local isValueChange = self.curServerOffset and self.noteOffset and self.curServerOffset ~= self.noteOffset
    if not isValueChange then
      self.ctrl:CloseSelf()
    else
      self:PopSaveOffsetPanel()
    end
  end
end

function UIActCrazyRockGameView:PopSaveOffsetPanel()
  UIUtil.ShowConfirmNew({
    contentText = CS.GameEntry.Localization:GetString("activity_99179_warning_desc_2"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        self:SaveNoteOffsetData()
        self.ctrl:CloseSelf()
      end,
      context = "activity_99179_warning_btn_4"
    },
    cancelBtnParam = {
      action = function()
        self.ctrl:CloseSelf()
      end,
      context = "activity_99179_warning_btn_3"
    },
    closeAction = function()
    end
  })
end

function UIActCrazyRockGameView:OnQuitBtnClick()
  self.pauseRoot:SetActive(false)
  if self.curGamePlayModel == CrazyRockGameMode.Normal then
    self.gamePlayerCpt:ChangeGameState(CrazyRockGameState.MusicEnd)
  elseif self.curGamePlayModel == CrazyRockGameMode.Offset then
    if self.curServerOffset and self.noteOffset and self.curServerOffset ~= self.noteOffset then
      UIUtil.ShowConfirmNew({
        contentText = CS.GameEntry.Localization:GetString("activity_99179_warning_desc_2"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            self:SaveNoteOffsetData()
            self.ctrl:CloseSelf()
          end,
          context = "activity_99179_warning_btn_4"
        },
        cancelBtnParam = {
          action = function()
            self.ctrl:CloseSelf()
          end,
          context = "activity_99179_warning_btn_3"
        },
        closeAction = function()
          self.pauseRoot:SetActive(true)
        end
      })
    else
      self.ctrl:CloseSelf()
    end
  else
    self.ctrl:CloseSelf()
  end
end

function UIActCrazyRockGameView:OnContinueBtnClick()
  self.pauseRoot:SetActive(false)
  self.gamePlayerCpt:ResumeGame()
end

function UIActCrazyRockGameView:ShowClickTips(noteData)
  self.isAlreadyShowClickTips = true
  self.keepClickingTips:SetActive(true)
  if self.gamePlayerCpt.hitButton then
    local noteDisappearDuration = 2
    if noteData then
      noteDisappearDuration = Mathf.Max(noteData:DisappearTimeWhenPassHitTime(), 1000) / 1000
    end
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.gamePlayerCpt.hitButton.transform.position + Vector3.New(50, -50, 0)
    param.isAutoClose = noteDisappearDuration
    DataCenter.ArrowManager:ShowFingerArrow(param)
  end
end

function UIActCrazyRockGameView:HideClickTips()
  self.keepClickingTips:SetActive(false)
  DataCenter.ArrowManager:RemoveArrow()
end

function UIActCrazyRockGameView:OnSetSceneEffState(params)
  if not CS.UnityEngine.Application.isEditor then
    return
  end
  self.normalEvnEff:SetActive(params)
  self.continueEvnEff:SetActive(params)
end

function UIActCrazyRockGameView:RefreshSkin()
  if not self.showId then
    Logger.LogError("showId is nil")
    return
  end
  self.showTmp = LocalController:instance():getLine(TableName.CRAZY_ROCK_SHOW, self.showId)
  if not self.showTmp then
    Logger.LogError("showTmp is nil")
    return
  end
  self.allNeedWaitLoadList = {}
  for _, v in pairs(NeedLoadWaitRefreshSkinType) do
    self.allNeedWaitLoadList[v] = false
  end
  local effPrefabPath = self.showTmp.enviroment_eff_prefab
  if effPrefabPath and self.normalEvnEff then
    self:RefreshBGEff(effPrefabPath, self.normalEvnEff.transform)
  end
  local continueEffPrefabPath = self.showTmp.continue_enviroment_eff_prefab
  if continueEffPrefabPath and self.continueEvnEff then
    self:RefreshBGEff(continueEffPrefabPath, self.continueEvnEff.transform)
  end
  self:RefreshBGImg()
  self.playerModelPath = self.showTmp.player_model_path
  self.monsterModelPath = self.showTmp.monster_model_path
  self.normalHitPath = self.showTmp.normal_hit_eff
  self.continueEffPath = self.showTmp.continue_hit_eff
  self.playerIdleEffPointPath = self.showTmp.idle_point_path
  self.playerAtkEffPointPath = self.showTmp.atk_point_path
  self:RefreshComboUI()
  self:RefreshTrackBG()
  self:RefreshNoteBGImg()
  self:RefreshContinueNoteEff()
end

function UIActCrazyRockGameView:RefreshBGEff(path, parentTrans)
  if not self.showTmp then
    Logger.LogError("showTmp is nil")
    return
  end
  if string.IsNullOrEmpty(path) then
    return
  end
  self:GameObjectInstantiateAsync(path, function(req)
    if req.isError then
      return
    end
    local obj = req.gameObject
    local trans = obj.transform
    trans:SetParent(parentTrans)
    trans.anchorMin = Vector2.New(0.5, 0)
    trans.anchorMax = Vector2.New(0.5, 1)
    trans.sizeDelta = Vector2.New(trans.sizeDelta.x, 0)
    trans:Set_localPosition(0, 0, 0)
    trans:Set_localScale(1, 1, 1)
    self:TryChangeBgEffAniByBpm(trans)
  end)
end

function UIActCrazyRockGameView:TryChangeBgEffAniByBpm(effTrans)
  if IsNull(effTrans) then
    return
  end
  local targetEffPath = "audio_mid"
  local particleSystem
  if not IsNull(effTrans:Find(targetEffPath)) then
    particleSystem = effTrans:Find(targetEffPath):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  end
  if not IsNull(particleSystem) and self.gamePlayerCpt then
    particleSystem.main.simulationSpeed = self:GetActAniSpeed()
  end
end

function UIActCrazyRockGameView:GetActAniSpeed()
  if not self.songData then
    return 1
  end
  return self.songData.bpm_act
end

function UIActCrazyRockGameView:RefreshBGImg()
  local bgConfig = self:GetCurBGConfig()
  if not bgConfig or #bgConfig < 2 then
    Logger.LogError("showTmp is nil or bg_config is nil or #bg_config < 2")
    return
  end
  local topBannerPath = bgConfig[1]
  if not string.IsNullOrEmpty(topBannerPath) then
    self.bannerTopImg:LoadSpriteAsync(topBannerPath, function()
      self.bannerTopImg:SetNativeSize()
    end)
  end
  local bottomBannerPath = bgConfig[2]
  if not string.IsNullOrEmpty(bottomBannerPath) then
    self.bannerBottomImg:LoadSpriteAsync(bottomBannerPath, function()
      self.bannerBottomImg:SetNativeSize()
    end)
  end
  local lineImgPath = self.showTmp.line_img
  if not string.IsNullOrEmpty(lineImgPath) then
    self.imgImg:LoadSpriteAsync(lineImgPath, function()
      self.imgImg:SetNativeSize()
    end)
  end
  self.imgImg:SetActive(self:IsNormalGamePlayMode() and not self:IsLowQuality())
  self.enviromentEffRoot:SetActive(self:IsNormalGamePlayMode() and not self:IsLowQuality())
  self.p_c_desc:SetActive((Config.IsPC() or CS.UnityEngine.Application.isEditor) and self:IsNormalGamePlayMode())
end

function UIActCrazyRockGameView:GetCurBGConfig()
  if not self.showTmp then
    return {}
  end
  if self:IsOffsetMode() or self:IsLowQuality() then
    return self.showTmp.offset_bg_config
  end
  return self.showTmp.bg_config
end

function UIActCrazyRockGameView:RefreshComboUI()
  if not self.showTmp or not self.showTmp.combo_cfg_arr then
    Logger.LogError("showTmp is nil or combo_cfg_arr is nil")
    return
  end
  if #self.showTmp.combo_cfg_arr < 6 then
    Logger.LogError("combo_cfg_arr is less than 6")
    return
  end
  local commonPath = self.showTmp.combo_cfg_arr[1]
  local comboPic1 = string.format("%s%s", commonPath, self.showTmp.combo_cfg_arr[2])
  local comboPic2 = string.format("%s%s", commonPath, self.showTmp.combo_cfg_arr[3])
  local comboPic3 = string.format("%s%s", commonPath, self.showTmp.combo_cfg_arr[4])
  local comboPic4 = string.format("%s%s", commonPath, self.showTmp.combo_cfg_arr[5])
  local comboTextColor = self.showTmp.combo_cfg_arr[6]
  self.comboImg1:LoadSpriteAsync(comboPic1, function()
    self.comboImg1:SetNativeSize()
  end)
  self.comboImg2:LoadSpriteAsync(comboPic2, function()
    self.comboImg2:SetNativeSize()
  end)
  self.comboImg3:LoadSpriteAsync(comboPic3, function()
    self.comboImg3:SetNativeSize()
  end)
  self.comboImg4:LoadSpriteAsync(comboPic4, function()
    self.comboImg4:SetNativeSize()
  end)
  self.comboText:SetColorHex(comboTextColor)
end

function UIActCrazyRockGameView:RefreshTrackBG()
  if not self.gamePlayerCpt then
    return
  end
  if not self.showTmp or not self.showTmp.track_bg_cfg_arr then
    Logger.LogError("showTmp is nil or track_bg_cfg_arr is nil")
    return
  end
  if #self.showTmp.track_bg_cfg_arr < 5 then
    Logger.LogError("combo_cfg_arr is less than 5")
    return
  end
  local commonPath = self.showTmp.track_bg_cfg_arr[1]
  local trackBgPath = string.format("%s%s", commonPath, self.showTmp.track_bg_cfg_arr[2])
  local circle1Path = string.format("%s%s", commonPath, self.showTmp.track_bg_cfg_arr[3])
  local circle2Path = string.format("%s%s", commonPath, self.showTmp.track_bg_cfg_arr[4])
  local buttonPath = string.format("%s%s", commonPath, self.showTmp.track_bg_cfg_arr[5])
  if self.bgTopImg and self.bgBottomImg then
    self.bgTopImg:LoadSpriteAsync(trackBgPath)
    self.bgBottomImg:LoadSpriteAsync(trackBgPath)
  end
  if self.circleImg1 then
    self.circleImg1:LoadSpriteAsync(circle1Path)
  end
  if self.circleImg2 then
    self.circleImg2:LoadSpriteAsync(circle2Path)
  end
  if self.hitBtnImg then
    self.hitBtnImg:LoadSpriteAsync(buttonPath)
  end
  self.circleImg2:LoadSpriteAsync(circle2Path)
  self.hitBtnImg:LoadSpriteAsync(buttonPath)
end

function UIActCrazyRockGameView:RefreshNoteBGImg()
  if not self.showTmp or not self.showTmp.note_img_cfg_arr then
    Logger.LogError("showTmp is nil or note_img_cfg_arr is nil")
    return
  end
  if #self.showTmp.note_img_cfg_arr < 4 then
    Logger.LogError("combo_cfg_arr is less than 4")
    return
  end
  local commonPath = self.showTmp.note_img_cfg_arr[1]
  local singleNotePath = string.format("%s%s", commonPath, self.showTmp.note_img_cfg_arr[2])
  local continueCircle1Path = string.format("%s%s", commonPath, self.showTmp.note_img_cfg_arr[3])
  local continueCircle2Path = string.format("%s%s", commonPath, self.showTmp.note_img_cfg_arr[4])
  if self.curGamePlayModel == CrazyRockGameMode.Offset then
    singleNotePath = OFFSET_NOTE_SPRITE_PATH
  end
  if self.singleNoteImg then
    self.singleNoteImg:LoadSprite(singleNotePath)
    self.singleNoteImg:SetNativeSize()
    self:OnNeedWaitSkinAssetsLoadFinish(NeedLoadWaitRefreshSkinType.SingleNoteImg)
  end
  if self.continueCircleImg1 then
    self.continueCircleImg1:LoadSprite(continueCircle1Path)
    self.continueCircleImg1:SetNativeSize()
    self:OnNeedWaitSkinAssetsLoadFinish(NeedLoadWaitRefreshSkinType.ContinueNoteFrameImg1)
  end
  if self.continueCircleImg2 then
    self.continueCircleImg2:LoadSprite(continueCircle2Path)
    self.continueCircleImg2:SetNativeSize()
    self:OnNeedWaitSkinAssetsLoadFinish(NeedLoadWaitRefreshSkinType.ContinueNoteFrameImg2)
  end
end

function UIActCrazyRockGameView:RefreshContinueNoteEff()
  if not self.showTmp or string.IsNullOrEmpty(self.showTmp.continue_note_eff_path) then
    Logger.LogError("showTmp is nil or continue_note_eff_path is nil")
    return
  end
  self:GameObjectInstantiateAsync(self.showTmp.continue_note_eff_path, function(req)
    if req.isError then
      return
    end
    local trans = req.gameObject.transform
    trans:SetParent(self.continueEffPoint.transform)
    trans.localScale = Vector3.one
    trans.localPosition = Vector3.zero
    self:OnNeedWaitSkinAssetsLoadFinish(NeedLoadWaitRefreshSkinType.ContinueNoteEff)
  end)
end

function UIActCrazyRockGameView:OnNeedWaitSkinAssetsLoadFinish(type)
  if not self.allNeedWaitLoadList then
    return
  end
  self.allNeedWaitLoadList[type] = true
  if self:IsAllNeedWaitSkinAssetsLoadFinish() and self.enterLoadFunc and not self.guideFlag then
    self.enterLoadFunc()
  end
end

function UIActCrazyRockGameView:IsAllNeedWaitSkinAssetsLoadFinish()
  if not self.allNeedWaitLoadList then
    return true
  end
  for _, v in pairs(self.allNeedWaitLoadList) do
    if not v then
      return false
    end
  end
  return true
end

function UIActCrazyRockGameView:RefreshTransformByGameMode()
  if not self.curGamePlayModel then
    return
  end
  local displayConfig = self.modeDisPlayConfig[self.curGamePlayModel]
  if not displayConfig then
    return
  end
  local hitBtn = self:TryAddComponent(UIBaseComponent, hit_button_path)
  if hitBtn then
    hitBtn.transform.anchorMin = displayConfig.hitBtnMinAnchor
    hitBtn.transform.anchorMax = displayConfig.hitBtnMaxAnchor
    hitBtn.transform.anchoredPosition = displayConfig.hitBtnPos
    local targetScale = displayConfig.hitBtnScale
    hitBtn.transform:Set_localScale(targetScale, targetScale, targetScale)
  end
  local audioTrack = self:TryAddComponent(UIBaseComponent, audio_track_path)
  if audioTrack then
    audioTrack.transform.anchoredPosition = displayConfig.audioTrackPos
    audioTrack.transform.anchorMin = displayConfig.audioTrackMinAnchor
    audioTrack.transform.anchorMax = displayConfig.audioTrackMaxAnchor
  end
  if self.curPos then
    self.curPos.transform.anchoredPosition = displayConfig.curNodePos
  end
  if self.offsetFrameImg then
    self.offsetFrameImg:SetActive(self.curGamePlayModel == CrazyRockGameMode.Offset)
    self.offsetFrameImg.transform.position = self.curPos.transform.position or Vector3.zero
  end
  local destRoot = self:TryAddComponent(UIBaseComponent, destination_path)
  if destRoot then
    destRoot:SetActive(self.curGamePlayModel == CrazyRockGameMode.Normal)
  end
  self.noteOffsetCpt = self:TryAddComponent(UIBaseComponent, node_set_offset_area_path)
  if self.noteOffsetCpt then
    self.noteOffsetCpt:SetActive(self.curGamePlayModel == CrazyRockGameMode.Offset)
  end
end

function UIActCrazyRockGameView:GetOffsetNoteDisappearEff(duration)
  self.offsetDisappearEffPoolList = self.offsetDisappearEffPoolList or {}
  local obj
  if #self.offsetDisappearEffPoolList <= 0 then
    obj = self.offsetNoteDisappearEff.gameObject:GameObjectSpawn(self.noteRoot.transform)
  else
    obj = self.offsetDisappearEffPoolList[#self.offsetDisappearEffPoolList]
    obj:SetActive(true)
    obj.transform:SetParent(self.noteRoot.transform)
    obj.transform:Set_localScale(1, 1, 1)
    self.offsetDisappearEffPoolList[#self.offsetDisappearEffPoolList] = nil
  end
  self.offsetDisappearTimerList = self.offsetDisappearTimerList or {}
  self.offsetDisappearTimerList[obj] = TimerManager:GetInstance():DelayInvoke(function()
    self:ReturnOffsetNoteDisappearEff(obj)
  end, duration or 2)
  return obj
end

function UIActCrazyRockGameView:GetOffsetNoteMissDisappearEff(duration)
  self.offsetMissDisappearEffPoolList = self.offsetMissDisappearEffPoolList or {}
  local obj
  if #self.offsetMissDisappearEffPoolList <= 0 then
    obj = self.offsetNoteMissDisappearEff.gameObject:GameObjectSpawn(self.noteRoot.transform)
  else
    obj = self.offsetMissDisappearEffPoolList[#self.offsetMissDisappearEffPoolList]
    obj:SetActive(true)
    obj.transform:SetParent(self.noteRoot.transform)
    obj.transform:Set_localScale(1, 1, 1)
    self.offsetMissDisappearEffPoolList[#self.offsetMissDisappearEffPoolList] = nil
  end
  self.offsetDisappearTimerList = self.offsetDisappearTimerList or {}
  self.offsetDisappearTimerList[obj] = TimerManager:GetInstance():DelayInvoke(function()
    self:ReturnOffsetNoteMissDisappearEff(obj)
  end, duration or 2)
  return obj
end

function UIActCrazyRockGameView:ReturnOffsetNoteDisappearEff(obj)
  if not self.offsetDisappearTimerList or not self.offsetDisappearTimerList[obj] then
    return
  end
  self.offsetDisappearTimerList[obj] = nil
  table.insert(self.offsetDisappearEffPoolList, obj)
  obj:SetActive(false)
end

function UIActCrazyRockGameView:ReturnOffsetNoteMissDisappearEff(obj)
  if not self.offsetDisappearTimerList or not self.offsetDisappearTimerList[obj] then
    return
  end
  self.offsetDisappearTimerList[obj] = nil
  table.insert(self.offsetMissDisappearEffPoolList, obj)
  obj:SetActive(false)
end

function UIActCrazyRockGameView:LoadNoteOffsetData()
  if not self.actData then
    self.noteOffset = 0
    return
  end
  local musicCfg = DataCenter.ActCrazyRockDataManager:GetMusicConfig(toInt(self.activityId))
  if not musicCfg then
    self.noteOffset = 0
    self.curServerOffset = self.noteOffset
    return
  end
  self.offsetLimitMin = -300
  self.offsetLimitMax = 300
  if musicCfg.adjust_note_show and #musicCfg.adjust_note_show >= 2 then
    self.offsetLimitMin = musicCfg.adjust_note_show[1] and musicCfg.adjust_note_show[1] * -1 or -300
    self.offsetLimitMax = musicCfg.adjust_note_show[2] or 300
  end
  self.noteOffset = self.actData.offset or 0
  self.curServerOffset = self.noteOffset
end

function UIActCrazyRockGameView:GetCurIsShowModel()
  local musicCfg = DataCenter.ActCrazyRockDataManager:GetMusicConfig(toInt(self.activityId))
  if not musicCfg then
    return true
  end
  if not musicCfg.hide_model_song_list then
    return true
  end
  for _, v in ipairs(musicCfg.hide_model_song_list) do
    if v == self.songId then
      return false
    end
  end
  return true
end

function UIActCrazyRockGameView:SaveNoteOffsetData()
  SFSNetwork.SendMessage(MsgDefines.MusicSetOffset, self.activityId, self.noteOffset)
end

function UIActCrazyRockGameView:ChangeNoteOffsetValue(sign)
  local targetValue = self.noteOffset + sign * NOTE_OFFSET_INTERVAL
  return self:SetOffsetValue(targetValue)
end

function UIActCrazyRockGameView:OnMusicGameSetOffsetSuccess()
  self:LoadNoteOffsetData()
  self:RefreshNoteOffsetView()
end

function UIActCrazyRockGameView:RefreshNoteOffsetView()
  self.noteOffsetInputText:SetText(string.format("%.3f", self.noteOffset / 1000))
  self:UpdateOffsetFrameImgPos()
end

function UIActCrazyRockGameView:UpdateOffsetFrameImgPos()
  if not self.prevPos or not self.curPos then
    return
  end
  if not self.songData then
    return
  end
  local prevTime = self.songData.notePreviewTime
  if prevTime < 0 then
    return
  end
  local fromPos = self.curPos.transform.position
  local toPos = self.prevPos.transform.position
  local progress = self.noteOffset / prevTime
  local offsetFramePos = Vector3.LerpUnclamped(fromPos, toPos, progress)
  self.offsetFrameImg.transform.position = offsetFramePos
end

function UIActCrazyRockGameView:OnNoteOffsetValueChange(value)
  local targetNoteOffset = tonumber(value)
  if not targetNoteOffset then
    targetNoteOffset = self.noteOffset
  else
    targetNoteOffset = targetNoteOffset * 1000
  end
  self:SetOffsetValue(targetNoteOffset)
end

function UIActCrazyRockGameView:SetOffsetValue(value)
  local targetNoteOffset = tonumber(value) or self.noteOffset
  local ret = true
  if targetNoteOffset < self.offsetLimitMin or targetNoteOffset > self.offsetLimitMax then
    UIUtil.ShowTipsId("activity_99179_tips_2")
    ret = false
  end
  self.noteOffset = Mathf.Clamp(targetNoteOffset, self.offsetLimitMin, self.offsetLimitMax)
  self:RefreshNoteOffsetView()
  return ret
end

function UIActCrazyRockGameView:GetCurCustomOffset()
  if self.curGamePlayModel == CrazyRockGameMode.Offset then
    return 0
  end
  return self.noteOffset
end

function UIActCrazyRockGameView:OpenOffsetIntroPanel()
  local param = {}
  param.title = "activity_99179_offset_warning_title"
  param.activityRulesStr = Localization:GetString("activity_99179_offset_warning_desc")
  param.activityId = self.activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
end

function UIActCrazyRockGameView:IsLowQuality()
  local isLowQuality = GameQualitySettings.GetQuality() == EGameQuality.Low
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  local isSimpleMode = displayLv < 0
  return isLowQuality or isSimpleMode
end

function UIActCrazyRockGameView:OnOpenUIAction(uiName)
  if uiName == UIWindowNames.UIDisconnect then
    self.ctrl:CloseSelf()
  end
end

return UIActCrazyRockGameView
