local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.DynamicTableMonster")
local WaterBottleMonster = BaseClass("WaterBottleMonster", base)
local Const = require("Scene.LWBattle.Const")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local BattleColliderUtils = CS.BattleColliderUtils
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local CallForHelpAniName = "hujiu"
local StruggledAniName = "zhengzha"
local HitGlassAniName = "chuiboli"
local bubbleAnchor = Vector3.New(0, 5, 0)
local DrowningBubbleEffectPath = "Assets/Main/Prefabs/LWBattle/Bottle/Eff_Bubble.prefab"
local AKFlyShineEffectPath = "Assets/Main/Prefabs/LWBattle/Bottle/Eff_AK_Shine.prefab"
local HeroFlyShineEffectPath = "Assets/Main/Prefabs/LWBattle/Bottle/Eff_Hero_Shine.prefab"
local HeroState = {
  None = 0,
  CallForHelp = 1,
  Struggled = 2,
  HitGlass = 3
}

function WaterBottleMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.dynamicResGameObjectCurPlayAniName = ""
  self.curHeroState = HeroState.None
  self.curPlayPlotId = 0
  self.curGlassCrackValue = -1
  self.curWaterHeightValue = -1
  self.curLerpBlood = self.curBlood
  self.curBloodRatio = self.curBlood / self.maxBlood
  self.drowningBubbleEffectId = -1
  self.drowningBubbleNodeGo = nil
  self.isLoadComplete = false
  self.playHitEffectOnHitPoint = true
  if self.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle then
    self.bubblePointData = self.heroEffectMeta and self.heroEffectMeta.bubble_point or nil
  end
end

function WaterBottleMonster:DestroyData()
  self.dynamicResGameObjectAnim = nil
  self.dynamicResGameObjectCurPlayAniName = nil
  self.curHeroState = nil
  self.curPlayPlotId = nil
  self.curGlassCrackValue = nil
  self.curWaterHeightValue = nil
  self.curLerpBlood = nil
  self.curBloodRatio = nil
  self.drowningBubbleEffectId = nil
  self.drowningBubbleNodeGo = nil
  self.isLoadComplete = nil
  self.bubblePointData = nil
  self.cachePlotData = nil
  base.DestroyData(self)
end

function WaterBottleMonster:DestroyView()
  self:RemoveDrowningBubbleEffect()
  base.DestroyView(self)
end

function WaterBottleMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  self:PlaySimpleAnim("Default")
  self:InitCrackAndWaterHeightEffect()
  self.isLoadComplete = true
end

function WaterBottleMonster:AfterLoadDynamicRes()
  if self.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle then
    self.dynamicResGameObjectAnim = self.dynamicResTransform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if self.bubblePointData and not string.IsNullOrEmpty(self.bubblePointData.nodePath) then
      local nodeTrans = self.dynamicResTransform:Find(self.bubblePointData.nodePath)
      if nodeTrans then
        self.drowningBubbleNodeGo = nodeTrans.gameObject
      end
    end
    self:UpdateShowHeroAniAndPlotBubble()
  else
    base.AfterLoadDynamicRes(self)
  end
end

function WaterBottleMonster:UpdateReversePos(deltaTime)
  if self.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle then
    return
  end
  base.UpdateReversePos(self, deltaTime)
end

function WaterBottleMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.curBlood <= 0 or not self.isLoadComplete then
    return
  end
  self.curBloodRatio = self.curBlood / self.maxBlood
  if self.monsterMeta.monster_type == Const.MonsterType.HorizontalWaterBottle then
    self:UpdateHorizontalWaterBottleCrackEffect()
  else
    self:UpdateStandingWaterBottleCrackEffect()
    self:UpdateShowHeroAniAndPlotBubble()
  end
  if math.abs(self.curLerpBlood - self.curBlood) > 0.01 then
    self:UpdateWaterHeightEffect(deltaTime)
  end
end

function WaterBottleMonster:TryHitWhite()
end

function WaterBottleMonster:DieGray()
end

