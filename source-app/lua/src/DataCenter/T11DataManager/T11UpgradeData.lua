local T11UpgradeData = BaseClass("T11UpgradeData")
local T11UpgradeTemplate = require("DataCenter.T11DataManager.Template.T11UpgradeTemplate")

local function __init(self)
  self.curUpgradeTmp = nil
  self.nextUpgradeTmp = nil
  self.upgradeTmpDic = {}
  self.curAttrInfo = {}
end

local function __delete(self)
  self.curUpgradeTmp = nil
  self.nextUpgradeTmp = nil
  self.upgradeTmpDic = nil
  self.curAttrInfo = nil
end

function T11UpgradeData:UpdateData(curProgressId)
  if 0 < curProgressId then
    self.curUpgradeTmp = self:GetUpgradeTmpByProgressId(curProgressId)
    self.curAttrInfo = self.curUpgradeTmp.attr_add
  else
    self.curUpgradeTmp = nil
    self.curAttrInfo = {}
  end
  T11Util.ShowLog("T11UpgradeData:UpdateData curUpgradeId:" .. curProgressId)
  if not self:IsMaxExp() then
    local nextUpgradeProgressId = self.curUpgradeTmp and self.curUpgradeTmp.next_id or self:GetFirstUpgradeTmpId()
    self.nextUpgradeTmp = self:GetUpgradeTmpByProgressId(nextUpgradeProgressId)
    T11Util.ShowLog("T11UpgradeData:UpdateData nextUpgradeId:" .. nextUpgradeProgressId)
  else
    self.nextUpgradeTmp = nil
    T11Util.ShowLog("arrive max exp")
  end
  if self.curUpgradeTmp and self.nextUpgradeTmp then
    local isChangeEquip = self.curUpgradeTmp.type ~= self.nextUpgradeTmp.type
    local isUpgradeStage = self.curUpgradeTmp.stage ~= self.nextUpgradeTmp.stage
    if isChangeEquip or isUpgradeStage then
      self.curUpgradeTmp = nil
    end
  end
end

function T11UpgradeData:GetCurUpgradeProgressId()
  if not self.curUpgradeTmp then
    T11Util.ShowLog("T11UpgradeData:GetCurUpgradeProgressId curUpgradeTmp is nil")
    return -1
  end
  return self.curUpgradeTmp.id
end

function T11UpgradeData:GetNextUpgradeProgressId()
  if not self.nextUpgradeTmp then
    T11Util.ShowLog("T11UpgradeData:GetNextUpgradeProgressId nextUpgradeTmp is nil")
    return -1
  end
  return self.nextUpgradeTmp.id
end

function T11UpgradeData:GetNextUpgradeCostData()
  if not self.nextUpgradeTmp then
    T11Util.ShowLog("T11UpgradeData:GetNextUpgradeCostData nextUpgradeTmp is nil")
    return -1
  end
  return self.nextUpgradeTmp:GetCostDataAfterParse()
end

function T11UpgradeData:GetCurUpgradeEquipId()
  return self.nextUpgradeTmp and self.nextUpgradeTmp.type or -1
end

function T11UpgradeData:GetCurUpgradeProgressVal()
  if not self.curUpgradeTmp then
    return 0
  end
  return self.curUpgradeTmp.progress or 0
end

function T11UpgradeData:GetCurUpgradeTmp()
  return self.curUpgradeTmp
end

function T11UpgradeData:GetNextUpgradeTmp()
  return self.nextUpgradeTmp
end

function T11UpgradeData:GetFirstUpgradeTmpId()
  local firstProgressId = LuaEntry.DataConfig:TryGetNum("soldier_eleven_param", "k4")
  return firstProgressId
end

function T11UpgradeData:IsMaxExp()
  return self.curUpgradeTmp and (not self.curUpgradeTmp.next_id or self.curUpgradeTmp.next_id <= 0)
end

function T11UpgradeData:IsInBreakStageState()
  if self:IsMaxExp() then
    return true
  end
  local curStage = T11Util.GetCurStage()
  if self.nextUpgradeTmp then
    return curStage < self.nextUpgradeTmp.stage
  end
  return false
end

function T11UpgradeData:GetUpgradeTmpByProgressId(progressId)
  if not table.containsKey(self.upgradeTmpDic, progressId) then
    local curUpgradeLine = LocalController:instance():getLine(TableName.T11_Upgrade_Config, progressId)
    if curUpgradeLine then
      local upgradeTmp = T11UpgradeTemplate.New()
      upgradeTmp:UpdateData(curUpgradeLine)
      self.upgradeTmpDic[progressId] = upgradeTmp
    end
  end
  return self.upgradeTmpDic[progressId]
end

function T11UpgradeData:GetCurAttrInfo()
  return self.curAttrInfo
end

T11UpgradeData.__init = __init
T11UpgradeData.__delete = __delete
return T11UpgradeData
