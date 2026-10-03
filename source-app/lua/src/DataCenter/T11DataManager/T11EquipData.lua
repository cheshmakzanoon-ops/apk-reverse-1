local T11EquipData = BaseClass("T11EquipData")
local T11EquipTemplate = require("DataCenter.T11DataManager.Template.T11EquipTemplate")

local function __init(self)
  self.equipId = 0
  self.equipTmp = nil
  self.curEquipState = T11EquipUpgradeState.NotUnLock
end

local function __delete(self)
  self.equipId = nil
  self.equipTmp = nil
  self.curEquipState = nil
end

function T11EquipData:UpdateData(equipId)
  self.equipId = equipId
  local upgradeLine = LocalController:instance():getLine(TableName.T11_Equip_Config, equipId)
  self.equipTmp = T11EquipTemplate.New()
  self.equipTmp:UpdateData(upgradeLine)
  self.stage = self.equipTmp.stage
  self.type = self.equipTmp.type
  self:UpdateUnlockState()
end

function T11EquipData:UpdateUnlockState()
  if T11Util.IsMaxExp() then
    self.curEquipState = T11EquipUpgradeState.Unlocked
    return
  end
  local curUpgradeEquipId, progress = T11Util.GetCurUpgradeEquipIdAndProgress()
  if self.equipId == curUpgradeEquipId then
    self.curEquipState = T11EquipUpgradeState.Upgrading
    self.curUpgradeProgress = progress
    T11Util.ShowLog("EquipId: " .. self.equipId .. " is Upgrading State.")
  elseif curUpgradeEquipId > self.equipId then
    self.curEquipState = T11EquipUpgradeState.Unlocked
    self.curUpgradeProgress = 100
    T11Util.ShowLog("EquipId: " .. self.equipId .. " is Unlocked State.")
  else
    self.curEquipState = T11EquipUpgradeState.NotUnLock
    self.curUpgradeProgress = 0
    T11Util.ShowLog("EquipId: " .. self.equipId .. " is NotUnLock State.")
  end
end

function T11EquipData:GetEquipState()
  return self.curEquipState
end

function T11EquipData:GetCurEquipUpgradeProgress()
  return self.curUpgradeProgress
end

function T11EquipData:GetCurStage()
  return self.stage
end

function T11EquipData:GetEquipId()
  return self.equipId
end

function T11EquipData:GetEquipNameKey()
  return self.equipTmp.name
end

function T11EquipData:GetEquipModelName()
  return self.equipTmp.model
end

T11EquipData.__init = __init
T11EquipData.__delete = __delete
return T11EquipData
