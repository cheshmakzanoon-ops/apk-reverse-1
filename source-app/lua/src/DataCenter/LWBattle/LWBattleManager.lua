local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local SVC_PVE_PATH = "Assets/Main/Shaders2019/SVC_PVE.shadervariants"
local LWBattleManager = BaseClass("LWBattleManager")

function LWBattleManager:__init()
  self.cameraOffset = Vector3.New(0, 0, 0)
  self.fpsLockId = -1
  self.tmpHeroUuid = 0
  self.lastVibFrame = 0
  self.exitFlag = nil
  self.recordMemNrsv = 0
  self.recordMemNuse = 0
  self.recordMemMrsv = 0
  self.recordMemMuse = 0
  self.cameraMoveFactor = 0.4
  self.cameraMoveType = 1
end

function LWBattleManager:__delete()
  self:Destroy()
  self.bonusDashLevelData = nil
end

local function ProtectCall(fun)
  local ok, msg = xpcall(fun, debug.traceback)
  if not ok then
    Logger.LogError(msg)
  end
end

function LWBattleManager:Destroy()
  ProtectCall(function()
    if self:CheckMemRecord() and self.param and self.param.levelId and self.param.type and self.param.type == PVEType.Parkour then
      local levelId = self.param.levelId
      local memNrsv, memNuse, memMrsv, memMuse, memNrsvDiff, memNuseDiff, memMrsvDiff, memMuseDiff = self:GetMemRecord()
      PostEventLog.Track(PostEventLog.Defines.BattleMemRecord, {
        stageId = levelId,
        pd_mem_nrsv = memNrsv,
        pd_mem_nuse = memNuse,
        pd_mem_mrsv = memMrsv,
        pd_mem_muse = memMuse,
        f_para1 = memNrsvDiff,
        f_para2 = memNuseDiff,
        f_para3 = memMrsvDiff,
        f_para4 = memMuseDiff
      })
    end
  end)
  self:RemoveListeners()
  if self.logic then
    self.logic:Destroy()
  end
  self:RemoveUpdateTimer()
  if self.cameraTween then
    self.cameraTween:Kill()
    self.cameraTween = nil
  end
  self.shakeTotal = nil
  if CS.CommonUtils.IsDebug() and self.OnDevFingerDown then
    self.touchCamera.touchInput:OnFingerDown("-", self.OnDevFingerDown)
    self.OnDevFingerDown = nil
  end
  self.parkourFirstGuideStageId = nil
  self.exitFlag = nil
  BattleReportUtil.Cancel()
  self.svc_pve = nil
end

function LWBattleManager:IsFromActBreakSunday()
  return self.param and self.param.fromActFrontBreakSunday or nil
end

