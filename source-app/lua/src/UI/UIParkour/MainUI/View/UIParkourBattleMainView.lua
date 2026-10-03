local Const = require("Scene.LWBattle.Const")
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local UIMysteryFeatureProgress = require("UI.UIParkour.MainUI.Component.UIMysteryFeatureProgress")
local Resource = CS.GameEntry.Resource
local ParkourJoystick = require("UI.UIParkour.MainUI.Component.ParkourJoystick")
local ParkourBonusPanel = require("UI.UIParkour.MainUI.Component.ParkourBonus.ParkourBonusPanel")
local TacticalWeaponSkillNodeComponent = require("UI.UIParkour.MainUI.Component.TacticalWeaponSkillNodeComponent")
local ParkourWinTypeStyle = {Normal = 1, Slider = 2}
local ParkourWinTypeSliderRender = require("UI.UIParkour.MainUI.Component.ParkourWinTypeSliderRender")
local ParkourWinTypeNormalRender = require("UI.UIParkour.MainUI.Component.ParkourWinTypeNormalRender")
local UIParkourHeroAwakenSkillComponent = require("UI/UIParkour/MainUI/Component/UIParkourHeroAwakenSkillComponent")
local UIParkourBattleMainView = BaseClass("UIParkourBattleMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local speedUpEff = "SafeArea/TopEffect/Eff_UI_suduxian"
local safeArea = "SafeArea/"
local BossNoticeCD = 5
local BossNoticeHideTime = 2
local ParkourBonusPanelPrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourBattleMainBonusPanel.prefab"
local win_condition_hor_layout_path = "SafeArea/WinCondition/WinConditionHorLayout"
local ResourceArray = {
  ResourceType.Wood,
  ResourceType.Metal,
  ResourceType.Food,
  ResourceType.Gold
}

function UIParkourBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitWinCondition()
  self:InitRes()
  self:InitLevelInfo()
  if self:GetUserData().onOpen then
    self:GetUserData().onOpen()
  end
  self.bonusEnter = false
  EventManager:GetInstance():Broadcast(EventId.ParkourBattleMainViewCreated)
end

function UIParkourBattleMainView:OnDestroy()
  if self.winConditionAsyncReq then
    for i, v in ipairs(self.winConditionAsyncReq) do
      v:Destroy()
    end
  end
  self.winConditionAsyncReq = nil
  self:ComponentDestroy()
  self:ClearEffectRes()
  self.bonusEnter = nil
  self.isMultipleWinCondition = nil
  base.OnDestroy(self)
  if self.featureResourceReq ~= nil then
    self.featureResourceReq:Destroy()
    self.featureResourceReq = nil
  end
  self:ClearAllDelayTimers()
end

function UIParkourBattleMainView:ComponentDefine()
  if CS.CommonUtils.IsDebug() then
    self.GMText = self:AddComponent(UIText, "GmWinBtn/GMText")
    local logInfo = DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId()
    if LuaEntry and LuaEntry.Player then
      local player = LuaEntry.Player
      if player.uid then
        logInfo = logInfo .. [[

 uid:]] .. player.uid
      end
      if player.abTest then
        if player.abTest == ABTestType.B then
          logInfo = logInfo .. [[

 abTest:B]]
        elseif player.abTest == ABTestType.A then
          logInfo = logInfo .. [[

 abTest:A]]
        end
        logInfo = logInfo .. [[

 gpuskin:]] .. tostring(DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.PveUseGpuSkin))
      end
    end
    self.GMText:SetText(logInfo)
    self.gm_win_btn = self:AddComponent(UIButton, "GmWinBtn")
    self.gm_win_btn:SetOnClick(function()
      DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
    end)
    self.jump_guide_btn = self:AddComponent(UIButton, "SafeArea/Guide/jumpGuide")
    self.jump_guide_btn:SetOnClick(function()
      DataCenter.LWGuideManager:ClearData()
      DataCenter.LWBattleManager:SetGamePause(false)
      DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
      local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name)
      if CanvasNormal then
        CanvasNormal.gameObject:SetActive(true)
      end
      SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.Over)
    end)
    self.jump_guide_btn:SetActive(false)
  else
    self.transform:Find("SafeArea/Guide/jumpGuide").gameObject:SetActive(false)
    self.transform:Find("GmWinBtn").gameObject:SetActive(false)
  end
  self.safeArea = self:AddComponent(UIBaseContainer, "SafeArea")
  self.winConditionArea = self:AddComponent(UIBaseComponent, "SafeArea/WinCondition")
  self.winConditionArea:SetLocalScaleXYZ(0, 0, 0)
  self.winConditionHorLayout = self:AddComponent(UIBaseContainer, win_condition_hor_layout_path)
  self.animator = self:AddComponent(UIAnimator, "")
  self.winBanner = self:AddComponent(UIBaseComponent, "WinBanner")
  self.winBanner:SetActive(false)
  self.winBannerTxt = self:AddComponent(UIText, "WinBanner/WinBannerText")
  self.winBannerTxt:SetLocalText(GameDialogDefine.MISSION_COMPLETE)
  self.speedUpEffect = self:AddComponent(UIBaseContainer, speedUpEff)
  self.speedUpEffect:SetActive(false)
  self.joystick = self:AddComponent(ParkourJoystick, "SafeArea/Joystick")
  self.joystick:SetActive(true)
  self.joystick:ReInit()
  DataCenter.LWBattleManager.logic:SetJoystick(self.joystick)
  self.back_btn = self:AddComponent(UIButton, "SafeArea/BackBtn")
  self.back_btn:SetActive(true)
  self.back_btn:SetOnClick(function()
    self:OnExitBtnClick()
  end)
  local btnContentContainer = self:AddComponent(UIBaseContainer, "SafeArea/Guide/btnContent")
  local btnContentContainer_new = self:AddComponent(UIBaseContainer, "SafeArea/Guide/btnContent_new")
  if self.ctrl:UseNewLogin() then
    btnContentContainer:SetActive(false)
    btnContentContainer_new:SetActive(true)
    btnContentContainer_new:SetAnchorMinXY(0.5, 0.5)
    btnContentContainer_new:SetAnchorMaxXY(0.5, 0.5)
    btnContentContainer_new:SetPivotXY(0.5, 0.5)
    btnContentContainer_new:SetAnchoredPositionXY(0, -360)
    self.startGame_Btn = self:AddComponent(UIButton, "SafeArea/Guide/btnContent_new/startGameBtn_new")
    self.startGame_text = self:AddComponent(UIText, "SafeArea/Guide/btnContent_new/startGameBtn_new/Text_new")
    self.loginGameBtn = self:AddComponent(UIButton, "SafeArea/Guide/btnContent_new/loginGameBtn_new")
    self.loginBtnText = self:AddComponent(UIText, "SafeArea/Guide/btnContent_new/loginGameBtn_new/loginBtnText_new")
    self.loginBtnText:SetText("<u>" .. Localization:GetString("login_btn_login") .. "</u>")
  else
    btnContentContainer:SetActive(true)
    btnContentContainer_new:SetActive(false)
    btnContentContainer:SetAnchorMinXY(0.5, 0.5)
    btnContentContainer:SetAnchorMaxXY(0.5, 0.5)
    btnContentContainer:SetPivotXY(0.5, 0.5)
    btnContentContainer:SetAnchoredPositionXY(0, -360)
    self.startGame_Btn = self:AddComponent(UIButton, "SafeArea/Guide/btnContent/startGameBtn")
    self.startGame_text = self:AddComponent(UIText, "SafeArea/Guide/btnContent/startGameBtn/Text")
    self.loginGameBtn = self:AddComponent(UIButton, "SafeArea/Guide/btnContent/loginGameBtn")
    self.loginBtnText = self:AddComponent(UIText, "SafeArea/Guide/btnContent/loginGameBtn/loginBtnText")
    self.loginBtnText:SetLocalText(110008)
  end
  self.startGame_text:SetLocalText(100833)
  self.map_btn = self:AddComponent(UIButton, "Map")
  self.map_btn:SetOnClick(function()
    self:OnMapClick()
  end)
  self.startGame_Btn:SetOnClick(function()
    self:OnStartGameClick()
  end)
  self.loginGameBtn:SetOnClick(function()
    self:OnLoginGameClick()
  end)
  local state = DataCenter.AccountManager:GetAccountBindState()
  self.loginGameBtn:SetActive(state ~= AccountBandState.Band)
  if CS.GameEntry.Setting.IsReview then
    self.loginGameBtn:SetActive(false)
  end
  self.guide = self.transform:Find("SafeArea/Guide").gameObject
  self.resContent = self:AddComponent(UIBaseContainer, "SafeArea/ResNode")
  self.resContent:SetActive(true)
  self.resPrefab = self.transform:Find("SafeArea/ResNode/UIMainTopResourceCell").gameObject
  self.resPrefab:GameObjectCreatePool()
  self.resPrefab:SetActive(false)
  self.resCells = {}
  self.missionBar = self:AddComponent(UISimpleAnimation, safeArea .. "Mission")
  self.missionText = self:AddComponent(UIText, safeArea .. "Mission/hengfu/Text_0")
  self.missionTarText = self:AddComponent(UIText, safeArea .. "Mission/hengfu/Text_1")
  self.missionIcon = self:AddComponent(UIImage, safeArea .. "Mission/hengfu/MissionIcon")
  self.missionBg = self:AddComponent(UIImage, safeArea .. "Mission/hengfu/sanjiao")
  self.missionBar:SetActive(false)
  self.bossNoticeContainer = self:AddComponent(UIBaseContainer, "BossComing")
  self.bossNotice = self:AddComponent(UIAnimator, "BossComing")
  self.bossNotice.gameObject:SetActive(false)
  self.bossNoticeText = self.bossNoticeContainer:AddComponent(UIText, "Text_0")
  self.lastBossNoticeTime = Time.realtimeSinceStartup
  self.tacticalWeaponSkillNodeComponent = self:AddComponent(TacticalWeaponSkillNodeComponent, "SafeArea/TacticalWeaponSkillNode")
  self.tacticalWeaponSkillNodeComponent:SetActive(true)
  self.levelNameText = self:AddComponent(UIText, "SafeArea/LevelNameText")
  self.levelNameText.transform:Set_localScale(0, 0, 0)
  self.heroAwakenSkillRoot = self:AddComponent(UIBaseContainer, "SafeArea/HeroAwakenSkillRoot")
  local param = self:GetUserData()
  if param and param.dashBonus then
    self:GetParkourBonusDash()
  end
