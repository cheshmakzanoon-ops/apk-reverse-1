local EquipRecommendData = BaseClass("EquipRecommendData")
EquipRecommendData.RecommendHeroNumLimit = 1

function EquipRecommendData:__init()
  self.curRecommendDict = {}
  self.nextRecommendDict = {}
  self.resultRecommendDict = {}
  self.heroUuidList = {}
  self.squad = 0
end

function EquipRecommendData:__delete()
  self.curRecommendDict = nil
  self.nextRecommendDict = nil
  self.resultRecommendDict = nil
  self.heroUuidList = nil
  self.squad = nil
end

function EquipRecommendData:Reset(squad)
  self.nextRecommendDict = {}
  self.curRecommendDict = {}
  self.heroUuidList = {}
  self.resultRecommendDict = {}
  self.squad = squad
  self.isDataValid = false
  if self.squad ~= nil and self.squad > 0 then
    self.isDataValid = true
    self.heroUuidList = DataCenter.ArmyFormationDataManager:GetHeroUuidListInSquad(self.squad)
    self:Update()
  end
end

function EquipRecommendData:Update()
  self:UpdateCur()
  self:UpdateNext()
  self:UpdateResult()
end

function EquipRecommendData:IsShowRecommendByHero(heroData)
  if heroData == nil then
    return false
  end
  if not table.IsNullOrEmpty(self.resultRecommendDict) and self.resultRecommendDict[heroData.uuid] ~= nil then
    return true
  end
  return false
end

function EquipRecommendData:IsShowRecommend(heroData, equipData)
  if heroData == nil or equipData == nil then
    return false
  end
  if not table.IsNullOrEmpty(self.resultRecommendDict) and self.resultRecommendDict[heroData.uuid] ~= nil then
    for _, slotType in pairs(self.resultRecommendDict[heroData.uuid]) do
      if slotType == equipData.slot then
        return true
      end
    end
  end
  return false
end

function EquipRecommendData:GetNextRecommendId(heroUuid)
  if self.isDataValid then
    return self.nextRecommendDict[heroUuid]
  end
end

function EquipRecommendData:GetNextRecommendTemplate(heroUuid)
  local id = self:GetNextRecommendId(heroUuid)
  if id ~= nil then
    return DataCenter.EquipRecommendManager:GetTemplate(id)
  end
end

function EquipRecommendData:UpdateResult()
  local function TryAddToResult(heroUuid, slotType, maxCount)
    if self.resultRecommendDict[heroUuid] == nil then
      self.resultRecommendDict[heroUuid] = {slotType}
      
      return true
    else
      local curCount = table.count(self.resultRecommendDict[heroUuid])
      if maxCount <= curCount then
        return false
      else
        table.insert(self.resultRecommendDict[heroUuid], slotType)
        return true
      end
    end
  end
  
  for heroUuid, curRecommendId in pairs(self.curRecommendDict) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData then
      local nextTemplate = self:GetNextRecommendTemplate(heroUuid)
      if nextTemplate ~= nil then
        local curTemplate = DataCenter.EquipRecommendManager:GetTemplate(curRecommendId)
        if curTemplate and not table.IsNullOrEmpty(curTemplate.positionOrderList) then
          for _, slotType in ipairs(curTemplate.positionOrderList) do
            if not (nextTemplate:IsEquipQualified(heroData, slotType) or TryAddToResult(heroUuid, slotType, curTemplate.recommend_num)) then
              break
            end
          end
        end
      end
    end
  end
end

