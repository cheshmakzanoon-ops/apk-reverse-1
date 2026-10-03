local ArmyTemplate = BaseClass("ArmyTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
  self.des = ""
  self.level = 0
  self.kind = ""
  self.icon = ""
  self.image = ""
  self.time = 0
  self.attack = 0
  self.defence = 0
  self.health = 0
  self.speed = 0
  self.load = 0
  self.power = 0
  self.max_train = 0
  self.needResource = {}
  self.needItem = {}
  self.attack_effect = {}
  self.defence_effect = {}
  self.health_effect = {}
  self.speed_effect = {}
  self.load_effect = {}
  self.max_train_effect = {}
  self.unlock_train_build = {}
  self.unlock_train_science = {}
  self.unlock_upgrade_build = {}
  self.unlock_upgrade_science = {}
  self.featureicon = {}
  self.featuredescription = {}
  self.treatResource = {}
  self.treat_time = 0
  self.treat_effect = {}
  self.arm = ArmType.Tank
  self.destory = 0
  self.exp = 0
  self.buildId = 0
  self.army_icon = ""
end

local function __delete(self)
  self.id = nil
  self.name = nil
  self.des = nil
  self.level = nil
  self.kind = nil
  self.icon = nil
  self.image = nil
  self.time = nil
  self.attack = nil
  self.defence = nil
  self.health = nil
  self.speed = nil
  self.load = nil
  self.power = nil
  self.max_train = nil
  self.max_train = nil
  self.needResource = nil
  self.needItem = nil
  self.attack_effect = nil
  self.defence_effect = nil
  self.health_effect = nil
  self.speed_effect = nil
  self.load_effect = nil
  self.max_train_effect = nil
  self.unlock_train_build = nil
  self.unlock_train_science = nil
  self.unlock_upgrade_build = nil
  self.unlock_upgrade_science = nil
  self.featureicon = nil
  self.featuredescription = nil
  self.treatResource = nil
  self.treat_time = nil
  self.treat_effect = nil
  self.arm = nil
  self.destory = nil
  self.exp = nil
  self.buildId = nil
  self.army_icon = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.des = row:getValue("description")
  self.level = row:getValue("level")
  self.kind = row:getValue("kind")
  self.icon = row:getValue("icon")
  self.image = row:getValue("image")
  self.time = row:getValue("time")
  self.attack = row:getValue("attack")
  self.defence = row:getValue("defence")
  self.health = row:getValue("health")
  self.speed = row:getValue("speed")
  self.load = row:getValue("load")
  self.power = row:getValue("power")
  self.destory = row:getValue("destory")
  self.max_train = row:getValue("max_train")
  self.treat_time = row:getValue("treat_time")
  self.featureicon = row:getValue("featureicon")
  self.arm = row:getValue("arm")
  self.buildId = row:getValue("buildId")
  self.army_icon = row:getValue("army_icon")
  local featuredescription = row:getValue("featuredescription")
  if featuredescription ~= nil then
    for k, v in pairs(featuredescription) do
      local param = {}
      param.diaName = k
      param.diaDes = v
      table.insert(self.featuredescription, param)
    end
  end
  self.attack_effect = row:getValue("attack_effect", "")
  self.defence_effect = row:getValue("defence_effect", "")
  self.health_effect = row:getValue("health_effect", "")
  self.speed_effect = row:getValue("speed_effect", "")
  self.load_effect = row:getValue("load_effect", "")
  self.max_train_effect = row:getValue("max_train_effect", "")
  self.treat_effect = row:getValue("treat_effect", "")
  self.exp = tonumber(row:getValue("exp"))
  local unlock_train_build = row:getValue("unlock_train_build")
  if unlock_train_build ~= nil then
    for k, v in pairs(unlock_train_build) do
      local need = {}
      need.buildId = k
      need.level = v
      table.insert(self.unlock_train_build, need)
    end
  end
  local unlock_train_science = row:getValue("unlock_train_science")
  if unlock_train_science ~= nil then
    for k, v in pairs(unlock_train_science) do
      local need = {}
      need.scienceId = k
      need.level = v
      table.insert(self.unlock_train_science, need)
    end
  end
  local unlock_upgrade_build = row:getValue("unlock_upgrade_build")
  if unlock_upgrade_build ~= nil then
    for k, v in pairs(unlock_upgrade_build) do
      local need = {}
      need.buildId = k
      need.level = v
      table.insert(self.unlock_upgrade_build, need)
    end
  end
  local unlock_upgrade_science = row:getValue("unlock_upgrade_science")
  if unlock_upgrade_science ~= nil then
    for k, v in pairs(unlock_upgrade_science) do
      local need = {}
      need.scienceId = k
      need.level = v
      table.insert(self.unlock_upgrade_science, need)
    end
  end
  local resource = row:getValue("resource_need")
  if resource ~= nil then
    for k, v in pairs(resource) do
      local need = {}
      need.resourceType = k
      need.count = v
      table.insert(self.needResource, need)
    end
  end
  local needItem = row:getValue("needItem")
  if needItem ~= nil then
    for k, v in pairs(needItem) do
      local need = {}
      need.itemId = k
      need.count = v
      table.insert(self.needItem, need)
    end
  end
  local treat_resource = row:getValue("treat_resource")
  if treat_resource ~= nil then
    for k, v in pairs(treat_resource) do
      local need = {}
      need.resourceType = k
      need.count = v
      table.insert(self.treatResource, need)
    end
  end
end

local function GetAttackAddValue(self)
  return 0
end

local function GetDefenceAddValue(self)
  return 0
end

local function GetHealthAddValue(self)
  return 0
end

local function GetSpeedValue(self)
  return self.speed
end

local function GetLoadAddValue(self)
  return 0
end

local function GetTreatValue(self)
  return LuaEntry.Effect:GetGameEffect(EffectDefine.REPAIR_SPEED_ADD)
end

local function GetTreatTime(self)
  return self.treat_time / (1 + self:GetTreatValue() / 100)
end

local function GetTreatResource(self)
  local result = {}
  for k, v in ipairs(self.treatResource) do
    local param = {}
    param.resourceType = v.resourceType
    param.count = v.count
    table.insert(result, param)
  end
  return result
end

local function GetTrainTime(self)
  local original = self.time
  local effect = self:GetTrainTimeEffect()
  if effect == nil then
    return original
  else
    local effectAdd = LuaEntry.Effect:GetGameEffect(effect) + LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_TRAIN_SPEED_ADD)
    return original / (1 + effectAdd / 100)
  end