end

function UIParkourBattleMainView:ComponentDestroy()
  self.missionIcon = nil
  self.missionBg = nil
  self.safeArea = nil
  self.back_btn = nil
  self.heroAwakenSkillRoot = nil
  self:ClearResContent()
  self.resContent = nil
  self.resPrefab = nil
  self.resCells = nil
  self.joystick = nil
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  if self.showCondition then
    self.showCondition:Stop()
    self.showCondition = nil
  end
  if self.bossNoticeExitTimer then
    self.bossNoticeExitTimer:Stop()
    self.bossNoticeExitTimer = nil
  end
  if IsNotNull(self.winConditionAreaTweener) then
    self.winConditionAreaTweener:Kill()
  end
  self.winConditionAreaTweener = nil
  if IsNotNull(self.levelNameTextTweener) then
    self.levelNameTextTweener:Kill()
  end
  self.levelNameTextTweener = nil
  self.parkourBonusPanel = nil
  self.bonusDash = nil
  self.bossHpBar = nil
  if self.openEffectTimer then
    self.openEffectTimer:Stop()
    self.openEffectTimer = nil
  end
  self.winConditionHorLayout = nil
end

function UIParkourBattleMainView:ClearResContent()
  self.resCells = {}
  self.resContent:RemoveComponents(UIMainResourceProgress)
  self.resPrefab:GameObjectRecycleAll()
