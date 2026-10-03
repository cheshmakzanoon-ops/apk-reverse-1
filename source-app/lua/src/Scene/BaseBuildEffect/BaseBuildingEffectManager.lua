local BaseBuildingEffectManager = BaseClass("BaseBuildingEffectManager", Singleton)
local BaseBuildingBossSkillEffectCtrl = require("Scene.BaseBuildEffect.BaseBuildingBossSkillEffectCtrl")
local ResourceManager = CS.GameEntry.Resource
local PrefabType = {
  IceDropEffect = "IceDropEffect",
  IceBoomEffect = "IceBoomEffect",
  SelectCircleEffect = "SelectCircleEffect",
  ZMSelectCircleEffect = "ZMSelectCircleEffect",
  ZMMissileDropEffect = "ZMMissileDropEffect",
  ZMMissileBoomEffect = "ZMMissileBoomEffect"
}
local PrefabPath = {
  [PrefabType.IceDropEffect] = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_zidan_01.prefab",
  [PrefabType.IceBoomEffect] = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_Boss_aisila01_jizhong_01.prefab",
  [PrefabType.SelectCircleEffect] = "Assets/_Art_LastWar/Effect/Prefab/S2/Eff_s_WorldMonster_Asila_Boss_kill.prefab",
  [PrefabType.ZMSelectCircleEffect] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_daodan_miaozhun.prefab",
  [PrefabType.ZMMissileDropEffect] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_daodan_02.prefab",
  [PrefabType.ZMMissileBoomEffect] = "Assets/_Art_LastWar/Effect/Prefab/Prefab01/Eff_s_jiluofu_feiting_daodan_hit_01.prefab"
}
local ZMDropDuration = 0.7

function BaseBuildingEffectManager:__init()
  self.allEffect = {}
  self.uid2uuidMap = {}
  self.effectShowMaxLod = 2
  self.effectShow = false
  self.effectTimers = {}
  self.tweens = {}
  self.bossEffectCtrl = BaseBuildingBossSkillEffectCtrl.New()
  self:AddListener()
end

function BaseBuildingEffectManager:__delete()
  for k, v in pairs(self.allEffect) do
    for k1, v1 in pairs(v) do
      if v1 then
        if v1.request then
          v1.request:Destroy()
          v1.request = nil
        end
        if v1.timer then
          v1.timer:Stop()
          v1.timer = nil
        end
        v1.ownerUid = nil
        v1.effectObj = nil
      end
    end
  end
  self:ClearTimers()
  for i, v in pairs(self.tweens) do
    if v then
      v:Kill()
      self.tweens[i] = nil
    end
  end
  self.effectShowMaxLod = nil
  self.effectShow = nil
  self.allEffect = nil
  self.effectTimers = nil
  self.tweens = nil
  if self.bossEffectCtrl then
    self.bossEffectCtrl:Delete()
  end
  self:RemoveListener()
end

function BaseBuildingEffectManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.CheckDomeOpen, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceWarDataChange, self.AllianceWarDataChange)
  EventManager:GetInstance():AddListener(EventId.AllianceWarDataInit, self.AllianceWarDataInit)
  EventManager:GetInstance():AddListener(EventId.BuildMainZeroUpgradeSuccess, self.CheckMyBuildUnderAttack)
end

function BaseBuildingEffectManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.CheckDomeOpen, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WORLD_BUILD_OUT_VIEW, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceWarDataChange, self.AllianceWarDataChange)
  EventManager:GetInstance():RemoveListener(EventId.AllianceWarDataInit, self.AllianceWarDataInit)
  EventManager:GetInstance():RemoveListener(EventId.BuildMainZeroUpgradeSuccess, self.CheckMyBuildUnderAttack)
end

function BaseBuildingEffectManager:CheckShowEffect(bUuid)
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil then
    self:OnWorldBaseRefresh(info)
  end
end

function BaseBuildingEffectManager:CheckMyBuildUnderAttack()
  local world = CS.SceneManager.World
  if not world then
    return
  end
  local point = LuaEntry.Player:GetMainWorldPos()
  local info = world:GetPointInfo(point)
  local self = BaseBuildingEffectManager:GetInstance()
  if info then
    local bUuid = info.uuid
    if DataCenter.AllianceWarDataManager:CheckTargetMine() then
      self:AddBaseBuildEffect(info, UIAssets.LWFocusEffect)
    else
      self:RemoveBaseBuildEffect(bUuid, UIAssets.LWFocusEffect)
    end
  end
end