function LWBattleManager:Enter(param)
  if self.logic ~= nil then
    self:Destroy()
  end
  self.param = param
  self.lastVibFrame = 0
  self.followCameraOffsetTotal = nil
  if param.memRecord then
    self.recordMemNrsv, self.recordMemNuse, self.recordMemMrsv, self.recordMemMuse = CS.CSUtils.GetMemRecord()
    self.memRecordFlag = true
  else
    self.recordMemNrsv, self.recordMemNuse, self.recordMemMrsv, self.recordMemMuse = 0, 0, 0, 0
  end
  self.logic = self:CreateBattleLogic(param)
  self:SetCurBattleLogic(self.logic)
  self.logic:Enter(param)
  local p = {}
  if param.type == PVEType.Parkour then
    local testId = LuaEntry.Player:GetGrayTestParkourStage(param.levelId)
    PostEventLog.Track(PostEventLog.Defines.BattleParkourStart, {
      stageId = tostring(param.levelId),
      doorid = testId
    })
    local fromActFrontBreakSunday = param.fromActFrontBreakSunday
    local stageId = param.levelId
    local levelTitle = ""
    if fromActFrontBreakSunday then
      local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId)
      local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
      levelTitle = Localization:GetString("activity_breakthrough_tips_19", stageIdIndex, stagesCount)
      p.rightText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc"))
    elseif param.enterType == PVEEnterType.StageFeatureBuilding then
      local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
      local index = table.indexof(feature.stages, param.levelId)
      if 1 <= index then
        if feature.winType[index] == 1 then
          levelTitle = Localization:GetString("newbies_fuben_title")
          if #feature.winType == 1 then
            local content = Localization:GetString("newbies_fuben_title")
            levelTitle = string.format("%s %d/%d", content, index, #feature.stages)
          elseif #feature.winType == 3 then
            if feature.caty[index] == "0" then
              local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), param.levelId, "desc")
              levelTitle = Localization:GetString(desc)
            else
              local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc")
              levelTitle = Localization:GetString(desc)
            end
          end
          p.rightText = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
        elseif feature.winType[index] == 2 then
          if #feature.stages == 1 then
            local content = Localization:GetString("newbies_fuben_title")
            levelTitle = string.format("%s %d/%d", content, index, #feature.stages)
            p.rightText = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
          elseif #feature.stages == 3 then
            if #feature.winType == 1 then
              local content = Localization:GetString("newbies_fuben_title")
              levelTitle = string.format("%s %d/%d", content, index, #feature.stages)
              p.rightText = Localization:GetString("newbies_fuben_battlefront_loading", tostring(feature.winNeedCount[index]))
            elseif #feature.winType == 3 then
              if feature.caty[index] == "0" then
                local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), param.levelId, "desc")
                levelTitle = Localization:GetString(desc)
              else
                local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc")
                levelTitle = Localization:GetString(desc)
              end
              p.rightText = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
            end
          end
        elseif feature.winType[index] == 0 then
          if #feature.winType == 1 then
            local content = Localization:GetString("newbies_fuben_title")
            levelTitle = string.format("%s %d/%d", content, index, #feature.stages)
          elseif #feature.winType == 3 then
            if feature.caty[index] == "0" then
              local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), param.levelId, "desc")
              levelTitle = Localization:GetString(desc)
            else
              local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc")
              levelTitle = Localization:GetString(desc)
            end
          end
          p.rightText = Localization:GetString("newbies_fuben_attack_loading")
        elseif feature.winType[index] == 3 then
          local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
          local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
          levelTitle = Localization:GetString(levelTitlePrefixKey, order)
          p.rightText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc"))
        end
      end
    else
      local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
      local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
      levelTitle = Localization:GetString(levelTitlePrefixKey, order)
      p.rightText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc"))
    end
    p.loadingBgRes = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "stage_loading")
    p.pic = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "stage_pic")
    p.leftText = levelTitle
  elseif param.type == PVEType.Count then
    PostEventLog.Track(PostEventLog.Defines.BattleCountStart, {
      stageId = tostring(param.levelId)
    })
    if param.enterType == PVEEnterType.StageFeatureBuilding then
      local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
      local index = table.indexof(feature.stages, param.levelId)
      if 1 <= index then
        if feature.winType[index] == 1 then
          p.leftText = Localization:GetString("newbies_fuben_title")
          p.rightText = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
        elseif feature.winType[index] == 2 then
          local content = Localization:GetString("newbies_fuben_title")
          if #feature.stages == 1 then
            p.leftText = content
            p.rightText = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
          elseif #feature.stages == 3 then
            p.leftText = string.format("%s %d/%d", content, index, tostring(#feature.stages))
            p.rightText = Localization:GetString("newbies_fuben_battlefront_loading", tostring(feature.winNeedCount[index]))
          end
        elseif feature.winType[index] == 3 then
          p.rightText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), param.levelId, "desc"))
          p.leftText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), param.levelId, "name"), GetTableData(TableName.LW_Count_Stage, param.levelId, "order"))
        end
      end
    else
      p.rightText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), param.levelId, "desc"))
      p.leftText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), param.levelId, "name"), GetTableData(TableName.LW_Count_Stage, param.levelId, "order"))
    end
  elseif param.type == PVEType.Skirmish then
    p.leftText = ""
    p.rightText = Localization:GetString("100231")
    if param.mailExtData.units then
      for _, v in pairs(param.mailExtData.units) do
        if v and 0 < v.weaponLevel then
          local heroId = v.heroId
          local packConfigId = LocalController:instance():getValue("lw_hero", heroId, "download_packs_id")
          if self:IsNeedDownloadGroupRes(packConfigId) then
            p.loadRemoteResTips = Localization:GetString("pack_downloading_button")
          end
        end
      end
    end
  elseif param.type == PVEType.FakePVP then
    p.leftText = ""
    p.rightText = ""
  elseif param.type == PVEType.TorchRelay then
    local activityId = param.userData.activityId
    local template = DataCenter.ActivityTorchRelayManager:GetStageTemplate(activityId)
    if template then
      p.leftText = Localization:GetString(template.banner_leftText)
      p.rightText = Localization:GetString(template.banner_rightText)
      p.loadingBgRes = template.banner_loadingBgRes
    else
      Logger.LogError("not find template!  activityId:" .. tostring(activityId))
      p.leftText = Localization:GetString("activity_name_99101")
      p.rightText = Localization:GetString("activity_pic_pass_99101")
      p.loadingBgRes = "Assets/Main/TextureEx/LWUITorchRelay/lrb_wanshengjie_zhuanchangtu.png"
    end
  elseif param.type == PVEType.KOF then
    if DataCenter.LWKOFBattleManager:GetType() == TypeKOF.Train then
      p.leftText = Localization:GetString("alliance_train_043")
      local isUR = false
      if param.extraData and param.extraData.trainData and param.extraData.trainData:IsUR() then
        isUR = true
      end
      local path = DataCenter.LWAllyStationDataManager:GetTrainRobLoadingImg(isUR)
      p.loadingBgRes = path
    else
      p.leftText = ""
      p.rightText = ""
    end
  elseif param.type == PVEType.Surfing then
    p.leftText = Localization:GetString("parkour_loading_rule_title")
    local stageMeta = DataCenter.SurfingStageTemplateManager:GetTemplate(param.levelId)
    if stageMeta then
      p.rightText = Localization:GetString(stageMeta:GetRandomTipId())
      p.pic = stageMeta.loading_pic
      p.loadingBgRes = stageMeta.loading_bg
    end
  elseif param.type == PVEType.SkyBattle then
    local stageId = param.levelId
    local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "name")
    local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "order")
    local levelTitle = Localization:GetString(levelTitlePrefixKey, order)
    p.rightText = Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), param.levelId, "desc"))
    p.loadingBgRes = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "stage_loading")
    p.pic = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "stage_pic")
    p.leftText = levelTitle
  elseif param.type == PVEType.GhostParkour then
    p.leftText = Localization:GetString("ghost_parkour_loading_rule_title")
    local stageMeta = DataCenter.SurfingStageTemplateManager:GetTemplate(param.levelId)
    if stageMeta then
      p.rightText = Localization:GetString(stageMeta:GetRandomTipId())
      p.pic = stageMeta.loading_pic
      p.loadingBgRes = stageMeta.loading_bg
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = 10004
  }, p)
  self.uiPveLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading).View
  
  local function SendMessage()
    ProtectCall(function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
    end)
    ProtectCall(function()
      GoToUtil.CloseAllWindows()
    end)
    ProtectCall(function()
      UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
    end)
    ProtectCall(function()
      UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
    end)
    self:CreateLevel()
    EventManager:GetInstance():Broadcast(EventId.GF_goto_pve_battle_loaded, param)
  end
  
  self.uiPveLoading:SetOnEntered(SendMessage)
  if self.fpsLockId == -1 then
    self.fpsLockId = CS.DynamicFPSConfig.AcquireHighFPSLocker()
  end
  local mainCamera = CS.UnityEngine.Camera.main
  if mainCamera then
    local targetLayer = CS.UnityEngine.LayerMask.NameToLayer("OutLineGolden")
    if 0 <= targetLayer and targetLayer <= 31 then
      local mainCullingMask = mainCamera.cullingMask
      mainCamera.cullingMask = mainCullingMask | 1 << targetLayer
    end
  end
end

function LWBattleManager:IsNeedDownloadGroupRes(packConfigId)
  return packConfigId and 0 < packConfigId and not ResGroupManager:IsDownload(packConfigId)
end

