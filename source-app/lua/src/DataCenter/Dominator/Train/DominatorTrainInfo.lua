local DominatorTrainInfo = BaseClass("DominatorTrainInfo")

function DominatorTrainInfo:__init()
  self.groupId = 0
  self.level = 0
end

function DominatorTrainInfo:__delete()
  self.groupId = nil
  self.level = nil
end

function DominatorTrainInfo:UpdateInfo(groupId, level)
  if groupId then
    self.groupId = groupId
  end
  if level then
    self.level = level
  end
end

function DominatorTrainInfo:IsDataValid()
  return true
end

function DominatorTrainInfo:GetGroupId()
  return self.groupId
end

function DominatorTrainInfo:GetGroupTemplate()
  return DataCenter.DominatorTemplateManager:GetTrainGroupTemplateById(self.groupId)
end

function DominatorTrainInfo:GetCurLevel()
  return self.level
end

function DominatorTrainInfo:GetCurLevelId()
  return self.groupId + self.level
end

function DominatorTrainInfo:GetCurLevelTemplate()
  return DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(self:GetCurLevelId())
end

function DominatorTrainInfo:IsMaxLevel()
  local curLevelTemplate = self:GetCurLevelTemplate()
  if curLevelTemplate then
    return curLevelTemplate:IsMaxLevel()
  end
  return false
end

function DominatorTrainInfo:IsCanUpgrade()
  if self:IsMaxLevel() then
    return false
  end
  local curLevelTemplate = self:GetCurLevelTemplate()
  if curLevelTemplate then
    if not curLevelTemplate:IsRequireOK() then
      return false
    end
    local costInfo = curLevelTemplate:GetUpgradeCostInfo()
    local isItemEnough = true
    for i, v in pairs(costInfo) do
      local haveCount = DataCenter.ItemData:GetItemCount(v.itemId)
      if haveCount < v.count then
        isItemEnough = false
        break
      end
    end
    return isItemEnough
  end
  return false
end

return DominatorTrainInfo