end

function UIParkourBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SquadSuperArmorStateChange, self.SquadSuperArmorChange)
  self:AddUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:AddUIListener(EventId.ParkourBossEnterBattle, self.OnBossEnter)
  self:AddUIListener(EventId.ParkourBossHpViewChanged, self.OnParkourBossHpViewChanged)
  self:AddUIListener(EventId.ParkourBossHpViewDead, self.OnParkourBossHpViewDead)
  self:AddUIListener(EventId.OnPVECastHeroAwakenSkill, self.OnPVECastHeroAwakenSkill)
end

function UIParkourBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.SquadSuperArmorStateChange, self.SquadSuperArmorChange)
  self:RemoveUIListener(EventId.OnPVEBattleGetGoods, self.OnPVEBattleGetGoods)
  self:RemoveUIListener(EventId.ParkourBossEnterBattle, self.OnBossEnter)
  self:RemoveUIListener(EventId.ParkourBossHpViewChanged, self.OnParkourBossHpViewChanged)
  self:RemoveUIListener(EventId.ParkourBossHpViewDead, self.OnParkourBossHpViewDead)
  self:RemoveUIListener(EventId.OnPVECastHeroAwakenSkill, self.OnPVECastHeroAwakenSkill)
  base.OnRemoveListener(self)
end

