local CommonEquipInfo = BaseClass("CommonEquipInfo")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.ownerUid = ""
  self.num = 0
  self.uuid = 0
  self.slot = 0
  self.cfgId = 0
  self.config = nil
  self.exp = 0
  self.upgradePercent = 0
end

local function __delete(self)
  self.ownerUid = nil
  self.num = nil
  self.uuid = nil
  self.slot = nil
  self.cfgId = nil
  self.config = nil
  self.exp = nil
end

local function UpdateInfo(self, data)
  if not data then
    return
  end
  if data.wearTargetId then
    self.ownerUid = data.wearTargetId
  end
  if data.num then
    self.num = data.num
  end
  if data.equipUid then
    self.uuid = data.equipUid
  end
  if data.slot then
    self.slot = data.slot
  end
  if data.exp then
    self.exp = data.exp
  end
  if data.cfgId then
    self.cfgId = data.cfgId
    self.config = DataCenter.CommonEquipTemplateManager:GetTemplate(self.cfgId)
    if self.exp and self.config then
      self.upgradePercent = self.exp / self.config.upgrade_value
    end
  end
end

local function IsBeingWeared(self)
  return self.slot > 0 and not string.IsNullOrEmpty(self.ownerUid)
end

local function GetConfigSlot(self)
  if self.config then
    return self.config.slot
  else
    return 0
  end
end

local function GetConfigType(self)
  if self.config then
    return self.config.type
  else
    return CommonEquipType.None
  end
end

local function GetConfigLevel(self)
  if self.config then
    return self.config.level
  else
    return 0
  end
end

local function GetEffects(self)
  if self.config then
    return self.config.baseEffect
  else
    return nil
  end
end

local function GetConfigQuality(self)
  if self.config then
    return self.config.quality
  else
    return 0
  end
end

local function GetConfigIcon(self)
  if self.config then
    return string.format(LoadPath.ItemPath, self.config.icon)
  else
    return ""
  end
end

local function GetConfigName(self)
  if self.config then
    return Localization:GetString(self.config.name)
  else
    return ""
  end
end

local function GetPower(self)
  if self.config then
    if self.exp == 0 then
      return self.config.power
    else
      local power = DataCenter.CommonEquipDataManager:GetPowerByPercent(self.config.power, self.config.lv_group, self.upgradePercent)
      return power
    end
  else
    return 0
  end
end

local function GetCanUpgrade(self)
  if self.config then
    return self.config.target_id > 0
  else
    return false
  end
end

function CommonEquipInfo:IsMax()
  if self.config then
    return self.config:IsMax()
  else
    return false
  end
end

local function GetUpgrdaeCost(self)
  if self.config then
    return self.config:GetUpgradeCost()
  else
    return nil
  end
end

function CommonEquipInfo:GetNextLvConfig()
  if self.config == nil then
    return
  end
  if not self:GetCanUpgrade() then
    return
  end
  local next = DataCenter.CommonEquipTemplateManager:GetTemplate(self.config.target_id)
  return next
end

function CommonEquipInfo:GetNextLvEquipInfo()
  return CommonEquipInfo.CreateByTemplate(self:GetNextLvConfig())
end

function CommonEquipInfo.CreateByTemplate(config, num)
  if config == nil then
    return
  end
  local equipData = CommonEquipInfo.New()
  equipData.cfgId = config.id
  equipData.config = config
  equipData.num = num or 1
  equipData.slot = 0
  return equipData
end

function CommonEquipInfo:IsOpenExpUpgrade()
  if self.config == nil then
    return
  end
  return self.config.upgrade_switch == 1
end

CommonEquipInfo.__init = __init
CommonEquipInfo.__delete = __delete
CommonEquipInfo.UpdateInfo = UpdateInfo
CommonEquipInfo.IsBeingWeared = IsBeingWeared
CommonEquipInfo.GetConfigSlot = GetConfigSlot
CommonEquipInfo.GetConfigType = GetConfigType
CommonEquipInfo.GetConfigLevel = GetConfigLevel
CommonEquipInfo.GetEffects = GetEffects
CommonEquipInfo.GetConfigQuality = GetConfigQuality
CommonEquipInfo.GetConfigIcon = GetConfigIcon
CommonEquipInfo.GetConfigName = GetConfigName
CommonEquipInfo.GetPower = GetPower
CommonEquipInfo.GetCanUpgrade = GetCanUpgrade
CommonEquipInfo.GetUpgrdaeCost = GetUpgrdaeCost
return CommonEquipInfo
