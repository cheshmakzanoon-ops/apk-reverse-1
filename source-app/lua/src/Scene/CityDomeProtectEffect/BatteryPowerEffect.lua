local base = UIAsyncNode
local BatteryPowerEffect = BaseClass("BatteryPowerEffect", base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local icon_status_path = "num/iconArmy"
local txt_level_path = "num/txtArmyCount"
local image_path = "num/add/Image"
local add_count_path = "num/add/Image/addCount"
local item_icon_path = "num/add/Image/ItemIconBg/ItemIcon"

function BatteryPowerEffect:OnCreate()
  base.OnCreate(self)
  local transform = self.transform
  if IsNull(transform) then
    return
  end
  transform:Set_localScale(1, 1, 1)
  transform:Set_localPosition(0, 3, 0)
  self.anim = transform:Find("num"):GetComponent(typeof(CS.SimpleAnimation))
  self.icon_status = transform:Find(icon_status_path):GetComponent(typeof(SpriteRenderer))
  self.txt_level = transform:Find(txt_level_path):GetComponent(typeof(SuperTextMesh))
  self.animAddCount = transform:Find(add_count_path):GetComponent(typeof(SuperTextMesh))
  self.animAddIcon = transform:Find(item_icon_path):GetComponent(typeof(SpriteRenderer))
  if self.lod == nil then
    self.lod = 1
  end
end

function BatteryPowerEffect:OnDestroy()
  self.lod = 7
  self.effect_path = nil
  self.theModelPos = nil
  if self.light_effect then
    self.light_effect:Delete()
    self.light_effect = nil
  end
  base.OnDestroy(self)
end

function BatteryPowerEffect:ReInit(uuid, lightHouseInfo, theModelPos, lod, ownerUid, pointId)
  local oldBrightness = 0
  local oldPowerSpeed = 0
  if self.lightHouseInfo then
    oldBrightness = toInt(self.lightHouseInfo.Brightness)
    oldPowerSpeed = toInt(self.lightHouseInfo.PowerSpeed)
  end
  self.lod = toInt(lod)
  self.pointId = pointId
  self.lightHouseInfo = lightHouseInfo
  self.ownerUid = ownerUid
  self.myself = ownerUid == LuaEntry.Player.uid
  self.theUuid = uuid or ""
  self.Update1000MS = nil
  if theModelPos then
    self.theModelPos = theModelPos
  end
  if self.myself then
    function self.Update1000MS()
      if self.myself and self.lightHouseInfo then
        local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
        
        if lightHouseStatus then
          self.lightHouseInfo.CurrPower = lightHouseStatus.power or 0
          self.lightHouseInfo.PowerSpeed = lightHouseStatus.speed or 0
          self.lightHouseInfo.Brightness = lightHouseStatus.brightnessLevel or 0
          self.lightHouseInfo.PowerUpdateTime = lightHouseStatus.syncTime or 0
        end
        self:UpdateData()
      end
    end
  end
  if self:AsyncLoadDone() then
    self:UpdateData()
  end
end

function BatteryPowerEffect:OnCameraChangeLod(lod)
  if self.gameObject == nil or IsNull(self.gameObject) then
    return
  end
  self.lod = toInt(lod)
  if self.lod >= 3 then
    if self.light_effect then
      self.light_effect:Delete()
      self.light_effect = nil
    end
  elseif self.theUuid ~= nil and self.effect_path ~= nil and self.light_effect == nil and self.theModelPos ~= nil and DisplaySettings.ShowMummyMarchEffect() then
    local theWorld = CS.SceneManager.World
    if theWorld then
      local v3Pos = self.theModelPos
      self.light_effect = UIAsyncNode.New("eff_light" .. self.theUuid, theWorld.DynamicObjNode.transform, self.effect_path, function(go)
        if IsNotNull(go) then
          go.transform:Set_localPosition(v3Pos.x, v3Pos.y, v3Pos.z)
        end
      end)
    end
  end
end

function BatteryPowerEffect:UpdateDataByPush(data, myself)
  if self.lightHouseInfo == nil then
    return
  end
  local anim_name = "Default"
  if data and data.updateType == LightHouseUpdateType.OTHER_WORKER_ARRIVE then
    local _, _, showAddCount = WorldSimpleModeUtils.ShowMummyTranslate()
    if showAddCount then
      anim_name = "anim"
    else
      anim_name = "Default"
    end
  else
    anim_name = "Default"
  end
  if self.anim ~= nil then
    if self.anim:IsPlaying(anim_name) then
      self.anim:Rewind(anim_name)
    else
      self.anim:Play(anim_name)
    end
  end
  if myself then
    local lightHouseStatusPre = DataCenter.SeasonPowerWorkerManager.lightHouseStatusPre
    local brightnessLevelOld
    if lightHouseStatusPre then
      brightnessLevelOld = lightHouseStatusPre.brightnessLevel or 0
    end
    local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
    if lightHouseStatus then
      self.lightHouseInfo.CurrPower = lightHouseStatus.power or 0
      self.lightHouseInfo.PowerSpeed = lightHouseStatus.speed or 0
      self.lightHouseInfo.Brightness = lightHouseStatus.brightnessLevel or 0
      self.lightHouseInfo.PowerUpdateTime = lightHouseStatus.syncTime or 0
    end
    if brightnessLevelOld ~= nil and self.lightHouseInfo.Brightness ~= brightnessLevelOld then
      self:PlayBrightnessEffect(self.lightHouseInfo.Brightness)
    end
  else
    local brightnessLevelOld = self.lightHouseInfo.Brightness
    self.lightHouseInfo.MaxPower = data.maxPower or self.lightHouseInfo.MaxPower
    self.lightHouseInfo.CurrPower = data.power or 0
    self.lightHouseInfo.PowerSpeed = data.speed or 0
    self.lightHouseInfo.Brightness = data.brightnessLevel or 0
    self.lightHouseInfo.PowerUpdateTime = data.powerSyncTime or 0
    if brightnessLevelOld ~= nil and brightnessLevelOld ~= data.brightnessLevel then
      self:PlayBrightnessEffect(data.brightnessLevel)
    end
  end
  self:UpdateData()
end

local BrightnessEffectList = {
  "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_ljw_s4_map_openlight_1.prefab",
  "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_ljw_s4_map_openlight_2.prefab",
  "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_ljw_s4_map_openlight_3.prefab",
  "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_ljw_s4_map_openlight_4.prefab"
}

function BatteryPowerEffect:PlayBrightnessEffect(brightnessLevel)
  if brightnessLevel == nil or brightnessLevel == 0 or self.lod == nil or self.lod >= 3 or not SceneUtils.GetIsInWorld() then
    return
  end
  local effectPath = BrightnessEffectList[brightnessLevel]
  if effectPath ~= nil and DisplaySettings.ShowMummyMarchEffect() then
    local theWorld = CS.SceneManager.World
    local v3Pos = self.theModelPos
    if theWorld and v3Pos then
      theWorld:CreateBattleVFX(effectPath, 3, function(go)
        if SceneUtils.GetIsInWorld() and go ~= nil then
          go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
          go.transform:Set_localPosition(v3Pos.x, v3Pos.y, v3Pos.z)
          go.transform:Set_localScale(1, 1, 1)
          go:SetActive(true)
        end
      end)
    end
  end
end

function BatteryPowerEffect:UpdateData()
  if IsNotNull(self.txt_level) and self.lightHouseInfo then
    local lightHouseInfo = self.lightHouseInfo
    local brightness = toInt(lightHouseInfo.Brightness)
    if 0 < brightness then
      self.txt_level.text = "L" .. brightness
    else
      self.txt_level.text = ""
    end
    local LightHouseLevel = toInt(lightHouseInfo.LightHouseLevel)
    if LightHouseLevel == 0 then
      Logger.LogError("LightHouseLevel is 0")
      if self.light_effect then
        self.light_effect:Delete()
        self.light_effect = nil
      end
      return
    end
    if lightHouseInfo.LightHouseActive ~= true then
      if lightHouseInfo.WorkerActive then
        self.icon_status:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_02.png")
      else
        self.icon_status:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_01.png")
      end
      if self.light_effect then
        self.light_effect:Delete()
        self.light_effect = nil
      end
      return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local currPower = toInt(lightHouseInfo.CurrPower)
    local powerSpeed = toInt(lightHouseInfo.PowerSpeed)
    local powerUpdateTime = toInt(lightHouseInfo.PowerUpdateTime)
    local maxPower = toInt(lightHouseInfo.MaxPower)
    local icon_path, effect_path
    if now > powerUpdateTime then
      currPower = math.min(maxPower, currPower + powerSpeed * (now - powerUpdateTime) * 0.001)
    else
      currPower = math.min(maxPower, currPower)
    end
    if brightness == 1 then
      icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_04.png"
      effect_path = "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_S4_Base_Light_01.prefab"
    elseif brightness == 2 then
      icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_05.png"
      effect_path = "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_S4_Base_Light_02.prefab"
    elseif brightness == 3 then
      icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_06.png"
      effect_path = "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_S4_Base_Light_03.prefab"
    elseif brightness == 4 then
      icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_07.png"
      effect_path = "Assets/Main/SeasonRes/S4/Prefabs/Effect/S4_Light/Eff_S4_Base_Light_04.prefab"
    elseif 0 < currPower then
      icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_03.png"
    else
      icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_02.png"
    end
    if maxPower <= currPower then
      if 0 < brightness then
        icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_09.png"
      else
        icon_path = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_08.png"
      end
    end
    if icon_path then
      self.icon_status:LoadSprite(icon_path)
    end
    if (effect_path == nil or effect_path ~= self.effect_path) and self.light_effect then
      self.light_effect:Delete()
      self.light_effect = nil
    end
    self.effect_path = effect_path
    if 3 > self.lod and effect_path ~= nil and self.light_effect == nil and self.theModelPos ~= nil and DisplaySettings.ShowMummyMarchEffect() then
      local theWorld = CS.SceneManager.World
      if theWorld then
        local v3Pos = self.theModelPos
        local nodeKey = string.format("eff_light_%s_%s", brightness, self.theUuid or brightness)
        self.light_effect = UIAsyncNode.New(nodeKey, theWorld.DynamicObjNode.transform, effect_path, function(go)
          if IsNotNull(go) then
            go.transform:Set_localPosition(v3Pos.x, v3Pos.y, v3Pos.z)
          end
        end)
      end
    end
  end
end

return BatteryPowerEffect
