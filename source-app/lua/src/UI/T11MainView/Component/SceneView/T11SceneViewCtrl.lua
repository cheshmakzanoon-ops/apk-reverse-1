local T11SceneViewCtrl = BaseClass("T11SceneViewCtrl")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local soldier_a_point_path = "ModelRoot/Soldier_A_Point"
local soldier_b_point_path = "ModelRoot/Soldier_B_Point"
local T11EquipModelType = {
  NotUnlock = 0,
  Unlocking = 1,
  Unlocked = 2,
  Upgrading = 3,
  MaxStage = 4
}
local SOLDIER_A_EQUIP_STATE_PREFAB_PATH_CONFIG = {
  [T11EquipModelType.NotUnlock] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_A_Equip/NotUnLockState/",
  [T11EquipModelType.Unlocking] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_A_Equip/UnlockingState/",
  [T11EquipModelType.Unlocked] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_A_Equip/UnlockedState/",
  [T11EquipModelType.Upgrading] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_A_Equip/UpgradingState/",
  [T11EquipModelType.MaxStage] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_A_Equip/MaxStage/"
}
local SOLDIER_B_EQUIP_STATE_PREFAB_PATH_CONFIG = {
  [T11EquipModelType.NotUnlock] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_B_Equip/NotUnLockState/",
  [T11EquipModelType.Unlocking] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_B_Equip/UnlockingState/",
  [T11EquipModelType.Unlocked] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_B_Equip/UnlockedState/",
  [T11EquipModelType.Upgrading] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_B_Equip/UpgradingState/",
  [T11EquipModelType.MaxStage] = "Assets/Main/Prefabs/UI/T11/SoldierModel/Soldier_B_Equip/MaxStage/"
}
local ANI_NAME_CONFIG = {
  [T11EquipType.Unknown] = "Action1",
  [T11EquipType.Head] = "Action1",
  [T11EquipType.Body] = "Action2",
  [T11EquipType.Arm] = "Action3",
  [T11EquipType.Weapon] = "Action4"
}

function T11SceneViewCtrl:__init()
  self.equipStateConfig = {}
  self.equipStateConfig[T11SoldierType.T11SoldierTypeA] = SOLDIER_A_EQUIP_STATE_PREFAB_PATH_CONFIG
  self.equipStateConfig[T11SoldierType.T11SoldierTypeB] = SOLDIER_B_EQUIP_STATE_PREFAB_PATH_CONFIG
  self.soldierPointDic = {}
  self.allSoldierEquipReqDic = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeA] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeA][T11EquipModelType.NotUnlock] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeA][T11EquipModelType.Unlocking] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeA][T11EquipModelType.Unlocked] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeA][T11EquipModelType.Upgrading] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeA][T11EquipModelType.MaxStage] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeB] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeB][T11EquipModelType.NotUnlock] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeB][T11EquipModelType.Unlocking] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeB][T11EquipModelType.Unlocked] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeB][T11EquipModelType.Upgrading] = {}
  self.allSoldierEquipReqDic[T11SoldierType.T11SoldierTypeB][T11EquipModelType.MaxStage] = {}
  self.equipAniDic = {}
end

function T11SceneViewCtrl:__delete()
  self:Destroy()
end

function T11SceneViewCtrl:Init(t11RtCpt)
  self.rtCpt = t11RtCpt
  self:FindHangPoint()
end

function T11SceneViewCtrl:FindHangPoint()
  self.soldierPointDic[T11SoldierType.T11SoldierTypeA] = self.rtCpt:GetSceneNode(soldier_a_point_path)
  self.soldierPointDic[T11SoldierType.T11SoldierTypeB] = self.rtCpt:GetSceneNode(soldier_b_point_path)
end

function T11SceneViewCtrl:RefreshModelState()
  for k1, v1 in pairs(self.allSoldierEquipReqDic) do
    local allEquipStateDic = v1
    for k2, v2 in pairs(allEquipStateDic) do
      local allReqDic = v2
      for k3, v3 in pairs(allReqDic) do
        if v3 then
          if v3.isDone and not v3.isError then
            v3.gameObject:SetActive(false)
          else
            v3:Destroy()
            allReqDic[k3] = false
          end
        end
      end
    end
  end
  local isMaxStage = T11Util.IsMaxStage()
  if not isMaxStage then
    self.allEquipDataList = T11Util.GetCurStageAllEquipData()
  else
    self.allEquipDataList = T11Util.GetShowMaxStageEquipDataList()
  end
  self.curUpgradeEquipType = T11Util.GetCurUpgradeEquipType()
  self:RefreshTargetModelState(T11SoldierType.T11SoldierTypeA)
  self:RefreshTargetModelState(T11SoldierType.T11SoldierTypeB)
end

