local Chapter2CameraMoveScene = BaseClass("Chapter2CameraMoveScene")

function Chapter2CameraMoveScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function Chapter2CameraMoveScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function Chapter2CameraMoveScene:ComponentDefine()
end

function Chapter2CameraMoveScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function Chapter2CameraMoveScene:DataDefine()
  self.param = nil
end

function Chapter2CameraMoveScene:DataDestroy()
  self.param = nil
end

function Chapter2CameraMoveScene:ReInit(param)
  self.param = param
  self.transform.position = SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos)
end

function Chapter2CameraMoveScene:ChangeParam(param)
  self:ReInit(param)
end

return Chapter2CameraMoveScene
