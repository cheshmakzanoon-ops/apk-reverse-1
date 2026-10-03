local UIHeroEquipListPanelCtrl = BaseClass("UIHeroEquipListPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipListPanel)
end

local function GetAllEquipDataList(heroData, slotType)
  local equipDataList = DataCenter.EquipDataManager:GetAllEquipListBySlotTypeAndHeroType(slotType, heroData.heroType, true)
  if equipDataList == nil then
    return {}
  end
  local curEquipDataId
  for k, v in pairs(equipDataList) do
    if v.heroUuid == heroData.uuid then
      equipDataList[k] = nil
      curEquipDataId = v.uuid
    end
  end
  local equipDataArray = {}
  for k, v in pairs(equipDataList) do
    table.insert(equipDataArray, k)
  end
  table.sort(equipDataArray, function(a, b)
    local equipA = DataCenter.EquipDataManager:GetEquipByUuid(a)
    local equipB = DataCenter.EquipDataManager:GetEquipByUuid(b)
    if equipA.level ~= equipB.level then
      return equipA.level > equipB.level
    end
    if equipA.quality ~= equipB.quality then
      return equipA.quality > equipB.quality
    end
    if equipA.power ~= equipB.power then
      return equipA.power > equipB.power
    end
    return equipA.configId > equipB.configId
  end)
  local maxPowerFreeEquipUuid = 0
  local maxPower = 0
  for k, v in pairs(equipDataArray) do
    local e = DataCenter.EquipDataManager:GetEquipByUuid(v)
    if (e.heroUuid == nil or e.heroUuid <= 0) and maxPower < e.power then
      maxPowerFreeEquipUuid = v
      maxPower = e.power
    end
  end
  return equipDataArray, curEquipDataId, maxPowerFreeEquipUuid
end

UIHeroEquipListPanelCtrl.CloseSelf = CloseSelf
UIHeroEquipListPanelCtrl.GetAllEquipDataList = GetAllEquipDataList
return UIHeroEquipListPanelCtrl
