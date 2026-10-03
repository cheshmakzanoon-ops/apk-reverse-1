local UIZombieBattleMainView = BaseClass("UIZombieBattleMainView", UIBaseView)
local base = UIBaseView
local ZombieBattleHeroCell = require("UI.UIZombieBattle.Component.ZombieBattleHeroCell")
local safeArea = "SafeArea/"
local Const = require("Scene.LWBattle.Const")
local UIPVEJoystickAim = require("UI.UIPVE.UIPVEMain.Component.UIPVEJoystickAim")
local Screen = CS.UnityEngine.Screen
local DEFAULT_HOLE_POSITION = Vector4.New(10, 10, 1, 1)
local OPEN_JOYSTICK = false
local TacticalWeaponCell = require("UI.UIZombieBattle.Component.TacticalWeaponCell")
local TacticalWeaponSkillNodeComponent = require("UI.UIParkour.MainUI.Component.TacticalWeaponSkillNodeComponent")
local SpeedUpComp = require("UI.UIZombieBattle.Component.ZombieBattleSpeedUp")
local ZombieBattleWinTypeStyle = {Normal = 1, Slider = 2}
local ZombieBattleWinTypeSliderRender = require("UI.UIZombieBattle.Component.ZombieBattleWinTypeSliderRender")
local ZombieBattleWinTypeNormalRender = require("UI.UIZombieBattle.Component.ZombieBattleWinTypeNormalRender")
local win_condition_hor_layout_path = "SafeArea/WinCondition/WinConditionHorLayout"
local Resource = CS.GameEntry.Resource

function UIZombieBattleMainView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:InitWinCondition()
  if self:GetUserData().onOpen then
    self:GetUserData().onOpen()
  end
  self:InitAutoAndDouble()
end

function UIZombieBattleMainView:OnDestroy()
  self:ComponentDestroy()
  self:ClearEffectRes()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  base.OnDestroy(self)
end