function LWBattleManager:CreateBattleLogic(param)
  if param.type == PVEType.Parkour then
    local ParkourBattleLogic = require("DataCenter.LWBattle.Logic.ParkourBattle.ParkourBattleLogic")
    return ParkourBattleLogic.New()
  elseif param.type == PVEType.Skirmish then
    local SkirmishLogic = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishLogic")
    return SkirmishLogic.New()
  elseif param.type == PVEType.Count then
    local CountBattleLogic = require("DataCenter.LWBattle.Logic.CountBattle.CountBattleLogic")
    return CountBattleLogic.New()
  elseif param.type == PVEType.FakePVP then
    local FakePVPLogic = require("DataCenter.LWFakePVPBattle.FakePVPLogic")
    return FakePVPLogic.New()
  elseif param.type == PVEType.Arena3V3 then
    local Arena3V3BattleLogic = require("DataCenter.LWArena3V3Battle.LWArena3V3BattleLogic")
    return Arena3V3BattleLogic.New()
  elseif param.type == PVEType.TorchRelay then
    local TorchRelayBattleLogic = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleLogic")
    return TorchRelayBattleLogic.New()
  elseif param.type == PVEType.KOF then
    local kofBattleLogic = require("DataCenter.LWKOFBattle.LWKOFBattleLogic")
    return kofBattleLogic.New()
  elseif param.type == PVEType.SkyBattle then
    local skyBattleLogic = require("DataCenter.LWBattle.Logic.SkyBattle.SkyBattleLogic")
    return skyBattleLogic.New()
  elseif param.type == PVEType.Surfing then
    local surfingLogic
    local enterType = param.enterType
    if enterType == PVEEnterType.SurfingPlayback then
      surfingLogic = require("DataCenter.LWBattle.Logic.Surfing.SurfingPlaybackLogic")
    else
      surfingLogic = require("DataCenter.LWBattle.Logic.Surfing.SurfingLogic")
    end
    return surfingLogic.New()
  elseif param.type == PVEType.LastStand then
    local lastStandLogic = require("DataCenter.LWBattle.Logic.LastStand.LastStandLogic")
    return lastStandLogic.New()
  elseif param.type == PVEType.GhostParkour then
    local logic
    local enterType = param.enterType
    if enterType == PVEEnterType.GhostPlayback then
      logic = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourPlaybackLogic")
    else
      logic = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourLogic")
    end
    return logic.New()
  end
end

function LWBattleManager:GetCurBattleLogic()
  return self.curLogic
end

function LWBattleManager:GetCurBattleType()
  return self.curLogic and self.curLogic:GetPVEType() or PVEType.None
end

function LWBattleManager:SetCurBattleLogic(logic)
  if logic and self.curLogic and logic:GetPVEType() ~= self.curLogic:GetPVEType() then
    self.curLogic:Destroy()
  end
  self.curLogic = logic
  if logic and CS.CommonUtils.IsDebug() then
    local tip = ""
    DAMAGE_LOG = CommonUtil.PlayerPrefsGetBool("OPEN_PVE_DAMAGE_LOG", false)
    if DAMAGE_LOG then
      tip = tip .. "\229\188\128\229\144\175\228\186\134\228\188\164\229\174\179log!\n"
    end
    INVINCIBLE = CommonUtil.PlayerPrefsGetBool("OPEN_PVE_INVINCIBLE", false)
    if INVINCIBLE then
      tip = tip .. "\229\188\128\229\144\175\228\186\134\230\151\160\230\149\140!\n"
    end
    LOCAL_HERO_SKILL_OVERRIDE = CommonUtil.PlayerPrefsGetBool("SKILL_USE_CLIENT_CONFIG", false)
    if LOCAL_HERO_SKILL_OVERRIDE then
      tip = tip .. "\228\189\191\231\148\168\228\186\134\230\156\172\229\156\176lw_hero\232\161\168\231\154\132\230\138\128\232\131\189\232\166\134\231\155\150\228\186\134\232\175\165\232\180\166\229\143\183\231\154\132\232\139\177\233\155\132\230\138\128\232\131\189!\n"
    end
    PVE_TEST_MODE = CommonUtil.PlayerPrefsGetBool("BULLET_MOTION_EDITOR", false)
    if PVE_TEST_MODE then
      tip = tip .. "\229\188\128\229\144\175\228\186\134\230\138\128\232\131\189\231\188\150\232\190\145\229\153\168!\n"
    end
    if not string.IsNullOrEmpty(tip) then
      UIUtil.ShowTips(tip, 8)
    end
  end
end

function LWBattleManager:CreateLevel()
  if nil == self.svc_pve then
    self.svc_pve = Resource:LoadAsset(SVC_PVE_PATH, typeof(CS.UnityEngine.ShaderVariantCollection)).asset
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ShaderWarmUp) then
    self.svc_pve:WarmUp()
  end
  if CS.SceneManager.IsInCity() then
    EventManager:GetInstance():Broadcast(EventId.BeforeReleaseCity)
  elseif CS.SceneManager.IsInWorld() then
    EventManager:GetInstance():Broadcast(EventId.BeforeLeaveWorld)
  end
  DataCenter.BuildBubbleManager:ClearAll()
  DataCenter.WorldBuildBubbleManager:ClearAll()
  DataCenter.RoadBubbleManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.WarningBallManager:DeleteTimer()
  DataCenter.WorldFavoDataManager:ClearAll()
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  CS.SceneManager.DestroyCurScene()
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.None)
  self.gameOver = false
  self.gamePause = false
  self.gameStart = false
  if self.param and self.param.type == PVEType.Surfing then
    self.gamePause = true
  end
  if self.param and self.param.type and UseEnterGCPveType[self.param.type] and self:IsOpenReturnOpt() then
    ProfilerUtil.BeginSample("LWBattleManager.CreateLevel.Collect")
    collectgarbage("collect")
    ProfilerUtil.EndSample()
  end
  self:AddUpdateTimer()
  self:InitCamera()
  self:AddListeners()
  
  local function onCreateComplete()
    self:LoadSceneComplete()
  end
  
  self.logic:LoadScene(onCreateComplete)
end

function LWBattleManager:InitCamera()
  self.cameraTween = nil
  self.camera = CS.UnityEngine.Camera.main
  self.touchCamera = self.camera:GetComponent(typeof(MobileTouchCamera))
  self.hudCamera = self.camera.transform:Find("HudCamera"):GetComponent(typeof(CS.UnityEngine.Camera))
  self.touchCamera.CanMoveing = false
  self.touchCameraTransform = self.touchCamera.transform
  self.cacheZoomParam = 0
  self.logic:InitCamera()
  if CS.CommonUtils.IsDebug() and not self.OnDevFingerDown then
    function self.OnDevFingerDown()
      EventManager:GetInstance():Broadcast(EventId.OnClickEmpty)
    end
    
    self.touchCamera.touchInput:OnFingerDown("+", self.OnDevFingerDown)
  end
