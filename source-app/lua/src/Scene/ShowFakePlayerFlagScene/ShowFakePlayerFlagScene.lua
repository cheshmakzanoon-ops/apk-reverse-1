local ShowFakePlayerFlagScene = BaseClass("ShowFakePlayerFlagScene")
local MoveDistance = 200

function ShowFakePlayerFlagScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function ShowFakePlayerFlagScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function ShowFakePlayerFlagScene:ComponentDefine()
end

function ShowFakePlayerFlagScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function ShowFakePlayerFlagScene:DataDefine()
  self.param = nil
end

function ShowFakePlayerFlagScene:DataDestroy()
  self.param = nil
end

function ShowFakePlayerFlagScene:ReInit(param)
  self.param = param
  DataCenter.GuideManager:DoNext()
  self.transform.position = self.param.pos
end

return ShowFakePlayerFlagScene
