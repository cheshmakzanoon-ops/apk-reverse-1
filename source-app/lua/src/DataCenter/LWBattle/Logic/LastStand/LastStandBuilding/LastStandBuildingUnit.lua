local base = require("Scene.LWBattle.UnitBase")
local LastStandBuildingUnit = BaseClass("LastStandBuildingUnit", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function LastStandBuildingUnit:Init(logic, config, pos)
  base.Init(self, logic)
  self.guid = logic:AllotUnitGuid()
  self.isBuildingDone = config.lv > 0
  self.buildNeedCoin = config.cost
  self.curCoin = 0
  self.unitType = UnitType.Member
  self.updateInterval = 1
  self.curInterval = 0
  self.reduceCoinInterval = 0.1
  self.reduceCoinIntervalUpgrade = 0.1
  self.lastStandBuildingType = nil
  self.buildingConfig = config
  self.buildingLevel = config.lv
  self.buildingPos = pos
  self.maxBlood = config.hp
  self.curUpgradeCoin = 0
  self.upgradeNeedCoin = config.cost
  self.isInitHpBar = false
end

function LastStandBuildingUnit:OnBuildCoinFull()
  self.isBuildingDone = true
  self:OnBuildingUpgrade()
  self:ShowUpgradeEffect()
  self.curBlood = self.maxBlood
  EventManager:GetInstance():Broadcast(EventId.LastStandBuildingFinish, self.buildingConfig)
end

function LastStandBuildingUnit:ShowUpgradeEffect()
  self.logic:ShowEffectObj("Assets/Main/Prefabs/LastStand/Effectt/Prefabs/Eff_morituwei_jianzhuchuxian.prefab", self.transform.position, nil, 2)
end

function LastStandBuildingUnit:GetBuildNeedCoin()
  return self.buildNeedCoin - self.curCoin
end

function LastStandBuildingUnit:OnDestroy()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function LastStandBuildingUnit:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if not self.transform then
    return
  end
  local teamPos = self.logic.team:GetPosition()
  local distance = Vector3.Distance(self.transform.position, teamPos)
  if distance < 3 then
    if not self.isStayInBuilding then
      self:OnEnterBuilding()
    end
  elseif self.isStayInBuilding then
    self:OnExitBuilding()
  end
  if self.isStayInBuilding then
    if not self.isBuildingDone then
      self.reduceCoinInterval = self.reduceCoinInterval - deltaTime
      if self.reduceCoinInterval <= 0 then
        self.reduceCoinInterval = 0.1
        self:OnBuildProgressReduce()
      end
    end
    self:OnStayInBuilding(deltaTime)
  end
  self:OnUpdateAfterBuildCheck(deltaTime)
  if not self.isBuildingDone then
    return
  end
  self.reduceCoinIntervalUpgrade = self.reduceCoinIntervalUpgrade - deltaTime
  if distance <= 4.1 and 0 >= self.reduceCoinIntervalUpgrade then
    self.reduceCoinIntervalUpgrade = 0.1
    self:OnUpgradeProgressReduce()
  end
  self:OnUpgradeAfterCheck(deltaTime)
  self.curInterval = self.curInterval - deltaTime
  self:UpdateInterval()
  if 0 < self.curInterval then
    return
  end
  self.curInterval = self.updateInterval
  self:ExecuteIntervalLogic()
end

function LastStandBuildingUnit:ExecuteIntervalLogic()
end

function LastStandBuildingUnit:UpdateInterval()
end

function LastStandBuildingUnit:OnEnterBuilding()
  if self.isStayInBuilding then
    return
  end
  self.isStayInBuilding = true
  if not self.isBuildingDone then
    return
  end
  self:ExecuteEnterBuildingLogic()
end

function LastStandBuildingUnit:ExecuteEnterBuildingLogic()
end

function LastStandBuildingUnit:OnExitBuilding()
  self.isStayInBuilding = false
end

function LastStandBuildingUnit:OnLoadComplete()
  if self.lastStandBuildingType ~= LastStandBuildType.Home and not self.isShown then
    self:HideBuilding()
  end
  if self.isBuildingDone then
    self:OnUpgradeProgressRefresh()
    self:ShowBuilding()
    if self.lastStandBuildingType == LastStandBuildType.Home then
      self.curBlood = self.maxBlood
      EventManager:GetInstance():Broadcast(EventId.LastStandHomeBuildFinish)
    end
    local param = {
      buildingCfg = self.buildingConfig,
      x = self.buildingPos.x,
      z = self.buildingPos.z
    }
    EventManager:GetInstance():Broadcast(EventId.LastStandBuildingUpgrade, param)
  end
end

function LastStandBuildingUnit:OnUpdateAfterBuildCheck(deltaTime)
  if self.isBuildingDone or not self.imageProgress then
    return
  end
  local targetSize = 4 * (self.curCoin / self.buildNeedCoin)
  local curImgSize = self.imageProgress.size.y
  if targetSize > curImgSize then
    self.imageProgress.size = Vector2.New(4, math.min(curImgSize + deltaTime * 3, targetSize))
  end
end

function LastStandBuildingUnit:OnUpgradeAfterCheck(deltaTime)
  if not self.imageUpgradeProgress then
    return
  end
  local targetSize = 3.45 * (self.curUpgradeCoin / self.upgradeNeedCoin)
  local curImgSize = self.imageUpgradeProgress.size.y
  if targetSize > curImgSize then
    self.imageUpgradeProgress.size = Vector2.New(0.87, math.min(curImgSize + deltaTime * 3, targetSize))
  else
    self.imageUpgradeProgress.size = Vector2.New(0.87, targetSize)
  end
end

function LastStandBuildingUnit:OnBuildProgressRefresh()
end

function LastStandBuildingUnit:OnBuildProgressReduce()
  local haveCoin = self.logic:GetCoin()
  if haveCoin <= 0 then
    return
  end
  if self.isBuildingDone or self.curCoin >= self.buildNeedCoin then
    return
  end
  if not self:CheckIsPreBuildingExistForBuilding() then
    return
  end
  self.logic:ReduceCoin()
  self:PlayCoinFlyEffect()
  self.curCoin = self.curCoin + 1
  self:OnBuildProgressRefresh()
  if self.curCoin >= self.buildNeedCoin then
    self:OnBuildCoinFull()
  end
end

function LastStandBuildingUnit:OnUpgradeProgressReduce()
  local haveCoin = self.logic:GetCoin()
  if haveCoin <= 0 then
    return
  end
  if self:IsMaxLevel() then
    return
  end
  if not self:CheckIsPreBuildingExistForUpgrade() then
    return
  end
  self.logic:ReduceCoin()
  self:PlayCoinFlyEffect()
  self.curUpgradeCoin = self.curUpgradeCoin + 1
  self:OnUpgradeProgressRefresh()
  if self.curUpgradeCoin >= self.upgradeNeedCoin then
    self.curUpgradeCoin = 0
    self:OnBuildingUpgrade()
  end
end

function LastStandBuildingUnit:PlayCoinFlyEffect()
  if self.imageUpgradeProgress then
    local param = {}
    param.worldPosition = self.imageUpgradeProgress.transform.position
    EventManager:GetInstance():Broadcast(EventId.LastStandReduceCoin, param)
  end
end

function LastStandBuildingUnit:IsBuildingDone()
  return self.isBuildingDone
end

function LastStandBuildingUnit:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if self.invincible then
    return
  end
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if 0 < hurt then
    hurt = self:ReduceShieldValue(hurt)
    self.curBlood = math.max(self.curBlood - hurt, 0)
    if 0 < self.curBlood then
      if not self.hpBarHandle and not self.isInitHpBar then
        self:InitHpBar()
      elseif self.hpBarHandle then
        pveUnitViewUtil.SetHpBar(self.hpBarHandle, self.curBlood, self.maxBlood, self:GetShieldValue())
      end
    end
  end
end

function LastStandBuildingUnit:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.invincible then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.curBlood <= 0 then
    self:OnBuildingDeath()
  end
end

function LastStandBuildingUnit:OnUpgradeProgressRefresh()
  if not self.textUpgradeCost then
    return
  end
  if self:IsConfigMaxLevel() then
    self:HideUpgradeUI()
    return
  end
  self.textUpgradeCost.text = self.curUpgradeCoin .. "/" .. self.upgradeNeedCoin
  self.imageUpgradeProgress.size.y = 0
end

function LastStandBuildingUnit:OnBuildingDeath()
  self:DestroyHpBar()
end

function LastStandBuildingUnit:DestroyHpBar()
  if self.hpBarHandle then
    pveUnitViewUtil.DestroyHpBar(self.hpBarHandle)
    self.hpBarHandle = nil
    self.isInitHpBar = false
  end
end

function LastStandBuildingUnit:ShowBuilding()
  self.isShown = true
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(true)
  end
end

function LastStandBuildingUnit:HideBuilding()
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
end

function LastStandBuildingUnit:OnBuildingUpgrade()
  local oldConfig = self.buildingConfig
  local nextLevelId = oldConfig.id + 1
  self.buildingConfig = self.logic.buildingMgr:GetBuildingConfig(self.lastStandBuildingType, nextLevelId)
  if not self.buildingConfig then
    Logger.LogError("\230\156\171\230\151\165\231\170\129\229\155\180\229\187\186\231\173\145\231\188\186\229\176\145\233\133\141\231\189\174:" .. tostring(self.lastStandBuildingType) .. ",level:" .. tostring(nextLevelId))
    return
  end
  self.buildingLevel = self.buildingLevel + 1
  self.upgradeNeedCoin = self.buildingConfig.cost
  self.maxBlood = self.buildingConfig.hp
  self:OnUpgradeProgressRefresh()
  self:ShowUpgradeEffect()
  if self.textLevel then
    self.textLevel.text = self.buildingLevel
  end
  local param = {
    buildingCfg = oldConfig,
    x = self.buildingPos.x,
    z = self.buildingPos.z
  }
  EventManager:GetInstance():Broadcast(EventId.LastStandBuildingUpgrade, param)
end

function LastStandBuildingUnit:IsMaxLevel()
  local homeLevel = self.logic.buildingMgr:GetCurHomeLevel()
  local isSelfHome = self.lastStandBuildingType == LastStandBuildType.Home
  if not isSelfHome and homeLevel <= self.buildingLevel then
    return true
  end
  return self.buildingLevel >= self.buildingConfig.max_lv
end

function LastStandBuildingUnit:IsConfigMaxLevel()
  return self.buildingLevel >= self.buildingConfig.max_lv
end

function LastStandBuildingUnit:GetCurLevel()
  return self.buildingLevel
end

function LastStandBuildingUnit:GetConfigId()
  if not self.buildingConfig then
    return 0
  end
  return self.buildingConfig.id
end

function LastStandBuildingUnit:CheckIsPreBuildingExistForBuilding()
  local preBuildingGroups = self.buildingConfig.front_building_list
  if table.IsNullOrEmpty(preBuildingGroups) then
    return true
  end
  for i, preBuildingIds in ipairs(preBuildingGroups) do
    local isExist = false
    for j, preBuildingId in ipairs(preBuildingIds) do
      isExist = self.logic.buildingMgr:IsPreBuildingExist(preBuildingId)
      if isExist then
        break
      end
    end
    if not isExist then
      return false
    end
  end
  return true
end

function LastStandBuildingUnit:CheckIsPreBuildingExistForUpgrade()
  if not self.buildingConfig then
    return false
  end
  local nextLevelConfig = self.logic.buildingMgr:GetBuildingConfig(self.lastStandBuildingType, self.buildingConfig.id + 1)
  if not nextLevelConfig then
    return true
  end
  local preBuildingGroups = nextLevelConfig.front_building_list
  if table.IsNullOrEmpty(preBuildingGroups) then
    return true
  end
  for i, preBuildingIds in ipairs(preBuildingGroups) do
    local isExist = false
    for j, preBuildingId in ipairs(preBuildingIds) do
      isExist = self.logic.buildingMgr:IsPreBuildingExist(preBuildingId)
      if isExist then
        break
      end
    end
    if not isExist then
      return false
    end
  end
  return true
end

function LastStandBuildingUnit:ShowUpgradeUI()
  if self.updateProgressTrans and not self.updateProgressTrans.gameObject.activeSelf then
    self.updateProgressTrans.gameObject:SetActive(true)
  end
end

function LastStandBuildingUnit:HideUpgradeUI()
  if self.updateProgressTrans and self.updateProgressTrans.gameObject.activeSelf then
    self.updateProgressTrans.gameObject:SetActive(false)
  end
end

function LastStandBuildingUnit:ShowGuideAnim()
  if not self.modelBuildingObj or not self.createInfoObj then
    return
  end
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.sequence = DOTween.Sequence()
  local targetTransform
  if self.isBuildingDone then
    targetTransform = self.modelBuildingObj.transform
  else
    targetTransform = self.createInfoObj.transform
  end
  self.sequence:Append(targetTransform:DOScale(Vector3.New(0.9, 0.9, 0.9), 0.3)):SetLoops(-1, CS.DG.Tweening.LoopType.Yoyo)
end

function LastStandBuildingUnit:StopGuideAnim()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  if self.modelBuildingObj then
    self.modelBuildingObj.transform.localScale = Vector3.New(1, 1, 1)
  end
  if self.createInfoObj then
    self.createInfoObj.transform.localScale = Vector3.New(1, 1, 1)
  end
end

function LastStandBuildingUnit:InitHpBar()
  if self.buildingConfig.type ~= LastStandBuildType.Home and self.buildingConfig.type ~= LastStandBuildType.Gate or not self.viewHandle then
    return
  end
  if self.hpBarHandle then
    self:DestroyHpBar()
  end
  self.hpBarHandle = pveUnitViewUtil.CreateSelfHpBarWithHandle(self.viewHandle, self.hpBarHeight, self.hpBarOffset, self.curBlood, self.maxBlood)
  self.isInitHpBar = true
end

function LastStandBuildingUnit:OnStayInBuilding()
end

return LastStandBuildingUnit