end

function LWBattleManager:AddListeners()
  if self.onKeyCodeEscape == nil then
    function self.onKeyCodeEscape()
      self:OnKeyCodeEscape()
    end
    
    EventManager:GetInstance():AddListener(EventId.OnKeyCodeEscape, self.onKeyCodeEscape)
  end
end

function LWBattleManager:RemoveListeners()
  if self.onKeyCodeEscape ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.OnKeyCodeEscape, self.onKeyCodeEscape)
    self.onKeyCodeEscape = nil
  end
end

function LWBattleManager:OnKeyCodeEscape()
  if not DataCenter.LWOpeningStageManager:IsAllDone() then
    return
  end
  if self.param and (self.param.type == PVEType.Surfing or self.param.type == PVEType.GhostParkour) then
    return
  end
  if not self:IsBattleFinish() and not self.gamePause then
    self:SetGamePause(true)
    local showMessage = "400097"
    local fromActFrontBreak = self.logic and self.logic.param and self.logic.param.fromActFrontBreakSunday
    if fromActFrontBreak then
      showMessage = "activity_breakthrough_tips_20"
    end
    UIUtil.ShowMessage(Localization:GetString(showMessage), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if self.curLogic == nil then
        self:SetGamePause(false)
        return
      end
      if self.param and self.param.type == PVEType.Skirmish then
        EventManager:GetInstance():Broadcast(EventId.BattleReportPlaybackExitMidway)
      end
      self:Exit(nil, nil)
      if fromActFrontBreak then
        local firstActId = DataCenter.ActFrontBreakSundayDataManager:GetFirstActId()
        if firstActId ~= -1 then
          GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, firstActId)
        end
      end
    end, function()
      self:SetGamePause(false)
    end, function()
      self:SetGamePause(false)
    end)
  end
end

local shakePos

function LWBattleManager.ShakeTweenGetter()
  return shakePos
end

function LWBattleManager.ShakeTweenSetter(pos)
  shakePos = pos
end

local defaultShakeDur = 0.5
local defaultShakeStrength = Vector3.New(0.5, 0.5, 0)
local defaultShakeVibrato = 30

function LWBattleManager:ShakeCameraWithParam(param)
  if not self.touchCamera then
    return
  end
  if self.cameraTween then
    self.cameraTween:Kill()
  end
  local duration = defaultShakeDur
  local strength = defaultShakeStrength
  local vibrato = defaultShakeVibrato
  if param then
    if param.duration then
      duration = param.duration
    end
    if param.strength then
      strength = param.strength
    end
    if param.vibrato then
      vibrato = param.vibrato
    end
  end
  shakePos = Vector3.zero
  if self.shakeTotal == nil then
    self.shakeTotal = Vector3.zero
  end
  self.cameraTween = nil
  local tw = DOTween.Shake(self.ShakeTweenGetter, self.ShakeTweenSetter, duration, strength, vibrato, 90, true)
  if tw ~= nil then
    self.cameraTween = tw
    tw:OnComplete(function()
      self.cameraTween = nil
      shakePos = Vector3.zero
    end)
  else
    Logger.LogError("LWBattleManager:ShakeCameraWithParam tween is nil!")
  end
end

function LWBattleManager:DoVibration(intensity, sharpness, duration)
  if self.lastVibFrame == Time.frameCount then
    return
  end
  self.lastVibFrame = Time.frameCount
  CS.CSUtils.DoCommonVibration(intensity, sharpness, duration)
end

function LWBattleManager:AutoZoom(zoom, time)
  time = time or 0.5
  self.cacheZoomParam = zoom
  if self:IsPlayingShakeCamera() then
    return
  end
  if self.touchCamera ~= nil then
    self.touchCamera:AutoZoom(zoom, time)
  end
end

function LWBattleManager:IsPlayingShakeCamera()
  return false
end

function LWBattleManager:GetFollowCameraTarget()
  if self.followCameraTarget == nil then
    self.followCameraTarget = Vector3.New(0, 0, 0)
  end
  return self.followCameraTarget
end

function LWBattleManager:GetFollowCameraOffset(x, y, z)
  if self.followCameraOffsetTotal == nil then
    self.followCameraOffsetTotal = Vector3.New(x, y, z)
  end
  return self.followCameraOffsetTotal
end

function LWBattleManager:LookAt(lookWorldPosition)
  local followTarget = self:GetFollowCameraTarget()
  followTarget.x = lookWorldPosition.x
  followTarget.y = lookWorldPosition.y
  followTarget.z = lookWorldPosition.z
  self.touchCamera:LookAt(lookWorldPosition + self.cameraOffset)
end

local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local velocity = Vector3.unity_vector3(0, 0, 0)

function LWBattleManager:CameraFollowLookAt(targetPos, smoothTime, smoothYTime, smoothDeltaTime)
  local transform = self.touchCameraTransform
  local x, y, z = transform:Get_position()
  local followCameraTarget = self:GetFollowCameraTarget()
  local offsetX = targetPos.x - followCameraTarget.x
  local offsetY = targetPos.y - followCameraTarget.y
  local offsetZ = targetPos.z - followCameraTarget.z
  local shakeOffsetX, shakeOffsetY, shakeOffsetZ = 0, 0, 0
  if not IsNull(self.cameraTween) then
    shakeOffsetX = shakePos.x - self.shakeTotal.x
    shakeOffsetY = shakePos.y - self.shakeTotal.y
    shakeOffsetZ = shakePos.z - self.shakeTotal.z
    self.shakeTotal.x = shakePos.x
    self.shakeTotal.y = shakePos.y
    self.shakeTotal.z = shakePos.z
  elseif self.shakeTotal then
    shakeOffsetX = self.shakeTotal.x * -1
    shakeOffsetY = self.shakeTotal.y * -1
    shakeOffsetZ = self.shakeTotal.z * -1
    self.shakeTotal = nil
  end
  if smoothTime then
    tmpV1:Set(x, y, z)
    local cameraOffsetTotal = self:GetFollowCameraOffset(x, y, z)
    cameraOffsetTotal.x = cameraOffsetTotal.x + offsetX + shakeOffsetX
    cameraOffsetTotal.y = cameraOffsetTotal.y + offsetY + shakeOffsetY
    cameraOffsetTotal.z = cameraOffsetTotal.z + offsetZ + shakeOffsetZ
    tmpV2:Set(cameraOffsetTotal.x, cameraOffsetTotal.y, cameraOffsetTotal.z)
    local tmpPos = Vector3.Lerp(tmpV1, tmpV2, 1 - Mathf.Exp(-smoothTime * smoothDeltaTime))
    local tmpY = Mathf.Lerp(tmpV1.y, tmpV2.y, 1 - Mathf.Exp(-smoothYTime * smoothDeltaTime))
    transform:Set_position(tmpPos.x, tmpY, tmpPos.z)
    tmpPos:ReturnPool()
  else
    transform:Set_position(x + offsetX + shakeOffsetX, y + offsetY + shakeOffsetY, z + offsetZ + shakeOffsetZ)
  end
  followCameraTarget.x = targetPos.x
  followCameraTarget.y = targetPos.y
  followCameraTarget.z = targetPos.z