function UIParkourBattleMainView:InitRes()
  self.resData = {}
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(logic.param.featureId)
    local index = 1
    if 1 < #feature.winType then
      index = table.indexof(feature.stages, logic.param.levelId)
    end
    local iconUrl
    local resType = 2
    if feature.winType[index] ~= 3 then
      self:CreateDelayTimer(function()
        if self.transform then
          if #feature.winType == 1 then
            if feature.winType[index] == 1 then
              local content = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
              self:ShowCondition("", content, 1)
            elseif feature.winType[index] == 2 then
              if #feature.stages == 1 then
                local content = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
                self:ShowCondition("", content, 1)
              else
                local content = Localization:GetString("newbies_fuben_battlefront_loading", tostring(feature.winNeedCount[index]))
                self:ShowCondition("", content, 1)
              end
            end
          elseif feature.winType[index] == 1 then
            local content = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
            self:ShowCondition("", content, 1)
          elseif feature.winType[index] == 2 then
            local content = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
            self:ShowCondition("", content, 1)
          elseif feature.winType[index] == 0 then
            local content = Localization:GetString("newbies_fuben_attack_loading")
            self:ShowCondition("", content, 1)
          end
        end
      end, 1)
      if feature.winType[index] == 1 or feature.winType[index] == 2 then
        self.featureResourceReq = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ParkourBattle/GrowResource.prefab")
        self.featureResourceReq:completed("+", function()
          self.resData[resType] = 0
          local item = self.featureResourceReq.gameObject
          item.transform:SetParent(self.resContent.transform)
          item.name = "Res" .. 1
          local cell = self.resContent:AddComponent(UIMysteryFeatureProgress, item.name)
          local param = {}
          if feature.winType[index] == 1 then
            iconUrl = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_zhujiemian_tubiao_ziyuan1.png"
            cell:SetActive(false)
          elseif feature.winType[index] == 2 then
            iconUrl = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png"
            param.soldier = true
            cell:SetActive(true)
          end
          param.resourceType = resType
          param.iconName = iconUrl
          param.showCount = 0
          param.maxCount = feature.winNeedCount[index]
          cell:SetZero(param)
          self.resCells[resType] = cell
        end)
      end
    end
  elseif logic.data.collectType then
    local resType, iconUrl, isSoldier
    if logic.data.collectType == DetectEventRetryTaskCollectType.Soldier then
      resType = 2
      iconUrl = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png"
      isSoldier = true
    else
      resType = DetectEventRetryTaskCollectType2ResourceType[logic.data.collectType]
      iconUrl = DataCenter.ResourceManager:GetResourceIconByType(resType)
      isSoldier = false
    end
    self.featureResourceReq = Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ParkourBattle/GrowResource.prefab")
    self.featureResourceReq:completed("+", function()
      self.resData[resType] = 0
      local item = self.featureResourceReq.gameObject
      item.transform:SetParent(self.resContent.transform)
      item.name = "Res" .. 1
      local cell = self.resContent:AddComponent(UIMysteryFeatureProgress, item.name)
      local param = {}
      param.soldier = isSoldier
      cell:SetActive(isSoldier)
      param.resourceType = resType
      param.iconName = iconUrl
      param.showCount = 0
      param.maxCount = logic.data.collectMaxNum
      cell:SetZero(param)
      self.resCells[resType] = cell
    end)
  else
    for i = 1, 1 do
      local resType = ResourceArray[i]
      self:AddResCell(resType)
    end
  end
end

function UIParkourBattleMainView:AddResCell(resType)
  self.resData[resType] = 0
  local item = self.resPrefab:GameObjectSpawn(self.resContent.transform)
  item.name = "Res" .. resType
  local cell = self.resContent:AddComponent(UIMainResourceProgress, item.name)
  local param = {}
  param.resourceType = resType
  param.iconName = DataCenter.ResourceManager:GetResourceIconByType(resType)
  param.showCount = 0
  cell:SetZero(param)
  cell:SetActive(false)
  self.resCells[resType] = cell
end

function UIParkourBattleMainView:OnPVEBattleGetGoods(param)
  if self.bonusEnter then
    self:OnBonusRefresh(param)
    return
  end
  if self.resCells[param.goodsId] == nil then
    self:AddResCell(param.goodsId)
  end
  self.resCells[param.goodsId]:SetActive(true)
  local pic = DataCenter.ResourceManager:GetResourceIconByType(param.goodsId)
  local srcPos = CS.CSUtils.WorldPositionToUISpacePosition(param.worldPosition)
  local targetPos = self.resCells[param.goodsId]:GetResourcePos()
  local FlyParkourPath = "Assets/_Art/Effect/prefab/ui/Common/FlyParkour.prefab"
  DataCenter.FlyController.DoFlyForLua(pic, nil, 1, srcPos, targetPos, 40, 40, function()
    self:AddRes(param.goodsId, param.goodsCount)
  end, FlyParkourPath, nil, -50, nil, nil)
end

function UIParkourBattleMainView:AddRes(goodsId, goodsCount)
  local param = {}
  param.resourceType = goodsId
  self.resData[goodsId] = self.resData[goodsId] + goodsCount
  param.showCount = self.resData[goodsId]
  self.resCells[goodsId]:SetData(param)
end

function UIParkourBattleMainView:OnStartGameClick()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_battle_start_btn, false)
  self.winConditionArea:SetActive(true)
  self.guide:SetActive(false)
  DataCenter.LWGuideManager:GuideStartGame()
end

function UIParkourBattleMainView:OnLoginGameClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseSwitchAccount, 110008)
end

