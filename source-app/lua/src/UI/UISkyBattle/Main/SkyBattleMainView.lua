local SkyBattleMainView = BaseClass("SkyBattleMainView", UIBaseView)
local Const = require("Scene.LWBattle.Const")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local StarConditionItemComponent = require("UI.UISkyBattle.Main.Components.StarConditionItemComponent")
local BossNoticeCD = 5

function SkyBattleMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitGM()
  self:InitWinCondition()
  self:InitWinBanner()
  self:InitStarCondition()
  self:InitLevelInfo()
  if self:GetUserData().onOpen then
    self:GetUserData().onOpen()
  end
end

function SkyBattleMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattleMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.GMText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.gm_win_btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.gm_win_btn:SetOnClick(function()
    self:OnGm_win_btnClick()
  end)
  self.safeArea = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.winConditionNode = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.winConditionIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.winConditionSlider = self.viewSkin:AddComponent(self, UISlider, 6)
  self.winConditionSliderEff = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.winConditionBarImg = self.viewSkin:AddComponent(self, UIImage, 8)
  self.winConditionText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.animator = self.viewSkin:AddComponent(self, UIAnimator, 10)
  self.winBanner = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.speedUpEffect = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.back_btn = self.viewSkin:AddComponent(self, UIButton, 13)
  self.back_btn:SetOnClick(function()
    self:OnBack_btnClick()
  end)
  self.levelNameText = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.starConditionLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.starConditionItem = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.animatorBossComing = self.viewSkin:AddComponent(self, UIAnimator, 17)
  self.text0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.winBannerTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.speedUpEffect:SetActive(false)
  self.back_btn:SetActive(true)
  self.animatorBossComing:SetActive(false)
  self.text0:SetLocalText("plane_stage_tips_01")
end

function SkyBattleMainView:ComponentDestroy()
  self.viewSkin = nil
  self.GMText = nil
  self.gm_win_btn = nil
  self.safeArea = nil
  self.winConditionNode = nil
  self.winConditionIcon = nil
  self.winConditionSlider = nil
  self.winConditionSliderEff = nil
  self.winConditionBarImg = nil
  self.winConditionText = nil
  self.animator = nil
  self.winBanner = nil
  self.speedUpEffect = nil
  self.back_btn = nil
  self.levelNameText = nil
  self.starConditionLayout = nil
  self.starConditionItem = nil
  self.animatorBossComing = nil
  self.text0 = nil
  self.winBannerTxt = nil
end

function SkyBattleMainView:DataDefine()
end

function SkyBattleMainView:DataDestroy()
  self.lastBossNoticeTime = nil
  self.starConditionListCell = nil
  self.starConditionLayout:RemoveComponents(StarConditionItemComponent)
  if self.starConditionItemPrefab then
    self.starConditionItemPrefab:GameObjectRecycleAll()
  end
  self.starConditionItemPrefab = nil
  self:ClearAllDelayTimers()
  self.delayTimeId = nil
end

function SkyBattleMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SquadSuperArmorStateChange, self.SquadSuperArmorChange)
  self:AddUIListener(EventId.ParkourWinConditionRefresh, self.UpdateWinConditionBar)
  self:AddUIListener(EventId.ParkourMainStarConditionRefresh, self.UpdateStarCondition)
  self:AddUIListener(EventId.ParkourBossEnterBattle, self.OnBossEnter)
end

function SkyBattleMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SquadSuperArmorStateChange, self.SquadSuperArmorChange)
  self:RemoveUIListener(EventId.ParkourWinConditionRefresh, self.UpdateWinConditionBar)
  self:RemoveUIListener(EventId.ParkourMainStarConditionRefresh, self.UpdateStarCondition)
  self:RemoveUIListener(EventId.ParkourBossEnterBattle, self.OnBossEnter)
end

function SkyBattleMainView:InitGM()
  if CS.CommonUtils.IsDebug() then
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
  else
    self.gm_win_btn:SetActive(false)
  end
end

function SkyBattleMainView:InitWinCondition()
  local winCondition = self:InitWinConditionShowStyle()
  if winCondition then
    local spriteName = self:GetWinConditionIcon(winCondition)
    self.winConditionIcon:LoadSprite(spriteName)
    if winCondition == Const.ParkourWinType.FinishPoint or winCondition == Const.ParkourWinType.Time then
      self.winConditionBarImg:LoadSprite("Assets/Main/Sprites/UI/UIZombieBattleMain/guanqia_cfm_tubiao_jindutiao_3")
    else
      self.winConditionBarImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_chengchixinxi_hongse_jindutiao.png")
    end
    self:UpdateWinConditionBar(winCondition)
  end