end

function LWBattleManager:CameraShakeUpdate()
  local shakeOffsetX, shakeOffsetY, shakeOffsetZ = 0, 0, 0
  if not IsNull(self.cameraTween) then
    shakeOffsetX = shakePos.x - self.shakeTotal.x
    shakeOffsetY = shakePos.y - self.shakeTotal.y
    shakeOffsetZ = shakePos.z - self.shakeTotal.z
    self.shakeTotal.x = shakePos.x
    self.shakeTotal.y = shakePos.y
    self.shakeTotal.z = shakePos.z
    local transform = self.touchCameraTransform
    local x, y, z = transform:Get_position()
    transform:Set_position(x + shakeOffsetX, y + shakeOffsetY, z + shakeOffsetZ)
  elseif self.shakeTotal then
    shakeOffsetX = self.shakeTotal.x * -1
    shakeOffsetY = self.shakeTotal.y * -1
    shakeOffsetZ = self.shakeTotal.z * -1
    self.shakeTotal = nil
    local transform = self.touchCameraTransform
    local x, y, z = transform:Get_position()
    transform:Set_position(x + shakeOffsetX, y + shakeOffsetY, z + shakeOffsetZ)
  end
end

function LWBattleManager:LoadSceneComplete()
  pcall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.PVE
    CS.SceneManager.CurrentSceneSubType = GetEnumKey(PVEType, self.param.type)
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.PVE)
  if self.uiPveLoading then
    self.uiPveLoading:Quit()
  end
  EventManager:GetInstance():Broadcast(EventId.PveLevelEnter, self.levelId)
  self.touchCamera.CanMoveing = false
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:SetActive(false)
  end
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) then
    local desertUI = UIManager:GetInstance():GetWindow(uiStr)
    if desertUI and desertUI.View then
      desertUI.View:SetActive(false)
    end
  end
  if self.param and self.param.type == PVEType.Surfing then
    self.gamePause = false
  end
  CS.GameEntry.Sound:SetAMBSoundVolumeTo0()
end

function LWBattleManager:SetGameOver(v)
  self.gameOver = v
end

function LWBattleManager:SetGamePause(v)
  self.gamePause = v
  if self.logic and self.logic.SetGamePause then
    self.logic:SetGamePause(v)
  end
end

function LWBattleManager:SetGameStart(v)
  self.gameStart = v
end

function LWBattleManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function LWBattleManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function LWBattleManager:OnUpdate()
  if not self.gameStart or self.gamePause or self.gameOver then
    if self.gamePause and self.logic and self.logic.OnUpdatePause then
      self.logic:OnUpdatePause()
    end
    return
  end
  if self.logic then
    self.logic:OnUpdate()
  end
end

function LWBattleManager:OnUpdateSec()
  if not self.gameStart or self.gameOver or self.gamePause then
    return
  end
  if self.logic then
    self.logic:OnUpdateSec()
  end
end

