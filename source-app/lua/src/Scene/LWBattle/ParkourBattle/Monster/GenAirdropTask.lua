local GenAirdropTask = BaseClass("GenAirdropTask")
local Resource = CS.GameEntry.Resource
local airplaneSpeed = 2
local airplaneHeight = 10
local dropTime = 2
local startDropDelay = 3
local removeDelay = 3
local airplanePath = "Assets/_Art_LastWar/Models/Environment/Build/A_build_huangseyunshuji_01/prefab/huangseyunshuji_beizengmen.prefab"
local parachutePath = "Assets/_Art_LastWar/Models/Environment/Build/A_build_jiangluosan/prefab/aisila_jiangluosan.prefab"

function GenAirdropTask:__init(mgr, bornMeta)
  self.mgr = mgr
  self.bornMeta = bornMeta
  self.initDefenseOffsetZ = 0
  if mgr.logic and mgr.logic.defenseOffsetZ then
    self.initDefenseOffsetZ = mgr.logic.defenseOffsetZ
  end
  local splMon = string.split(bornMeta.monster, ",")
  self.monsterArr = {}
  for _, v in ipairs(splMon) do
    table.insert(self.monsterArr, tonumber(v))
  end
  self.bornCount = #self.monsterArr
  self.genNum = 0
  local offset = bornMeta.offset
  local startOffset = startDropDelay * airplaneSpeed + dropTime * airplaneSpeed
  self.airplaneStartPos = Vector3.New(bornMeta.x - startOffset, airplaneHeight, bornMeta.y + self.initDefenseOffsetZ)
  local offTime = offset / airplaneSpeed
  self.dropData = {}
  local time = startDropDelay
  for i = 1, self.bornCount do
    local drop = {}
    drop.delayTime = time
    drop.timer = 0
    drop.startPos = Vector3.New(bornMeta.x - dropTime * airplaneSpeed + offset * (i - 1), airplaneHeight, bornMeta.y + self.initDefenseOffsetZ)
    drop.endPos = Vector3.New(bornMeta.x + offset * (i - 1), 0, bornMeta.y + self.initDefenseOffsetZ)
    drop.removeTimer = removeDelay
    time = time + offTime
    table.insert(self.dropData, drop)
  end
  time = time + removeDelay
  self.dropTime = 0
  self.dropTotalTime = time
  self.airplaneReq = Resource:InstantiateAsync(airplanePath)
  self.airplaneReq:completed("+", function(handle)
    if handle.isError then
      return
    end
    self.airplaneTransform = handle.gameObject.transform
    self.airplaneTransform:Set_localEulerAngles(0, 90, 0)
    local x = self.dropTime * airplaneSpeed
    self.airplaneTransform:Set_localPosition(self.airplaneStartPos.x + x, airplaneHeight, self.airplaneStartPos.z)
    self.airplaneTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.airplaneTransformValid = true
    self.airplaneSoundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Buff_Heli_Fly_Loop, true)
  end)
end

function GenAirdropTask:__delete()
  if self.airplaneReq then
    self.airplaneReq:Destroy()
    self.airplaneReq = nil
  end
  if self.airplaneSoundId then
    DataCenter.LWSoundManager:StopSound(self.airplaneSoundId)
    self.airplaneSoundId = nil
  end
  if self.dropData then
    for i, drop in ipairs(self.dropData) do
      if drop then
        if drop.parachuteReq then
          drop.parachuteReq:Destroy()
          drop.parachuteReq = nil
        end
        drop.parachuteTransform = nil
        if drop.soundId then
          DataCenter.LWSoundManager:StopSound(drop.soundId)
          drop.soundId = nil
        end
      end
    end
    self.dropData = nil
  end
  self.monsterArr = nil
  self.dropData = nil
end

function GenAirdropTask:Update(deltaTime)
  self.dropTime = self.dropTime + deltaTime
  if self.dropTime >= self.dropTotalTime then
    self.mgr:RemoveTask(self)
    return
  end
  if self.airplaneTransformValid then
    local x = self.dropTime * airplaneSpeed
    self.airplaneTransform:Set_localPosition(self.airplaneStartPos.x + x, airplaneHeight, self.airplaneStartPos.z)
  end
  for i, drop in ipairs(self.dropData) do
    if self.dropTime > drop.delayTime then
      if drop.timer < dropTime then
        local ext = self.dropTime - drop.delayTime
        drop.timer = ext
        if drop.monsterGuid == nil then
          local monsterId = self.monsterArr[i]
          local m = self.mgr:CreateMonster(drop.endPos.x, drop.endPos.z, monsterId)
          if m then
            drop.monsterGuid = m.guid
            m:SetLocalPosition(drop.startPos)
            m:Load()
            m:SetAirDropping(true)
            self.mgr:AddShowList(m)
          end
          if drop.parachuteReq == nil then
            drop.parachuteReq = Resource:InstantiateAsync(parachutePath)
            drop.parachuteReq:completed("+", function(handle)
              if handle.isError then
                return
              end
              drop.parachuteTransform = handle.gameObject.transform
              drop.parachuteTransform:Set_localScale(1, 1, 1)
              drop.parachuteTransform:Set_localEulerAngles(0, 0, 0)
              local curP = Vector3.Lerp(drop.startPos, drop.endPos, drop.timer / dropTime)
              drop.parachuteTransform:Set_localPosition(curP.x, curP.y, curP.z)
              curP:ReturnPool()
              drop.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Battle_Buff_Heli_Fly_Drop, false)
            end)
          end
        else
          local curP = Vector3.Lerp(drop.startPos, drop.endPos, drop.timer / dropTime)
          local m = self.mgr:GetMonster(drop.monsterGuid)
          if m then
            m:SetLocalPosition(curP)
          end
          if drop.parachuteTransform then
            drop.parachuteTransform:Set_localPosition(curP.x, curP.y, curP.z)
          end
          curP:ReturnPool()
        end
        if drop.timer >= dropTime then
          local m = self.mgr:GetMonster(drop.monsterGuid)
          if m then
            m:SetAirDropping(false)
            m:SetForceUpdateReversePos()
          end
        end
      end
    elseif drop.removeTimer > 0 then
      drop.removeTimer = drop.removeTimer - deltaTime
      if drop.removeTimer <= 0 then
        if drop.parachuteReq then
          drop.parachuteReq:Destroy()
          drop.parachuteReq = nil
        end
        drop.parachuteTransform = nil
        if drop.soundId then
          DataCenter.LWSoundManager:StopSound(drop.soundId)
          drop.soundId = nil
        end
      end
    end
  end
end

return GenAirdropTask