function T11SceneViewCtrl:RefreshTargetModelState(soldierType)
  for _, v in ipairs(self.allEquipDataList) do
    self:GenTargetEquipByState(v, soldierType)
  end
  self:RefreshAllEquipAni()
end

function T11SceneViewCtrl:GenTargetEquipByState(equipData, soldierType)
  local equipModelName = equipData:GetEquipModelName()
  local targetModelState = self:GetEquipModelState(equipData)
  local targetStateDic = self.allSoldierEquipReqDic[soldierType][targetModelState]
  if targetStateDic and targetStateDic[equipModelName] then
    if targetStateDic[equipModelName].isDone and targetStateDic[equipModelName].gameObject and not targetStateDic[equipModelName].gameObject.activeSelf then
      targetStateDic[equipModelName].gameObject:SetActive(true)
    end
    return
  end
  if not equipModelName then
    Logger.LogError("T11SceneViewCtrl:GenTargetEquipByState equipModelName is nil")
    return
  end
  local equipPrefabPath = self.equipStateConfig[soldierType][targetModelState] .. equipModelName .. ".prefab"
  local equipReq = ResourceManager:InstantiateAsync(equipPrefabPath)
  equipReq:completed("+", function(handle)
    if handle.isError then
      return
    end
    local hangPoint = self.soldierPointDic[soldierType]
    if IsNull(hangPoint) then
      handle:Destroy()
      return
    end
    local go = handle.gameObject
    go:SetActive(true)
    go.transform:SetParent(hangPoint.transform)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go.transform:Set_localRotation(0, 0, 0, 1)
    local ani = go:GetComponent(typeof(CS.SimpleAnimation))
    self.equipAniDic[go] = ani
    self:RefreshTargetEquipAni(go)
  end)
  self.allSoldierEquipReqDic[soldierType][targetModelState][equipModelName] = equipReq
end

function T11SceneViewCtrl:RefreshAllEquipAni()
  if not self.allSoldierEquipReqDic then
    return
  end
  for k1, v1 in pairs(self.allSoldierEquipReqDic) do
    local allEquipStateDic = v1
    for k2, v2 in pairs(allEquipStateDic) do
      local allReqDic = v2
      for k3, v3 in pairs(allReqDic) do
        if v3 and v3.isDone and v3.gameObject and v3.gameObject.activeSelf then
          self:RefreshTargetEquipAni(v3.gameObject)
        end
      end
    end
  end
end

function T11SceneViewCtrl:RefreshTargetEquipAni(obj)
  if not table.containsKey(self.equipAniDic, obj) then
    return
  end
  local ani = self.equipAniDic[obj]
  if not ani then
    return
  end
  local forceShowWeaponPose = false
  local curUpgradeState = DataCenter.T11DataManager:GetCurT11UpgradeState()
  if T11Util.IsMaxStage() or curUpgradeState == T11UnlockState.T11Unlockable or curUpgradeState == T11UnlockState.SkillBreakable or curUpgradeState == T11UnlockState.T11Unlocking or curUpgradeState == T11UnlockState.SkillBreaking or curUpgradeState == T11UnlockState.T11UnlockConfirmComplete or curUpgradeState == T11UnlockState.SkillBreakConfirmComplete then
    forceShowWeaponPose = true
  end
  local showEquipType = forceShowWeaponPose and T11EquipType.Weapon or self.curUpgradeEquipType
  local aniName = ANI_NAME_CONFIG[showEquipType]
  if not aniName then
    return
  end
  ani:Play(aniName)
end

function T11SceneViewCtrl:GetEquipModelState(equipData)
  if not T11Util.IsUnlockT11() then
    if equipData.curEquipState == T11EquipUpgradeState.NotUnLock then
      return T11EquipModelType.NotUnlock
    elseif equipData.curEquipState == T11EquipUpgradeState.Unlocked then
      return T11EquipModelType.Unlocked
    elseif equipData.curEquipState == T11EquipUpgradeState.Upgrading then
      return T11EquipModelType.Unlocking
    end
  else
    if T11Util.IsMaxStage() then
      return T11EquipModelType.MaxStage
    end
    if equipData.curEquipState == T11EquipUpgradeState.Upgrading then
      return T11EquipModelType.Upgrading
    else
      return T11EquipModelType.Unlocked
    end
  end
end

function T11SceneViewCtrl:Destroy()
  self.equipStateConfig = nil
  for k1, v1 in pairs(self.allSoldierEquipReqDic) do
    local allEquipStateDic = v1
    for k2, v2 in pairs(allEquipStateDic) do
      local allReqDic = v2
      for k3, v3 in pairs(allReqDic) do
        if v3 then
          v3:Destroy()
        end
      end
    end
  end
  self.allSoldierEquipReqDic = nil
  self.equipAniDic = nil
end

return T11SceneViewCtrl