function LWBattleManager:Exit(ExitAction, exitType)
  if self:ExitAsync(ExitAction, exitType) then
    return
  end
  CommonUtil.PlayerPrefsSetInt("PveLevelLosed", 0)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISkirmishResult) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishResult)
  end
  if self.fpsLockId ~= -1 then
    self.fpsLockId = CS.DynamicFPSConfig.FreeHighFPSLocker(self.fpsLockId)
  end
  DataCenter.LWSoundManager:StopAllSounds()
  self:Destroy()
  self:SetCurBattleLogic()
  EventManager:GetInstance():Broadcast(EventId.GF_pve_battle_exit, {
    id = self.param.levelId,
    type = exitType
  })
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    local action = ExitAction
    local onSceneCreated
    
    local function commonOnSceneCreated()
      Resource:ClearPoolByTagGroup(ObjectPoolTagGroup.Battle)
      if not UseReturnOptPveType[self.param.type] or not self:IsOpenReturnOpt() then
        collectgarbage("collect")
      end
    end
    
    if self.param.enterType == PVEEnterType.TruckRob or self.param.enterType == PVEEnterType.HSRRob or self.param.enterType == PVEEnterType.TrainRob or self.param.enterType == PVEEnterType.DetectCaveExploreEnter or self.param.enterType == PVEEnterType.DetectRetryTask or self.param.enterType == PVEEnterType.DetectAttackCityS0 or self.param.enterType == PVEEnterType.DetectZombieBusTrain and self.param.extraData.isInWorld then
      self.logic:AfterExit()
      
      function onSceneCreated()
        DataCenter.WarningBallManager:AddTimer()
        commonOnSceneCreated()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
        EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
        if action ~= nil then
          action()
        end
        DataCenter.GuideManager:DoWaitTriggerAfterBack()
        if self.param.enterType == PVEEnterType.DetectCaveExploreEnter then
          GoToUtil.GotoWorldPos(self.param.backWorldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            if exitType == "win" then
              if not UIUtil.CheckDetectCanCrossServer() and CrossServerUtil:NeedIntercept() then
                return
              end
              DataCenter.RadarCenterDataManager:RecordDetectTriggerTime()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
                anim = true,
                UIMainAnim = UIMainAnimType.AllHide
              })
            end
          end)
          return
        elseif self.param.enterType == PVEEnterType.DetectRetryTask then
          GoToUtil.GotoWorldPos(self.param.backWorldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            if CrossServerUtil:NeedIntercept() then
              return
            end
            if exitType == "win" and self.param.extraData and (self.param.extraData.eventType == DetectEventType.RESCUE_TASK or self.param.extraData.eventType == DetectEventType.OFF_SEASON_TREASURE) then
              DataCenter.FakeParkourRescueMarchManager:AddMarchIndex(self.param.extraData.pointId, self.param.extraData.prefabPath)
            end
          end)
          return
        elseif self.param.enterType == PVEEnterType.DetectAttackCityS0 then
          GoToUtil.GotoWorldPos(self.param.backWorldPos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
            if exitType == "win" then
              if CrossServerUtil:NeedIntercept() then
                return
              end
              local pointId, prefab = DataCenter.AttackCityAnimManager:GetMonsterRadarPointIdAndPrefab()
              if pointId and prefab then
                DataCenter.AttackCityAnimManager:ShowPointDeadAnim(pointId, prefab)
              end
            end
          end)
          return
        elseif self.param.enterType == PVEEnterType.HSRRob then
          RailwayUtil.TryOpenHSRRob()
          return
        end
        if self.param.enterType == PVEEnterType.DetectZombieBusTrain then
          DataCenter.RadarCenterDataManager:RequestToJumpZombieBusTrain(self.param.extraData.eventUuid, DetectEventZombieBusTrainJumpToType.WorldBattle)
        end
        if string.IsNullOrEmpty(exitType) then
          RailwayUtil.JumpToTrainByTrainData(self.param.extraData and self.param.extraData.trainData)
        end
      end
      
      SFSNetwork.SendMessage(MsgDefines.GoToWorld)
      SceneUtils.CreateWorld()
    elseif BattleFieldUtil.InBattleField() then
      function onSceneCreated()
        if self.logic then
          self.logic:AfterExit()
        end
        DataCenter.WarningBallManager:AddTimer()
        commonOnSceneCreated()
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
        EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
        local targetSId, targetWorldId = BattleFieldUtil.GetBattleServerInfo(LuaEntry.Player:GetCurWorldType())
        local position = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
        GoToUtil.GotoDragonPos(position, CS.SceneManager.World.InitZoom, 0.02, function()
          if action ~= nil then
            action()
          end
        end, targetSId, targetWorldId)
      end
      
      SceneUtils.CreateWorld()
    else
      function onSceneCreated()
        if self.logic then
          self.logic:AfterExit()
        end
        DataCenter.WarningBallManager:AddTimer()
        commonOnSceneCreated()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
        EventManager:GetInstance():Broadcast(EventId.OnEnterCity, {battleExitType = exitType})
        DataCenter.CityNpcManager:SetNpcVisible(true)
        if action ~= nil then
          action()
        end
        DataCenter.GuideManager:DoWaitTriggerAfterBack()
        if self.param.enterType == PVEEnterType.PVPArena then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.PeakArena, nil)
        elseif self.param.enterType == PVEEnterType.ActivityArena then
          if DataCenter.LWNewbieArenaManager.info then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
              anim = true,
              UIMainAnim = UIMainAnimType.AllHide
            }, tonumber(DataCenter.LWNewbieArenaManager.info.id))
          end
        elseif self.param.enterType == PVEEnterType.Arena3V3 then
          if exitType ~= "chat" then
            DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
          end
        elseif self.param.enterType == PVEEnterType.ActivityArenaV2 then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewbieArenaV2, nil)
        elseif self.param.enterType == PVEEnterType.Monopoly then
          DataCenter.MonopolyManager:TryMoveCameraEnterCity()
        elseif self.param.enterType == PVEEnterType.TorchRelayMain then
          if DataCenter.ActivityListDataManager:IsContainActivityGroup(CommonActivityGroupEnum.Christmas2024) then
            local actId = DataCenter.ActivityListDataManager:GetOpenIdByType(EnumActivity.TorchRelay.Type)
            if actId and tonumber(actId) > 0 then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIFestivalActivityCommonGroupShow, CommonActivityGroupEnum.Christmas2024, actId)
            end
          end
        elseif self.param.enterType == PVEEnterType.NewPeakArena then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewPeakArena, nil)
        elseif self.param.enterType == PVEEnterType.NewGaleArena then
          DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.NewGaleArena, nil)
        elseif self.param.enterType == PVEEnterType.DetectZombieBusTrain then
          DataCenter.RadarCenterDataManager:RequestToJumpZombieBusTrain(self.param.extraData.eventUuid, DetectEventZombieBusTrainJumpToType.CityBattle)
        elseif self.param.enterType == PVEEnterType.HeroTryOut and self.param.extraData and self.param.extraData.cfgId then
          local heroTryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param.extraData.cfgId)
          if heroTryOutTemplate then
            heroTryOutTemplate:OpenHeroDetail()
            if exitType == "win" then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroTryOutTask, {anim = true}, heroTryOutTemplate.hero_id, heroTryOutTemplate.tag_id)
              heroTryOutTemplate:TryPlayBackPlot()
            end
          end
        end
      end
      
      SceneUtils.CreateCity()
    end
    CS.SceneManager.World:CreateScene(onSceneCreated)
  end
  local uiStr = BattleFieldUtil.GetMainUIName()
  if not string.IsNullOrEmpty(uiStr) then
    local desertUI = UIManager:GetInstance():GetWindow(uiStr)
    if desertUI and desertUI.View then
      desertUI.View:SetActive(true)
    end
  else
    local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
    if mainUIView then
      mainUIView:SetActive(true)
    end
  end
  CS.GameEntry.Sound:ResetAMBSoundVolume()
end

function LWBattleManager:ExitAsync(ExitAction, exitType)
  local exitFlag = self.exitFlag
  self.exitFlag = nil
  if exitFlag and self.param.enterType == PVEEnterType.TowerupJeepAdventure and DataCenter.LWJeepAdventureManager:GetBackSwitchOn() then
    local action, type = ExitAction, exitType
    UIUtil.PlayCutSceneAnim(function()
      DataCenter.LWBattleManager:ExitNewHandler(action, type)
      DataCenter.LWJeepAdventureManager:SetBattleBackMark(true)
      DataCenter.LWHummerSceneManager:Enter()
    end, function()
      return DataCenter.LWHummerSceneManager:CheckLoadingState()
    end)
    return true
  elseif self.param.enterType == PVEEnterType.SeasonTower then
    local action, type = ExitAction, exitType
    DataCenter.LWSeasonTowerManager:OnAlertTowerBubbleClick(function()
      DataCenter.LWBattleManager:ExitNewHandler()
    end, action)
    return true
  end
  if exitFlag and self.param.enterType == PVEEnterType.StageFeatureScene then
    local action, type = ExitAction, exitType
    local tabType = self.param.stageFeatureTabType
    UIUtil.PlayCutSceneAnim(function()
      DataCenter.LWBattleManager:ExitNewHandler(action, type)
      DataCenter.StageFeatureSceneManager:Enter(tabType)
    end, function()
      return DataCenter.StageFeatureSceneManager:CheckLoadingState()
    end, nil, nil, nil, 2)
    return true
  end
  if self:HandleTrainTruncRobQuickExit(ExitAction, exitType) then
    return true
  end
  return false