function UIZombieBattleMainView:ComponentDefine()
  if CS.CommonUtils.IsDebug() then
    self.gm_win_btn = self:AddComponent(UIButton, safeArea .. "GmWinBtn")
    self.GMText = self:AddComponent(UIText, safeArea .. "GmWinBtn/GMText")
    self.GMText:SetText(DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId())
    self.gm_win_btn:SetOnClick(function()
      DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
    end)
  else
    self.transform:Find(safeArea .. "GmWinBtn").gameObject:SetActive(false)
  end
  self.btns = self:AddComponent(UIBaseComponent, safeArea .. "Btns")
  self.btns:SetActive(true)
  self.back_btn = self:AddComponent(UIButton, safeArea .. "Btns/BackBtn")
  self.back_btn:SetOnClick(function()
    self:OnBtnHome()
  end)
  self.map_btn = self:AddComponent(UIButton, safeArea .. "Map")
  self.map_btn:SetOnClick(function()
    self:OnShowMap()
  end)
  self.hangUpBtn = self:AddComponent(UIButton, safeArea .. "HangUpBtn")
  self.hangUpBtn:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0)
  end)
  self.autoOnBtnTxt = self:AddComponent(UIText, safeArea .. "Btns/AutoBtn/AutoTxt")
  self.autoOnBtnTxt:SetLocalText(100629)
  self.autoOn = self:AddComponent(UIBaseComponent, safeArea .. "Btns/AutoBtn/AutoOn")
  self.autoOn:SetActive(false)
  self.autoBtn = self:AddComponent(UIButton, safeArea .. "Btns/AutoBtn")
  self.autoBtn:SetOnClick(function()
    self:OnAutoClick()
  end)
  self.doubleOn = self:AddComponent(UIBaseComponent, safeArea .. "Btns/DoubleBtn/DoubleOn")
  self.doubleOn:SetActive(false)
  self.doubleBtn = self:AddComponent(UIButton, safeArea .. "Btns/DoubleBtn")
  self.doubleBtn:SetOnClick(function()
    self:OnDoubleClick()
  end)
  local autoLockLv = LuaEntry.DataConfig:TryGetNum("unlock_auto_battle", "k1", 1)
  local autoShow = autoLockLv <= DataCenter.BuildManager.MainLv and LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), self:GetUserData().levelId, "auto_skill") > 0
  self.autoBtn:SetActive(autoShow)
  if autoShow and CommonUtil.PlayerPrefsGetInt("ZOMBIE_BATTLE_UI_AUTO_ULT_BTN_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("ZOMBIE_BATTLE_UI_AUTO_ULT_BTN_GUIDE", 1)
    local evtParams = {}
    evtParams.plotId = 601601
    evtParams.anchor = self.autoBtn.transform.localPosition
    evtParams.mode = "2D"
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, evtParams)
  end
  local doubleShow = CS.CommonUtils.IsDebug()
  self.doubleBtn:SetActive(doubleShow)
  self.winConditionArea = self.transform:Find(safeArea .. "WinCondition")
  self.winConditionHorLayout = self:AddComponent(UIBaseContainer, win_condition_hor_layout_path)
  self.spotImg = self:AddComponent(UIImage, "Spot")
  self.spotMat = self.spotImg:GetMaterial()
  self.spotImg:SetActive(false)
  for i = 1, 5 do
    self.spotMat:SetVector("_Hole" .. i, DEFAULT_HOLE_POSITION)
  end
  self.grayImgN = self:AddComponent(UIImage, safeArea .. "gray")
  self.grayMat = self.grayImgN:GetMaterial()
  self.winConditionArea:Set_localScale(0, 0, 0)
  self.winBanner = self:AddComponent(UIBaseComponent, safeArea .. "WinBanner")
  self.winBanner:SetActive(false)
  self.winBannerTxt = self:AddComponent(UIText, safeArea .. "WinBanner/WinBannerText")
  self.winBannerTxt:SetLocalText(GameDialogDefine.MISSION_COMPLETE)
  self.winBannerAnim = self:AddComponent(UIAnimator, safeArea)
  self.missionBar = self:AddComponent(UISimpleAnimation, safeArea .. "Mission")
  self.missionText = self:AddComponent(UIText, safeArea .. "Mission/hengfu/Text_0")
  self.missionTarText = self:AddComponent(UIText, safeArea .. "Mission/hengfu/Text_1")
  self.missionIcon = self:AddComponent(UIImage, safeArea .. "Mission/hengfu/MissionIcon")
  self.missionBg = self:AddComponent(UIImage, safeArea .. "Mission/hengfu/sanjiao")
  self.missionBar:SetActive(false)
  self.speedUpEffect = self:AddComponent(UIBaseContainer, "TopEffect/Eff_UI_suduxian")
  self.speedUpEffect:SetActive(false)
  self.bossNoticeContainer = self:AddComponent(UIBaseContainer, "BossComing")
  self.bossNotice = self:AddComponent(UIAnimator, "BossComing")
  self.bossNotice.gameObject:SetActive(false)
  self.bossNoticeText = self.bossNoticeContainer:AddComponent(UIText, "Text_0")
  self.heroCell = {}
  self.winConditionIconListCell = {}
  self.deadNum = 0
  self.heroNode = self:AddComponent(UIBaseComponent, safeArea .. "HeroHead")
  self.heroNode:SetActive(true)
  self.memberCount = DataCenter.ZombieBattleManager.squad:GetMemberCount()
  for i = 1, 5 do
    self.heroCell[i] = self:AddComponent(ZombieBattleHeroCell, string.format("SafeArea/HeroHead/ZombieBattleHeroCell%s", i))
    local hero
    for _, h in pairs(DataCenter.ZombieBattleManager.squad.members) do
      if h.index == i then
        hero = h
      end
    end
    if hero then
      self.heroCell[i].gameObject:SetActive(true)
      self.heroCell[i]:SetData(hero)
    else
      self.heroCell[i].gameObject:SetActive(false)
    end
  end
  self.stageProgressGrid = self:AddComponent(UIBaseContainer, safeArea .. "StageProgressGrid")
  if OPEN_JOYSTICK then
    self.joystick = self:AddComponent(UIPVEJoystickAim, safeArea .. "UIPVEJoystickAim")
    self.joystick:SetActive(true)
  end
  self.spotTime = {}
  self.spotMember = {}
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.speedUpComp = self:AddComponent(SpeedUpComp, safeArea .. "SpeedUp")
  self.speedUpComp:SetVisible(true)
  self.tacticalWeaponContainer = self:AddComponent(TacticalWeaponCell, safeArea .. "Btns/TacticalWeapon")
  local tacticalWeaponMember = DataCenter.ZombieBattleManager.squad.teamWeapon
  if tacticalWeaponMember then
    self.tacticalWeaponContainer:SetActive(true)
    self.tacticalWeaponContainer:SetData(tacticalWeaponMember)
  else
    self.tacticalWeaponContainer:SetActive(false)
  end
  self.punchOK = 0
  self.tacticalWeaponSkillNodeComponent = self:AddComponent(TacticalWeaponSkillNodeComponent, "SafeArea/Btns/TacticalWeaponSkillNode")
  self.tacticalWeaponSkillNodeComponent:SetActive(true)
