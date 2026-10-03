local HeroRedPointManager = BaseClass("HeroRedPointManager", Singleton)
HeroRedPointType = {
  MainUI = 1,
  HeroListCard = 2,
  HeroDetail_PropertyPage = 3,
  HeroDetail_UpgradeBtn = 4,
  HeroDetail_EmptyEquipSlot = 5,
  HeroDetail_SkillPage = 7,
  HeroDetail_RankPage = 10,
  HeroDetail_RankUpgrade = 11,
  Equip_UpgradeBtn = 13,
  HeroDetail_ExistEquipSlot = 14,
  HeroDetial_UniqueWeapon = 15,
  HeroDetial_HeroAwaken = 16
}
HeroRedPointCacheType = {Resource = 1, Hero = 2}
local eventUpdateCache = {}

function HeroRedPointManager:__init()
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.GoodsUpdate)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.ResourceItemUpdate)
  EventManager:GetInstance():AddListener(EventId.EquipDataUpdate, self.EquipUpdate)
  EventManager:GetInstance():AddListener(EventId.ArmyFormatUpdate, self.SquadUpdate)
  EventManager:GetInstance():AddListener(EventId.HeroEquipInstall, self.EquipUpdate)
  EventManager:GetInstance():AddListener(EventId.HeroEquipUninstall, self.EquipUpdate)
  EventManager:GetInstance():AddListener(EventId.HeroLvUpSuccess, self.HeroLvUpSuccess)
  EventManager:GetInstance():AddListener(EventId.HeroUniqueWeaponUpgrade, self.UniqueWeaponUpdate)
  EventManager:GetInstance():AddListener(EventId.OpenHeroUniqueWeapon, self.UniqueWeaponUpdate)
  EventManager:GetInstance():AddListener(EventId.HeroUWEnhanceUnitUpgrade, self.UniqueWeaponUpdate)
  EventManager:GetInstance():AddListener(EventId.HeroUWEnhanceUnlocked, self.UniqueWeaponUpdate)
  EventManager:GetInstance():AddListener(EventId.OpenHeroAwakenPage, self.HeroAwakenUpdate)
  EventManager:GetInstance():AddListener(EventId.HeroAwakenUpgradeSuccess, self.HeroAwakenUpdate)
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUpdateTimer()
end

function HeroRedPointManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.GoodsUpdate)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.ResourceItemUpdate)
  EventManager:GetInstance():RemoveListener(EventId.EquipDataUpdate, self.EquipUpdate)
  EventManager:GetInstance():RemoveListener(EventId.ArmyFormatUpdate, self.SquadUpdate)
  EventManager:GetInstance():RemoveListener(EventId.HeroEquipInstall, self.EquipUpdate)
  EventManager:GetInstance():RemoveListener(EventId.HeroEquipUninstall, self.EquipUpdate)
  EventManager:GetInstance():RemoveListener(EventId.HeroLvUpSuccess, self.HeroLvUpSuccess)
  EventManager:GetInstance():RemoveListener(EventId.HeroUniqueWeaponUpgrade, self.UniqueWeaponUpdate)
  EventManager:GetInstance():RemoveListener(EventId.OpenHeroUniqueWeapon, self.UniqueWeaponUpdate)
  EventManager:GetInstance():RemoveListener(EventId.HeroUWEnhanceUnitUpgrade, self.UniqueWeaponUpdate)
  EventManager:GetInstance():RemoveListener(EventId.HeroUWEnhanceUnlocked, self.UniqueWeaponUpdate)
  EventManager:GetInstance():RemoveListener(EventId.OpenHeroAwakenPage, self.HeroAwakenUpdate)
  EventManager:GetInstance():RemoveListener(EventId.HeroAwakenUpgradeSuccess, self.HeroAwakenUpdate)
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUpdateTimer()
end

function HeroRedPointManager:AddUpdateTimer()
  self.cd_resource = 1
  self.cd_hero = 5
  eventUpdateCache = {}
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function HeroRedPointManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function HeroRedPointManager:OnUpdate()
  local deltaTime = Time.deltaTime
  if self.cd_resource > 0 then
    self.cd_resource = self.cd_resource - deltaTime
  else
    self.cd_resource = 1
    if eventUpdateCache[HeroRedPointCacheType.Resource] then
      eventUpdateCache[HeroRedPointCacheType.Resource] = nil
      EventManager:GetInstance():Broadcast(EventId.RefreshMainUIHeroRedPoint)
    end
  end
  if 0 < self.cd_hero then
    self.cd_hero = self.cd_hero - deltaTime
  else
    self.cd_hero = 5
    if eventUpdateCache[HeroRedPointCacheType.Hero] then
      eventUpdateCache[HeroRedPointCacheType.Hero] = nil
      EventManager:GetInstance():Broadcast(EventId.RefreshMainUIHeroRedPoint)
    end
  end
end

function HeroRedPointManager:ForceRefreshRedPoint()
  if self.updateTimer then
    self.cd_hero = 0
  end
end

