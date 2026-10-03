local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWUIActCrazyRockMainView = BaseClass("LWUIActCrazyRockMainView", base)
local UIModelView = require("Framework.UI.Component.UIModelView")
local M = LWUIActCrazyRockMainView
local Localization = CS.GameEntry.Localization
local GameQualitySettings = require("Util.GameQualitySettings")
local RockGamePlayerAniMachine = require("UI.UIActCrazyRock.PlayView.Component.AniMachine.RockGamePlayerAniMachine")
local RockGameMonsterAniMachine = require("UI.UIActCrazyRock.PlayView.Component.AniMachine.RockGameMonsterAniMachine")
local play_btn_path = "PlayBtn"
local itemIcon_path = "PlayBtn/LW_Btn_Common_New_Base/Cost/Itemicon"
local item_cost_num_path = "PlayBtn/LW_Btn_Common_New_Base/Cost/ItemCostNum"
local best_score_path = "BestScore"
local txt_act_name_path = "BaseInfo/Txt_ActName"
local remain_time_text_path = "BaseInfo/RemainTimeContent/RemainTimeText"
local task_btn_path = "TaskBtn"
local task_btn_text_path = "TaskBtn/TaskBtnText"
local rank_btn_path = "RankBtn"
local rank_btn_text_path = "RankBtn/RankBtnText"
local intro_btn_path = "BaseInfo/IntroBtn"
local play_path = "PlayBtn/LW_Btn_Common_New_Base/Play"
local play_btn_red_dot_path = "PlayBtn/PlayBtnRedDot"
local task_btn_red_dot_path = "TaskBtn/TaskBtnRedDot"
local game_r_t_path = "Root/GameRT"
local resource_icon_path = "ResBar/root/resourceIcon"
local resource_num_path = "ResBar/root/resourceNum"
local add_btn_path = "ResBar/addBtn"
local add_res_btn_red_dot_path = "ResBar/addBtn/addResBtnRedDot"
local player_point_path = "ModelRoot/PlayerPoint"
local monster_point_path = "ModelRoot/MonsterPoint"
local SCENE_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActMusicFestival2025/ActCrazyRock/GamePlayScene/MusicSceneRoot.prefab"
local low_device_tips_path = "LowDeviceTips"
local normal_evn_eff_path = "Root/Bg/VX_enviroment/NormalEvnEff"
local bg_up_path = "Root/Bg/BgUp"
local bg_path = "Root/Bg/Bg"
local line_path = "Root/Bg/Line"
local offset_btn_path = "OffsetBtn"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self:RefreshScore()
  DataCenter.LWUIBGMManager:RegisterUIBGMPlay(UIPlayBgmType.CrazyRockMain)
end

function M:OnDisable()
  DataCenter.LWUIBGMManager:RemoveUIBGMPlay(UIPlayBgmType.CrazyRockMain)
  base.OnDisable(self)
end