end

local function GetMaxTrainValue(self)
  local original = self.max_train
  local effect = self:GetTrainMaxNumEffect()
  if effect == nil then
    return original
  else
    local effectAdd = LuaEntry.Effect:GetGameEffect(effect) + LuaEntry.Effect:GetGameEffect(EffectDefine.ARMY_TRAIN_MAX_ADD)
    return math.floor(original + effectAdd)
  end
end

local function GetTrainTimeEffect(self)
  if self.arm == ArmType.Tank then
    return EffectDefine.TANK_TRAIN_SPEED_ADD
  elseif self.arm == ArmType.Robot then
    return EffectDefine.ROBOT_TRAIN_SPEED_ADD
  elseif self.arm == ArmType.Plane then
    return EffectDefine.PLANE_TRAIN_SPEED_ADD
  end
end

local function GetUpgradeStateEffect(self)
  if self.arm == ArmType.Tank then
    return EffectDefine.TANK_UPGRADE_SWITCH
  elseif self.arm == ArmType.Robot then
    return EffectDefine.INFANTRY_UPGRADE_SWITCH
  elseif self.arm == ArmType.Plane then
    return EffectDefine.PLANE_UPGRADE_SWITCH
  end
end

local function GetTrainMaxNumEffect(self)
  if self.arm == ArmType.Tank then
    return EffectDefine.TANK_TRAIN_NUM_ADD
  elseif self.arm == ArmType.Robot then
    return EffectDefine.ROBOT_TRAIN_NUM_ADD
  elseif self.arm == ArmType.Plane then
    return EffectDefine.PLANE_TRAIN_NUM_ADD
  end
end

local function GetAddValueEffectName(self)
  if self.arm == ArmType.Tank then
    return "arm_1"
  elseif self.arm == ArmType.Robot then
    return "arm_2"
  elseif self.arm == ArmType.Plane then
    return "arm_3"
  end
end

ArmyTemplate.__init = __init
ArmyTemplate.__delete = __delete
ArmyTemplate.InitData = InitData
ArmyTemplate.GetAttackAddValue = GetAttackAddValue
ArmyTemplate.GetDefenceAddValue = GetDefenceAddValue
ArmyTemplate.GetHealthAddValue = GetHealthAddValue
ArmyTemplate.GetSpeedValue = GetSpeedValue
ArmyTemplate.GetLoadAddValue = GetLoadAddValue
ArmyTemplate.GetMaxTrainValue = GetMaxTrainValue
ArmyTemplate.GetTreatValue = GetTreatValue
ArmyTemplate.GetTreatTime = GetTreatTime
ArmyTemplate.GetTreatResource = GetTreatResource
ArmyTemplate.GetTrainTime = GetTrainTime
ArmyTemplate.GetTrainTimeEffect = GetTrainTimeEffect
ArmyTemplate.GetTrainMaxNumEffect = GetTrainMaxNumEffect
ArmyTemplate.GetAddValueEffectName = GetAddValueEffectName
ArmyTemplate.GetUpgradeStateEffect = GetUpgradeStateEffect
return ArmyTemplate
