local RoleModelManager = BaseClass("RoleModelManager")
local Resource = CS.GameEntry.Resource
local idleAniName = "Idle"
local runAniName = "Run01"
local rolePath = "Assets/Main/Prefabs/UIChristmasPerfab/A_Hero_bubing_yundonghui_battle.prefab"
local aniPath = "A_Hero_bubing_yundonghui_battle/Hero_bubing_yundonghui_torch_skin"

function RoleModelManager:__init()
  self:DataDefine()
end

function RoleModelManager:__delete()
  self:OnDestroy()
end

function RoleModelManager:DataDefine()
  self.modelShowManager = nil
  self.rolePath = rolePath
  self.aniPath = aniPath
  self.roleLoadRequest = nil
  self.roleRoot = nil
  self.role = nil
  self.roleAni = nil
  self.roleIsWalking = false
  self.roleDir = 0
end

function RoleModelManager:OnDestroy()
  self.modelShowManager = nil
  self.rolePath = nil
  self.roleIsWalking = nil
  self.roleDir = nil
  self.roleLoadRequest = nil
  self.roleRoot = nil
  self.role = nil
  self.roleAni = nil
end

function RoleModelManager:SetRoleResPath(path, aniPath)
  if not string.IsNullOrEmpty(path) then
    self.rolePath = path
  end
  if not string.IsNullOrEmpty(aniPath) then
    self.aniPath = aniPath
  end
end

function RoleModelManager:SetRoleData(isWalking, dir)
  self.roleIsWalking = isWalking
  self.roleDir = dir
  self:TrySetRoleShow()
end

function RoleModelManager:TrySetRoleShow()
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

function RoleModelManager:StartShow(modelShowManager)
  self.modelShowManager = modelShowManager
  self.roleRoot = self.modelShowManager.scene.transform:Find("HeroPos")
  self:CreateRole()
end

function RoleModelManager:CreateRole()
  self.roleLoadRequest = nil
  local req = Resource:InstantiateAsync(self.rolePath)
  req:completed("+", function()
    local roleRoot = req.gameObject.transform
    req.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    roleRoot:Set_localPosition(0, 0, 0)
    self.role = req.gameObject
    self.role.transform.position = self.roleRoot.transform.position
    local aniChild = self.role.transform:Find(self.aniPath)
    self.roleAni = aniChild:GetComponentInChildren(typeof(CS.SimpleAnimation))
    TimerManager:GetInstance():DelayInvoke(function()
      EventManager:GetInstance():Broadcast(EventId.ActMonopolyRoleLoadFin)
    end, 0.01)
    self:TrySetRoleShow()
  end)
  self.roleLoadRequest = req
end

function RoleModelManager:EndShow()
  if self.roleLoadRequest then
    self.roleLoadRequest:RealDestroy()
    self.roleLoadRequest = nil
    self.role = nil
    self.roleAni = nil
  end
end

return RoleModelManager