end

function LWBattleManager:ExitNewHandler(ExitAction, exitType)
  CommonUtil.PlayerPrefsSetInt("PveLevelLosed", 0)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISkirmishResult) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishResult)
  end
  if self.fpsLockId ~= -1 then
    self.fpsLockId = CS.DynamicFPSConfig.FreeHighFPSLocker(self.fpsLockId)
  end
  DataCenter.LWSoundManager:StopAllSounds()
  self:Destroy()
  self:SetCurBattleLogic()
  EventManager:GetInstance():Broadcast(EventId.GF_pve_battle_exit, {
    id = self.param.levelId,
    type = exitType
  })
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    local action = ExitAction
    if self.logic then
      self.logic:AfterExit()
    end
    Resource:ClearPoolByTagGroup(ObjectPoolTagGroup.Battle)
    collectgarbage("collect")
    EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
    if action ~= nil then
      action()
    end
  end
end

function LWBattleManager:Restart()
  local p = self.param
  p.retry = true
  self:Destroy()
  self:Enter(p)
end

function LWBattleManager:GetPVEEnterType()
  if self.param == nil or self.param.enterType == nil then
    return PVEEnterType.Default
  end
  return self.param.enterType
end

function LWBattleManager:SetPVEEnterType(type)
  if self.param and self.param.enterType then
    self.param.enterType = type
  end
end

function LWBattleManager:IsBattleFinish()
  return self.logic.IsBattleFinish and self.logic:IsBattleFinish() or self.gameOver
end

function LWBattleManager:JumpLevel(levelId)
  if not CS.CommonUtils.IsDebug() then
    return
  end
  levelId = tonumber(levelId) or 0
  if levelId <= 0 then
    return
  end
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), levelId)
  if line then
    local param = {}
    param.type = PVEType.Parkour
    param.enterType = PVEEnterType.GM
    param.levelId = levelId
    param.memRecord = true
    DataCenter.LWBattleManager:Enter(param)
    return
  end
  DataCenter.ZombieBattleManager:Destroy()
  local param = {}
  param.type = PVEType.Barrage
  param.enterType = PVEEnterType.GM
  param.levelId = levelId
  param.levelGroupId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), levelId, "group")
  DataCenter.ZombieBattleManager:Enter(param)
end

function LWBattleManager:PlayReplay(mailUid)
  if not string.IsNullOrEmpty(mailUid) then
    if BattleReportUtil.UseCDNBattleReport() then
      local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailUid)
      local ext = mailInfo and mailInfo:GetMailExt() or nil
      local isAddressMode = false
      local address = ""
      if ext then
        isAddressMode = ext and ext.GetIfAddressMode and ext:GetIfAddressMode() or false
        if isAddressMode then
          address = ext:GetBattleDownloadAddress()
        end
      end
      BattleReportUtil.Create(tonumber(mailUid), nil, nil, isAddressMode, address)
    else
      SFSNetwork.SendMessage(MsgDefines.MailGetFightReportDetail, tonumber(mailUid))
    end
  end
end

function LWBattleManager:PlayLastReplay()
  local mailUid = CommonUtil.PlayerPrefsGetString("LAST_SKIRMISH_MAIL_UUID")
  self:PlayReplay(mailUid)
end

function LWBattleManager:TestSetWaterFresnelValue(value)
  if self.logic and self.logic.TestSetWaterFresnelValue then
    self.logic:TestSetWaterFresnelValue(value)
  end
end

function LWBattleManager:RestartParam(param)
  self:Destroy()
  self:Enter(param)
end

function LWBattleManager:GetTmpHeroUuid()
  self.tmpHeroUuid = self.tmpHeroUuid - 1
  if self.tmpHeroUuid == IntMinValue then
    self.tmpHeroUuid = -1
  end
  return self.tmpHeroUuid
end

function LWBattleManager:GetParkourFirstGuideStageId()
  if self.parkourFirstGuideStageId == nil then
    self.parkourFirstGuideStageId = LuaEntry.DataConfig:TryGetNum("first_guide_stage", "k1")
  end
  return self.parkourFirstGuideStageId
end

function LWBattleManager:DebugPlayTorchRelayBattle(stageId)
  local param = {}
  param.type = PVEType.TorchRelay
  param.enterType = PVEEnterType.GM
  param.levelId = stageId
  DataCenter.LWBattleManager:Enter(param)
end

function LWBattleManager:DebugPlayLWHummerScene()
  UIUtil.PlayCutSceneAnim(function()
    DataCenter.LWHummerSceneManager:Enter()
  end, function()
    return DataCenter.LWHummerSceneManager:CheckLoadingState()
  end)
end

function LWBattleManager:DebugPlayDominatorBattle(dominatorUpId)
  DataCenter.ZombieBattleManager:Destroy()
  DataCenter.LWBattleManager:Destroy()
  local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpTemplate(tonumber(dominatorUpId))
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.TowerupJeepAdventure
  param.levelId = tonumber(dominatorUpTemplate.level_id)
  param.sceneId = tonumber(dominatorUpTemplate.scene_id)
  param.extraData = {}
  param.extraData.cfgId = tonumber(dominatorUpId)
  param.extraData.pageType = JeepAdventurePageType.Domintor
  DataCenter.LWBattleManager:Enter(param)
end

function LWBattleManager:GetBonusDashLevelData()
  if self.bonusDashLevelData == nil then
    self.bonusDashLevelData = {}
    local d1 = self:GetBonusDashLevelCfg("k1")
    if d1 ~= nil then
      table.insert(self.bonusDashLevelData, d1)
    end
    d1 = self:GetBonusDashLevelCfg("k2")
    if d1 ~= nil then
      table.insert(self.bonusDashLevelData, d1)
    end
    d1 = self:GetBonusDashLevelCfg("k3")
    if d1 ~= nil then
      table.insert(self.bonusDashLevelData, d1)
    end
    d1 = self:GetBonusDashLevelCfg("k4")
    if d1 ~= nil then
      table.insert(self.bonusDashLevelData, d1)
    end
    d1 = self:GetBonusDashLevelCfg("k5")
    if d1 ~= nil then
      table.insert(self.bonusDashLevelData, d1)
    end
  end
  return self.bonusDashLevelData