function UIParkourBattleMainView:OnExitBtnClick()
  if DataCenter.LWBattleManager.logic.winTimer or DataCenter.LWBattleManager.gameOver then
    return
  end
  if DataCenter.LWBattleManager:IsFromActBreakSunday() then
    DataCenter.LWBattleManager:SetGamePause(true)
    UIUtil.ShowMessage(Localization:GetString("activity_breakthrough_tips_20"), 2, "breakthough_button_04", "breakthough_button_03", function()
      self:OnExit()
      local firstActId = DataCenter.ActFrontBreakSundayDataManager:GetFirstActId()
      if firstActId ~= -1 then
        DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.ActFrontBreakSunday)
        local preLoadAssets = {
          [UIAssets.ActivityTabGroupItem] = true,
          [UIAssets.UIActivityListItem] = true,
          [UIAssets.FrontBreakSunday] = true
        }
        GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, firstActId, preLoadAssets)
      end
    end, function()
      DataCenter.LWBattleManager:SetGamePause(false)
    end, function()
      DataCenter.LWBattleManager:SetGamePause(false)
    end)
    return
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    DataCenter.StageFeatureBuildingManager:OnExitBattle(logic.param.buildUuid)
  end
  self:OnExit()
end

function UIParkourBattleMainView:OnMapClick()
end

function UIParkourBattleMainView:OnExit()
  PostEventLog.BattleResultLog(PVEType.Parkour, 2)
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local enterType = logic and logic.param and logic.param.enterType
  if enterType == PVEEnterType.TowerupJeepAdventure or enterType == PVEEnterType.StageFeatureScene then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "quit")
end

function UIParkourBattleMainView:GetWinConditionPrefabAndStyle(winType)
  local prefab = ""
  local style = ParkourWinTypeStyle.Normal
  if winType == Const.ParkourWinType.KillTargetMonster then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeKillMonsterItem.prefab"
    style = ParkourWinTypeStyle.Slider
  elseif winType == Const.ParkourWinType.KillMonster then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeKillMonsterItem.prefab"
    style = ParkourWinTypeStyle.Slider
  elseif winType == Const.ParkourWinType.FinishPoint then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeFinishPointItem.prefab"
    style = ParkourWinTypeStyle.Slider
  elseif winType == Const.ParkourWinType.Time then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeTimeItem.prefab"
    style = ParkourWinTypeStyle.Slider
  elseif winType == Const.ParkourWinType.KillBoss then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeKillBossItem.prefab"
    style = ParkourWinTypeStyle.Normal
  elseif winType == Const.ParkourWinType.SaveWorker then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeSaveWorkerItem.prefab"
    style = ParkourWinTypeStyle.Slider
  elseif winType == Const.ParkourWinType.BlastStandingWaterBottle then
    prefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourWinTypeBlastStandingWaterBottleItem.prefab"
    style = ParkourWinTypeStyle.Normal
  end
  return prefab, style
end

function UIParkourBattleMainView:InitWinCondition()
  local isLevelOneGuide = DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne
  local showWinCondition = not isLevelOneGuide
  self.winConditionArea:SetActive(showWinCondition)
  if showWinCondition then
    self.winConditionAsyncReq = {}
    local index = 0
    for winType, v in pairs(DataCenter.LWBattleManager.logic.winConditions) do
      local prefabName, winStyle = self:GetWinConditionPrefabAndStyle(winType)
      local cmp = ParkourWinTypeNormalRender
      if winStyle == ParkourWinTypeStyle.Slider then
        cmp = ParkourWinTypeSliderRender
      end
      if not string.IsNullOrEmpty(prefabName) then
        if winType == Const.ParkourWinType.KillBoss then
          local showCount = v.needKillNum and v.needKillNum or 0
          for j = 1, showCount do
            index = index + 1
            local typeIndex = j
            local itemIndex = index
            self:CreateWinItem(itemIndex, prefabName, winType, cmp, typeIndex)
          end
        else
          index = index + 1
          local itemIndex = index
          self:CreateWinItem(itemIndex, prefabName, winType, cmp, 1)
        end
      end
    end
    local isShowLevelNameText = self:IsShowLevelNameText()
    if isShowLevelNameText then
      self.winConditionArea:SetAnchoredPositionXY(0, -60)
    else
      self.winConditionArea:SetAnchoredPositionXY(0, -10)
    end
  end
  local param = self:GetUserData()
  if param.showGuide then
    self.back_btn:SetActive(false)
    self.guide:SetActive(true)
    self.winConditionArea:SetActive(false)
    DataCenter.LWBattleManager:SetGamePause(true)
  else
    self.back_btn:SetActive(true)
    if DataCenter.LWGuideManager:GetIsStart() and DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne then
      self.back_btn:SetActive(false)
    end
    self.guide:SetActive(false)
  end
  if isLevelOneGuide then
    if DataCenter.AccountManager:IsShumeiCreateAccountRisk() then
      local isOn = CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_SHUMEI_CREATE_ACCOUNT_RISK_BAN)
      if isOn then
        self.startGame_Btn:SetActive(false)
      end
      PostEventLog.Track(PostEventLog.Defines.ShumeiCreateAccountRiskBan, {emulator_baned = "hide_start"})
    elseif CS.ShumeiSdkManager.Instance:IsForbidCreateRole() then
      self.startGame_Btn:SetActive(false)
      PostEventLog.Track("s_shu_mei_create_role_ban", {s_para1 = "hide_start"})
    elseif CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_ACCOUNT_SELECT_STATE) and CS.GameEntry.GlobalData.LoginServerError == false then
      self:RemoveBtnJustStartGame()
    end
  end
