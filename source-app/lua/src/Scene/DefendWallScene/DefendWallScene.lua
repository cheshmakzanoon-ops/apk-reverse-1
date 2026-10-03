local DefendWallScene = BaseClass("DefendWallScene")

function DefendWallScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function DefendWallScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function DefendWallScene:ComponentDefine()
end

function DefendWallScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function DefendWallScene:DataDefine()
  self.param = nil
end

function DefendWallScene:DataDestroy()
  self.param = nil
end

function DefendWallScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
end

function DefendWallScene:ChangeParam(param)
  self:ReInit(param)
end

return DefendWallScene
