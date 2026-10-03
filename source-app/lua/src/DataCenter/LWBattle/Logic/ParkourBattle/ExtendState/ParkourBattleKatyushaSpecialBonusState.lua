local base = require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleExtendState")
local Const = require("Scene.LWBattle.Const")
local ParkourBattleKatyushaSpecialBonusState = BaseClass("ParkourBattleKatyushaSpecialBonusState", base)
local ResourceManager = CS.GameEntry.Resource
local DELAY_SHOW_TIMELINE_TIME = 6.9
local AHEAD_ADD_HERO_TIME = 0.3

function ParkourBattleKatyushaSpecialBonusState:__init(logic)
  self.logic = logic
  self.bonusWinConditions = self.logic.data.bonusWinConditions
  self.bonusExtendData = self.logic.data.bonusExtendData
  self.heroUnit = nil
  self.heroInfo = nil
  self.hasResetUltimate = false
  self.isWaitingForShowTimeline = false
  self.isStateValid = nil
  local assetPath = self.bonusExtendData.timelineAssetPath
  local request = ResourceManager:InstantiateAsync(assetPath)
  request:completed("+", function()
    if request.isError then
      Logger.LogError("KatyushaSpecial load timeline failed: " .. assetPath)
      return
    end
    request.gameObject:SetActive(false)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self:TryShowTimeline()
  end)
  self.reqTimeline = request
  self.director = nil
end

function ParkourBattleKatyushaSpecialBonusState:__delete()
  self.logic = nil
  self.bonusWinConditions = nil
  self.bonusExtendData = nil
  self.heroUnit = nil
  self.heroInfo = nil
  self.hasResetUltimate = nil
  self.isWaitingForShowTimeline = nil
  self.isStateValid = nil
  self:StopTimer()
  self:DestroyTimeline()
  self:SetLayerActive(true)
end

function ParkourBattleKatyushaSpecialBonusState:OnEnter(state)
  self:AddListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:AddListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
  self.heroUnit = nil
  self.heroInfo = nil
  self.hasResetUltimate = false
  self.isStateValid = true
  self.state = state
  self.logic.team:ChangeStage(state)
  self.logic:OnFingerUp()
  DataCenter.LWBattleManager:SetGamePause(true)
  local evtData = {
    plotGroupId = self.bonusExtendData.plotGroupId,
    hideMainUI = true
  }
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, evtData)
end

function ParkourBattleKatyushaSpecialBonusState:OnPlotDone()
  if not self.isStateValid then
    return
  end
  if not self.logic or not self.logic.monsterMgr then
    return
  end
  DataCenter.LWBattleManager:SetGamePause(false)
  self.logic.monsterMgr:ChangeBonus()
  self:StopTimer()
  self.delayShowTimelineTimer = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWBattleManager:SetGamePause(true)
    local evtData = {
      plotGroupId = self.bonusExtendData.plotGroupIdBeforeTimeline,
      hideMainUI = true
    }
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, evtData)
  end, DELAY_SHOW_TIMELINE_TIME)
end

function ParkourBattleKatyushaSpecialBonusState:OnPlotBeforeTimelineDone()
  if not self.isStateValid then
    return
  end
  DataCenter.LWBattleManager:SetGamePause(false)
  self.isWaitingForShowTimeline = true
  self:TryShowTimeline()
end

function ParkourBattleKatyushaSpecialBonusState:TryShowTimeline()
  if not self.isWaitingForShowTimeline then
    return
  end
  if self.reqTimeline and self.reqTimeline.isDone then
    self.isWaitingForShowTimeline = false
    if not self.isStateValid then
      return
    end
    if IsNull(self.reqTimeline.gameObject) then
      return
    end
    local obj = self.reqTimeline.gameObject
    obj:SetActive(true)
    local director = obj:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    if IsNotNull(director) then
      self.onDirectorPlayStopHandler = Bind(self, self.OnTimelinePlayStopHandler)
      director:stopped("+", self.onDirectorPlayStopHandler)
      director:Play()
      self.director = director
      self:OnTimelineStart()
    else
      Logger.LogError("KatyushaSpecial timeline PlayableDirector not found: " .. self.reqTimeline.PrefabPath)
      self:DestroyTimeline()
    end
  end
end

function ParkourBattleKatyushaSpecialBonusState:OnTimelinePlayStopHandler()
  self:DestroyTimeline()
  self:OnTimelineFinish()
end

function ParkourBattleKatyushaSpecialBonusState:OnTimelineStart()
  DataCenter.LWBattleManager:SetGamePause(true)
  self:SetLayerActive(false)
  if self.aheadAddHeroTimer then
    self.aheadAddHeroTimer:Stop()
    self.aheadAddHeroTimer = nil
  end
  if self.director then
    local delayTime = self.director.duration - AHEAD_ADD_HERO_TIME
    self.aheadAddHeroTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ResumeBattleAndAddHero()
    end, delayTime)
  end
end