end

function UIParkourBattleMainView:CreateWinItem(itemIndex, prefabName, winType, cmp, slotIndex)
  local request = Resource:InstantiateAsync(prefabName)
  request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.transform:SetParent(self.winConditionHorLayout.transform)
    go.transform:Set_localScale(1, 1, 1)
    local name = "WinItem_" .. tostring(itemIndex)
    go.name = name
    go:SetActive(true)
    local winCmp = self.winConditionHorLayout:AddComponent(cmp, go)
    winCmp:InitData(winType, slotIndex)
  end)
  table.insert(self.winConditionAsyncReq, request)
end

function UIParkourBattleMainView:RemoveBtnJustStartGame()
  self.winConditionArea:SetActive(true)
  self.guide:SetActive(false)
  DataCenter.LWGuideManager:GuideStartGame()
end

function UIParkourBattleMainView:InitLevelInfo()
  local isShowLevelNameText = self:IsShowLevelNameText()
  self.levelNameText:SetActive(isShowLevelNameText)
  if not isShowLevelNameText then
    return
  end
  local param = DataCenter.LWBattleManager.param
  local fromActFrontBreakSunday = param.fromActFrontBreakSunday
  local stageId = param.levelId
  local levelTitle = ""
  if fromActFrontBreakSunday then
    local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId)
    local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
    levelTitle = Localization:GetString("activity_breakthrough_tips_19", stageIdIndex, stagesCount)
  else
    local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
    local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
    levelTitle = Localization:GetString(levelTitlePrefixKey, order)
  end
  self.levelNameText:SetText(levelTitle)
end

function UIParkourBattleMainView:IsShowLevelNameText()
  local isLevelOneGuide = DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne
  if isLevelOneGuide then
    return false
  end
  local param = DataCenter.LWBattleManager.param
  local fromActFrontBreakSunday = param.fromActFrontBreakSunday
  if fromActFrontBreakSunday then
    return true
  end
  local stageId = param.levelId
  local titleType = tonumber(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "battle_title_type"))
  if titleType ~= 1 then
    return false
  end
  return true
end

function UIParkourBattleMainView:ShowWinConditionImage(winCondition)
  self:ClearEffectRes()
  if winCondition and winCondition[1] and winCondition[1].winType then
    if winCondition[1].winType == 3 or winCondition[1].winType == 4 then
      self.missionTarText:SetColor(WhiteColor)
    else
      self.missionTarText:SetColor(ParkourYellowColor)
    end
    if Const.ParkourWinConditionTypeAtlas[winCondition[1].winType] then
      self.missionIcon:LoadSpriteAuto(Const.ParkourWinConditionTypeAtlas[winCondition[1].winType])
      self.missionBg:LoadSpriteAuto(Const.ParkourWinConditionBgAtlas[winCondition[1].winType])
      self:CreateDelayTimer(function()
        self:LoadEffectPrefabs(Const.ParkourWinConditionBgEffect[winCondition[1].winType], self.missionBg, "effectBg")
      end, 0.11, "missionEffectTimer")
      self:LoadEffectPrefabs(Const.ParkourWinConditionIconEffect[winCondition[1].winType], self.missionIcon, "effectIcon")
    else
      self.missionIcon:LoadSpriteAuto(Const.ParkourWinConditionDefaultAtlas[1])
      self.missionBg:LoadSpriteAuto(Const.ParkourWinConditionDefaultAtlas[2])
    end
  end
end