function BaseBuildingEffectManager:OnWorldBaseRefresh(info)
  if info ~= nil then
    local bUuid = info.uuid
    local ownerUid = info.ownerUid
    if info.itemId == BuildingTypes.FUN_BUILD_MAIN then
      if ownerUid == LuaEntry.Player.uid then
        if DataCenter.AllianceWarDataManager:CheckTargetMine() then
          self:AddBaseBuildEffect(info, UIAssets.LWFocusEffect)
        end
      else
        local warUuid = DataCenter.AllianceWarDataManager:GetPlayerLeaderWar(bUuid)
        if warUuid then
          self:AddBaseBuildEffect(info, UIAssets.LWFocusEffect)
        end
      end
    end
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByLeaderUid(ownerUid)
    if data then
      self:AddBaseBuildEffect(info, UIAssets.LWAllianceWarFlag, 5, 0.5)
    end
    self:CheckBaseFrozenSelected(info)
    self:CheckBaseZMBossSelected(info)
    if self.bossEffectCtrl then
      self.bossEffectCtrl:OnWorldBaseEffectRefresh(info)
    end
  end
end

function BaseBuildingEffectManager:RemoveBaseBuildEffect(bUuid, effectName)
  local data = self.allEffect[bUuid]
  if data ~= nil then
    if effectName then
      local effectData = data[effectName]
      if effectData then
        if effectData.request then
          effectData.request:Destroy()
          effectData.request = nil
        end
        if effectData.timer then
          effectData.timer:Stop()
          effectData.timer = nil
        end
        data[effectName] = nil
      end
    else
      for i, v in pairs(data) do
        if v then
          if v.request then
            v.request:Destroy()
            v.request = nil
          end
          if v.timer then
            v.timer:Stop()
            v.timer = nil
          end
          data[i] = nil
        end
      end
    end
  end
  if self.bossEffectCtrl then
    self.bossEffectCtrl:RemoveBaseEffect(bUuid)
  end
end

function BaseBuildingEffectManager:AddBaseBuildEffect(buildPointInfo, effectName, offsetY, effectScale)
  if not buildPointInfo then
    return
  end
  local bUuid = buildPointInfo.uuid
  local uid = buildPointInfo.ownerUid
  local pointIndex = buildPointInfo.mainIndex
  local serverId = buildPointInfo.serverId
  local prefabName = effectName
  local data = self.allEffect[bUuid]
  if not data then
    data = {}
    self.allEffect[bUuid] = data
  end
  self.uid2uuidMap[uid] = bUuid
  if data and not data[prefabName] then
    local tItem = {}
    local request = ResourceManager:InstantiateAsync(prefabName)
    tItem.request = request
    tItem.ownerUid = uid
    data[prefabName] = tItem
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      if effectScale == nil then
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      else
        request.gameObject.transform:Set_localScale(effectScale, effectScale, effectScale)
      end
      local offsetYValue = 0
      if offsetY then
        offsetYValue = offsetY
      end
      local pos = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World, serverId)
      pos.y = pos.y + offsetYValue
      request.gameObject.transform.position = pos
      tItem.effectObj = request.gameObject
    end)
  end
end

function BaseBuildingEffectManager:CheckAllianceWarFlagEffect(data)
  if CS.SceneManager.World == nil then
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(data.pointId)
  if info and info.PointType == WorldPointType.PlayerBuilding then
    cast(info, typeof(CS.BuildPointInfo))
    local allianceData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByLeaderUid(data.ownerUid)
    local buildUuid = self.uid2uuidMap[data.ownerUid]
    buildUuid = buildUuid or info.uuid
    if allianceData then
      self:AddBaseBuildEffect(info, UIAssets.LWAllianceWarFlag, 5, 0.5)
    else
      self:RemoveBaseBuildEffect(buildUuid, UIAssets.LWAllianceWarFlag)
    end
  end
end

function BaseBuildingEffectManager:CheckFocusEffect(data)
  if CS.SceneManager.World == nil then
    return
  end
  self:CheckMyBuildUnderAttack()
  local bUuid = data.targetUuid
  local info = CS.SceneManager.World:GetPointInfoByUuid(bUuid)
  if info ~= nil and info.PointType == WorldPointType.PlayerBuilding then
    cast(info, typeof(CS.BuildPointInfo))
    local ownerUid = info.ownerUid
    if info.itemId == BuildingTypes.FUN_BUILD_MAIN and ownerUid ~= LuaEntry.Player.uid then
      local warUuid = DataCenter.AllianceWarDataManager:GetPlayerLeaderWar(bUuid)
      if warUuid then
        self:AddBaseBuildEffect(info, UIAssets.LWFocusEffect)
      else
        self:RemoveBaseBuildEffect(bUuid, UIAssets.LWFocusEffect)
      end
    end
  end