function HeroRedPointManager:GoodsUpdate()
  eventUpdateCache[HeroRedPointCacheType.Resource] = true
end

function HeroRedPointManager:ResourceItemUpdate()
  eventUpdateCache[HeroRedPointCacheType.Resource] = true
end

function HeroRedPointManager:HeroLvUpSuccess()
  eventUpdateCache[HeroRedPointCacheType.Hero] = true
end

function HeroRedPointManager:EquipUpdate()
  eventUpdateCache[HeroRedPointCacheType.Hero] = true
end

function HeroRedPointManager:SquadUpdate()
  EventManager:GetInstance():Broadcast(EventId.RefreshMainUIHeroRedPoint)
end

function HeroRedPointManager:UniqueWeaponUpdate()
  eventUpdateCache[HeroRedPointCacheType.Hero] = true
end

function HeroRedPointManager:HeroAwakenUpdate()
  eventUpdateCache[HeroRedPointCacheType.Hero] = true
end

function HeroRedPointManager:OnPassDay()
  EventManager:GetInstance():Broadcast(EventId.RefreshMainUIHeroRedPoint)
end

function HeroRedPointManager:CheckCanShowRedPoint(type, ...)
  if type == HeroRedPointType.MainUI then
    return self:CheckMainUIRedPoint()
  elseif type == HeroRedPointType.HeroListCard then
    return self:CheckHeroListCard(tonumber(select(1, ...)))
  elseif type == HeroRedPointType.HeroDetail_PropertyPage then
    return self:CheckHeroDetail_PropertyPage(tonumber(select(1, ...)))
  elseif type == HeroRedPointType.HeroDetail_UpgradeBtn then
    return self:CheckHeroDetail_UpgradeBtn(tonumber(select(1, ...)))
  elseif type == HeroRedPointType.HeroDetail_ExistEquipSlot then
    return self:CheckHeroDetail_ExistEquipSlot(select(1, ...), select(2, ...))
  elseif type == HeroRedPointType.HeroDetail_EmptyEquipSlot then
    return self:CheckHeroDetail_EmptyEquipSlot(select(1, ...), select(2, ...), select(3, ...))
  elseif type == HeroRedPointType.HeroDetail_SkillPage then
    return self:CheckHeroDetail_SkillPage(select(1, ...))
  elseif type == HeroRedPointType.HeroDetail_RankPage then
  elseif type == HeroRedPointType.HeroDetail_RankUpgrade then
  elseif type == HeroRedPointType.HeroReplace_EquipBtn then
  elseif type == HeroRedPointType.Equip_UpgradeBtn then
  elseif type == HeroRedPointType.HeroDetial_UniqueWeapon then
    return self:CheckHeroDetail_UniqueWeapon(select(1, ...))
  elseif type == HeroRedPointType.HeroDetial_HeroAwaken then
    return self:CheckHeroDetail_HeroAwaken(select(1, ...))
  end
  return false
end

function HeroRedPointManager:CheckMainUIRedPoint()
  if self:HasHeroCanUnlock() then
    return true
  end
  local allHeroes = DataCenter.HeroDataManager:GetAllHeroList()
  for _, hero in pairs(allHeroes) do
    if hero:CanUpMilitaryRank() then
      return true
    end
    if self:IsHeroInSquad(hero.uuid) then
      local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
      if hero:ShowUpGradeRedPoint(expCount) then
        return true
      end
      if hero:ShowEquipRedPoint(true) then
        return true
      end
      if hero:CanShowUniqueWeaponRedPoint() then
        return true
      end
      if hero:IsUniqueWeaponNewOpen() then
        return true
      end
    end
  end
  return false
end

function HeroRedPointManager:CheckHeroListCard(uuid)
  local hero = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
  if hero then
    if self:IsHeroInSquad(uuid) then
      local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
      if hero:ShowUpGradeRedPoint(expCount) then
        return true
      end
      if hero:ShowEquipRedPoint(true) then
        return true
      end
      if hero:CanShowUniqueWeaponRedPoint() then
        return true
      end
      if hero:IsUniqueWeaponNewOpen() then
        return true
      end
      if hero:CanShowHeroAwakenRedPoint() then
        return true
      end
      if hero:IsHeroAwakenNewOpen() then
        return true
      end
    end
  else
    local heroMetaId = uuid
    if self:CanUnlock(heroMetaId) then
      return true
    end
  end
  return false
end

function HeroRedPointManager:CheckHeroDetail_PropertyPage(uuid)
  local hero = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
  if hero and self:IsHeroInSquad(uuid) then
    local expCount = DataCenter.ResourceItemDataManager:GetHeroExpCount()
    if hero:ShowUpGradeRedPoint(expCount) then
      return true
    end
  end
  return false
end

function HeroRedPointManager:CheckHeroDetail_UpgradeBtn(uuid)
  return self:CheckHeroDetail_PropertyPage(uuid)
end