end

function UIZombieBattleMainView:InitAutoAndDouble()
  if CS.CommonUtils.IsDebug() then
    self.isDouble = CommonUtil.PlayerPrefsGetBool("ZOMBIE_BATTLE_DOUBLE", true)
  else
    self.isDouble = false
  end
  Time.timeScale = self.isDouble and 2 or 1
  self.doubleOn:SetActive(self.isDouble)
  self.isAuto = CommonUtil.PlayerPrefsGetBool("ZOMBIE_BATTLE_AUTO", false)
  self.autoOn:SetActive(self.isAuto)
end

function UIZombieBattleMainView:OnDoubleClick()
  self.isDouble = not self.isDouble
  Time.timeScale = self.isDouble and 2 or 1
  self.doubleOn:SetActive(self.isDouble)
  CommonUtil.PlayerPrefsSetBool("ZOMBIE_BATTLE_DOUBLE", self.isDouble)
end

function UIZombieBattleMainView:OnAutoClick()
  self.isAuto = not self.isAuto
  self.autoOn:SetActive(self.isAuto)
  CommonUtil.PlayerPrefsSetBool("ZOMBIE_BATTLE_AUTO", self.isAuto)
end

function UIZombieBattleMainView:ComponentDestroy()
  if self.winConditionAsyncReq then
    for i, v in ipairs(self.winConditionAsyncReq) do
      v:Destroy()
    end
  end
  self.winConditionAsyncReq = nil
  self.missionIcon = nil
  self.missionBg = nil
  for i = 1, 5 do
    self.spotMat:SetVector("_Hole" .. i, DEFAULT_HOLE_POSITION)
  end
  self.spotMat = nil
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  Time.timeScale = 1
  self.back_btn = nil
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  if self.stageCellReqs ~= nil then
    for _, req in ipairs(self.stageCellReqs) do
      req:Destroy()
    end
  end
  self.stageCellReqs = nil
  self.stageCells = nil
  self.curStageCell = nil
  self.joystick = nil
  self.grayMat = nil
  if self.cdTimer then
    self.cdTimer:Stop()
    self.cdTimer = nil
  end
  self.spotTime = nil
  self.spotMember = nil
  self.speedUpComp = nil
  self.tacticalWeaponContainer = nil
  DataCenter.LWSoundManager:StopSound(self.bigWaveSoundUid)
end

function UIZombieBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PVEWin, self.OnPVEWin)
  self:AddUIListener(EventId.PVELose, self.OnPVELose)
  self:AddUIListener(EventId.BossEnterBattle, self.OnBossEnter)
  self:AddUIListener(EventId.BattleZombiesEnter, self.ZombieComing)
  self:AddUIListener(EventId.SquadSuperArmorStateChange, self.SquadSuperArmorChange)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.PlotGroupDone, self.PlotGroupDone)
end

function UIZombieBattleMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.PVEWin, self.OnPVEWin)
  self:RemoveUIListener(EventId.PVELose, self.OnPVELose)
  self:RemoveUIListener(EventId.BossEnterBattle, self.OnBossEnter)
  self:RemoveUIListener(EventId.BattleZombiesEnter, self.ZombieComing)
  self:RemoveUIListener(EventId.SquadSuperArmorStateChange, self.SquadSuperArmorChange)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.PlotGroupDone, self.PlotGroupDone)
  base.OnRemoveListener(self)
end

function UIZombieBattleMainView:PlotGroupDone()
  if not self.autoShow then
    return
  end
  if self.param.enterType == PVEEnterType.StageFeatureBuilding then
    return
  end
  if CommonUtil.PlayerPrefsGetInt("ZOMBIE_BATTLE_UI_AUTO_ULT_BTN_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("ZOMBIE_BATTLE_UI_AUTO_ULT_BTN_GUIDE", 1)
    local evtParams = {}
    evtParams.plotId = 601601
    evtParams.anchor = self.autoBtn.transform.localPosition
    evtParams.mode = "2D"
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, evtParams)
  end
end

function UIZombieBattleMainView:OnKeyCodeEscape()
end

function UIZombieBattleMainView:InitWinCondition()
  self.winConditionArea.gameObject:SetActive(true)
  self.winConditionAsyncReq = {}
  local index = 0
  local winType = DataCenter.ZombieBattleManager.pveTemplate.winCondition.winType
  local prefabName, winStyle = self:GetWinConditionPrefabAndStyle(winType)
  local cmp = ZombieBattleWinTypeNormalRender
  if winStyle == ZombieBattleWinTypeStyle.Slider then
    cmp = ZombieBattleWinTypeSliderRender
  end
  if not string.IsNullOrEmpty(prefabName) then
    if winType == Const.StageWinType.KillBoss then
      local showCount = DataCenter.ZombieBattleManager.pveTemplate.winCondition.needKillBossNum or 0
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

function UIZombieBattleMainView:CreateWinItem(itemIndex, prefabName, winType, cmp, slotIndex)
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

function UIZombieBattleMainView:ShowWinCondition(callback)
  if not self.missionBar then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_show)
  self.missionBar:SetActive(true)
  local battleMgr = DataCenter.ZombieBattleManager
  self.missionBar.simpleAnimation:Play("Default")
  self.missionText:SetLocalText(battleMgr.pveTemplate.stageMeta.title)
  self.missionTarText:SetLocalText(battleMgr.pveTemplate.stageMeta.target, battleMgr.pveTemplate.winCondition.needKillNum or battleMgr.pveTemplate.winCondition.timeLimit or battleMgr.pveTemplate.winCondition.needKillBossNum or battleMgr.pveTemplate.winCondition.winType == Const.StageWinType.WayPoint and math.floor(battleMgr.wayPoint[#battleMgr.wayPoint].pos.z - battleMgr.wayPoint[1].pos.z))
  if battleMgr.pveTemplate.winCondition.winType == Const.StageWinType.ClearLastTrigger then
    self.missionTarText:SetLocalText(battleMgr.pveTemplate.stageMeta.target, battleMgr.finalTriggerLimit)
  end
  self:ShowWinConditionImage(battleMgr.pveTemplate.winCondition.winType)
  self.missionBar.simpleAnimation:Play("Default")
  self.showTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.showTimer = nil
    self.missionBar.simpleAnimation:Play("Close")
    self.winConditionArea:DOScale(Vector3.New(1, 1, 1), 0.3):Delay(1)
    callback()
  end, 2.5)
end

function UIZombieBattleMainView:ShowWinConditionImage(winType)
  self:ClearEffectRes()
  if winType then
    if winType == 3 or winType == 4 then
      self.missionTarText:SetColor(WhiteColor)
    else
      self.missionTarText:SetColor(ParkourYellowColor)
    end
    if Const.ParkourWinConditionTypeAtlas[winType] then
      self.missionIcon:LoadSpriteAuto(Const.ParkourWinConditionTypeAtlas[winType])
      self.missionBg:LoadSpriteAuto(Const.ParkourWinConditionBgAtlas[winType])
      if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:LoadEffectPrefabs(Const.ParkourWinConditionBgEffect[winType], self.missionBg, "effectBg")
      end, 0.11)
      self:LoadEffectPrefabs(Const.ParkourWinConditionIconEffect[winType], self.missionIcon, "effectIcon")
    else
      self.missionIcon:LoadSpriteAuto(Const.ParkourWinConditionDefaultAtlas[1])
      self.missionBg:LoadSpriteAuto(Const.ParkourWinConditionDefaultAtlas[2])
    end
  end
end

function UIZombieBattleMainView:LoadEffectPrefabs(path, parent, effectName)
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

function UIZombieBattleMainView:ClearEffectRes()
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

function UIZombieBattleMainView:OnBossEnter()
  self.bossNotice.gameObject:SetActive(false)
  self.bossNotice.gameObject:SetActive(true)
  self.bossNoticeText:SetLocalText(800328)
end

function UIZombieBattleMainView:ZombieComing()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_zombie_tide_warning)
  TimerManager:GetInstance():DelayInvoke(function()
    self.bigWaveSoundUid = DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_zombies_cacophony, true)
  end, 1)
  self.bossNotice.gameObject:SetActive(false)
  self.bossNotice.gameObject:SetActive(true)
  self.bossNoticeText:SetLocalText(800327)
