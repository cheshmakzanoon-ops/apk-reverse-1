local LadingObject = BaseClass("LadingObject")
local Resource = CS.GameEntry.Resource
local InitRotation = Quaternion.Euler(-90, 90, 0)

function LadingObject:__init(player)
  self.player = player
  self.param = {}
  self.createFlyParam = nil
end

function LadingObject:__delete()
  self.param = {}
  self.createFlyParam = nil
end

function LadingObject:ReInit(param)
  self.param = param
  self.createFlyParam = nil
end

function LadingObject:Create()
  self.carryInst = Resource:InstantiateAsync(self.param.path)
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

function LadingObject:Destroy()
  if self.carryInst ~= nil then
    self.carryInst:Destroy()
    self.carryInst = nil
  end
end

function LadingObject:GetPosRot()
  return self.transform.position, self.transform.rotation
end

function LadingObject:SetLocalPos(localPos)
  if self.param.localPos.x ~= localPos.x or self.param.localPos.y ~= localPos.y or self.param.localPos.z ~= localPos.z then
    self.param.localPos = localPos
    if self.transform ~= nil then
      self.transform.localPosition = localPos
    end
  end
end

function LadingObject:FlyOut(targetPos, onComplete)
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
      fly:DoParabolaAnim(targetPos, srcPos, onComplete)
    end
  end
end

function LadingObject:SetVisible(visible)
  self.param.visible = visible
  if self.transform ~= nil then
    self.transform.gameObject:SetActive(visible)
  end
end

return LadingObject
