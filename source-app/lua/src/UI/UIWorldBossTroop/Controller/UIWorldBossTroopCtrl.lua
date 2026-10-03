local UIWorldBossTroopCtrl = BaseClass("UIWorldBossTroopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldBossTroop)
end

local function GetMarchInfoList(self)
  local showList = {}
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local dataList = DataCenter.ActBossDataManager:GetActBossDataList()
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
    oneData.serverId = v.serverId
    oneData.distance = 0
    local distance = Vector3.Distance(SceneUtils.TileIndexToWorld(oneData.startPos, ForceChangeScene.World, oneData.serverId), SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos, ForceChangeScene.World, loginServerId))
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

UIWorldBossTroopCtrl.CloseSelf = CloseSelf
UIWorldBossTroopCtrl.GetMarchInfoList = GetMarchInfoList
return UIWorldBossTroopCtrl
