local Resource = CS.GameEntry.Resource
local Const = require("Scene.CityPioneer.Const")
local InitRotation = Quaternion.Euler(-93, 90, 0)
local CityCarryObject = BaseClass("CityCarryObject")

function CityCarryObject:__init()
  self.param = {}
end

function CityCarryObject:__delete()
  self.param = {}
end

function CityCarryObject:Create(param)
  self.param = param
  self.carryInst = Resource:InstantiateAsync(Const.GarbageRewardPath[self.param.resType])
  self.carryInst:completed("+", function(req)
    local transform = req.gameObject.transform
    transform:SetParent(self.param.spaceMan:GetCarryRoot())
    transform.localPosition = self.param.localPos
    transform.localRotation = InitRotation
    transform.localScale = Vector3.one
    self.transform = transform
    local anim = transform:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
    if anim ~= nil then
      anim:Play("V_soldie_shxr_rock", -1, 0)
    end
  end)
end

function CityCarryObject:Destroy()
  if self.carryInst ~= nil then
    self.carryInst:Destroy()
  end
end

function CityCarryObject:GetType()
  return self.param.resType
end

function CityCarryObject:GetPosRot()
  return self.transform.position, self.transform.rotation
end

function CityCarryObject:SetLocalPos(localPos)
  self.param.localPos = localPos
  if self.transform ~= nil then
    self.transform.localPosition = localPos
  end
end

function CityCarryObject:FlyOut(startPos, targetPos, foward, onComplete)
  if self.transform ~= nil then
    self.transform:SetParent(nil)
  else
    self:Destroy()
    return
  end
  local srcPos = self.param.spaceMan:GetFlyPos()
  local fly = self.transform:GetComponent(typeof(CS.UIGoodsFly))
  if fly then
    fly:DoAnim(3, -3, targetPos, srcPos, onComplete)
  end
end

return CityCarryObject