end

function BaseBuildingEffectManager:OnCameraChangeLod(lod)
  local show = lod <= self.effectShowMaxLod
  if show ~= self.effectShow then
    self.effectShow = show
    if self.allEffect ~= nil then
      for k, v in pairs(self.allEffect) do
        for k1, v1 in pairs(v) do
          if v1 and not IsNull(v1.effectObj) then
            v1.effectObj:SetActive(show)
          end
        end
      end
    end
    if self.bossEffectCtrl then
      self.bossEffectCtrl:OnCameraChangeLod(show)
    end
  end
end

function BaseBuildingEffectManager:DeleteAllEffect()
  if self.allEffect then
    for k, v in pairs(self.allEffect) do
      for k1, v1 in pairs(v) do
        if v1 then
          if v1.request then
            v1.request:Destroy()
            v1.request = nil
          end
          if v1.timer then
            v1.timer:Stop()
            v1.timer = nil
          end
          v1.ownerUid = nil
          v1.effectObj = nil
        end
      end
    end
  end
  self:ClearTimers()
  for i, v in pairs(self.tweens) do
    if v then
      v:Kill()
      self.tweens[i] = nil
    end
  end
  self.allEffect = {}
  self.uid2uuidMap = {}
  self.effectTimers = {}
  self.tweens = {}
end

local function BuildInViewSignal(uuid)
  BaseBuildingEffectManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function BuildOutViewSignal(uuid)
  BaseBuildingEffectManager:GetInstance():RemoveBaseBuildEffect(tonumber(uuid))
end

local function ChangeCameraLodSignal(lod)
  BaseBuildingEffectManager:GetInstance():OnCameraChangeLod(lod)
end

local function AllianceWarDataChange(data)
  BaseBuildingEffectManager:GetInstance():CheckAllianceWarFlagEffect(data)
  BaseBuildingEffectManager:GetInstance():CheckFocusEffect(data)
end

local function AllianceWarDataInit()
  BaseBuildingEffectManager:GetInstance():DeleteAllEffect()
  if BaseBuildingEffectManager:GetInstance().bossEffectCtrl then
    BaseBuildingEffectManager:GetInstance().bossEffectCtrl:DeleteAllEffect()
  end
end

local function CheckBaseFrozenSelected(self, info)
  if DataCenter.ActivityMonsterInvasionDataManager.invasionId > 0 and info then
    if info.monsterInvasion then
      local endTs = info.monsterInvasion.aimEndTime
      local curTs = UITimeManager:GetInstance():GetServerTime()
      local delay = endTs - curTs
      delay = delay / 1000 - 1.5
      if 0 < delay then
        if self:CheckSelectEffectIsShow(info.uuid, PrefabPath[PrefabType.SelectCircleEffect]) then
          self:AddFrozenSelectedTimer(info, delay)
          return
        end
        self:AddBaseBuildEffect(info, PrefabPath[PrefabType.SelectCircleEffect])
        self:AddFrozenSelectedTimer(info, delay)
        return
      end
    end
    self:RemoveFrozenSelectedTimer(info.uuid)
    self:RemoveBaseBuildEffect(info.uuid, PrefabPath[PrefabType.SelectCircleEffect])
  end
end

local function CheckBaseZMBossSelected(self, info)
  if not DataCenter.LWZoneMobilizationManager:IsActivityOpen() then
    return
  end
  if info then
    if info.zoneMobilization then
      local endTs = info.zoneMobilization.aimEndTime
      local curTs = UITimeManager:GetInstance():GetServerTime()
      local delay = endTs - curTs
      delay = delay / 1000 - 1.5
      if 0 < delay then
        if self:CheckSelectEffectIsShow(info.uuid, PrefabPath[PrefabType.ZMSelectCircleEffect]) then
          self:AddZMSelectedTimer(info, delay)
          return
        end
        self:AddBaseBuildEffect(info, PrefabPath[PrefabType.ZMSelectCircleEffect])
        self:AddZMSelectedTimer(info, delay)
        return
      end
    end
    self:RemoveZMSelectedTimer(info.uuid)
    self:RemoveBaseBuildEffect(info.uuid, PrefabPath[PrefabType.ZMSelectCircleEffect])
  end
end

local function CheckSelectEffectIsShow(self, uuid, prefabName)
  local data = uuid and self.allEffect and self.allEffect[uuid]
  if data and data[prefabName] then
    return true
  end
  return false
end

