local T11EquipGroupData = BaseClass("T11EquipGroupData")
local T11EquipData = require("DataCenter.T11DataManager.T11EquipData")

local function __init(self)
  self.curStage = nil
  self.allEquipDataList = {}
  self.allEquipDataDic = {}
end

local function __delete(self)
  self.curStage = nil
  self.allEquipDataList = nil
  self.allEquipDataDic = nil
end

function T11EquipGroupData:UpdateData(stage)
  if self.curStage ~= stage then
    self.allEquipDataList = {}
    self.allEquipDataDic = {}
  end
  self.curStage = stage
  self:UpdateAllEquipData()
end

function T11EquipGroupData:UpdateAllEquipData()
  local allEquipTmpIdList = DataCenter.T11DataManager:GetCurStageAllEquipIdList(self.curStage)
  for _, equipId in pairs(allEquipTmpIdList) do
    local equipData = self.allEquipDataDic[equipId]
    if not equipData then
      equipData = T11EquipData.New()
      self.allEquipDataDic[equipId] = equipData
      table.insert(self.allEquipDataList, equipData)
    end
    equipData:UpdateData(equipId)
  end
end

function T11EquipGroupData:GetAllEquipDataList()
  return self.allEquipDataList
end

function T11EquipGroupData:GetEquipDataById(equipId)
  if not self.allEquipDataDic then
    return nil
  end
  return self.allEquipDataDic[equipId]
end

T11EquipGroupData.__init = __init
T11EquipGroupData.__delete = __delete
return T11EquipGroupData