function HeroRedPointManager:CheckHeroDetail_EmptyEquipSlot(slotType, heroType, heroUuid)
  if not self:IsHeroInSquad(heroUuid) then
    return false
  end
  local canEquip = false
  local allEquip = DataCenter.EquipDataManager:GetAllEquipListBySlotTypeAndHeroType(slotType, heroType, false)
  if table.count(allEquip) > 0 then
    canEquip = true
  end
  return canEquip
end

function HeroRedPointManager:CheckHeroDetail_ExistEquipSlot(equipData, heroUuid)
  if self:IsHeroInSquad(heroUuid) then
    if equipData:CanUpgrade() then
      return true
    end
    if equipData:CanPromote() and DataCenter.EquipDataManager:CheckRedEquipOpen() then
      return true
    end
    if DataCenter.EquipDataManager:HasBetterEquipBySlotAndHeroType(equipData.config.slot, equipData.config.heroType, equipData.power) then
      return true
    end
  end
  return false
end

function HeroRedPointManager:CheckHeroDetail_SkillPage(heroUuid)
  if self:IsHeroInSquad(heroUuid) then
    local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    for i = 1, 4 do
      local skillData = hero:GetHeroSkillBySlotIndex(i)
      if skillData then
        if hero:IsSkillCanUpgrade(skillData) then
          return true
        end
        if hero:IsIndexSkillNewUnlocked(i) then
          return true
        end
      end
    end
  end
  return false
end

function HeroRedPointManager:IsHeroInSquad(heroUuid)
  local idx = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(heroUuid)
  return idx ~= nil
end

function HeroRedPointManager:CanUnlock(heroMetaId)
  local itemId = HeroUtils.GetHeroDebrisIdByHeroId(heroMetaId)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local heroId = toInt(itemTemplate.para2)
  local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  local hasHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
  if string.IsNullOrEmpty(hasHero) and heroTemplate.showInHeroList == true then
    local need = HeroUtils.GetJigsawCost(itemId)
    local count = DataCenter.ItemData:GetItemCount(itemId)
    if need <= count then
      return true
    end
  end
  return false
end

function HeroRedPointManager:HasHeroCanUnlock()
  local type99Items = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_99)
  if type99Items then
    for k, v in pairs(type99Items) do
      local itemId = toInt(v.id)
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      local heroId = toInt(itemTemplate.para2)
      local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
      local hasHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
      if string.IsNullOrEmpty(hasHero) then
        local promoteId = DataCenter.HeroDataManager:GetHeroPromoteId(tostring(heroId))
        if promoteId then
          local promoteHero = DataCenter.HeroDataManager:GetHeroUuidByHeroId(promoteId)
          if not string.IsNullOrEmpty(promoteHero) then
            hasHero = promoteHero
          end
        end
      end
      if string.IsNullOrEmpty(hasHero) and heroTemplate.showInHeroList == true then
        local need = HeroUtils.GetJigsawCost(itemId)
        local count = DataCenter.ItemData:GetItemCount(itemId)
        if need <= count then
          return true
        end
      end
    end
  end
  return false
end

function HeroRedPointManager:HasHeroCanUpgradeHonorLevel(heroType)
  local allHeroes = DataCenter.HeroDataManager:GetHeroesByType(heroType)
  local functionUnlockCache = {}
  local functionUnlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
  if not heroType then
    local tankBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[HeroType.Tank])
    local missileBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[HeroType.Missile])
    local aircraftBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[HeroType.Aircraft])
    functionUnlockCache[HeroType.Tank] = tankBuilding ~= nil and functionUnlockLevel <= tankBuilding.level
    functionUnlockCache[HeroType.Missile] = missileBuilding ~= nil and functionUnlockLevel <= missileBuilding.level
    functionUnlockCache[HeroType.Aircraft] = aircraftBuilding ~= nil and functionUnlockLevel <= aircraftBuilding.level
  else
    local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[heroType])
    functionUnlockCache[heroType] = typeBuilding ~= nil and functionUnlockLevel <= typeBuilding.level
  end
  for _, hero in pairs(allHeroes) do
    if functionUnlockCache[hero.heroType] and hero:IsReachMaxRank() and not hero:IsReachMaxHonorLevel() then
      local costFragId = hero:GetHeroFragId()
      local costFragCount = hero:GetHonorLevelUpgradeCost()
      local hasFragCount = DataCenter.ItemData:GetItemCount(costFragId)
      if costFragCount <= hasFragCount then
        return true, hero.uuid
      end
    end
  end
  return false
end

function HeroRedPointManager:CheckHeroDetail_UniqueWeapon(heroUuid)
  if self:IsHeroInSquad(heroUuid) then
    local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if hero:CanShowUniqueWeaponRedPoint() then
      return true
    end
    if hero:IsUniqueWeaponNewOpen() then
      return true
    end
  end
  return false
end

function HeroRedPointManager:CheckHeroDetail_HeroAwaken(heroUuid)
  if self:IsHeroInSquad(heroUuid) then
    local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if hero:CanShowHeroAwakenRedPoint() then
      return true
    end
    if hero:IsHeroAwakenNewOpen() then
      return true
    end
  end
  return false
end

return HeroRedPointManager