function WaterBottleMonster:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and self.afterBeAttackDone then
    return
  end
  if self.curBlood <= 0 then
    local value = 0
    if self.monsterMeta.monster_type == Const.MonsterType.HorizontalWaterBottle then
      value = value - 0.5
    end
    self:SetWaterHeightEffect(value)
    if self.viewHandle and self.logic.RemoveAllHitEffectObjByParentViewHandle then
      self.logic:RemoveAllHitEffectObjByParentViewHandle(self.viewHandle)
      if self.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle and self.curPlayPlotId and 0 < self.curPlayPlotId then
        EventManager:GetInstance():Broadcast(EventId.RemovePlotBubbleById, self.curPlayPlotId)
      end
    end
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  self.afterBeAttackDone = true
end

function WaterBottleMonster:FlyNode()
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
  if self.dynamicResReq and not IsNull(self.dynamicResGameObject) and self.battleMgr and self.battleMgr.WaterBottleDynamicResFlyToTeam then
    local req = self.dynamicResReq
    self.dynamicResReq = nil
    self:ClearDynamicRes()
    local effectPath = ""
    if self.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle then
      effectPath = HeroFlyShineEffectPath
    else
      effectPath = AKFlyShineEffectPath
    end
    self.battleMgr:WaterBottleDynamicResFlyToTeam(req, self.deathEvent, self.preSelectHeroUuid, self.monsterMeta.monster_type, effectPath)
    return
  end
  self:ClearDynamicRes()
  local eventId = self.deathEvent
  local extra = self.preSelectHeroUuid
  if eventId then
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
    if meta and meta.isUnAddEnergyType then
      DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extra)
    end
  end
end

function WaterBottleMonster:InitCrackAndWaterHeightEffect()
  pveUnitViewUtil.InitGlassAndWaterRender(self.viewHandle, "Root/Trans/Bottle/A_build_shuiping_boli", "Root/Trans/Bottle/A_build_shuiping_shui")
  if self.monsterMeta.monster_type == Const.MonsterType.HorizontalWaterBottle then
    self:UpdateHorizontalWaterBottleCrackEffect()
    self:SetWaterHeightEffect(0.5)
  else
    self:UpdateStandingWaterBottleCrackEffect()
    self:SetWaterHeightEffect(1)
  end
end

function WaterBottleMonster:UpdateHorizontalWaterBottleCrackEffect()
  local frameValue = 0
  if self.curBloodRatio >= 0.3 and self.curBloodRatio <= 0.6 then
    frameValue = 1
  elseif self.curBloodRatio < 0.3 then
    frameValue = 2
  end
  self:SetGlassCrackEffect(frameValue)
end

function WaterBottleMonster:UpdateStandingWaterBottleCrackEffect()
  local frameValue = 0
  if self.curBloodRatio >= 0.6 and self.curBloodRatio < 0.8 then
    frameValue = 1
  elseif self.curBloodRatio >= 0.4 and self.curBloodRatio < 0.6 then
    frameValue = 2
  elseif self.curBloodRatio >= 0.2 and self.curBloodRatio < 0.4 then
    frameValue = 3
  elseif self.curBloodRatio < 0.2 then
    frameValue = 4
  end
  self:SetGlassCrackEffect(frameValue)
end

function WaterBottleMonster:UpdateWaterHeightEffect(deltaTime)
  local difference = Mathf.Abs(self.curLerpBlood - self.curBlood)
  local lerpSpeed = 2 + difference * 0.3
  self.curLerpBlood = Mathf.Lerp(self.curLerpBlood, self.curBlood, deltaTime * lerpSpeed)
  local value = self.curLerpBlood / self.maxBlood
  if self.monsterMeta.monster_type == Const.MonsterType.HorizontalWaterBottle then
    value = value - 0.5
  end
  self:SetWaterHeightEffect(value)
end

function WaterBottleMonster:SetGlassCrackEffect(newFrameValue)
  if self.curGlassCrackValue ~= newFrameValue then
    self.curGlassCrackValue = newFrameValue
    pveUnitViewUtil.SetGlassCrackEffect(self.viewHandle, self.curGlassCrackValue)
  end
end

function WaterBottleMonster:SetWaterHeightEffect(newHeightValue)
  if math.abs(self.curWaterHeightValue - newHeightValue) > 0.01 then
    self.curWaterHeightValue = newHeightValue
    pveUnitViewUtil.SetWaveIntensityEffect(self.viewHandle, self.curWaterHeightValue)
  end
