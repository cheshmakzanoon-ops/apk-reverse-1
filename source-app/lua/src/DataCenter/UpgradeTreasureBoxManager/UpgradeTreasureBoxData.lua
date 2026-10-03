local UpgradeTreasureBoxData = BaseClass("UpgradeTreasureBoxData")

function UpgradeTreasureBoxData:__init()
  self.initQuality = 0
  self.uid = ""
  self.origin = 0
  self.progress = {}
  self.state = 0
  self.uuid = 0
  self.group = 0
  self.quality = 0
  self.confId = 0
  self.activityId = 0
  self.auto = 0
end

function UpgradeTreasureBoxData:__delete()
  self.initQuality = nil
  self.uid = nil
  self.origin = nil
  self.progress = nil
  self.state = nil
  self.uuid = nil
  self.group = nil
  self.quality = nil
  self.confId = nil
  self.activityId = nil
  self.auto = nil
end

function UpgradeTreasureBoxData:ParseInfo(boxUpgradeInfo)
  if boxUpgradeInfo == nil then
    Logger.LogError("boxUpgradeInfo is nil")
    return
  end
  self.initQuality = boxUpgradeInfo.initQuality or 0
  self.uid = boxUpgradeInfo.uid or ""
  self.origin = boxUpgradeInfo.origin or 0
  self.progress = boxUpgradeInfo.progress or {}
  self.state = boxUpgradeInfo.state or 0
  self.uuid = boxUpgradeInfo.uuid or 0
  self.group = boxUpgradeInfo.group or 0
  self.quality = boxUpgradeInfo.quality or 0
  self.confId = boxUpgradeInfo.confId or 0
  local extra = boxUpgradeInfo.extra
  if extra then
    self.activityId = extra.activityId or 0
    self.auto = extra.auto or 1
  end
  self:ModifyProgress()
end

function UpgradeTreasureBoxData:GetMaxUpgradeTimes()
  if not self.progress then
    return 0
  end
  return #self.progress
end

function UpgradeTreasureBoxData:GetLastNotRedProgress()
  local result = 1
  if not self.progress then
    return result
  end
  for i = #self.progress, 1, -1 do
    if self.progress[i] ~= UpgradeTreasureBoxQuality.Red then
      result = self.progress[i]
      break
    end
  end
  return result
end

function UpgradeTreasureBoxData:IsAuto()
  return self.auto == 1
end

function UpgradeTreasureBoxData:GetUuid()
  return self.uuid
end

function UpgradeTreasureBoxData:ModifyProgress()
  if not self.progress then
    Logger.LogError("UpgradeTreasureBoxData:ModifyProgress progress is nil")
    return
  end
  if #self.progress == 0 then
    Logger.LogError("UpgradeTreasureBoxData:ModifyProgress progress is empty")
    return
  end
  local length = #self.progress
  if self.progress[length] == UpgradeTreasureBoxQuality.Red and self.progress[length - 1] == UpgradeTreasureBoxQuality.Red then
    self.progress[length - 1] = UpgradeTreasureBoxQuality.Orange
  end
end

return UpgradeTreasureBoxData
