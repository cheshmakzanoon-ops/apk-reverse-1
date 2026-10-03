local GoddessMummySummoner = BaseClass("GoddessMummySummoner")
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local SimpleAnimation = typeof(CS.SimpleAnimation)
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local DEAD_ANIM_LENGTH = 4

function GoddessMummySummoner:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
end

function GoddessMummySummoner:OnDestroy()
  if self.delay4 then
    self.delay4:Stop()
    self.delay4 = nil
  end
end

function GoddessMummySummoner:ReInit(uuid, fireTime)
  self.uuid = uuid
  self.fireTime = toInt(fireTime) - DEAD_ANIM_LENGTH * 1000
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

function GoddessMummySummoner:UpdateFireTime(info)
  if info and info.aosEndTime then
    self.fireTime = toInt(info.aosEndTime) - DEAD_ANIM_LENGTH * 1000
  end
end

function GoddessMummySummoner:OnUpdatePoint()
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
  self.fireTime = toInt(info.aosEndTime or 0) - DEAD_ANIM_LENGTH * 1000
  self:Update()
end

function GoddessMummySummoner:Update()
  if self.playAnim then
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.fireTime and now >= self.fireTime then
    self.playAnim = true
    if self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    if not IsNull(self.gameObject) then
      local skin = self.gameObject.transform:Find("ModelGo/Normal/GoddessMummy/skin")
      if skin then
        local simAnim = skin:GetComponent(SimpleAnimation)
        simAnim.enabled = true
        if simAnim:IsPlaying("death") then
          simAnim:Rewind("death")
        else
          simAnim:Stop()
          simAnim:Play("death")
        end
        local theWorld = CS.SceneManager.World
        if theWorld and theWorld.CreateVFX then
          theWorld:CreateVFX("Assets/Main/SeasonRes/S3/Prefabs/S3_zhaohuanshenxiang/Eff_ljw_S3_A_bulid_zhaohuanshenxiang_death.prefab", skin.position, 5)
          local firePoint = skin:Find("To_unity/DeformationSystem/Root/ditai/wuqi/wuqi1")
          if firePoint then
            theWorld:CreateVFX("Assets/Main/SeasonRes/S3/Prefabs/S3_zhaohuanshenxiang/Eff_ljw_S3_A_bulid_zhaohuanshenxiang_death_wuqi.prefab", firePoint.position, 3)
          end
        end
        local atkLoopVFX = skin:Find("To_unity/DeformationSystem/Root/Eff_ljw_S3_A_bulid_zhaohuanshenxiang_attack_ioop")
        local weaponLoopVFX = skin:Find("To_unity/DeformationSystem/Root/ditai/wuqi/wuqi1/Eff_ljw_S3_A_bulid_zhaohuanshenxiang_attack_wuqi_loop")
        if atkLoopVFX then
          atkLoopVFX.gameObject:SetActive(false)
        end
        if weaponLoopVFX then
          weaponLoopVFX.gameObject:SetActive(false)
        end
        self.delay4 = TimerManager:GetInstance():DelayInvoke(function()
          if IsNull(self.gameObject) then
            return
          end
          local obj = CS.SceneManager.World:GetObjectByUuid(self.uuid)
          if obj ~= nil then
            obj:UpdateGameObject()
          end
        end, DEAD_ANIM_LENGTH)
      end
    end
  elseif self.fireTime then
    local remainTime = self.fireTime - now
    if self.TimeText then
      self.TimeText.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    end
  end
end

function GoddessMummySummoner:OnLodChange(lod)
  self.theLod = toInt(lod)
end

return GoddessMummySummoner