end

function SkyBattleMainView:UpdateWinConditionBar(winType)
  local battleMgr = DataCenter.LWBattleManager.logic
  local winCondition = DataCenter.LWBattleManager.logic:GetWinConditionDataByWinType(winType)
  if winCondition == nil then
    return
  end
  if winType == Const.ParkourWinType.KillTargetMonster then
    local needKillTarget = winCondition.needKillTarget
    local curValue = 0
    local needValue = 0
    for k, v in pairs(needKillTarget) do
      curValue = curValue + v.finish
      needValue = needValue + v.need
    end
    self:SetWinConditionBar(math.max(0, needValue - curValue) / needValue)
    self:SetWinConditionText(string.format("%d", math.max(0, needValue - curValue)), true)
  elseif winType == Const.ParkourWinType.KillMonster then
    local curValue = battleMgr.killNum
    local needValue = winCondition.needKillNum
    self:SetWinConditionBar(math.max(0, needValue - curValue) / needValue)
    self:SetWinConditionText(string.format("%d", math.max(0, needValue - curValue)), true)
  elseif winType == Const.ParkourWinType.FinishPoint then
    local finalPos = battleMgr.data.endLine
    local startPos = 0
    local curPos = battleMgr.movedZDistance or 0
    self:SetWinConditionBar((curPos - startPos) / (finalPos - startPos))
    local remain = math.floor(finalPos - curPos)
    remain = remain < 0 and 0 or remain
    self:SetWinConditionText(string.format("%d m", remain))
  elseif winType == Const.ParkourWinType.Time then
    local curValue = battleMgr.useTime or 0
    local needValue = winCondition.needTime or 1
    self:SetWinConditionBar((needValue - curValue) / needValue)
    self:SetWinConditionText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(needValue - curValue))
  end
end

function SkyBattleMainView:InitWinBanner()
  self.winBanner:SetActive(false)
  self.winBannerTxt:SetLocalText(GameDialogDefine.MISSION_COMPLETE)
end

function SkyBattleMainView:InitStarCondition()
  self.starConditionItemPrefab = self.starConditionItem.gameObject
  self.starConditionItemPrefab:SetActive(false)
  self.starConditionItemPrefab:GameObjectCreatePool()
  self.starConditionListCell = {}
  if DataCenter.LWBattleManager.logic.GetStarCondition then
    local starConditions = DataCenter.LWBattleManager.logic:GetStarCondition()
    if starConditions then
      for i, condition in ipairs(starConditions) do
        local isShow = DataCenter.LWBattleManager.logic:CheckIsShowedStarCondition(condition.type)
        if isShow then
          local conditionType = condition.type
          local go = self.starConditionItemPrefab:GameObjectSpawn(self.starConditionLayout.transform)
          go.name = "starCondition" .. tostring(conditionType)
          go:SetActive(true)
          local starConditionItem = self.starConditionLayout:AddComponent(StarConditionItemComponent, go.name)
          self.starConditionListCell[conditionType] = starConditionItem
          self:UpdateStarCondition(condition)
        end
      end
    end
  end
end

function SkyBattleMainView:UpdateStarCondition(condition)
  if self.starConditionListCell[condition.type] then
    local logic = DataCenter.LWBattleManager.logic
    local conditionMatchTxt = ""
    local matchCondition = true
    if condition.type == BattleStarCondition.StageSuccessTime then
      local remainTime = condition.value - logic.useTime
      if 0 < remainTime then
        conditionMatchTxt = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(remainTime)
      else
        matchCondition = false
      end
    end
    self.starConditionListCell[condition.type]:Refresh(matchCondition, conditionMatchTxt, Localization:GetString("plane_chapter_detail_15"))
  end
end

function SkyBattleMainView:OnGm_win_btnClick()
  DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
end

function SkyBattleMainView:OnBack_btnClick()
  if DataCenter.LWBattleManager.logic.winTimer or DataCenter.LWBattleManager.gameOver then
    return
  end
  self:OnExit()
end

function SkyBattleMainView:OnExit()
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:Exit(nil, "quit")
end

