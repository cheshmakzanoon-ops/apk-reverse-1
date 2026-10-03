local ActEasterEggUpgradeAmazingEggData = BaseClass("ActEasterEggUpgradeAmazingEggData")
local ActEasterEggAmazingEggData = require("DataCenter.ActEasterEggManager.ActEasterEggAmazingEggData")

function ActEasterEggUpgradeAmazingEggData:__init()
  self.activityId = 0
  self.upFlag = -1
  self.doubleFlag = -1
  self.amazingEggInfo = nil
  self.reward = nil
end

function ActEasterEggUpgradeAmazingEggData:__delete()
  self.activityId = nil
  self.upFlag = nil
  self.doubleFlag = nil
  self.amazingEggInfo = nil
  self.reward = nil
end

function ActEasterEggUpgradeAmazingEggData:ParseUpgradeInfo(message)
  self.activityId = message.activityId
  self.upFlag = message.upFlag
  self.doubleFlag = message.doubleFlag
  local amazingEggInfo = ActEasterEggAmazingEggData.New()
  amazingEggInfo:ParseEggInfo(message.amazingEggInfo)
  self.amazingEggInfo = amazingEggInfo
  self.reward = message.reward
end

function ActEasterEggUpgradeAmazingEggData:IsDouble()
  return self.doubleFlag == 1
end

function ActEasterEggUpgradeAmazingEggData:IsUpgradeSuccess()
  return self.upFlag == 1
end

function ActEasterEggUpgradeAmazingEggData:GetUpgradeItemInfo()
  if not self.amazingEggInfo then
    return
  end
  return self.amazingEggInfo:GetUpgradeItemInfo()
end

function ActEasterEggUpgradeAmazingEggData:GetCurQuality()
  return self.amazingEggInfo.curQuality
end

return ActEasterEggUpgradeAmazingEggData
