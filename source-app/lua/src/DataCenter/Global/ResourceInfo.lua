local ResourceInfo = BaseClass("ResourceInfo")

function ResourceInfo:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function ResourceInfo:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    Logger.LogError(msg_name, " not register")
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function ResourceInfo:__init()
  self.__event_handlers = {}
  self:__reset()
  self:AddListener(EventId.EffectNumChange, self.UpdateResourceMaxValue)
end

function ResourceInfo:__reset()
  self.flint = 0
  self.obsidian = 0
  self.oil = 0
  self.metal = 0
  self.water = 0
  self.electricity = 0
  self.money = 0
  self.pvePoint = 0
  self.wood = 0
  self.people = 0
  self.honorScore = 0
  self.petroleum = 0
  self.maxOil = 0
  self.maxMetal = 0
  self.maxWater = 0
  self.maxElectricity = 0
  self.maxPvePoint = 0
  self.oilAddSpeed = 0
  self.waterAddSpeed = 0
  self.metalAddSpeed = 0
end

function ResourceInfo:InitFromNet(obj)
  local resource = obj.resource
  if resource then
    self:UpdateResource(resource)
  end
  self:UpdateResourceMaxValue()
end

function ResourceInfo:Release()
  self:RemoveListener(EventId.EffectNumChange, self.UpdateResourceMaxValue)
end

function ResourceInfo:UpdateResource(resource, needResourceUpdated)
  if resource then
    self:UpdateResourceCurrentValue(resource)
    if needResourceUpdated == nil or needResourceUpdated == true then
      EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
    end
  end
end

function ResourceInfo:UpdateResourceAddSpeed(message)
  if message.oil_speed then
    self.oilAddSpeed = message.oil_speed
  end
  if message.water_speed then
    self.waterAddSpeed = message.water_speed
  end
  if message.metal_speed then
    self.metalAddSpeed = message.metal_speed
  end
end

function ResourceInfo:UpdateResourceCurrentValue(resource)
  if resource.oil then
    self.oil = resource.oil
  end
  if resource.metal then
    self.metal = resource.metal
  end
  if resource.money then
    self.money = resource.money
  end
  if resource.electricity then
    self.electricity = resource.electricity
  end
  if resource.water then
    self.water = resource.water
  end
  if resource.pvePoint then
    self.pvePoint = resource.pvePoint
  end
  if resource.wood then
    self.wood = resource.wood
  end
  if resource.people then
    self.people = resource.people
  end
  if resource.dragonHonorScore then
    self.honorScore = resource.dragonHonorScore
  end
  if resource.obsidian then
    self.obsidian = resource.obsidian
  end
  if resource.flint then
    self.flint = resource.flint
  end
  if resource.petroleum then
    self.petroleum = resource.petroleum
  end
end

function ResourceInfo:UpdateResourceMaxValue()
  self.maxWater = LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_MAX_LIMIT)
  self.maxMetal = LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_MAX_LIMIT)
  self.maxOil = LuaEntry.Effect:GetGameEffect(EffectDefine.OIL_MAX_LIMIT)
  self.maxElectricity = LuaEntry.Effect:GetGameEffect(EffectDefine.ELECTRICITY_MAX_LIMIT)
  self.maxPvePoint = LuaEntry.Effect:GetGameEffect(EffectDefine.PVE_POINT_MAX_LIMIT)
end

function ResourceInfo:GetMaxStorageByResType(type)
  if type == ResourceType.Oil then
    return self.maxOil
  elseif type == ResourceType.Water then
    return self.maxWater
  elseif type == ResourceType.Electricity then
    return self.maxElectricity
  elseif type == ResourceType.Metal then
    return self.maxMetal
  elseif type == ResourceType.PvePoint then
    return self.maxPvePoint
  end
  return 0
end

function ResourceInfo:GetResCurrentPercentByResType(type)
  if type == ResourceType.Oil then
    if self.maxOil <= 0 then
      return 0
    end
    return self.oil / self.maxOil
  elseif type == ResourceType.Water then
    if 0 >= self.maxWater then
      return 0
    end
    return self.water / self.maxWater
  elseif type == ResourceType.Electricity then
    if 0 >= self.maxElectricity then
      return 0
    end
    return self.electricity / self.maxElectricity
  elseif type == ResourceType.Metal then
    if 0 >= self.maxMetal then
      return 0
    end
    Logger.LogError(" can not get Metal percent")
    return 0
  elseif type == ResourceType.PvePoint then
    if 0 >= self.maxPvePoint then
      return 0
    end
    return self.pvePoint / self.maxPvePoint
  end
  return 0
