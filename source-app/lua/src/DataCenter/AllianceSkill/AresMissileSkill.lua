local AresMissileSkill = BaseClass("AresMissileSkill")
local Localization = CS.GameEntry.Localization
local SuperTextMesh = typeof(CS.SuperTextMesh)
local SimpleAnimation = typeof(CS.SimpleAnimation)
local TypeParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local UIAresMissileEnergyItem = require("UI.UIActivityCenterTable.Component.KillZombie.Scene.UIAresMissileEnergyItem")

function AresMissileSkill:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
  self.energySkill = nil
  self.skillEnergyItemHandle = nil
  self.skillEnergyItem = nil
end

function AresMissileSkill:OnDestroy()
  if self.delay6 then
    self.delay6:Stop()
    self.delay6 = nil
  end
  if self.delay10 then
    self.delay10:Stop()
    self.delay10 = nil
  end
  self.energySkill = nil
  if self.skillEnergyItemHandle then
    self.skillEnergyItemHandle:Destroy()
    self.skillEnergyItemHandle = nil
  end
  if self.skillEnergyItem then
    self.skillEnergyItem:Delete()
    self.skillEnergyItem = nil
  end
end

function AresMissileSkill:ReInit(uuid, fireTime, skillId)
  self.uuid = uuid
  self.skillId = skillId
  self.fireTime = toInt(fireTime) - 10000
  self.playAnim = false
  if self.gameObject then
    self.TimeRoot = self.gameObject.transform:Find("ModelGo/CityLabel/TimeLabel")
    if skillId == 20001 then
      if self.TimeRoot then
        self.TimeRoot.gameObject:SetActive(false)
      end
      self.energySkill = true
      self:ShowSkillEnergy()
    else
      self.energySkill = false
      if self.skillEnergyItem then
        self.skillEnergyItem:SetActive(false)
      end
      if self.TimeRoot then
        self.TimeRoot.gameObject:SetActive(true)
        self.TimeText = self.TimeRoot.transform:Find("TimeText"):GetComponent(SuperTextMesh)
      end
    end
  end
  self:Update()
end

function AresMissileSkill:OnUpdatePoint()
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
  self.fireTime = toInt(info.aosEndTime or 0) - 10000
  if self.energySkill and self.skillEnergyItem then
    self.skillEnergyItem:Refresh(info)
  end
  self:Update()
end

function AresMissileSkill:Update(theWorld)
  if self.playAnim then
    if self.energySkill then
      if self.skillEnergyItem then
        self.skillEnergyItem:SetActive(false)
      end
    elseif self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.fireTime and now >= self.fireTime then
    self.playAnim = true
    if self.energySkill then
      if self.skillEnergyItem then
        self.skillEnergyItem:SetActive(false)
      end
    elseif self.TimeRoot then
      self.TimeRoot.gameObject:SetActive(false)
    end
    if not IsNull(self.gameObject) then
      local skin = self.gameObject.transform:Find("ModelGo/Normal/AresMissile/skin")
      if skin then
        do
          local simAnim = skin:GetComponent(SimpleAnimation)
          simAnim.enabled = true
          if simAnim:IsPlaying("attack") then
            simAnim:Rewind("attack")
          else
            simAnim:Stop()
            simAnim:Play("attack")
          end
          DataCenter.LWSoundManager:PlaySound(SoundAssetId.s2_ares_missile_ignites, false)
          local eff1 = self.gameObject.transform:Find("ModelGo/Normal/AresMissile/skin/To_unity/Root/Eff_daditu_zhanshenfeidan_01")
          local eff2 = self.gameObject.transform:Find("ModelGo/Normal/AresMissile/skin/To_unity/Root/huojian/Eff_daditu_zhanshenfeidan_02")
          local eff3 = self.gameObject.transform:Find("ModelGo/Normal/AresMissile/skin/To_unity/Root/Eff_daditu_zhanshenfeidan_03")
          if eff1 then
            eff1.gameObject:SetActive(true)
          end
          if eff2 then
            eff2.gameObject:SetActive(true)
          end
          if eff3 then
            eff3.gameObject:SetActive(true)
          end
          self.delay6 = TimerManager:GetInstance():DelayInvoke(function()
            if IsNull(self.gameObject) then
              return
            end
            if not IsNull(skin) then
              if simAnim:IsPlaying("down") then
                simAnim:Rewind("down")
              else
                simAnim:Play("down")
              end
            end
            if not IsNull(eff1) then
              eff1.gameObject:SetActive(false)
            end
            if not IsNull(eff2) then
              eff2.gameObject:SetActive(false)
            end
            if not IsNull(eff3) then
              eff3.gameObject:SetActive(false)
            end
            if IsNull(skin) then
              return
            end
            local eff4 = self.gameObject.transform:Find("ModelGo/Normal/AresMissile/skin/To_unity/Root/Eff_daditu_zhanshenfeidan_04")
            if eff4 then
              eff4.gameObject:SetActive(true)
              local tps = eff4:GetComponent(TypeParticleSystem)
              if tps then
                tps:Play()
              end
            end
            self.delay10 = TimerManager:GetInstance():DelayInvoke(function()
              if IsNull(self.gameObject) then
                return
              end
              if not IsNull(eff4) then
                eff4.gameObject:SetActive(false)
              end
              local obj = CS.SceneManager.World:GetObjectByUuid(self.uuid)
              if obj ~= nil then
                obj:UpdateGameObject()
              end
            end, 4.5)
          end, 6)
        end
      end
    end
  elseif self.fireTime then
    local remainTime = self.fireTime - now
    if self.energySkill then
      if self.skillEnergyItem then
        self.skillEnergyItem:RefreshTime(remainTime)
      end
    elseif self.TimeText then
      self.TimeText.text = Localization:GetString("2010331", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    end
  end
end

function AresMissileSkill:OnLodChange(lod)
  self.theLod = toInt(lod)
end

function AresMissileSkill:UpdateFireTime(info)
  if info and info.aosEndTime then
    self.fireTime = toInt(info.aosEndTime) - 10000
  end
end

local function ShowSkillEnergy(self)
  if self.uuid == nil then
    return
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if info == nil or info.PointType ~= WorldPointType.PlayerBuilding then
    return
  end
  if self.skillEnergyItem then
    self.skillEnergyItem:Refresh(info)
    return
  end
  if self.skillEnergyItemHandle then
    return
  end
  local skillEnergyItemHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/UIAresMissileEnergy.prefab")
  skillEnergyItemHandle:completed("+", function(handle)
    local item
    local ok, msg = xpcall(function()
      local trans = handle.gameObject.transform
      item = UIAresMissileEnergyItem.New(info, handle.gameObject)
      trans:SetParent(UIManager:GetInstance():GetLayer(UILayer.World.Name).transform)
      trans.position = self.gameObject.transform.position
    end, debug.traceback)
    if ok and item ~= nil then
      self.skillEnergyItem = item
    else
      Logger.LogError(msg)
      ok, msg = xpcall(function()
        if item ~= nil then
          item:Dispose()
        end
      end, debug.traceback)
      if not ok and handle and not IsNull(handle.gameObject) then
        handle.gameObject:SetActive(false)
      end
    end
  end)
  self.skillEnergyItemHandle = skillEnergyItemHandle
end

AresMissileSkill.ShowSkillEnergy = ShowSkillEnergy
return AresMissileSkill