function UIParkourBattleMainView:LoadEffectPrefabs(path, parent, effectName)
  if self.effectResHandles == nil then
    self.effectResHandles = {}
  end
  if string.IsNullOrEmpty(path) then
    return
  end
  effectName = effectName or "effect_" .. tostring(#self.effectResHandles + 1)
  if self.effectResHandles[effectName] ~= nil then
    self.effectResHandles[effectName]:Destroy()
    self.effectResHandles[effectName] = nil
  end
  local request = CS.GameEntry.Resource:InstantiateAsync(path)
  self.effectResHandles[effectName] = request
  request:completed("+", function()
    if request.isError or request.gameObject == nil then
      self.effectResHandles[effectName] = nil
      return
    end
    request.gameObject:SetActive(true)
    local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTransform ~= nil then
      rectTransform:SetParent(parent.transform, false)
      rectTransform:Set_localScale(1, 1, 1)
      rectTransform:Set_anchoredPosition(0, 0)
    end
  end)
end

function UIParkourBattleMainView:ClearEffectRes()
  if self.effectResHandles then
    for name, effect in pairs(self.effectResHandles) do
      if effect then
        effect:Destroy()
        effect = nil
      end
    end
    self.effectResHandles = nil
  end
end

function UIParkourBattleMainView:ShowWinCondition(callback, hideMission, winCondition)
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    return
  end
  if hideMission then
    self.winConditionArea:SetLocalScaleXYZ(1, 1, 1)
    self.levelNameText.transform:Set_localScale(1, 1, 1)
    return
  end
  if not self.missionBar then
    self.winConditionArea:SetLocalScaleXYZ(1, 1, 1)
    self.levelNameText.transform:Set_localScale(1, 1, 1)
    return
  end
  local data = DataCenter.LWBattleManager.logic.data
  if not data then
    self.winConditionArea:SetLocalScaleXYZ(1, 1, 1)
    self.levelNameText.transform:Set_localScale(1, 1, 1)
    return
  end
  if string.IsNullOrEmpty(data.target) then
    self.winConditionArea:SetLocalScaleXYZ(1, 1, 1)
    self.levelNameText.transform:Set_localScale(1, 1, 1)
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_show)
  self:ShowWinConditionImage(winCondition)
  self.missionBar:SetActive(true)
  self.missionBar.simpleAnimation:Play("Default")
  self.missionText:SetLocalText(data.title)
  local languageKey, keyParam = data:GetTargetDesData()
  if not string.IsNullOrEmpty(languageKey) then
    if table.IsNullOrEmpty(keyParam) or table.count(keyParam) == 0 then
      self.missionTarText:SetLocalText(languageKey)
    else
      self.missionTarText:SetLocalText(languageKey, table.unpack(keyParam))
    end
  end
  self.missionBar.simpleAnimation:Play("Default")
  self.showTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.showTimer = nil
    self.missionBar.simpleAnimation:Play("Close")
    self.winConditionAreaTweener = self.winConditionArea.transform:DOScale(Vector3.New(1, 1, 1), 0.3)
    self.winConditionAreaTweener:Delay(1)
    self.levelNameTextTweener = self.levelNameText.transform:DOScale(Vector3.New(1, 1, 1), 0.3)
    self.levelNameTextTweener:Delay(1)
    callback()
  end, 2.5)
end

function UIParkourBattleMainView:ShowCondition(title, content, delay)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_show)
  self.missionBar:SetActive(true)
  self.missionBar.simpleAnimation:Play("Default")
  self.missionText:SetLocalText(title)
  self.missionTarText:SetLocalText(content)
  self.missionBar.simpleAnimation:Play("Default")
  self.showCondition = TimerManager:GetInstance():DelayInvoke(function()
    self.showCondition = nil
    self.missionBar.simpleAnimation:Play("Close")
    self.winConditionAreaTweener = self.winConditionArea.transform:DOScale(Vector3.New(1, 1, 1), 0.3)
    self.winConditionAreaTweener:Delay(1)
    self.levelNameTextTweener = self.levelNameText.transform:DOScale(Vector3.New(1, 1, 1), 0.3)
    self.levelNameTextTweener:Delay(1)
  end, delay)
end

function UIParkourBattleMainView:ShowBossHpBar()
  self.winConditionArea:SetActive(true)
end

function UIParkourBattleMainView:SquadSuperArmorChange()
  local isSuperArmor = DataCenter.LWBattleManager.logic.team:IsSuperArmor()
  self.speedUpEffect:SetActive(isSuperArmor)
  if isSuperArmor then
    DataCenter.LWBattleManager:AutoZoom(40)
    local rate = Screen.height / Screen.width / (DefaultScreenHeight / DefaultScreenWidth)
    self.speedUpEffect.transform:Set_localScale(ResetScale.x, ResetScale.y * rate, ResetScale.z * rate)
  else
    DataCenter.LWBattleManager:AutoZoom(20)
  end
end

function UIParkourBattleMainView:OnParkourBattleWin()
  self.back_btn:SetActive(false)
  self.winBanner:SetActive(true)
  self.animator:Play("Eff_ui_beizengmen_mubiao_wancheng", 0, 0)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_battle_end)
  self:CreateDelayTimer(function()
    if self.winBanner then
      self.winBanner:SetActive(false)
    end
    if self.winConditionArea then
      self.winConditionArea.gameObject:SetActive(false)
    end
    if self.levelNameText then
      self.levelNameText:SetActive(false)
    end
  end, 1.8)
end

function UIParkourBattleMainView:OnParkourBattleLose()
  if self.back_btn then
    self.back_btn:SetActive(false)
  end
end

function UIParkourBattleMainView:OnBossEnter()
  if self.bonusEnter then
    return
  end
  local time = Time.realtimeSinceStartup
  if time - self.lastBossNoticeTime < BossNoticeCD then
    return
  end
  self.lastBossNoticeTime = time
  self.bossNotice.gameObject:SetActive(false)
  self.bossNotice.gameObject:SetActive(true)
  self.bossNoticeText:SetLocalText(800328)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_boss_warning)
