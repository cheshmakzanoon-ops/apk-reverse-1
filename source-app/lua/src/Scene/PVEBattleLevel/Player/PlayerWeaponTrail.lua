local PlayerWeaponTrail = BaseClass("PlayerWeaponTrail")
local Resource = CS.GameEntry.Resource

function PlayerWeaponTrail:__init(param)
  self.transform = nil
  self.gameObject = nil
  self.inst = nil
  self.param = param
  self.particleList = {}
  self:Create()
end

function PlayerWeaponTrail:__delete()
  self.transform = nil
  self.gameObject = nil
  self.inst = nil
  self.param = {}
  self.particleList = {}
end

function PlayerWeaponTrail:Create()
  self.inst = Resource:InstantiateAsync(self.param.trailName)
  self.inst:completed("+", function(req)
    self.gameObject = req.gameObject
    self.transform = self.gameObject.transform
    self.transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.transform.localScale = ResetScale
    self.gameObject:SetActive(true)
    self:ComponentDefine()
  end)
end

function PlayerWeaponTrail:Destroy()
  self:ComponentDestroy()
  if self.inst ~= nil then
    self.inst:Destroy()
  end
end

function PlayerWeaponTrail:ComponentDefine()
  self.particleList = {}
  local list = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem), true)
  if list ~= nil and list.Length > 0 then
    for i = 0, list.Length - 1 do
      table.insert(self.particleList, list[i])
    end
  end
end

function PlayerWeaponTrail:ComponentDestroy()
  self.particleList = {}
end

function PlayerWeaponTrail:Play()
  for k, v in ipairs(self.particleList) do
    v:Play()
  end
end

function PlayerWeaponTrail:PlayTrail(param)
  if self.transform ~= nil then
    self.transform.position = param.pos
    self.transform.rotation = param.rot
    self.transform.localScale = param.localScale
    self:Play()
  end
end

return PlayerWeaponTrail
