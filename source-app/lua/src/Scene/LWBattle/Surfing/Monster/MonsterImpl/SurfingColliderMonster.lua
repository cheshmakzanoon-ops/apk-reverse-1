local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingObj")
local SurfingColliderMonster = BaseClass("SurfingColliderMonster", base)

function SurfingColliderMonster:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
end

function SurfingColliderMonster:DestroyView()
  self:ResetMonster()
  self:ResetTerrain()
  base.DestroyView(self)
end

function SurfingColliderMonster:OnCollisionViewHandle(target, version)
  if version == nil then
    base.OnCollisionViewHandle(self, target)
    return
  end
  if self.dontCollide[target.guid] == nil or self.dontCollide[target.guid] ~= version then
    self.dontCollide[target.guid] = version or 1
    if target and 0 < (target.curBlood or 0) then
      self:OnCollide(target)
    end
  end
end

function SurfingColliderMonster:OnCollide(target)
  if target == nil then
    return
  end
  local collide_damage = self.monsterMeta.collide_damage
  if target and 0 < (target.curBlood or 0) and 0 < collide_damage then
    self.logic:DealDamage(self, target, target:GetPosition(), nil, 0.2, nil, nil, nil, collide_damage)
  end
end

function SurfingColliderMonster:OnMonsterCollided()
  if self.isHide then
    return
  end
  local para3 = self.monsterMeta.para3
  local hide = false
  if para3 and self.transform then
    self.hideGos = {}
    for _, v in ipairs(para3) do
      local trans = self.transform:Find(v)
      if IsNotNull(trans) then
        local go = trans.gameObject
        go:SetActive(false)
        table.insert(self.hideGos, go)
        hide = true
      end
    end
  end
  self.isHide = hide
  if hide then
    return
  end
  self.isHide = hide
  self:Death()
end

function SurfingColliderMonster:ResetMonster()
  if self.hideGos then
    for _, v in ipairs(self.hideGos) do
      if v then
        v:SetActive(true)
      end
    end
    self.hideGos = nil
  end
  self.isHide = nil
end

function SurfingColliderMonster:SetColliderTag()
  if self.markTerrain then
    return
  end
  local colliders = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Collider))
  if IsNotNull(colliders) then
    local layer1 = LayerMask.NameToLayer("Terrain")
    local layer2 = LayerMask.NameToLayer("Zombie")
    self.terrainObjs = {}
    for i = 0, colliders.Length - 1 do
      local collider = colliders[i]
      local go = collider.gameObject
      local layer = go.layer
      if layer == layer1 or layer == layer2 then
        go.tag = "Finish"
        table.insert(self.terrainObjs, go)
      end
    end
  end
  self.markTerrain = true
end

function SurfingColliderMonster:ResetTerrain()
  if self.terrainObjs then
    for _, v in ipairs(self.terrainObjs) do
      if v then
        v.tag = "Untagged"
      end
    end
    self.terrainObjs = nil
  end
  self.markTerrain = nil
end

return SurfingColliderMonster
