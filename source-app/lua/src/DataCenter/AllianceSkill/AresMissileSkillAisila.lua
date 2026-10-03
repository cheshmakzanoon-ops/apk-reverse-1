local AresMissileSkillAisila = BaseClass("AresMissileSkillAisila")
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local SimpleAnimation = typeof(CS.SimpleAnimation)
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

function AresMissileSkillAisila:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
end

function AresMissileSkillAisila:OnDestroy()
  if self.delay6 then
    self.delay6:Stop()
    self.delay6 = nil
  end
  if self.delay10 then
    self.delay10:Stop()
    self.delay10 = nil
  end
end

function AresMissileSkillAisila:ReInit(uuid, fireTime, skillId)
  self.uuid = uuid
  self.skillId = skillId
  self.fireTime = toInt(fireTime) - 3000
  self.playAnim = false
  if self.gameObject then
    self.TimeRoot = self.gameObject.transform:Find("ModelGo/CityLabel/TimeLabel")
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(true)
      self.TimeText = self.TimeRoot.transform:Find("TimeText"):GetComponent(SuperTextMesh)
    end
  end
  self:Update()
end

function AresMissileSkillAisila:OnUpdatePoint()
  if self.playAnim then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil or self.fireTime == nil then
    return
  end
  local info = theWorld:GetPointInfoByUuid(self.uuid)
  if info == nil or info.PointType ~= WorldPointType.PlayerBuilding then
    return
  end
  self.fireTime = toInt(info.aosEndTime or 0) - 3000
  self:Update()
end

function AresMissileSkillAisila:UpdateGameObject()
  if IsNotNull(self.gameObject) and IsNull(self.simAnim) then
    local skin_path = "ModelGo/Normal/AresMissile/A_Build@aisila01_skin"
    local skin = self.gameObject.transform:Find(skin_path)
    if skin then
      local simAnim = skin:GetComponent(SimpleAnimation)
      simAnim.enabled = true
      self.simAnim = simAnim
    end
  end
end

function AresMissileSkillAisila:Update(theWorld)
  if self.playAnim then
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  self:UpdateGameObject()
  if self.fireTime and now >= self.fireTime then
    local simAnim = self.simAnim
    if IsNotNull(self.simAnim) then
      self.playAnim = true
      if simAnim:IsPlaying("attack01") then
        simAnim:Rewind("attack01")
      else
        simAnim:Play("attack01")
      end
      if IsNotNull(self.eff_loop) then
        self.eff_loop.gameObject:SetActive(false)
      else
        local loop_head_path = "ModelGo/Normal/AresMissile/A_Build@aisila01_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Neck0_M/Head_M/Eff_S4_Mars_Loop_Head_M"
        local eff_loop = self.gameObject.transform:Find(loop_head_path)
        if eff_loop then
          eff_loop.gameObject:SetActive(false)
        end
      end
      do
        local fly_root_path = "ModelGo/Normal/AresMissile/A_Build@aisila01_skin/To_unity/DeformationSystem/Root/Eff_S4_Mars_Fly_Root"
        local eff_fly = self.gameObject.transform:Find(fly_root_path)
        if eff_fly then
          eff_fly.gameObject:SetActive(true)
        end
        local theUuid = self.uuid
        self.delay6 = TimerManager:GetInstance():DelayInvoke(function()
          if IsNotNull(eff_fly) then
            eff_fly.gameObject:SetActive(false)
          end
          if IsNotNull(self.eff_loop) then
            self.eff_loop.gameObject:SetActive(false)
          end
          if IsNotNull(self.simAnim) then
            if simAnim:IsPlaying("attack02") then
              simAnim:Rewind("attack02")
            else
              simAnim:Play("attack02")
            end
            simAnim:PlayQueued("dead")
          end
          self.delay10 = TimerManager:GetInstance():DelayInvoke(function()
            if IsNull(self.gameObject) then
              return
            end
            local _world = CS.SceneManager.World
            if _world ~= nil then
              local obj = _world:GetObjectByUuid(theUuid)
              if obj ~= nil then
                obj:Destroy()
                obj:CreateGameObject()
                local info = _world:GetPointInfoByUuid(theUuid)
                if info ~= nil and info.PointType == WorldPointType.PlayerBuilding then
                  local curServerId = LuaEntry.Player:GetCurServerId()
                  local prefabName = "Assets/_Art/Effect/prefab/scene/Build/Dabenqianyi/VFX_world_zhucheng_qianyi_hui.prefab"
                  local worldPos = SceneUtils.TileIndexToWorld(info.mainIndex, ForceChangeScene.World, curServerId)
                  _world:CreateBattleVFX(prefabName, 3.5, function(go)
                    go.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
                  end)
                end
              end
            end
          end, 8)
        end, 0.5)
      end
    end
  elseif self.fireTime then
    local remainTime = self.fireTime - now
    if remainTime < 0 then
      remainTime = 0
    end
    if self.TimeText then
      self.TimeText.text = Localization:GetString("2010331", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    end
    if IsNotNull(self.gameObject) and IsNotNull(self.simAnim) and IsNull(self.eff_loop) then
      local simAnim = self.simAnim
      if simAnim:IsPlaying("idle") or simAnim:IsPlaying("attack") then
        local loop_head_path = "ModelGo/Normal/AresMissile/A_Build@aisila01_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Neck0_M/Head_M/Eff_S4_Mars_Loop_Head_M"
        local eff_loop = self.gameObject.transform:Find(loop_head_path)
        if eff_loop then
          if eff_loop.gameObject.activeSelf then
          else
            eff_loop.gameObject:SetActive(true)
          end
          self.eff_loop = eff_loop
        end
      end
    end
  end
end

function AresMissileSkillAisila:OnLodChange(lod)
  self.theLod = toInt(lod)
end

return AresMissileSkillAisila