end

function UIZombieBattleMainView:OnPVEWin()
  DataCenter.LWSoundManager:StopSound(self.bigWaveSoundUid)
  self.isDouble = false
  Time.timeScale = 1
  self.btns:SetActive(false)
  self.heroNode:SetActive(false)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_goal_finish)
  self.winBanner:SetActive(true)
  self.winBannerAnim:Play("Eff_ui_beizengmen_mubiao_wancheng", 0, 0)
  TimerManager:GetInstance():DelayInvoke(function()
    if self.winBanner then
      self.winBanner:SetActive(false)
    end
    if self.winConditionArea then
      self.winConditionArea.gameObject:SetActive(false)
    end
  end, 1.8)
  if self.speedUpComp then
    self.speedUpComp:SetVisible(false)
  end
end

function UIZombieBattleMainView:OnPVELose()
  DataCenter.LWSoundManager:StopSound(self.bigWaveSoundUid)
  self.isDouble = false
  Time.timeScale = 1
  self.btns:SetActive(false)
  self.heroNode:SetActive(false)
  if self.winConditionArea then
    self.winConditionArea.gameObject:SetActive(false)
  end
  if self.speedUpComp then
    self.speedUpComp:SetVisible(false)
  end
end

function UIZombieBattleMainView:DoPVELose()
  DataCenter.ZombieBattleManager:OnBattleLose()
end

function UIZombieBattleMainView:OnBtnHome()
  if DataCenter.ZombieBattleManager.winTimer or DataCenter.ZombieBattleManager.gameOver then
    return
  end
  if self.param.enterType == PVEEnterType.Monopoly then
    DataCenter.MonopolyManager:SetSpontaneousBattle(false)
  end
  self:OnExit()
end

function UIZombieBattleMainView:OnExit()
  DataCenter.LWSoundManager:StopSound(self.bigWaveSoundUid)
  local exitStageId = DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId()
  PostEventLog.BattleResultLog(PVEType.Barrage, 2)
  self.ctrl:CloseSelf()
  self:DoPVELose()
  if self.param.enterType == PVEEnterType.Radar then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.DetectEventExitBtn)
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
    DataCenter.ZombieBattleManager:SetBattleExitFlag(true)
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.TowerupExitBtn)
  else
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  end
end

function UIZombieBattleMainView:OnEnable()
  base.OnEnable(self)
  if self.joystick then
    self.joystick:ReInit()
    DataCenter.ZombieBattleManager:SetJoystick(self.joystick)
  end
end

function UIZombieBattleMainView:OnShowMap()
  if not DataCenter.ZombieBattleManager.gameOver and not DataCenter.ZombieBattleManager.gamePause then
    self:DoPVELose()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStage, {anim = false}, nil)
end

