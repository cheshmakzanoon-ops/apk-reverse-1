local BaseUnitItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterBaseItem")
local BountyHunterUAV = BaseClass("BountyHunterUAV", BaseUnitItem)
local Localization = CS.GameEntry.Localization
local base = BaseUnitItem
local Resource = CS.GameEntry.Resource
local UAV_PREFAB_PATH = "Assets/Main/Prefabs/PrefabsIncrement/Character/Vehicle/UAV/A_Hero_wurenji_10_50/A_Hero_wurenji_50/prefab/A_Hero_wurenji_50.prefab"
local AIM_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_daodan_miaozhun.prefab"
local BOMB_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/Common/Common2/Eff_wurenji_hongzha_single2.prefab"
local PATROL_RADIUS = 50
local PATROL_HEIGHT = 10
local PATROL_DURATION = 15

local function __init(self, scene)
  base.__init(self, scene)
end

local function __delete(self)
  base.__delete(self)
end

function BountyHunterUAV:Init()
  base.Init(self, "uav")
  self.effLoadReqList = {}
end

function BountyHunterUAV:LoadItem(parent, callback)
  self.prefabPath = UAV_PREFAB_PATH
  self.callback = callback
  self.uuid = "uav"
  self.parent = parent
  local rotation = Vector3.New(0, 0, 0)
  local scale = 1
  self:LoadModel(self.prefabPath, parent, birthLocalPos, rotation, scale, function()
    self:OnLoadedFinish()
    if callback then
      callback()
    end
  end)
end

function BountyHunterUAV:EnterPatrolState()
  if not self.hunterTrans then
    return
  end
  if self.patrolTween then
    self.patrolTween:Kill()
    self.patrolTween = nil
  end
  local centerPos = self.hunterTrans.position - self.hunterTrans.forward * 25
  local patrolPath = self:GetPatrolTweenData(centerPos)
  local goTrackPath = {}
  table.insert(goTrackPath, Vector3(self.transform.position.x, self.transform.position.y, self.transform.position.z))
  table.insert(goTrackPath, Vector3(centerPos.x, 100, centerPos.y))
  self.patrolTween = self.transform:DOPath(goTrackPath, 3, CS.DG.Tweening.PathType.CatmullRom):SetLookAt(0.01)
  self.patrolTween:OnComplete(function()
    self.transform.position = patrolPath[1]
    self.patrolTween = self.transform:DOPath(patrolPath, PATROL_DURATION, CS.DG.Tweening.PathType.CatmullRom):SetLoops(-1, CS.DG.Tweening.LoopType.Restart):SetEase(CS.DG.Tweening.Ease.Linear):SetLookAt(0.1)
  end)
end

function BountyHunterUAV:GetPatrolTweenData(centerWorldPos)
  local path = {}
  local segments = 12
  for i = 0, segments do
    local angle = i / segments * (2 * math.pi)
    local x = centerWorldPos.x + PATROL_RADIUS * math.cos(angle)
    local z = centerWorldPos.z + PATROL_RADIUS * math.sin(angle)
    table.insert(path, Vector3(x, centerWorldPos.y + PATROL_HEIGHT, z))
  end
  return path
end