function EquipRecommendData:UpdateNext()
  if table.IsNullOrEmpty(self.heroUuidList) then
    return
  end
  local orders = {}
  for _, heroUuid in pairs(self.heroUuidList) do
    local curRecommendTemplate = self:GetCurRecommend(heroUuid)
    if curRecommendTemplate ~= nil then
      orders[heroUuid] = curRecommendTemplate.order
    end
  end
  
  local function IsAllSameValue(param)
    local first
    for k, v in pairs(param) do
      if first == nil then
        first = v
      elseif first ~= v then
        return false
      end
    end
    return true
  end
  
  local function GetMinOrderHeros(param)
    local minOrder
    for k, v in pairs(param) do
      if minOrder == nil or v < minOrder then
        minOrder = v
      end
    end
    if minOrder ~= nil then
      local res = {}
      for k, v in pairs(param) do
        if v == minOrder then
          table.insert(res, k)
        end
      end
      return res, minOrder
    end
  end
  
  if not table.IsNullOrEmpty(orders) then
    local isAllSame = IsAllSameValue(orders)
    if isAllSame then
      for _, heroUuid in pairs(self.heroUuidList) do
        local curRecommendTemplate = self:GetCurRecommend(heroUuid)
        if curRecommendTemplate ~= nil then
          local nextTemplate = DataCenter.EquipRecommendManager:GetTemplateByOrderAndGroup(curRecommendTemplate.order + 1, curRecommendTemplate.group_id)
          if nextTemplate ~= nil then
            self.nextRecommendDict[heroUuid] = nextTemplate.id
          end
        end
      end
    else
      local minOrderHeros, minOrder = GetMinOrderHeros(orders)
      if not table.IsNullOrEmpty(minOrderHeros) then
        for _, heroUuid in pairs(minOrderHeros) do
          local groupId = DataCenter.EquipRecommendManager:GetGroupIdByHero(heroUuid)
          if groupId ~= nil then
            local nextTemplate = DataCenter.EquipRecommendManager:GetTemplateByOrderAndGroup(minOrder + 1, groupId)
            if nextTemplate ~= nil then
              self.nextRecommendDict[heroUuid] = nextTemplate.id
            end
          end
        end
      end
    end
    
    local function GetHeroJobOrder(job)
      if job == HeroJob.exportation then
        return 1
      elseif job == HeroJob.Defense then
        return 2
      else
        return 3
      end
    end
    
    local resultTmp = {}
    for heroUuid, recommendId in pairs(self.nextRecommendDict) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        local data = {
          heroUuid = heroUuid,
          recommendId = recommendId,
          heroJob = heroData.heroJob,
          power = heroData.power or 0
        }
        table.insert(resultTmp, data)
      end
    end
    table.sort(resultTmp, function(a, b)
      local jobOrderA = GetHeroJobOrder(a.heroJob)
      local jobOrderB = GetHeroJobOrder(b.heroJob)
      if jobOrderA ~= jobOrderB then
        return jobOrderA < jobOrderB
      else
        return a.power > b.power
      end
    end)
    self.nextRecommendDict = {}
    local count = 0
    for i, v in ipairs(resultTmp) do
      if count >= self.RecommendHeroNumLimit then
        goto lbl_145
      end
      self.nextRecommendDict[v.heroUuid] = v.recommendId
      count = count + 1
    end
  end
  ::lbl_145::
end

function EquipRecommendData:GetCurRecommend(heroUuid)
  if self.curRecommendDict[heroUuid] then
    return DataCenter.EquipRecommendManager:GetTemplate(self.curRecommendDict[heroUuid])
  end
end

function EquipRecommendData:UpdateCur()
  local function UpdateOne(heroUuid)
    local res = 0
    
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      local recommendTemplateList = DataCenter.EquipRecommendManager:GetTemplateListByHero(heroUuid)
      if not table.IsNullOrEmpty(recommendTemplateList) then
        local curRecommend
        for i, v in ipairs(recommendTemplateList) do
          local weaponQualified = v:IsEquipQualified(heroData, EquipmentSlotType.Weapon)
          if not weaponQualified then
            break
          end
          local armorQualified = v:IsEquipQualified(heroData, EquipmentSlotType.Armor)
          if not armorQualified then
            break
          end
          local coreQualified = v:IsEquipQualified(heroData, EquipmentSlotType.Core)
          if not coreQualified then
            break
          end
          local radarQualified = v:IsEquipQualified(heroData, EquipmentSlotType.Radar)
          if not radarQualified then
            break
          end
          curRecommend = v
        end
        if curRecommend ~= nil then
          res = curRecommend.id
        end
      end
    end
    self.curRecommendDict[heroUuid] = res
  end
  
  if not table.IsNullOrEmpty(self.heroUuidList) then
    for _, heroUuid in pairs(self.heroUuidList) do
      UpdateOne(heroUuid)
    end
  end
end

return EquipRecommendData