function UIZombieBattleMainView:OnUpdate()
  local showSpot = false
  for index, time in pairs(self.spotTime) do
    if 0 < time then
      local newTime = time - Time.deltaTime
      self.spotTime[index] = newTime
      if 0 < newTime then
        local member = self.spotMember[index]
        if member and 0 < member:GetCurBlood() then
          showSpot = true
          local worldPos = member:GetPosition()
          local screenPos = CS.UnityEngine.Camera.main:WorldToScreenPoint(worldPos)
          local x = screenPos.x / Screen.width
          local y = screenPos.y / Screen.height
          x = 0.5 - 3 * x
          y = 0.5 - 6 * y
          self.spotMat:SetVector("_Hole" .. index, Vector4.New(x, y, 1, 1))
        else
          self.spotMat:SetVector("_Hole" .. index, DEFAULT_HOLE_POSITION)
        end
      else
        self.spotMat:SetVector("_Hole" .. index, DEFAULT_HOLE_POSITION)
      end
    end
  end
  self.spotImg:SetActive(showSpot)
  if self.speedUpComp then
    self.speedUpComp:OnUpdate(Time.deltaTime)
  end
end

function UIZombieBattleMainView:Spot(member, time)
  local index = member.index
  self.spotTime[index] = time
  self.spotMember[index] = member
end

function UIZombieBattleMainView:SquadSuperArmorChange()
  local isSuperArmor = DataCenter.ZombieBattleManager.squad:IsSuperArmor()
  self.speedUpEffect:SetActive(isSuperArmor)
  if isSuperArmor then
    DataCenter.ZombieBattleManager:AutoZoom(40)
    local ScreenSize = self.rectTransform.rect
    local scaleWidth = ScreenSize.width / DefaultScreenWidth
    local scaleHeight = ScreenSize.height / DefaultScreenHeight
    self.speedUpEffect:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
  else
    DataCenter.ZombieBattleManager:AutoZoom(20)
  end
end

function UIZombieBattleMainView:IsTimeStopCD()
  return self.timeStopCD
end

function UIZombieBattleMainView:SetTimeStopCD()
  self.timeStopCD = true
  if self.cdTimer then
    self.cdTimer:Stop()
    self.cdTimer = nil
  end
  local cd = self.isAuto and TIME_STOP_CD_AI or TIME_STOP_CD
  self.cdTimer = TimerManager:DelayInvoke(function()
    self.timeStopCD = false
  end, cd)
end

function UIZombieBattleMainView:GetWinConditionPrefabAndStyle(winType)
  local prefab = ""
  local style = ZombieBattleWinTypeStyle.Normal
  if winType == Const.StageWinType.KillTargetMonster then
    prefab = "Assets/Main/Prefabs/UI/ZombieBattle/ZombieBattleWinTypeKillMonsterItem.prefab"
    style = ZombieBattleWinTypeStyle.Slider
  elseif winType == Const.StageWinType.KillMonster then
    prefab = "Assets/Main/Prefabs/UI/ZombieBattle/ZombieBattleWinTypeKillMonsterItem.prefab"
    style = ZombieBattleWinTypeStyle.Slider
  elseif winType == Const.StageWinType.WayPoint then
    prefab = "Assets/Main/Prefabs/UI/ZombieBattle/ZombieBattleWinTypeWayPointItem.prefab"
    style = ZombieBattleWinTypeStyle.Slider
  elseif winType == Const.StageWinType.Time then
    prefab = "Assets/Main/Prefabs/UI/ZombieBattle/ZombieBattleWinTypeTimeItem.prefab"
    style = ZombieBattleWinTypeStyle.Slider
  elseif winType == Const.StageWinType.KillBoss then
    prefab = "Assets/Main/Prefabs/UI/ZombieBattle/ZombieBattleWinTypeKillBossItem.prefab"
    style = ZombieBattleWinTypeStyle.Normal
  elseif winType == Const.StageWinType.ClearLastTrigger then
    prefab = "Assets/Main/Prefabs/UI/ZombieBattle/ZombieBattleWinTypeKillMonsterItem.prefab"
    style = ZombieBattleWinTypeStyle.Slider
  end
  return prefab, style
end

return UIZombieBattleMainView
