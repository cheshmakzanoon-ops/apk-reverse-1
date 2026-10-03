local BaseBuildingBossSkillEffectCtrl = BaseClass("BaseBuildingBossSkillEffectCtrl")
local ResourceManager = CS.GameEntry.Resource
local DOTween = CS.DG.Tweening.DOTween

function BaseBuildingBossSkillEffectCtrl:__init()
  self.allEffect = {}
  self.effectShow = false
  self.effectTimers = {}
  self.tweens = {}
end

function BaseBuildingBossSkillEffectCtrl:__delete()
  self:ClearEffects()
  self:ClearTimers()
  self:ClearTweens()
  self.effectShow = nil
  self.allEffect = nil
  self.effectTimers = nil
  self.tweens = nil
end

function BaseBuildingBossSkillEffectCtrl:OnWorldBaseEffectRefresh(info)
  if info ~= nil then
    self:CheckBaseBossAttacked(info)
  end
end

function BaseBuildingBossSkillEffectCtrl:OnCameraChangeLod(show)
  if show ~= self.effectShow then
    self.effectShow = show
    if self.allEffect ~= nil then
      for _, v in pairs(self.allEffect) do
        for _, v1 in pairs(v) do
          if v1 and not IsNull(v1.effectObj) then
            v1.effectObj:SetActive(show)
          end
        end
      end
    end
  end
end

function BaseBuildingBossSkillEffectCtrl:DeleteAllEffect()
  self:ClearEffects()
  self:ClearTimers()
  self:ClearTweens()
  self.allEffect = {}
  self.effectTimers = {}
  self.tweens = {}
end

local function CheckBaseBossAttacked(self, info)
  if info then
    if info.commonMonsterSkillInfo then
      local detailInfoList = info.commonMonsterSkillInfo.detailInfo
      if IsNotNull(detailInfoList) and detailInfoList.Count > 0 then
        local count = detailInfoList.Count
        local now = UITimeManager:GetInstance():GetServerTime()
        for i = 0, count - 1 do
          local detailInfo = detailInfoList[i]
          if detailInfo then
            self:AddSkillEffect(info, detailInfo, now)
          end
        end
      end
    else
      self:RemoveBaseEffect(info.uuid)
    end
  end
end

local function AddSkillEffect(self, info, detailInfo, curTs)
  if info and detailInfo then
    local endTs = detailInfo.AimEndTime
    if curTs == nil then
      curTs = UITimeManager:GetInstance():GetServerTime()
    end
    local skillId = detailInfo.SkillId
    if skillId == nil then
      return
    end
    local line = LocalController:instance():getLine(TableName.CommonBossSkill, skillId)
    if line == nil then
      return
    end
    local preTime = line.attack_pre_time
    local path = line.select_effect
    local delay = endTs - curTs
    delay = delay / 1000 - preTime
    if 0 < delay then
      if self:CheckSelectEffectIsShow(info.uuid, skillId, path) then
        self:AddBossSelectedTimer(info.uuid, skillId, path, delay, line)
        return
      end
      self:AddBossSelectedEffect(info, skillId, line, delay)
      return
    end
  end
end

local function RemoveBaseEffect(self, uuid)
  if uuid then
    if self.allEffect and self.allEffect[uuid] then
      for k, v in pairs(self.allEffect[uuid]) do
        if v then
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
              self.allEffect[uuid][k][k1] = nil
            end
          end
          self.allEffect[uuid][k] = nil
        end
      end
      self.allEffect[uuid] = nil
    end
    if self.effectTimers and self.effectTimers[uuid] then
      for k, v in pairs(self.effectTimers[uuid]) do
        if v then
          for k1, v1 in pairs(v) do
            v1:Stop()
            self.effectTimers[uuid][k][k1] = nil
          end
          self.effectTimers[uuid][k] = nil
        end
      end
      self.effectTimers[uuid] = nil
    end
    if self.tweens and self.tweens[uuid] then
      for k, v in pairs(self.tweens[uuid]) do
        if v then
          for k1, v1 in pairs(v) do
            if v1 then
              v1:Kill()
              self.tweens[uuid][k][k1] = nil
            end
          end
          self.tweens[uuid][k] = nil
        end
      end
      self.tweens[uuid] = nil
    end
  end
end

local function CheckSelectEffectIsShow(self, uuid, skillId, prefabName)
  local data = uuid and self.allEffect and self.allEffect[uuid]
  if data and data[skillId] and data[skillId][prefabName] then
    return true
  end
  return false
end

local function AddBossSelectedTimer(self, uuid, skillId, path, delay, line)
  if uuid and skillId and path and line then
    delay = delay or 0
    self:RemoveTimer(uuid, skillId, path)
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveEffect(uuid, skillId, path)
      self:RemoveTimer(uuid, skillId, path)
      self:AddBossDropEffectTimer(info, skillId, line)
    end, delay)
    self:AddEffectTimer(uuid, skillId, path, timer)
  end
