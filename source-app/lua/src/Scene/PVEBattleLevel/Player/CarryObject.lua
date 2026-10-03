local Resource = CS.GameEntry.Resource
local Const = require("Scene.PVEBattleLevel.Const")
local InitRotation = Quaternion.Euler(-93, 90, 0)
local CarryObject = BaseClass("CarryObject")

function CarryObject:__init(player)
  self.player = player
  self.param = {}
  self.createFlyParam = nil
end

function CarryObject:__delete()
  self.param = {}
  self.createFlyParam = nil
end

function CarryObject:ReInit(param)
  self.param = param
  self.createFlyParam = nil
end

function CarryObject:Create()
  self.carryInst = Resource:InstantiateAsync(Const.GarbageRewardPath[self.param.resType])
  self.carryInst:completed("+", function(req)
    local transform = req.gameObject.transform
    transform:SetParent(self.player:GetCarryRoot())
    transform.localPosition = self.param.localPos
    transform.localRotation = InitRotation
    transform.localScale = Vector3.one
    self.transform = transform
    local anim = transform:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
    if anim ~= nil then
      anim:Play("V_soldie_shxr_rock", -1, 0)
    end
    self:SetVisible(self.param.visible)
    if self.createFlyParam ~= nil then
      self:FlyOut(self.createFlyParam.targetPos, self.createFlyParam.onComplete)
    end
  end)
end

function CarryObject:Destroy()
  if self.carryInst ~= nil then
    self.carryInst:Destroy()
    self.carryInst = nil
  end
end

function CarryObject:GetType()
  return self.param.resType
end

function CarryObject:GetPosRot()
  return self.transform.position, self.transform.rotation
end

function CarryObject:SetLocalPos(localPos)
  if self.param.localPos.x ~= localPos.x or self.param.localPos.y ~= localPos.y or self.param.localPos.z ~= localPos.z then
    self.param.localPos = localPos
    if self.transform ~= nil then
      self.transform.localPosition = localPos
    end
  end
end

function CarryObject:FlyOut(targetPos, onComplete)
  self.createFlyParam = {}
  self.createFlyParam.targetPos = targetPos
  self.createFlyParam.onComplete = onComplete
  if self.carryInst == nil then
    self:Create()
  else
    if self.transform ~= nil then
      self.transform:SetParent(nil)
    else
      self:Destroy()
      return
    end
    local srcPos = self.transform.position
    local fly = self.transform:GetComponent(typeof(CS.UIGoodsFly))
    if fly then
      fly:DoAnim(3, -3, targetPos, srcPos, onComplete)
    end
  end
end

function CarryObject:SetVisible(visible)
  self.param.visible = visible
  if self.transform ~= nil then
    self.transform.gameObject:SetActive(visible)
  end
end

return CarryObject