end

function WaterBottleMonster:UpdateShowHeroAniAndPlotBubble()
  if IsNull(self.dynamicResGameObject) then
    return
  end
  local curState = HeroState.None
  if self.curBloodRatio >= 0.8 and self.curBloodRatio <= 1 then
    curState = HeroState.CallForHelp
  elseif self.curBloodRatio >= 0.4 and self.curBloodRatio < 0.8 then
    curState = HeroState.Struggled
  elseif self.curBloodRatio < 0.4 then
    curState = HeroState.HitGlass
  end
  if self.curHeroState ~= curState then
    self.curHeroState = curState
    self:RefreshPlayHeroAni(curState)
    self:RefreshShowPlotBubble(curState)
  end
  self:UpdateDrowningBubbleEffect()
end

function WaterBottleMonster:RefreshPlayHeroAni(heroState)
  local newAniName
  if heroState == HeroState.CallForHelp then
    newAniName = CallForHelpAniName
  elseif heroState == HeroState.Struggled then
    newAniName = StruggledAniName
  elseif heroState == HeroState.HitGlass then
    newAniName = HitGlassAniName
  end
  if newAniName and self.dynamicResGameObjectCurPlayAniName ~= newAniName and self.dynamicResGameObjectAnim then
    self.dynamicResGameObjectCurPlayAniName = newAniName
    self.dynamicResGameObjectAnim:Play(self.dynamicResGameObjectCurPlayAniName)
  end
end

function WaterBottleMonster:RefreshShowPlotBubble(heroState)
  if self.curBlood <= 0 then
    return
  end
  local targetPlotId = self:GetPlayPlotId(heroState)
  if 0 < targetPlotId and self.curPlayPlotId ~= targetPlotId then
    EventManager:GetInstance():Broadcast(EventId.RemovePlotBubbleById, self.curPlayPlotId)
    self.curPlayPlotId = targetPlotId
    if self.dynamicResTransform then
      local bubbleParams = {}
      bubbleParams.plotId = targetPlotId
      bubbleParams.anchor = bubbleAnchor
      bubbleParams.mode = "3DFollow"
      bubbleParams.followTarget = self.dynamicResTransform
      EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleOnlyId, bubbleParams)
    end
  end
end

function WaterBottleMonster:GetPlayPlotId(state)
  if self.cachePlotData == nil then
    self.cachePlotData = self.battleMgr.monsterMgr:GetPlotDataByMonsterId(self.monsterMetaId)
  end
  if self.cachePlotData then
    local plotIdArr = self.cachePlotData[state]
    if plotIdArr then
      local count = table.count(plotIdArr)
      if 0 < count then
        local startPlot = plotIdArr[1]
        local endPlot = plotIdArr[count]
        return math.random(startPlot, endPlot)
      end
    end
  end
  return 0
end

function WaterBottleMonster:UpdateDrowningBubbleEffect()
  local showThreshold = self.bubblePointData and self.bubblePointData.showThreshold or 0.85
  if showThreshold <= self.curBloodRatio then
    if self.drowningBubbleEffectId < 0 then
      self:ShowDrowningBubbleEffect()
    end
  else
    self:RemoveDrowningBubbleEffect()
  end
end

function WaterBottleMonster:ShowDrowningBubbleEffect()
  if self.logic and self.drowningBubbleNodeGo then
    local scale = self.bubblePointData and self.bubblePointData.scale or 1
    self.drowningBubbleEffectId = self.logic:ShowEffectObj(DrowningBubbleEffectPath, nil, nil, 0, self.drowningBubbleNodeGo.transform, EffectObjType.Normal, scale)
  end
end

function WaterBottleMonster:RemoveDrowningBubbleEffect()
  if self.drowningBubbleEffectId > 0 and self.logic then
    self.logic:RemoveEffectObj(self.drowningBubbleEffectId)
    self.drowningBubbleEffectId = -1
  end
end

function WaterBottleMonster:RegisterUpdateReversePos()
  if self.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle then
    return
  end
  base.RegisterUpdateReversePos(self)
end

return WaterBottleMonster