function M:ComponentDefine()
  self.itemIcon = self:AddComponent(UIImage, itemIcon_path)
  self.itemCostNum = self:AddComponent(UIText, item_cost_num_path)
  self.bestScore = self:AddComponent(UIText, best_score_path)
  self.txtActName = self:AddComponent(UIText, txt_act_name_path)
  self.remain_time_text = self:AddComponent(UIText, remain_time_text_path)
  self.playGameBtn = self:AddComponent(UIButton, play_btn_path)
  self.playGameBtn:SetOnClick(function()
    self:OnClickPlayGameBtn()
  end)
  self.rankBtn = self:AddComponent(UIButton, rank_btn_path)
  self.rankBtn:SetOnClick(function()
    self:OnClickRankBtn()
  end)
  self.taskBtn = self:AddComponent(UIButton, task_btn_path)
  self.taskBtn:SetOnClick(function()
    self:OnClickTaskBtn()
  end)
  self.rankBtnText = self:AddComponent(UIText, rank_btn_text_path)
  self.taskBtnText = self:AddComponent(UIText, task_btn_text_path)
  self.rankBtnText:SetLocalText("activity_concert_33")
  self.taskBtnText:SetLocalText("activity_concert_34")
  self.IntroBtn = self:AddComponent(UIButton, intro_btn_path)
  self.IntroBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.playText = self:AddComponent(UIText, play_path)
  self.playText:SetLocalText("activity_concert_36")
  self.playBtnRed = self:AddComponent(UIBaseContainer, play_btn_red_dot_path)
  self.taskBtnRed = self:AddComponent(UIBaseContainer, task_btn_red_dot_path)
  self.addResBtnRed = self:AddComponent(UIBaseContainer, add_res_btn_red_dot_path)
  self.resourceIcon = self:AddComponent(UIImage, resource_icon_path)
  self.resourceNum = self:AddComponent(UIText, resource_num_path)
  self.addBtn = self:AddComponent(UIButton, add_btn_path)
  self.addBtn:SetOnClick(function()
    self:OnResClickAddBtn()
  end)
  self.playerAniMachine = RockGamePlayerAniMachine.New()
  self.monsterAniMachine = RockGameMonsterAniMachine.New()
  self.gameRT = self:AddComponent(UIModelView, game_r_t_path)
  self.lowDeviceTips = self:AddComponent(UIBaseContainer, low_device_tips_path)
  self.effRoot = self:AddComponent(UIBaseComponent, normal_evn_eff_path)
  self.bannerTopImg = self:AddComponent(UIRawImage, bg_up_path)
  self.bannerBottomImg = self:AddComponent(UIRawImage, bg_path)
  self.lineImg = self:AddComponent(UIRawImage, line_path)
  self.offsetBtn = self:AddComponent(UIButton, offset_btn_path)
  self.offsetBtn:SetOnClick(function()
    self:OpenOffsetPanel()
  end)
end

function M:ComponentDestroy()
  self.itemIcon = nil
  self.itemCostNum = nil
  self.bestScore = nil
  self.txtActName = nil
  self.remain_time_text = nil
  self.playGameBtn = nil
  self.rankBtn = nil
  self.taskBtn = nil
  self.rankBtnText = nil
  self.taskBtnText = nil
  self.IntroBtn = nil
  self.playText = nil
  self.playBtnRed = nil
  self.taskBtnRed = nil
  self.playerAniMachine:Destroy()
  self.monsterAniMachine:Destroy()
  self.playerAniMachine = nil
  self.monsterAniMachine = nil
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
end

function M:DataDefine()
  self.activityId = 0
  self.activityInfo = {}
  self.genBGEffFlag = false
end

function M:DataDestroy()
  self.activityId = nil
  self.activityInfo = nil
  self.genBGEffFlag = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrazyRockActInfoUpdate, self.OnActInfoUpdate)
  self:AddUIListener(EventId.CrazyRockTaskRewardGet, self.OnGetTaskReward)
  self:AddUIListener(EventId.StartMusicGamePlay, self.OnStartMusicGamePlay)
  self:AddUIListener(EventId.MusicGameUpdateScore, self.RefreshScore)
  self:AddUIListener(EventId.MusicGameViewOpen, self.OnMusicGameViewOpen)
  self:AddUIListener(EventId.MusicGameViewClose, self.OnMusicGameViewClose)
  self:AddUIListener(EventId.RefreshItems, self.RefreshItems)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.SetTaskBtnRedDot)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CrazyRockActInfoUpdate, self.OnActInfoUpdate)
  self:RemoveUIListener(EventId.CrazyRockTaskRewardGet, self.OnGetTaskReward)
  self:RemoveUIListener(EventId.StartMusicGamePlay, self.OnStartMusicGamePlay)
  self:RemoveUIListener(EventId.MusicGameUpdateScore, self.RefreshScore)
  self:RemoveUIListener(EventId.MusicGameViewOpen, self.OnMusicGameViewOpen)
  self:RemoveUIListener(EventId.MusicGameViewClose, self.OnMusicGameViewClose)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshItems)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.SetTaskBtnRedDot)