local function AddFrozenSelectedTimer(self, info, delay)
  if info and info.uuid then
    self:RemoveFrozenSelectedTimer(info.uuid)
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveBaseBuildEffect(info.uuid, PrefabPath[PrefabType.SelectCircleEffect])
      self:AddIceDropEffectTimer(info)
      self:RemoveFrozenSelectedTimer(info.uuid)
    end, delay)
    self:AddEffectTimer(info.uuid, PrefabType.SelectCircleEffect, timer)
  end
end

local function AddZMSelectedTimer(self, info, delay)
  if info and info.uuid then
    self:RemoveZMSelectedTimer(info.uuid)
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveBaseBuildEffect(info.uuid, PrefabPath[PrefabType.SelectCircleEffect])
      self:AddZMDropEffectTimer(info)
      self:RemoveZMSelectedTimer(info.uuid)
    end, delay)
    self:AddEffectTimer(info.uuid, PrefabType.SelectCircleEffect, timer)
  end
end

local function AddEffectTimer(self, uuid, prefabName, timer)
  if uuid == nil or string.IsNullOrEmpty(prefabName) or timer == nil then
    return
  end
  if not self.effectTimers then
    self.effectTimers = {
      [uuid] = {
        [prefabName] = timer
      }
    }
  elseif not self.effectTimers[uuid] then
    self.effectTimers[uuid] = {
      [prefabName] = timer
    }
  elseif not self.effectTimers[uuid][prefabName] then
    self.effectTimers[uuid][prefabName] = timer
  else
    self.effectTimers[uuid][prefabName]:Stop()
    self.effectTimers[uuid][prefabName] = timer
  end
end

local function RemoveFrozenSelectedTimer(self, uuid)
  self:RemoveTimer(uuid, PrefabType.SelectCircleEffect)
end

local function RemoveZMSelectedTimer(self, uuid)
  self:RemoveTimer(uuid, PrefabType.SelectCircleEffect)
end

local function RemoveTimer(self, uuid, key)
  if self.effectTimers and uuid and key and self.effectTimers[uuid] and self.effectTimers[uuid][key] then
    self.effectTimers[uuid][key]:Stop()
    self.effectTimers[uuid][key] = nil
  end
end

local function InstanceEffect(self, info, prefabType, duration, pos, callback, finishCb)
  if info == nil then
    return
  end
  local uuid = info.uuid
  local data = self.allEffect[uuid]
  if not data then
    data = {}
    self.allEffect[uuid] = data
  end
  self.uid2uuidMap[info.ownerUid] = uuid
  local path = prefabType and PrefabPath[prefabType]
  if data and not string.IsNullOrEmpty(path) then
    self:RemoveBaseBuildEffect(uuid, prefabType)
    if not IsNull(CS.SceneManager.World) then
      local build = CS.SceneManager.World:GetWorldBuildingByUuid(uuid)
      if build and not IsNull(build.gameObject) then
        local parent = build.gameObject.transform:Find("ModelGo/Normal")
        if not IsNull(parent) then
          local tItem = {}
          local request = self:InstantiateAsync(path, parent, duration, pos, tItem, callback, function()
            if finishCb then
              finishCb()
            end
            self:RemoveBaseBuildEffect(uuid, prefabType)
          end)
          tItem.request = request
          tItem.ownerUid = info.ownerUid
          data[prefabType] = tItem
          tItem.effectObj = request.gameObject
          if prefabType == PrefabType.IceBoomEffect then
            DataCenter.LWSoundManager:PlaySound(62005, false)
          end
        end
      end
    end
  end
end

local function AddIceDropEffectTimer(self, info)
  self:InstanceEffect(info, PrefabType.IceDropEffect, 1.5, Vector3.New(ResetPosition.x, ResetPosition.y + 50, ResetPosition.z), function(req, tf)
    if not IsNull(tf) then
      local tarPos = Vector3.New(ResetPosition.x, ResetPosition.y + 1, ResetPosition.z)
      if self.tweens then
        self:RemoveTween(info.uuid)
      else
        self.tweens = {}
      end
      self.tweens[info.uuid] = self:AddTween(tf:DOLocalMove(tarPos, 1.5), info.uuid)
    end
  end)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:InstanceEffect(info, PrefabType.IceBoomEffect, 1, Vector3.New(ResetPosition.x, ResetPosition.y + 1.5, ResetPosition.z))
    self:RemoveBaseBuildEffect(info.uuid, PrefabType.IceDropEffect)
    self:RemoveTimer(info.uuid, PrefabType.IceBoomEffect)
  end, 1.4)
  self:AddEffectTimer(info.uuid, PrefabType.IceBoomEffect, timer)
end

