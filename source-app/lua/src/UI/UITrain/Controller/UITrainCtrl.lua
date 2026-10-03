local UITrainCtrl = BaseClass("UITrainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UITrain)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetUpgradData(self, buildId, fromArmyId)
  if buildId == nil then
    return nil
  end
  local param = {}
  param.minTrain = 1
  param.buildId = buildId
  param.isUpgrading = false
  param.extra = nil
  param.goldImage = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId)
  local queue = DataCenter.ArmyManager:GetArmyQueue(queueType)
  if queue ~= nil then
    local tempList = string.split(queue.itemId, ";")
    if queue:GetQueueState() == NewQueueState.Work and tempList ~= nil and 3 < #tempList then
      param.isUpgrading = true
      fromArmyId = tempList[3]
      local toArmyId = tempList[1]
      param.armyId = fromArmyId
      param.armyMaxId = toArmyId
    end
  end
  if fromArmyId == nil then
    return nil
  end
  if param.armyId == nil then
    param.armyId = fromArmyId
    param.armyMaxId = DataCenter.ArmyManager:GetMaxUpgradeId(fromArmyId, buildId)
  end
  local army = DataCenter.ArmyManager:FindArmy(fromArmyId)
  if army == nil then
    param.free = 0
  else
    param.free = army.free
  end
  local curArmyTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(fromArmyId)
  param.maxTrain = curArmyTemplate:GetMaxTrainValue()
  return param
end

UITrainCtrl.CloseSelf = CloseSelf
UITrainCtrl.Close = Close
UITrainCtrl.GetUpgradData = GetUpgradData
return UITrainCtrl