end

function M:SetData(activityId)
  self.activityId = activityId
  SFSNetwork.SendMessage(MsgDefines.MusicGameActivityInfo, toInt(self.activityId))
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.musicConfig = DataCenter.ActCrazyRockDataManager:GetMusicConfig(self.activityId)
  self.txtActName:SetLocalText(self.activityInfo.name)
  self:RefreshItems()
  self:RefreshScore()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
  self.showId = self.musicConfig.showId or 1
  self:RefreshSkin()
  self:RefreshRTSceneBg()
  CS.UIGray.SetGray(self.playGameBtn.transform, false, true)
  local isLowQuality = GameQualitySettings.GetQuality() == EGameQuality.Low
  self.lowDeviceTips:SetActive(isLowQuality)
  local showConfig = self.activityInfo:GetShowConfigTemp()
  UIActivityCenterCommonUtil.SetTopViewColor(self.txtActName.gameObject, nil, self.remain_time_text.gameObject, showConfig)
end

function M:IsLowQuality()
  local isLowQuality = GameQualitySettings.GetQuality() == EGameQuality.Low
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  local isSimpleMode = displayLv < 0
  return isLowQuality or isSimpleMode
end

function M:RefreshRTSceneBg()
  self.gameRT:Clear()
  self.gameRT:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.gameRT:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.gameRT:ReInit(SCENE_PREFAB_PATH)
  self.gameRT:SetOnLoadSceneHandler(function()
    local playerPointRoot = self.gameRT:GetSceneNode(player_point_path)
    local monsterPointRoot = self.gameRT:GetSceneNode(monster_point_path)
    local aniSpeed = 1
    
    local function getRtNodeFunc(path)
      return self.gameRT:GetSceneNode(path)
    end
    
    self:GeneratePrefab(self.playerModelPath, playerPointRoot.transform, function(trans)
      local effPathParams = {}
      effPathParams.idleEffPath = self.playerIdleEffPointPath
      self.playerAniMachine:Init(trans, aniSpeed, getRtNodeFunc, effPathParams)
    end)
    self:GeneratePrefab(self.monsterModelPath, monsterPointRoot.transform, function(trans)
      self.monsterAniMachine:Init(trans, aniSpeed, getRtNodeFunc)
    end)
    if not self.gameRT.activeSelf then
      self.gameRT:SetActive(true)
    end
  end)
end

function M:GeneratePrefab(path, parentTrans, callback)
  if not path then
    Logger.LogError("LWUIActCrazyRockMainView:GeneratePrefab. path is nil")
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

function M:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.remain_time_text:SetText(countDownTimeStr)
end

function M:RefreshItems()
  local cost = DataCenter.ActCrazyRockDataManager:GetActCost(self.activityId)
  if not cost then
    return
  end
  local costItem = cost.itemId
  local costItemNum = cost.itemNum
  local icon = DataCenter.ItemTemplateManager:GetIconPath(costItem)
  self.itemIcon:LoadSprite(icon)
  self.resourceIcon:LoadSprite(icon)
  self.itemCostNum:SetText(costItemNum)
  local itemNum = DataCenter.ItemData:GetItemCount(costItem)
  local showRed = 0 < itemNum
  local curShow = self.playBtnRed.activeSelf
  if curShow ~= showRed then
    self.playBtnRed:SetActive(showRed)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
  self:SetTaskBtnRedDot()
  self.resourceNum:SetText(itemNum)
end

function M:RefreshScore()
  if self.activityId == 0 then
    return
  end
  local score = DataCenter.ActCrazyRockDataManager:GetHistoryTopScore(self.activityId)
  if not score then
    Logger.LogError("score is nil")
    return
  end
  self.bestScore:SetText(Localization:GetString("activity_concert_35", score))