end

local function AddBossSelectedEffect(self, info, skillId, line, delay)
  if info and skillId and line and delay then
    local path = line.select_effect
    local uuid = info.uuid
    if path == nil then
      return
    end
    self:RemoveTimer(uuid, skillId, path)
    self:InstanceEffect(info, skillId, path)
    local timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveEffect(uuid, skillId, path)
      self:RemoveTimer(uuid, skillId, path)
      self:AddBossDropEffectTimer(info, skillId, line)
    end, delay)
    self:AddEffectTimer(uuid, skillId, path, timer)
  end
end

local function AddBossDropEffectTimer(self, info, skillId, line)
  if info and skillId and line then
    local uuid = info.uuid
    local path = line.fall_client_effect
    if path == nil then
      return
    end
    local dropDuration = line.drop_effect_duration or 0
    self:InstanceEffect(info, skillId, path, dropDuration + 1, Vector3.New(0, 50, 0), function(req, tf)
      if IsNotNull(tf) then
        local tarPos = Vector3.New(0, 1, 0)
        self:AddTween(uuid, skillId, path, tf:DOLocalMove(tarPos, dropDuration))
      end
    end, function()
      self:RemoveEffect(uuid, skillId, path)
    end)
    local boomPath = line.hit_client_effect
    local soundId = line.hit_sound_effect
    if boomPath then
      do
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          self:InstanceEffect(info, skillId, boomPath, 2, Vector3.New(0, 1.5, 0))
          if soundId then
            DataCenter.LWSoundManager:PlaySound(soundId, false)
          end
          self:RemoveTimer(uuid, skillId, boomPath)
        end, dropDuration + 0.1)
        self:AddEffectTimer(uuid, skillId, boomPath, timer)
      end
    end
  end
end

local function AddEffectTimer(self, uuid, skillId, path, timer)
  if uuid == nil or skillId == nil or string.IsNullOrEmpty(path) or timer == nil then
    return
  end
  if not self.effectTimers then
    self.effectTimers = {
      [uuid] = {
        [skillId] = {
          [path] = timer
        }
      }
    }
  elseif not self.effectTimers[uuid] then
    self.effectTimers[uuid] = {
      [skillId] = {
        [path] = timer
      }
    }
  elseif not self.effectTimers[uuid][skillId] then
    self.effectTimers[uuid][skillId] = {
      [path] = timer
    }
  elseif not self.effectTimers[uuid][skillId][path] then
    self.effectTimers[uuid][skillId][path] = timer
  else
    self.effectTimers[uuid][skillId][path]:Stop()
    self.effectTimers[uuid][skillId][path] = timer
  end
end

local function RemoveTimer(self, uuid, skillId, path)
  if self.effectTimers and uuid and path and self.effectTimers[uuid] and self.effectTimers[uuid][skillId] and self.effectTimers[uuid][skillId][path] then
    self.effectTimers[uuid][skillId][path]:Stop()
    self.effectTimers[uuid][skillId][path] = nil
  end
end

local function AddTween(self, uuid, skillId, key, tween)
  if uuid and key and tween then
    local sequence = DOTween.Sequence()
    sequence:Append(tween)
    sequence:OnComplete(function()
      self:RemoveTween(uuid, skillId, key)
    end)
    if self.tweens == nil then
      self.tweens = {
        [uuid] = {
          [skillId] = {
            [key] = sequence
          }
        }
      }
    elseif self.tweens[uuid] == nil then
      self.tweens[uuid] = {
        [skillId] = {
          [key] = sequence
        }
      }
    elseif self.tweens[uuid][skillId] == nil then
      self.tweens[uuid][skillId] = {
        [key] = sequence
      }
    elseif self.tweens[uuid][skillId][key] == nil then
      self.tweens[uuid][skillId][key] = sequence
    else
      self.tweens[uuid][skillId][key]:Kill()
      self.tweens[uuid][skillId][key] = sequence
    end
  end
end

local function RemoveTween(self, uuid, skillId, key)
  if uuid and skillId and key and self.tweens ~= nil and self.tweens[uuid] ~= nil and self.tweens[uuid][skillId] ~= nil and self.tweens[uuid][skillId][key] ~= nil then
    self.tweens[uuid][skillId][key]:Kill()
    self.tweens[uuid][skillId][key] = nil
  end
end

local function ClearEffects(self)
  if self.allEffect then
    for k, v in pairs(self.allEffect) do
      for k1, v1 in pairs(v) do
        if v1 then
          for k2, v2 in pairs(v1) do
            if v2.request then
              v2.request:Destroy()
              v2.request = nil
            end
            if v2.timer then
              v2.timer:Stop()
              v2.timer = nil
            end
            v2.ownerUid = nil
            v2.effectObj = nil
            self.allEffect[k][k1][k2] = nil
          end
          self.allEffect[k][k1] = nil
        end
      end
      self.allEffect[k] = nil
    end
  end
