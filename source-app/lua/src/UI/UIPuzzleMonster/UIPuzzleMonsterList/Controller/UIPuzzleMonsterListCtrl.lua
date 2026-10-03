local UIPuzzleMonsterListCtrl = BaseClass("UIPuzzleMonsterListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIPuzzleMonsterList)
end

local function GetMarchInfoList(self)
  local showList = {}
  local dataList = DataCenter.ActivityPuzzleDataManager:GetPuzzleMarches()
  if dataList == nil then
    return showList
  end
  for k, v in pairs(dataList) do
    local oneData = {}
    oneData.uuid = v.uuid
    oneData.monsterId = v.monsterId
    oneData.actStartTime = v.actStartTime
    oneData.actEndTime = v.actEndTime
    oneData.armyUnit = v.armyUnit
    oneData.armyHealth = v.armyHealth
    oneData.armyInitHealth = v.armyInitHealth
    oneData.startPos = v.startPos
    oneData.distance = 0
    local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(oneData.startPos), SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos))
    oneData.distance = math.max(0, distance)
    table.insert(showList, oneData)
  end
  table.sort(showList, function(a, b)
    if a.distance < b.distance then
      return true
    end
    return false
  end)
  return showList
end

UIPuzzleMonsterListCtrl.CloseSelf = CloseSelf
UIPuzzleMonsterListCtrl.GetMarchInfoList = GetMarchInfoList
return UIPuzzleMonsterListCtrl