end

function M:OnActInfoUpdate()
  self:RefreshScore()
end

function M:OnClickPlayGameBtn()
  if self:IsBgmOrEffMute() then
    UIUtil.ShowConfirmNew({
      contentText = CS.GameEntry.Localization:GetString("activity_99179_sound_desc_2"),
      btnNum = 2,
      showToggle = false,
      confirmBtnParam = {
        action = function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingSet)
        end,
        context = "activity_99179_sound_btn_3"
      },
      cancelBtnParam = {
        action = function()
          self:ExecutePlayGame()
        end,
        context = "activity_99179_sound_btn_4"
      },
      closeAction = function()
      end
    })
  else
    self:ExecutePlayGame()
  end
end

function M:IsBgmOrEffMute()
  local volumeNumEffect = Setting:GetBool(SettingKeys.EFFECT_MUSIC_ON, true)
  local volumeNumMusic = Setting:GetBool(SettingKeys.BG_MUSIC_ON, true)
  return not volumeNumEffect or not volumeNumMusic
end

function M:ExecutePlayGame()
  if DataCenter.ActWinterStormManager:CheckInMatchingViewState() then
    return
  end
  local cost = DataCenter.ActCrazyRockDataManager:GetActCost(self.activityId)
  if not cost then
    Logger.LogError("cost is nil")
    return
  end
  local costItem = cost.itemId
  local itemNum = DataCenter.ItemData:GetItemCount(costItem)
  if cost and cost.itemNum and itemNum < cost.itemNum then
    LWResourceLackUtil:GotoGoodsItemLack(costItem, cost.itemNum - itemNum)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MusicGameStart, self.activityId)
  CS.UIGray.SetGray(self.playGameBtn.transform, true, false)
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
  self.waitMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
    CS.UIGray.SetGray(self.playGameBtn.transform, false, true)
    self.waitMsgTimer = nil
  end, 5)
end

function M:OnStartMusicGamePlay(params)
  local activityId = params.activityId
  if activityId ~= toInt(self.activityId) then
    Logger.LogError("activityId is not match")
    return
  end
  if self.gameRT.activeSelf then
    self.gameRT:SetActive(false)
  end
  if self.waitMsgTimer then
    self.waitMsgTimer:Stop()
    self.waitMsgTimer = nil
  end
  CS.UIGray.SetGray(self.playGameBtn.transform, false, true)
  local panelParams = {}
  panelParams.activityId = self.activityId
  panelParams.songId = params.songId
  panelParams.showId = self.showId
  panelParams.gamePlayModel = CrazyRockGameMode.Normal
  UIManager:GetInstance():OpenWindow(UIWindowNames.CrazyRockGame, {anim = true}, panelParams)
end

function M:OnClickTaskBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockTask, self.activityId)
end

function M:OnClickRankBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockRank, self.activityId)
end

function M:OnClickInfoBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockRewardPreview, self.activityId)
end

function M:SetTaskBtnRedDot()
  local show = DataCenter.ActCrazyRockTaskManager:GetRedDotNum() > 0
  if self.taskBtnRed then
    self.taskBtnRed:SetActive(show)
  end
  if self.addResBtnRed then
    self.addResBtnRed:SetActive(show)
  end
end

function M:OnGetTaskReward()
  self:SetTaskBtnRedDot()
end

function M:OnMusicGameViewClose()
  if self.gameRT and not self.gameRT.activeSelf then
    self.gameRT:SetActive(true)
  end
end

function M:OnMusicGameViewOpen()
  if self.gameRT and self.gameRT.activeSelf then
    self.gameRT:SetActive(false)
  end
end

function M:OnResClickAddBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActCrazyRockTask, self.activityId)
end