end

function UIParkourBattleMainView:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName]:Stop()
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function UIParkourBattleMainView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function UIParkourBattleMainView:OnBonusEnter(param)
  self.bonusEnter = true
  self.winConditionArea.gameObject:SetActive(false)
  if param and param.bonusType == Const.ParkourBattleBonusType.Dash then
    local dashBonus = self:GetParkourBonusDash()
    dashBonus:SetActive(true)
    dashBonus:SetData(param)
  else
    local parkourBonusPanel = self:GetParkourBonusPanel()
    parkourBonusPanel:SetActive(true)
    parkourBonusPanel:SetData(param)
  end
end

function UIParkourBattleMainView:OnBonusRefresh(param)
  local parkourBonusPanel = self:GetParkourBonusPanel()
  parkourBonusPanel:Refresh(param)
end

function UIParkourBattleMainView:OnBonusWinConditionRefresh(param)
  local parkourBonusPanel = self:GetParkourBonusPanel()
  parkourBonusPanel:RefreshConditions(param)
end

function UIParkourBattleMainView:GetParkourBonusPanel()
  if self.parkourBonusPanel == nil then
    local siblingIndex = self.winConditionArea.transform:GetSiblingIndex()
    self.parkourBonusPanel = self:LoadComponentAsync(ParkourBonusPanel, ParkourBonusPanelPrefabPath, self.safeArea.transform, function(view, go, comp)
      comp:SetSiblingIndex(siblingIndex + 1)
      comp:SetOffsetMinXY(0, 0)
      comp:SetOffsetMaxXY(0, 0)
    end)
  end
  return self.parkourBonusPanel
end

function UIParkourBattleMainView:GetParkourBonusDash()
  if self.bonusDash == nil then
    local bonusDashScriptPath = "UI/UIParkour/MainUI/Component/UIParkourBonusDash"
    local bonusDashPrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourBonusDash.prefab"
    self.bonusDash = UIBaseComponent.LoadComponentAsync(self, bonusDashScriptPath, bonusDashPrefabPath, self.safeArea.transform, function(view, go, lua, callback_param)
      if self.bonusDash then
        self.bonusDash:SetActive(false)
      end
    end)
  end
  return self.bonusDash
end

function UIParkourBattleMainView:GetBossHpBar()
  if self.bossHpBar == nil then
    local barNum = 1
    local bossIcon
    local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
    if logic and logic.boss then
      local boss = logic.boss[1]
      if boss then
        barNum = boss.monsterMeta.hp_bar_num
        bossIcon = boss.monsterMeta.icon
      end
    end
    local bossHpBarScriptPath = "UI.UIParkour.MainUI.Component.ParkourBossHpBarComponent"
    local bossHpBarPrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourBossHpBar.prefab"
    self.bossHpBar = UIBaseComponent.LoadComponentAsync(self, bossHpBarScriptPath, bossHpBarPrefabPath, self.safeArea.transform, function(view, go, lua, callback_param)
      self.bossHpBar:SetAnchoredPositionXY(0, -300)
      self.bossHpBar:InitBossIcon(bossIcon)
    end)
    self.bossHpBar:InitBarNum(barNum)
  end
  return self.bossHpBar
end

function UIParkourBattleMainView:OnParkourBossHpViewChanged()
  local bossHpBar = self:GetBossHpBar()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.boss then
    local boss = logic.boss[1]
    if boss then
      bossHpBar:SetHp(boss.curBlood, boss.maxBlood)
    end
  end
end

function UIParkourBattleMainView:OnParkourBossHpViewDead()
  local bossHpBar = self:GetBossHpBar()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.boss then
    local boss = logic.boss[1]
    if boss then
      bossHpBar:SetHp(boss.curBlood, boss.maxBlood)
    else
      bossHpBar:SetDead()
    end
  end
end

function UIParkourBattleMainView:OnPVECastHeroAwakenSkill(evtData)
  local skillInfo, heroInfo
  if evtData and evtData.skill and evtData.skill.skillInfo then
    skillInfo = evtData.skill.skillInfo
  end
  if evtData and evtData.unit and evtData.unit.hero then
    heroInfo = evtData.unit.hero
  end
  if skillInfo == nil or heroInfo == nil then
    return
  end
  if self.heroAwakenSkill == nil then
    if self.heroAwakenSkillReq == nil then
      self.heroAwakenSkillReq = self:GameObjectInstantiateAsync(UIAssets.HeroAwakenParkourSkill, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroAwakenSkillRoot.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        self.heroAwakenSkill = self:AddComponent(UIParkourHeroAwakenSkillComponent, go)
        self.heroAwakenSkill:ReInit(skillInfo, heroInfo)
      end)
    end
  else
    self.heroAwakenSkill:ReInit(skillInfo, heroInfo)
  end
end

return UIParkourBattleMainView
