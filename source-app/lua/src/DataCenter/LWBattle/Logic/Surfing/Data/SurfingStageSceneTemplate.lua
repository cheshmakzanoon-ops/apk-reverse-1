local SurfingStageSceneTemplate = BaseClass("SurfingStageSceneTemplate")

function SurfingStageSceneTemplate:__init()
  self.id = nil
  self.sceneIds = nil
  self.sceneExt = nil
  self.farmMonster = nil
  self.speedZ = nil
  self.max_meters = nil
end

function SurfingStageSceneTemplate:__delete()
  self.id = nil
  self.sceneIds = nil
  self.sceneExt = nil
  self.farmMonster = nil
  self.speedZ = nil
  self.max_meters = nil
end

function SurfingStageSceneTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.sceneIds = row:getValue("scene")
  self.sceneExt = row:getValue("sceneExt")
  self.farmMonster = row:getValue("farm_monster")
  self.speedZ = row:getValue("speed_z")
  self.max_meters = row:getValue("max_meters")
end

return SurfingStageSceneTemplate
