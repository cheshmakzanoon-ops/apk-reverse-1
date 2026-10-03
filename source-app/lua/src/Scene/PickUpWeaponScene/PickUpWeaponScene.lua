local PickUpWeaponScene = BaseClass("PickUpWeaponScene")

function PickUpWeaponScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function PickUpWeaponScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PickUpWeaponScene:ComponentDefine()
end

function PickUpWeaponScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function PickUpWeaponScene:DataDefine()
  self.param = nil
end

function PickUpWeaponScene:DataDestroy()
  self.param = nil
end

function PickUpWeaponScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
end

return PickUpWeaponScene