end

function LWBattleManager:GetBonusDashLevelCfg(k)
  local d1 = LuaEntry.DataConfig:TryGetStr("bonus_level_type", k)
  if not string.IsNullOrEmpty(d1) then
    local d1Array = string.split(d1, "|")
    if d1Array and #d1Array == 5 then
      local data = {}
      data.progress = tonumber(d1Array[1]) / 100
      data.speedCof = tonumber(d1Array[2]) or 1
      data.anim = d1Array[3]
      data.eff = d1Array[4] ~= "0" and d1Array[4] or ""
      data.damageCof = tonumber(d1Array[5]) or 1
      return data
    end
  end
  return nil
end

function LWBattleManager:SetBattleExitFlag(flag)
  self.exitFlag = flag
end

function LWBattleManager:CheckMemRecord()
  if self.param and self.param.memRecord and self.memRecordFlag then
    self.memRecordFlag = false
    return true
  end
  return false
end

function LWBattleManager:GetMemRecord()
  local recordMemNrsv, recordMemNuse, recordMemMrsv, recordMemMuse = self.recordMemNrsv, self.recordMemNuse, self.recordMemMrsv, self.recordMemMuse
  self.recordMemNrsv, self.recordMemNuse, self.recordMemMrsv, self.recordMemMuse = 0, 0, 0, 0
  local memNrsv, memNuse, memMrsv, memMuse = CS.CSUtils.GetMemRecord()
  if 0 < recordMemNrsv and 0 < recordMemNuse and 0 < recordMemMrsv and 0 < recordMemMuse then
    return memNrsv, memNuse, memMrsv, memMuse, memNrsv - recordMemNrsv, memNuse - recordMemNuse, memMrsv - recordMemMrsv, memMuse - recordMemMuse
  else
    return memNrsv, memNuse, memMrsv, memMuse, 0, 0, 0, 0
  end
end

function LWBattleManager:SetTestSurfingData(data)
  if not string.IsNullOrEmpty(data) then
    local array = string.split(data, "|")
    if #array == 5 then
      self.lineOffset = tonumber(array[1]) or 3
      self.lineChangeTime = tonumber(array[2]) or 0.1
      self.jumpForce = tonumber(array[3]) or 15
      self.gravity = tonumber(array[4]) or -30
      self.slideTime = tonumber(array[5]) or 0.5
      self.touchThreshold = tonumber(array[6]) or 20
    end
  end
end

function LWBattleManager:SetTestSurfingDeco(ignoreDecoration)
  self.ignoreDecoration = ignoreDecoration
end

function LWBattleManager:SetTestCameraMoveFactor(value)
  self.cameraMoveFactor = value or 2
end

function LWBattleManager:SetTestCameraMoveType(type)
  self.cameraMoveType = type or 1
end

function LWBattleManager:ShowTipsId(msgId, showTime, playerHead, heroHead, isUseOldUI, offsetY, isAlHelpMsg, alHelpInfo)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleMessageBar, {anim = true, playEffect = false})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIBattleMessageBar)
  local view = window and window.View
  if view then
    view:AddNewMsg_MsgId(msgId, showTime, playerHead, heroHead, offsetY, isAlHelpMsg, alHelpInfo)
  end
end

function LWBattleManager:IsOpenReturnOpt()
  return LuaEntry.Player:IsOpenReturnOpt()
end

function LWBattleManager:SetBattleExitStartTime(type)
  if self.battleExitTimeByType == nil then
    self.battleExitTimeByType = {}
  end
  self.battleExitTimeByType[type] = Time.realtimeSinceStartup
end

function LWBattleManager:SetBattleExitEndTime(type)
  if self.battleExitTimeByType and self.battleExitTimeByType[type] then
    local diff = tonumber(string.formatDecimal(Time.realtimeSinceStartup - self.battleExitTimeByType[type], 2))
    PostEventLog.Track(PostEventLog.Defines.BattleExitTimeByType, {battle_type = type, end_time = diff})
    self.battleExitTimeByType[type] = nil
  end
end

function LWBattleManager:HandleTrainTruncRobQuickExit(ExitAction, exitType)
  if self.param == nil or self.param.extraData == nil then
    return false
  end
  local isTruckQuickRob = self.param.extraData.isTruckQuickRob and self.param.enterType == PVEEnterType.TruckRob
  local isTrainQuickRob = DataCenter.LWKOFBattleManager:GetIsQuickRob() and self.param.enterType == PVEEnterType.TrainRob
  if isTruckQuickRob or isTrainQuickRob then
    DataCenter.LWKOFBattleManager:SetIsQuickRob(false)
    local action, type = ExitAction, exitType
    UIUtil.PlayCutSceneAnim(function()
      local uuid = 0
      if self.param.extraData.trainData then
        uuid = checknumber(self.param.extraData.trainData.uuid)
      end
      DataCenter.LWTrainDataManager:TryGetTrainList()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainScene, {anim = true}, TrainTab.Enemy, uuid)
      DataCenter.LWBattleManager:ExitNewHandler(action, type)
      SceneUtils.CreateCity()
      CS.SceneManager.World:CreateScene(function()
        EventManager:GetInstance():Broadcast(EventId.OnEnterCity, {battleExitType = exitType})
      end)
      local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
      if mainUIView then
        mainUIView:SetActive(true)
      end
    end, function()
      if DataCenter.TrainSceneManager:Loaded() then
        return true
      end
      local loadedTime = DataCenter.TrainSceneManager:LoadTime()
      if 0 < loadedTime and UITimeManager:GetInstance():GetServerTime() - loadedTime > 2000 then
        return true
      end
      return false
    end)
    return true
  end
  return false
end

function LWBattleManager:CanPlayBgm()
  return DataCenter.LWSeasonTowerSceneManager.inSeasonTowerScene
end

function LWBattleManager:PlayBgm()
  if DataCenter.LWSeasonTowerSceneManager.inSeasonTowerScene then
    DataCenter.LWSeasonTowerManager:PlayBgm()
  end
end

return LWBattleManager