end

function ResourceInfo:GetCntByResType(type)
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if type == ResourceType.Oil then
    return self.oil
  elseif type == ResourceType.Water then
    return self.water
  elseif type == ResourceType.Electricity then
    return self.electricity
  elseif type == ResourceType.Metal then
    return self.metal
  elseif type == ResourceType.Food then
    return self.money
  elseif type == ResourceType.PvePoint then
    return self.pvePoint
  elseif type == ResourceType.Wood then
    return self.wood
  elseif type == ResourceType.People then
    return self.people
  elseif type == ResourceType.BatteryPower then
    return DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
  elseif type == ResourceType.OBSIDIAN then
    return self.obsidian
  elseif type == ResourceType.FLINT then
    local reduce = DataCenter.ResourceReduceCalcMamanger:GetReduceValue(ResourceType.FLINT)
    local value = self.flint - reduce
    return 0 < value and value or 0
  elseif type == ResourceType.Gold then
    return LuaEntry.Player.gold or 0
  elseif type == ResourceType.AlliancePoint then
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if baseData ~= nil then
      return baseData.accPoint or 0
    end
  elseif type == ResourceType.DragonPoint then
    return LuaEntry.Resource.honorScore or 0
  elseif type == ResourceType.ResistancePoint then
    return SeasonUtil.GetSelfSeasonResistanceValue() or 0
  elseif type == ResourceType.Petroleum then
    return self.petroleum or 0
  elseif type == ResourceType.AllianceStone then
    if allianceData then
      return toInt(allianceData.resStone)
    end
  elseif type == ResourceType.AllianceFarmerExp then
    if allianceData then
      return toInt(allianceData.resFarmerExp)
    end
  elseif type == ResourceType.AllianceFarmerExpItem then
    local cfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    if cfg and cfg.resource_item then
      return DataCenter.ItemData:GetItemCount(toInt(cfg.resource_item)) or 0
    end
  elseif type == ResourceType.AllianceCoal and allianceData then
    local seasonType = SeasonUtil.GetSeasonType()
    local count = toInt(allianceData.resCoal)
    if seasonType ~= SeasonMapType.Snow then
      return count
    end
    local info = DataCenter.AllianceMineManager:GetAllianceStoveCenterStatus()
    if info and info.endTime ~= nil and info.endTime ~= 0 and info.state ~= 0 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if (info.state == 1 or info.state == 2) and curTime >= info.endTime then
        return 0
      end
      local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
      if theStoveCenter ~= nil then
        local level = toInt(theStoveCenter.level)
        local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + BuildingTypes.SEASON_STOVE_CENTER)
        if meta then
          if info.state == 1 then
            count = math.ceil(meta.coal_normal * (info.endTime - curTime) * 0.001 / 60)
          elseif info.state == 2 then
            count = math.ceil(meta.coal_overload * (info.endTime - curTime) * 0.001 / 60)
          end
        end
      end
    end
    return count
  end
  return 0
end

function ResourceInfo:GetResAddSpeedByResType(type)
  if type == ResourceType.Oil then
    return self.oilAddSpeed
  elseif type == ResourceType.Water then
    return self.waterAddSpeed
  elseif type == ResourceType.Electricity then
    return LuaEntry.Effect:GetGameEffect(EffectDefine.ELECTRICITY_SPEED)
  elseif type == ResourceType.Metal then
    return self.metalAddSpeed
  end
  return 0
end

function ResourceInfo:ChangeNum(resourceType, num)
  if resourceType == ResourceType.Oil then
    self.oil = self.oil + num
  elseif resourceType == ResourceType.Water then
    self.water = self.water + num
  elseif resourceType == ResourceType.OBSIDIAN then
    self.obsidian = self.obsidian + num
  elseif resourceType == ResourceType.FLINT then
    self.flint = self.flint + num
  elseif resourceType == ResourceType.Electricity then
    self.electricity = self.electricity + num
  elseif resourceType == ResourceType.Metal then
    self.metal = self.metal + num
  elseif resourceType == ResourceType.Food then
    self.money = self.money + num
  elseif resourceType == ResourceType.PvePoint then
    self.pvePoint = self.pvePoint + num
  elseif resourceType == ResourceType.Wood then
    self.wood = self.wood + num
  elseif resourceType == ResourceType.People then
    self.people = self.people + num
  elseif resourceType == ResourceType.Petroleum then
    self.petroleum = self.petroleum + num
  end
end

function ResourceInfo.GetHonorScore()
  return LuaEntry.Resource.honorScore
end

return ResourceInfo