function ParkourBattleKatyushaSpecialBonusState:ResumeBattleAndAddHero()
  if not self.isStateValid then
    return
  end
  if not self.logic or not self.logic.team then
    return
  end
  if self.logic and self.logic.team then
    local emptySlot = self.logic.team:GetAllEmptySlots()
    if table.IsNullOrEmpty(emptySlot) then
      local lastUnit = self.logic.team:GetLastUnit()
      if lastUnit ~= nil then
        self.logic.team:RemoveMember(lastUnit)
      end
    end
  end
  DataCenter.LWBattleManager:SetGamePause(false)
  self.heroUnit = self.logic.team:AddTrialHero(self.bonusExtendData.heroId, self.bonusExtendData.heroLevel, self.bonusExtendData.heroRank)
end

function ParkourBattleKatyushaSpecialBonusState:OnTimelineFinish()
  self:SetLayerActive(true)
end

function ParkourBattleKatyushaSpecialBonusState:OnExit()
  self:RemoveListener(EventId.PlotGroupDone, self.OnPlotGroupDone)
  self:RemoveListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
  self:StopTimer()
  self:DestroyTimeline()
  self:SetLayerActive(true)
  self.isStateValid = false
end

function ParkourBattleKatyushaSpecialBonusState:StopTimer()
  if self.delayShowTimelineTimer then
    self.delayShowTimelineTimer:Stop()
    self.delayShowTimelineTimer = nil
  end
  if self.aheadAddHeroTimer then
    self.aheadAddHeroTimer:Stop()
    self.aheadAddHeroTimer = nil
  end
end

function ParkourBattleKatyushaSpecialBonusState:DestroyTimeline()
  if IsNotNull(self.director) then
    self.director:stopped("-", self.onDirectorPlayStopHandler)
    self.onDirectorPlayStopHandler = nil
  end
  if self.reqTimeline then
    self.reqTimeline:RealDestroy()
    self.reqTimeline = nil
  end
  self.director = nil
end

function ParkourBattleKatyushaSpecialBonusState:OnUpdate()
  if self.heroUnit ~= nil and not self.hasResetUltimate and self.heroUnit.IsViewLoaded and self.heroUnit:IsViewLoaded() then
    if self.heroUnit.skillManager then
      local ultimateSkill = self.heroUnit:GetUltimateSkill()
      if ultimateSkill then
        local skill = self.heroUnit.skillManager:GetSkillById(ultimateSkill.skillId)
        if skill then
          self.heroUnit.skillManager:ResetCooldown(skill)
        end
      end
    end
    self.hasResetUltimate = true
  end
end

function ParkourBattleKatyushaSpecialBonusState:OnMonsterDeath(monster)
  local winConditions = self:GetCheckWinConditions()
  if winConditions[Const.ParkourWinType.KillBoss] then
    local condition = winConditions[Const.ParkourWinType.KillBoss]
    if not condition.finish and self.logic and condition.winType == Const.ParkourWinType.KillBoss and (monster.monsterMeta.is_boss == 1 or monster.monsterMeta.monster_type == Const.MonsterType.Boss) then
      self.logic:OnBattleWin()
    end
  end
end

function ParkourBattleKatyushaSpecialBonusState:GetCheckWinConditions()
  return self.bonusWinConditions
end

function ParkourBattleKatyushaSpecialBonusState:OnFingerDown(pos)
  self.logic:OnFingerDownLeftRight(pos)
end

function ParkourBattleKatyushaSpecialBonusState:OnFingerHold(deltaTime)
  self.logic:OnFingerHoldLeftRight(deltaTime)
end

function ParkourBattleKatyushaSpecialBonusState:GetBonusType()
  return Const.ParkourBattleBonusType.KatyushaSpecial
end

function ParkourBattleKatyushaSpecialBonusState:SetLayerActive(isActive)
  local sceneLayer = UIManager:GetInstance():GetLayer(UILayer.Scene.Name)
  if sceneLayer then
    local sceneLayerObj = sceneLayer.gameObject
    if IsNotNull(sceneLayerObj) then
      sceneLayerObj:SetActive(isActive)
    end
  end
  local hpBarLayer = UIManager:GetInstance():GetLayer(UILayer.HpBar.Name)
  if hpBarLayer then
    local hpBarLayerObj = hpBarLayer.gameObject
    if IsNotNull(hpBarLayerObj) then
      hpBarLayerObj:SetActive(isActive)
    end
  end
end

function ParkourBattleKatyushaSpecialBonusState:OnPlotGroupDone(plotGroupId)
  if self.bonusExtendData then
    if plotGroupId == self.bonusExtendData.plotGroupId then
      self:OnPlotDone()
    elseif plotGroupId == self.bonusExtendData.plotGroupIdBeforeTimeline then
      self:OnPlotBeforeTimelineDone()
    end
  end
end

function ParkourBattleKatyushaSpecialBonusState:OnPlotViewClosedAbnormally(plotGroupId)
  if self.bonusExtendData then
    if plotGroupId == self.bonusExtendData.plotGroupId then
      self:OnPlotDone()
    elseif plotGroupId == self.bonusExtendData.plotGroupIdBeforeTimeline then
      self:OnPlotBeforeTimelineDone()
    end
  end
end

return ParkourBattleKatyushaSpecialBonusState