function M:RefreshSkin()
  if not self.showId then
    Logger.LogError("showId is nil")
    return
  end
  self.showTmp = LocalController:instance():getLine(TableName.CRAZY_ROCK_SHOW, self.showId)
  if not self.showTmp then
    Logger.LogError("showTmp is nil")
    return
  end
  self.playerModelPath = self.showTmp.player_model_path
  self.monsterModelPath = self.showTmp.monster_model_path
  self.playerIdleEffPointPath = self.showTmp.idle_point_path
  self:GenerateBGEff()
  self:RefreshBGImg()
end

function M:GenerateBGEff()
  if self.genBGEffFlag then
    return
  end
  if not self.showTmp then
    return
  end
  local effPrefabPath = self.showTmp.enviroment_eff_prefab
  if string.IsNullOrEmpty(effPrefabPath) then
    return
  end
  self:GameObjectInstantiateAsync(effPrefabPath, function(req)
    if req.isError then
      return
    end
    local obj = req.gameObject
    local trans = obj.transform
    trans:SetParent(self.effRoot.transform)
    trans.anchorMin = Vector2.New(0.5, 0)
    trans.anchorMax = Vector2.New(0.5, 1)
    trans:Set_localPosition(0, 0, 0)
    trans:Set_localScale(1, 1, 1)
  end)
  self.genBGEffFlag = true
end

function M:RefreshBGImg()
  if not (self.showTmp and self.showTmp.bg_config) or #self.showTmp.bg_config < 2 then
    Logger.LogError("showTmp is nil or bg_config is nil or #bg_config < 2")
    return
  end
  local topBannerPath = self.showTmp.bg_config[1]
  if not string.IsNullOrEmpty(topBannerPath) then
    self.bannerTopImg:LoadSpriteAsync(topBannerPath, function()
      self.bannerTopImg:SetNativeSize()
    end)
  end
  local bottomBannerPath = self.showTmp.bg_config[2]
  if not string.IsNullOrEmpty(bottomBannerPath) then
    self.bannerBottomImg:LoadSpriteAsync(bottomBannerPath, function()
      self.bannerBottomImg:SetNativeSize()
    end)
  end
  local lineImgPath = self.showTmp.line_img
  if not string.IsNullOrEmpty(lineImgPath) then
    self.lineImg:LoadSpriteAsync(lineImgPath, function()
      self.lineImg:SetNativeSize()
    end)
  end
end

function LWUIActCrazyRockMainView:OpenOffsetPanel()
  if not self.musicConfig then
    Logger.LogError("musicConfig is nil")
    return
  end
  if self.waitMsgTimer then
    return
  end
  if self:IsBgmOrEffMute() then
    UIUtil.ShowConfirmNew({
      contentText = CS.GameEntry.Localization:GetString("activity_99179_sound_desc_2"),
      btnNum = 2,
      showToggle = false,
      confirmBtnParam = {
        action = function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingSet)
        end,
        context = "activity_99179_sound_btn_3"
      },
      cancelBtnParam = {
        action = function()
          self:ExecuteOpenOffsetPanel()
        end,
        context = "activity_99179_sound_btn_4"
      },
      closeAction = function()
      end
    })
  else
    self:ExecuteOpenOffsetPanel()
  end
end

function LWUIActCrazyRockMainView:ExecuteOpenOffsetPanel()
  if not self.musicConfig.calibration_song or toInt(self.musicConfig.calibration_song) <= 0 then
    Logger.LogError("calibration_song is nil or calibration_song <= 0")
    return
  end
  local offsetSongId = toInt(self.musicConfig.calibration_song)
  local params = {}
  params.activityId = self.activityId
  params.songId = offsetSongId
  params.showId = self.showId
  params.gamePlayModel = CrazyRockGameMode.Offset
  UIManager:GetInstance():OpenWindow(UIWindowNames.CrazyRockGame, {anim = true}, params)
end

return LWUIActCrazyRockMainView
