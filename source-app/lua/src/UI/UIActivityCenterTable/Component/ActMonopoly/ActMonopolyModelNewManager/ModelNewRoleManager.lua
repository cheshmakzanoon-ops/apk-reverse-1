local ModelNewRoleManager = BaseClass("ModelNewRoleManager")
local Resource = CS.GameEntry.Resource
local RoleLocalScale = 1
local idleAniName = "Idle"
local runAniName = "Run01"
local rolePath = "Assets/Main/Prefabs/UIChristmasPerfab/A_Hero_bubing_yundonghui_battle.prefab"
local aniPath = "A_Hero_bubing_yundonghui_battle/Hero_bubing_yundonghui_torch_skin"

function ModelNewRoleManager:__init()
  self:DataDefine()
end

function ModelNewRoleManager:__delete()
  self:OnDestroy()
end

function ModelNewRoleManager:DataDefine()
  self.modelShowManager = nil
  self.rolePath = rolePath
  self.aniPath = aniPath
  self.roleLoadRequest = nil
  self.role = nil
  self.roleAni = nil
  self.roleIsWalking = false
  self.roleDir = 0
end

function ModelNewRoleManager:OnDestroy()
  self.modelShowManager = nil
  self.rolePath = nil
  self.roleIsWalking = nil
  self.roleDir = nil
  self.roleLoadRequest = nil
  self.role = nil
  self.roleAni = nil
end

function ModelNewRoleManager:SetRoleResPath(path, aniPath)
  if not string.IsNullOrEmpty(path) then
    self.rolePath = path
  end
  if not string.IsNullOrEmpty(aniPath) then
    self.aniPath = aniPath
  end
end

function ModelNewRoleManager:SetRoleData(isWalking, dir)
  self.roleIsWalking = isWalking
  self.roleDir = dir
  self:TrySetRoleShow()
end

function ModelNewRoleManager:SetRoleLocalPos(pos)
  if self.role then
    self.role.transform.localPosition = pos
  end
end

function ModelNewRoleManager:GetRoleTransform()
  if self.role then
    return self.role.transform
  end
end

function ModelNewRoleManager:TrySetRoleShow()
  if self.role then
    self.role.transform:Set_eulerAngles(0, self.roleDir, 0)
  end
  if self.roleAni then
    if self.roleIsWalking then
      self.roleAni:Play(runAniName)
    else
      self.roleAni:Play(idleAniName)
    end
  end
end

function ModelNewRoleManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self:CreateRole()
end

function ModelNewRoleManager:CreateRole()
  self.roleLoadRequest = nil
  local req = Resource:InstantiateAsync(self.rolePath)
  req:completed("+", function()
    local roleRoot = req.gameObject.transform
    req.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    roleRoot.transform:SetParent(self.modelShowManager.modelRoot.transform, false)
    self.role = req.gameObject
    self.role.transform:Set_localPosition(0, 0, 0)
    self.role.transform:Set_localScale(RoleLocalScale, RoleLocalScale, RoleLocalScale)
    local aniChild = self.role.transform:Find(self.aniPath)
    self.roleAni = aniChild:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.modelShowManager.modelNewRoleManagerInitFin = true
    self.modelShowManager:CheckAllLoadFinish()
    self:TrySetRoleShow()
  end)
  self.roleLoadRequest = req
end

function ModelNewRoleManager:EndShow()
  if self.roleLoadRequest then
    self.roleLoadRequest:Destroy()
    self.roleLoadRequest = nil
    self.role = nil
    self.roleAni = nil
  end
end

return ModelNewRoleManager
