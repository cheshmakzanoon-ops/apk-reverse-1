local PvePirateBoomScene = BaseClass("PvePirateBoomScene")

function PvePirateBoomScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function PvePirateBoomScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PvePirateBoomScene:ComponentDefine()
end

function PvePirateBoomScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function PvePirateBoomScene:DataDefine()
  self.param = nil
end

function PvePirateBoomScene:DataDestroy()
  self.param = nil
end

function PvePirateBoomScene:ReInit(param)
  self.param = param
end

function PvePirateBoomScene:ChangeParam(param)
  self:ReInit(param)
end

return PvePirateBoomScene