function SkyBattleMainView:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  if not self.delayTimeId then
    self.delayTimeId = 0
  end
  self.delayTimeId = self.delayTimeId + 1
  timerName = timerName or "timer_" .. tostring(self.delayTimeId)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function SkyBattleMainView:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function SkyBattleMainView:GetWinConditionIcon(winType)
  local spriteName = ""
  if winType == Const.ParkourWinType.KillMonster then
    spriteName = "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_zhandou03.png"
  elseif winType == Const.ParkourWinType.FinishPoint then
    spriteName = "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_zhandou03.png"
  elseif winType == Const.ParkourWinType.Time then
    spriteName = "Assets/Main/Sprites/UI/LWUIStageSkyBattleChapter/FX_feiji_zhandou03.png"
  end
  return spriteName
end

function SkyBattleMainView:InitWinConditionShowStyle()
  local hasWinCondition = DataCenter.LWBattleManager.logic.winCondition ~= nil
  local winConditionType
  if hasWinCondition then
    self.winConditionSlider:SetActive(true)
    self.winConditionIcon:SetActive(true)
    self.winConditionText:SetActive(true)
    self.winConditionNode:SetActive(true)
    self.winConditionSliderEff:SetActive(false)
    winConditionType = DataCenter.LWBattleManager.logic.winCondition.winType
  else
    self.winConditionSlider:SetActive(false)
  end
  return winConditionType
end

function SkyBattleMainView:SetWinConditionBar(percent)
  if not self.transform then
    return
  end
  self.winConditionSlider:SetValue(Mathf.Clamp(percent, 0, 1))
  if 1 <= percent then
    self.winConditionSliderEff:SetActive(true)
  end
end

function SkyBattleMainView:SetWinConditionText(txt, punch)
  if not self.transform then
    return
  end
  if self.winConditionText then
    self.winConditionText:SetText(txt)
  end
end

function SkyBattleMainView:InitLevelInfo()
  local isShowLevelNameText = self:IsShowLevelNameText()
  self.levelNameText:SetActive(isShowLevelNameText)
  if not isShowLevelNameText then
    return
  end
  local param = DataCenter.LWBattleManager.param
  local stageId = param.levelId
  local levelTitle = ""
  local enterType = param.type
  if enterType == PVEType.SkyBattle then
    local stageName = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "name")
    local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "order")
    levelTitle = Localization:GetString(stageName, order)
  end
  self.levelNameText:SetText(levelTitle)
end

function SkyBattleMainView:IsShowLevelNameText()
  local param = DataCenter.LWBattleManager.param
  local enterType = param.type
  if enterType ~= PVEType.SkyBattle then
    return false
  end
  if not param.fromChapter then
    return false
  end
  local stageId = param.levelId
  local titleType = tonumber(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_SkyBattle), stageId, "battle_title_type"))
  if titleType ~= 1 then
    return false
  end
  return true
end

function SkyBattleMainView:ShowWinCondition(callback, hideMission)
  DataCenter.LWSoundManager:PlaySound(10015)
end

function SkyBattleMainView:SquadSuperArmorChange()
  local isSuperArmor = DataCenter.LWBattleManager.logic.team:IsSuperArmor()
  self.speedUpEffect:SetActive(isSuperArmor)
end

function SkyBattleMainView:OnParkourBattleWin()
  self.back_btn:SetActive(false)
  self.winBanner:SetActive(true)
  self.animator:Play("Eff_ui_beizengmen_mubiao_wancheng", 0, 0)
  DataCenter.LWSoundManager:PlaySound(10037)
  self:CreateDelayTimer(function()
    if self.winBanner then
      self.winBanner:SetActive(false)
    end
    if self.winConditionNode then
      self.winConditionNode:SetActive(false)
    end
    if self.levelNameText then
      self.levelNameText:SetActive(false)
    end
  end, 1.8)
end

function SkyBattleMainView:OnBossEnter()
  local time = Time.realtimeSinceStartup
  if self.lastBossNoticeTime and time - self.lastBossNoticeTime < BossNoticeCD then
    return
  end
  self.lastBossNoticeTime = time
  self.animatorBossComing:SetActive(false)
  self.animatorBossComing:SetActive(true)
  self.text0:SetLocalText("plane_stage_tips_01")
  DataCenter.LWSoundManager:PlaySound(10033)
end

return SkyBattleMainView
