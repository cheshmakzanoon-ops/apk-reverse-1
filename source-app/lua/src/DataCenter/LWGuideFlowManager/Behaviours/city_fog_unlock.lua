local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"number", "posX"},
  {"number", "posY"}
}

function behaviour:Begin()
  local cityPos = DataCenter.BuildManager.main_city_pos
  local tilePos = Vector2.New(self.posX + cityPos.x - 3, self.posY + cityPos.y + 2)
  local fogPos = SceneUtils.TileToWorld(tilePos)
  local inCity = SceneUtils.GetIsInCity()
  if inCity and DataCenter.CityZoneMgr.cityZoneFog.loadComplete then
    self.revealer = CS.FOWRevealer()
    self.revealer:Init(fogPos, Vector2.New(10.0, 10.0))
  end
  self.done = true
end

function behaviour:Clear()
  if self.revealer then
    self.revealer:OnDestroy()
    self.revealer = nil
  end
end

return behaviour
