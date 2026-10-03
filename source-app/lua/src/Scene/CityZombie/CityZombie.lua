local CityZombie = BaseClass("CityZombie")
local Resource = CS.GameEntry.Resource

function CityZombie:__init(param)
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = param
  self.anim = nil
  self.animState = nil
  self:Create()
end

function CityZombie:Destroy()
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.transform = nil
  self.gameObject = nil
  self.param = nil
  self.anim = nil
  self.animState = nil
end

function CityZombie:Create()
  if self.req == nil then
    local path = "Assets/_Art_LastWar/Models/Characters/Zombies/A_Monster_Zombie01/prefab/A_Monster_Zombie02.prefab"
    self.req = Resource:InstantiateAsync(path)
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.gameObject.name = "Zombie" .. self.param.id
      self.transform = self.req.gameObject.transform
      self.transform:SetParent(self.param.parent)
      self.transform.localPosition = VecZero
      self.transform:Set_eulerAngles(self.param.parent:Get_eulerAngles())
      self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if not self.anim then
        Logger.LogError("\232\175\165\229\141\149\228\189\141\228\184\139\233\157\162\230\178\161\230\140\130SimpleAnimation\232\132\154\230\156\172\239\188\140gameObject:" .. self.gameObject.name)
      end
      self:PlayAnim(ZombieAnim.Idle, 1)
      self.walkCD = 10
    end)
  end
end

function CityZombie:Reload(param)
  self.req = nil
  self:Destroy()
  self.param = param
  self:Create()
end

function CityZombie:PlayAnim(name, speed)
  if self.anim then
    self.animState = name
    self.anim:Play(name)
    if speed then
      self.anim:SetStateSpeed(name, speed)
    end
  end
end

function CityZombie:GetPosition()
  return self.transform.localPosition
end

function CityZombie:SetPosition(pos)
  if self.transform then
    self.transform.localPosition = pos
  end
end

function CityZombie:SetRotation(quaternion)
  if self.transform then
    self.transform.localRotation = quaternion
  end
end

function CityZombie:GetMoveSpeed()
  return 0.4
end

function CityZombie:OnUpdate()
  if self.walkCD == nil or IsNull(self.transform) or self.animState == Const.ZombieAnim.Idle then
    return
  end
  local curPos = self:GetPosition()
  local moveLen = Time.deltaTime * self:GetMoveSpeed()
  self.pathLen = self.pathLen - moveLen
  if self.pathLen <= 0 then
    self:SetPosition(self.currPathEnd)
    self:PlayAnim(Const.ZombieAnim.Idle, 1)
  else
    self:SetPosition(curPos + self.moveForward * moveLen)
  end
end

function CityZombie:OnUpdateSec()
  if self.walkCD == nil or self.animState == Const.ZombieAnim.Walk then
    return
  end
  self.walkCD = self.walkCD - 1
  if self.walkCD < 0 then
    self.walkCD = 10
    local curPos = self:GetPosition()
    self.currPathEnd = Vector3(curPos.x, curPos.y, curPos.z - 5)
    self.pathLen = Vector3.Distance(self.currPathEnd, curPos)
    self.moveForward = Vector3.Normalize(self.currPathEnd - curPos)
    self:SetRotation(Quaternion.LookRotation(self.moveForward))
    self:PlayAnim(Const.ZombieAnim.Walk, 1)
  end
end

return CityZombie