function BountyHunterUAV:StartAttackTargetPos(bombTargetPosList, groundPosY, hunterTrans, duration)
  if not self.transform or not bombTargetPosList then
    return
  end
  if self.patrolTween then
    self.patrolTween:Kill()
    self.patrolTween = nil
  end
  self.hunterTrans = hunterTrans
  local hunterWorldPos = hunterTrans.position
  local bombCenterWorldPosSumX = 0
  local bombCenterWorldPosSumZ = 0
  for _, v in ipairs(bombTargetPosList) do
    bombCenterWorldPosSumX = bombCenterWorldPosSumX + v.x
    bombCenterWorldPosSumZ = bombCenterWorldPosSumZ + v.z
  end
  local posCount = #bombTargetPosList
  local centerPosX = bombCenterWorldPosSumX / posCount
  local centerPosY = groundPosY + 6
  local centerPosZ = bombCenterWorldPosSumZ / posCount
  self:ShowHunterLog("StartAttackTargetPos .. x: " .. centerPosX .. "y : " .. centerPosY .. "z :" .. centerPosZ)
  local startWorldPos = Vector3(hunterWorldPos.x, hunterWorldPos.y + 10, hunterWorldPos.z)
  local controlPos = Vector3(centerPosX, centerPosY, centerPosZ)
  local tmpEndPos1 = controlPos - startWorldPos
  local tmpEndPos2 = controlPos + Vector3(tmpEndPos1.x, -tmpEndPos1.y, tmpEndPos1.z) * 2 + Vector3(0, 10, 0)
  local endWorldPos = Vector3(tmpEndPos2.x, tmpEndPos2.y, tmpEndPos2.z)
  self.transform.position = startWorldPos
  local path = {
    startWorldPos,
    controlPos,
    endWorldPos
  }
  self.bombTween = self.transform:DOPath(path, duration, CS.DG.Tweening.PathType.CatmullRom):SetEase(CS.DG.Tweening.Ease.OutCubic):SetLookAt(0.1)
  self.bombTween:OnComplete(function()
    self.bombTween = nil
    self:OnBombFinish()
  end)
  self:ShowAimEff(bombTargetPosList)
  self.bombTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ShowBombEff(Vector3(centerPosX, groundPosY, centerPosZ))
  end, 0.5)
end

function BountyHunterUAV:ShowAimEff(bombTargetPosList)
  for _, v in ipairs(bombTargetPosList) do
    self:LoadEff(AIM_EFF_PATH, self.parent.transform, v)
  end
end

function BountyHunterUAV:ShowBombEff(bombWorldPos)
  self:LoadEff(BOMB_EFF_PATH, self.parent.transform, bombWorldPos)
end

function BountyHunterUAV:OnBombFinish()
  for _, v in ipairs(self.effLoadReqList) do
    v:Destroy()
  end
  self:EnterPatrolState()
end

function BountyHunterUAV:OnLoadedFinish()
  if not self.transform then
    return
  end
end

function BountyHunterUAV:ShowHunterLog(info)
end

function BountyHunterUAV:LoadEff(prefabPath, parent, worldPos, initRotation, scale, callback)
  if string.IsNullOrEmpty(prefabPath) then
    Logger.LogError("path is null!")
    return
  end
  local loadModelReq = Resource:InstantiateAsync(prefabPath)
  loadModelReq:completed("+", function(req)
    if req.isError then
      if callback then
        callback()
      end
      Logger.LogError("bounty hunter bullet model load fail")
      return
    end
    local transform = req.gameObject.transform
    transform:Set_localScale(1, 1, 1)
    if parent then
      transform:SetParent(parent.transform)
    end
    if worldPos then
      transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    else
      transform:Set_localPosition(0, 0, 0)
    end
    if initRotation then
      transform:Set_localRotation(initRotation.x, initRotation.y, initRotation.z, 1)
    else
      transform:Set_localRotation(0, 0, 0, 1)
    end
    if scale then
      transform:Set_localScale(scale, scale, scale)
    end
    transform.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    if callback then
      callback()
    end
  end)
  table.insert(self.effLoadReqList, loadModelReq)
  return loadModelReq
end

function BountyHunterUAV:Destroy()
  base.Destroy(self)
  for _, v in ipairs(self.effLoadReqList) do
    v:Destroy()
  end
  self.effLoadReqList = nil
  if self.bombTimer then
    self.bombTimer:Stop()
    self.bombTimer = nil
  end
  if self.bombTween then
    self.bombTween:Kill()
    self.bombTween = nil
  end
  if self.patrolTween then
    self.patrolTween:Kill()
    self.patrolTween = nil
  end
end

BountyHunterUAV.__init = __init
BountyHunterUAV.__delete = __delete
return BountyHunterUAV