end

local function ClearTimers(self)
  if self.effectTimers then
    for k, v in pairs(self.effectTimers) do
      if v then
        for k1, v1 in pairs(v) do
          if v1 then
            for k2, v2 in pairs(v1) do
              v2:Stop()
              self.effectTimers[k][k1][k2] = nil
            end
            self.effectTimers[k][k1] = nil
          end
        end
        self.effectTimers[k] = nil
      end
    end
  end
end

local function ClearTweens(self)
  if self.tweens then
    for k, v in pairs(self.tweens) do
      if v then
        for k1, v1 in pairs(v) do
          if v1 then
            for k2, v2 in pairs(v1) do
              v2:Kill()
              self.tweens[k][k1][k2] = nil
            end
            self.tweens[k][k1] = nil
          end
        end
        self.tweens[k] = nil
      end
    end
  end
end

local function InstanceEffect(self, info, skillId, path, duration, pos, callback, finishCb)
  if info == nil or skillId == nil or path == nil then
    return
  end
  local uuid = info.uuid
  local data
  if self.allEffect == nil then
    data = {}
    self.allEffect = {
      [uuid] = {
        [skillId] = data
      }
    }
  elseif self.allEffect[uuid] == nil then
    data = {}
    self.allEffect[uuid] = {
      [skillId] = data
    }
  elseif self.allEffect[uuid][skillId] == nil then
    data = {}
    self.allEffect[uuid][skillId] = data
  else
    data = self.allEffect[uuid][skillId]
  end
  if not string.IsNullOrEmpty(path) then
    self:RemoveEffect(uuid, skillId, path)
    if IsNotNull(CS.SceneManager.World) then
      local build = CS.SceneManager.World:GetWorldBuildingByUuid(uuid)
      if build and IsNotNull(build.gameObject) then
        local parent = build.gameObject.transform:Find("ModelGo/Normal")
        if IsNotNull(parent) then
          local tItem = {}
          local request = self:InstantiateAsync(path, parent, duration, pos, tItem, callback, function()
            if finishCb then
              finishCb()
            end
            self:RemoveEffect(uuid, skillId, path)
          end)
          tItem.request = request
          tItem.ownerUid = info.ownerUid
          tItem.effectObj = request.gameObject
          data[path] = tItem
        end
      end
    end
  end
end

local function RemoveEffect(self, uuid, skillId, path)
  if self.allEffect and self.allEffect[uuid] and self.allEffect[uuid][skillId] and self.allEffect[uuid][skillId][path] then
    local effect = self.allEffect[uuid][skillId][path]
    if effect.request then
      effect.request:Destroy()
      effect.request = nil
    end
    if effect.timer then
      effect.timer:Stop()
      effect.timer = nil
    end
    effect.ownerUid = nil
    effect.effectObj = nil
    self.allEffect[uuid][skillId][path] = nil
  end
end

local function InstantiateAsync(self, path, parent, duration, pos, tItem, callback, finishCb)
  if not string.IsNullOrEmpty(path) then
    local request = CS.GameEntry.Resource:InstantiateAsync(path)
    request:completed("+", function(req)
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
      pos = pos or ResetPosition
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
    return request
  end
end

BaseBuildingBossSkillEffectCtrl.CheckSelectEffectIsShow = CheckSelectEffectIsShow
BaseBuildingBossSkillEffectCtrl.AddEffectTimer = AddEffectTimer
BaseBuildingBossSkillEffectCtrl.RemoveTimer = RemoveTimer
BaseBuildingBossSkillEffectCtrl.AddTween = AddTween
BaseBuildingBossSkillEffectCtrl.RemoveTween = RemoveTween
BaseBuildingBossSkillEffectCtrl.CheckBaseBossAttacked = CheckBaseBossAttacked
BaseBuildingBossSkillEffectCtrl.AddSkillEffect = AddSkillEffect
BaseBuildingBossSkillEffectCtrl.RemoveBaseEffect = RemoveBaseEffect
BaseBuildingBossSkillEffectCtrl.AddBossSelectedTimer = AddBossSelectedTimer
BaseBuildingBossSkillEffectCtrl.AddBossSelectedEffect = AddBossSelectedEffect
BaseBuildingBossSkillEffectCtrl.AddBossDropEffectTimer = AddBossDropEffectTimer
BaseBuildingBossSkillEffectCtrl.ClearEffects = ClearEffects
BaseBuildingBossSkillEffectCtrl.ClearTimers = ClearTimers
BaseBuildingBossSkillEffectCtrl.ClearTweens = ClearTweens
BaseBuildingBossSkillEffectCtrl.InstanceEffect = InstanceEffect
BaseBuildingBossSkillEffectCtrl.RemoveEffect = RemoveEffect
BaseBuildingBossSkillEffectCtrl.InstantiateAsync = InstantiateAsync
return BaseBuildingBossSkillEffectCtrl
