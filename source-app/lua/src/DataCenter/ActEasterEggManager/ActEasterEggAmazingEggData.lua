local ActEasterEggAmazingEggData = BaseClass("ActEasterEggAmazingEggData")

function ActEasterEggAmazingEggData:__init()
  self:AddListener()
  self.gradeArr = {}
  self.curQuality = 0
  self.multiple = 0
  self.receive = -1
  self.time = 0
  self.uuid = ""
end

function ActEasterEggAmazingEggData:__delete()
  self:RemoveListener()
  self.gradeArr = nil
  self.curQuality = nil
  self.multiple = nil
  self.receive = nil
  self.time = nil
  self.uuid = nil
end

function ActEasterEggAmazingEggData:AddListener()
end

function ActEasterEggAmazingEggData:RemoveListener()
end

function ActEasterEggAmazingEggData:ParseEggInfo(eggInfo)
  self.gradeArr = eggInfo.gradeArr
  self.curQuality = eggInfo.curQuality
  self.multiple = eggInfo.multiple
  self.receive = eggInfo.receive
  self.time = eggInfo.time
  self.uuid = eggInfo.uuid
end

function ActEasterEggAmazingEggData:GetUpgradeItemInfo()
  local configData = DataCenter.ActEasterEggManager:GetEggConfigData()
  if not configData then
    Logger.LogError("config is nil")
    return
  end
  local upgradeTimes = configData.amazingUpgradeTimes
  local result = {}
  local gradeArr = self.gradeArr
  if self.gradeArr == nil then
    return result
  end
  for k = 1, upgradeTimes do
    local value = gradeArr[k] or 0
    table.insert(result, value)
  end
  return result
end

return ActEasterEggAmazingEggData
