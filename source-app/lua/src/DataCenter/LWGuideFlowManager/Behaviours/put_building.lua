local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local parser = require("DataCenter.LWGuideFlowManager.LWGuideFlowParamParser")
behaviour.params = {
  {"number", "buildingId"}
}

function behaviour:Begin()
  if self.buildingId == nil or self.buildingId <= 0 then
    self:LogError("buildingId is empty")
    return
  end
  local state = DataCenter.BuildManager:GetBuildState(self.buildingId)
  if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
    GoToUtil.CloseAllWindows()
    local world = CS.SceneManager.World
    if world ~= nil then
      local point = BuildingUtils.GetPointByBuildCanPut(self.buildingId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      BuildingUtils.ShowPutBuild(self.buildingId, PlaceBuildType.Build, 0, point, nil, nil)
    else
      Logger.LogInfo("put_building can not build, world is nil")
    end
  else
    Logger.LogInfo("put_building can not build, state: " .. tostring(state))
  end
  self.done = true
end

return behaviour
