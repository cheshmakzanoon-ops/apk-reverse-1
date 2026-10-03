local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {
    "number",
    "behaviourId"
  }
}

function behaviour:Begin()
  if self.behaviourId == SeasonTowerConfig.GuideData.BehaviourId.OpenMain then
    DataCenter.LWSeasonTowerManager:EnterScene()
  elseif self.behaviourId == SeasonTowerConfig.GuideData.BehaviourId.OpenIntroduction then
    DataCenter.LWSeasonTowerManager:OpenIntroduction()
  elseif self.behaviourId == SeasonTowerConfig.GuideData.BehaviourId.OpenRule then
    DataCenter.LWSeasonTowerManager:OpenRule()
  elseif self.behaviourId == SeasonTowerConfig.GuideData.BehaviourId.ShowTile then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_ALERTTOWER)
    if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
      GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_ALERTTOWER)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_ALERTTOWER, WorldTileBtnType.SeasonTowerEntrance)
    end
  elseif self.behaviourId == SeasonTowerConfig.GuideData.BehaviourId.ShowTips1 then
  elseif self.behaviourId == SeasonTowerConfig.GuideData.BehaviourId.ShowTips2 then
    EventManager:GetInstance():Broadcast(EventId.SeasonTowerShowGuideTips, {
      state = true,
      key = "season_tower_guide_tips1"
    })
  end
  self.done = true
end

function behaviour:End()
end

return behaviour