local function AddZMDropEffectTimer(self, info)
  self:InstanceEffect(info, PrefabType.ZMMissileDropEffect, ZMDropDuration + 1, Vector3.New(ResetPosition.x, ResetPosition.y + 50, ResetPosition.z), function(req, tf)
    if not IsNull(tf) then
      local tarPos = Vector3.New(ResetPosition.x, ResetPosition.y + 1, ResetPosition.z)
      if self.tweens then
        self:RemoveTween(info.uuid)
      else
        self.tweens = {}
      end
      self.tweens[info.uuid] = self:AddTween(tf:DOLocalMove(tarPos, ZMDropDuration), info.uuid)
    end
  end, function()
    self:RemoveBaseBuildEffect(info.uuid, PrefabType.ZMMissileDropEffect)
  end)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:InstanceEffect(info, PrefabType.ZMMissileBoomEffect, 2, Vector3.New(ResetPosition.x, ResetPosition.y + 1.5, ResetPosition.z))
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_attack_down, false)
    self:RemoveTimer(info.uuid, PrefabType.ZMMissileBoomEffect)
  end, ZMDropDuration - 0.1)
  self:AddEffectTimer(info.uuid, PrefabType.ZMMissileBoomEffect, timer)
end

local function InstantiateAsync(self, path, parent, duration, pos, tItem, callback, finishCb)
  if not string.IsNullOrEmpty(path) then
    local req = CS.GameEntry.Resource:InstantiateAsync(path)
    req:completed("+", function(req)
      if req.isError then
        req:Destroy()
        return
      end
      if CS.SceneManager.CurrSceneID ~= SceneManagerSceneID.World then
        req:Destroy()
        return
      end
      local go = req.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      tf.parent = parent
      tf.localPosition = pos
      tf.localRotation = VecZero
      tf.localScale = ResetScale
      tf:Set_localRotation(0, 0, 0, 1)
      go:SetActive(true)
      if callback then
        callback(req, tf)
      end
      if duration and 0 < duration then
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          if finishCb then
            finishCb()
          end
        end, duration)
        if tItem then
          tItem.timer = timer
        end
      end
    end)
    return req
  end
end

local function AddTween(self, tween, uuid)
  if tween and uuid then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(tween)
    sequence:OnComplete(function()
      self:RemoveTween(uuid)
    end)
    return sequence
  end
end

local function RemoveTween(self, uuid)
  if uuid and self.tweens and self.tweens[uuid] then
    self.tweens[uuid]:Kill()
    self.tweens[uuid] = nil
  end
end

local function ClearTimers(self)
  if self.effectTimers then
    for i, v in pairs(self.effectTimers) do
      if v then
        for k, v1 in pairs(v) do
          if v1 then
            v1:Stop()
            self.effectTimers[i][k] = nil
          end
        end
      end
    end
  end
end

BaseBuildingEffectManager.BuildInViewSignal = BuildInViewSignal
BaseBuildingEffectManager.BuildOutViewSignal = BuildOutViewSignal
BaseBuildingEffectManager.AllianceWarDataInit = AllianceWarDataInit
BaseBuildingEffectManager.AllianceWarDataChange = AllianceWarDataChange
BaseBuildingEffectManager.ChangeCameraLodSignal = ChangeCameraLodSignal
BaseBuildingEffectManager.CheckBaseFrozenSelected = CheckBaseFrozenSelected
BaseBuildingEffectManager.AddFrozenSelectedTimer = AddFrozenSelectedTimer
BaseBuildingEffectManager.RemoveFrozenSelectedTimer = RemoveFrozenSelectedTimer
BaseBuildingEffectManager.CheckSelectEffectIsShow = CheckSelectEffectIsShow
BaseBuildingEffectManager.AddIceDropEffectTimer = AddIceDropEffectTimer
BaseBuildingEffectManager.InstantiateAsync = InstantiateAsync
BaseBuildingEffectManager.InstanceEffect = InstanceEffect
BaseBuildingEffectManager.AddEffectTimer = AddEffectTimer
BaseBuildingEffectManager.RemoveTimer = RemoveTimer
BaseBuildingEffectManager.AddTween = AddTween
BaseBuildingEffectManager.RemoveTween = RemoveTween
BaseBuildingEffectManager.ClearTimers = ClearTimers
BaseBuildingEffectManager.CheckBaseZMBossSelected = CheckBaseZMBossSelected
BaseBuildingEffectManager.AddZMSelectedTimer = AddZMSelectedTimer
BaseBuildingEffectManager.AddZMDropEffectTimer = AddZMDropEffectTimer
BaseBuildingEffectManager.RemoveZMSelectedTimer = RemoveZMSelectedTimer
return BaseBuildingEffectManager
