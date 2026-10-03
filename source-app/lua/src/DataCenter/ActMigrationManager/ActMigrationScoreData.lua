local ActMigrationScoreData = BaseClass("ActMigrationScoreData")

function ActMigrationScoreData:__init()
  self.score = 0
  self.heroPowerUpdateTime = 0
  self.heroPowerArray = {}
  self.weaponChipPower = 0
  self.weaponEquipPower = 0
  self.weaponLevelPower = 0
  self.buildingDecoPower = 0
  self.buildingWorkerPower = 0
  self.sciencePower = 0
  self.armyPowerUpdateTime = 0
  self.armyPowerArray = {}
end

function ActMigrationScoreData:__delete()
  self.score = 0
  self.heroPowerUpdateTime = 0
  self.heroPowerArray = {}
  self.weaponChipPower = 0
  self.weaponEquipPower = 0
  self.weaponLevelPower = 0
  self.buildingDecoPower = 0
  self.buildingWorkerPower = 0
  self.sciencePower = 0
  self.armyPowerUpdateTime = 0
  self.armyPowerArray = {}
end

function ActMigrationScoreData:ParseData(t)
  if t == nil then
    return
  end
  if t.score then
    self.score = t.score
  end
  if t.heroPowerUpdateTime then
    self.heroPowerUpdateTime = t.heroPowerUpdateTime
  end
  local heroList = t.heroPowerArray
  if heroList then
    local tmpList = {}
    for i, v in pairs(heroList) do
      table.insert(tmpList, {
        heroId = v.heroId,
        level = v.level,
        rankLv = v.rankLv,
        weaponLevel = v.weaponLevel,
        formationId = v.formationId,
        power = v.maxpower
      })
    end
    self.heroPowerArray = tmpList
  end
  if t.weaponChipPower then
    self.weaponChipPower = t.weaponChipPower
  end
  if t.weaponEquipPower then
    self.weaponEquipPower = t.weaponEquipPower
  end
  if t.weaponLevelPower then
    self.weaponLevelPower = t.weaponLevelPower
  end
  if t.buildingDecoPower then
    self.buildingDecoPower = t.buildingDecoPower
  end
  if t.buildingWorkerPower then
    self.buildingWorkerPower = t.buildingWorkerPower
  end
  if t.sciencePower then
    self.sciencePower = t.sciencePower
  end
  if t.armyPowerUpdateTime then
    self.armyPowerUpdateTime = t.armyPowerUpdateTime
  end
  local armyPowerList = t.armyPowerArray
  if armyPowerList then
    local tmpList = {}
    for _, v in pairs(armyPowerList) do
      table.insert(tmpList, {
        index = v.serialNo,
        soldierId = v.soldierId,
        number = v.number,
        power = v.power
      })
    end
    self.armyPowerArray = tmpList
  end
end

function ActMigrationScoreData:GetNameKey(type)
  local nameKey = "power_stats_21"
  if type == 1 then
    nameKey = "power_stats_21"
  elseif type == 2 then
    nameKey = "power_stats_22"
  elseif type == 3 then
    nameKey = "power_stats_23"
  elseif type == 4 then
    nameKey = "power_stats_24"
  elseif type == 5 then
    nameKey = "power_stats_25"
  end
  return nameKey
end

function ActMigrationScoreData:GetIconPath(type)
  local iconPath = ""
  if type == 1 then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbaorongyuqiang_icon.png"
  elseif type == 2 then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_wurenji_icon.png"
  elseif type == 3 then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_zhuangshi_icon.png"
  elseif type == 4 then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_shibing_icon.png"
  elseif type == 5 then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_keji_icon.png"
  end
  return iconPath
end

function ActMigrationScoreData:GetNameKeyByTypeAndIdx(sType, idx)
  local nameKey = ""
  if sType == 2 then
    if idx == 1 then
      nameKey = "power_stats_8"
    elseif idx == 2 then
      nameKey = "power_stats_9"
    elseif idx == 3 then
      nameKey = "power_stats_10"
    end
  elseif sType == 3 then
    if idx == 1 then
      nameKey = "power_stats_11"
    elseif idx == 2 then
      nameKey = "power_stats_12"
    end
  end
  return nameKey
end

function ActMigrationScoreData:GetPower(type, idx)
  local power = 0
  if type == 1 then
    local array = self.heroPowerArray or {}
    for i, v in ipairs(array) do
      power = power + (v.power or 0)
    end
  elseif type == 2 then
    if idx == 0 or idx == 1 then
      power = power + self.weaponChipPower
    end
    if idx == 0 or idx == 2 then
      power = power + self.weaponEquipPower
    end
    if idx == 0 or idx == 3 then
      power = power + self.weaponLevelPower
    end
  elseif type == 3 then
    if idx == 0 or idx == 1 then
      power = power + self.buildingDecoPower
    end
    if idx == 0 or idx == 2 then
      power = power + self.buildingWorkerPower
    end
  elseif type == 4 then
    local array = self.armyPowerArray or {}
    for _, v in ipairs(array) do
      power = power + (v.power or 0)
    end
  elseif type == 5 then
    power = power + self.sciencePower
  end
  return power
end

return ActMigrationScoreData
