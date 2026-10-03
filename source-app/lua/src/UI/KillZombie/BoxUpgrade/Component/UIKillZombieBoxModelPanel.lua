local UIKillZombieBoxModelPanel = BaseClass("UIKillZombieBoxModelPanel", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local KillZombieALKirovModel = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieALKirovModel")
local ChildLevelFlag = {
  Level1 = 1,
  Level2 = 2,
  Level3 = 3,
  Level4 = 4,
  Level5 = 5,
  Level6 = 6
}
local BoxStatusFlag = {
  Idle = 1,
  Upgrade = 2,
  OpenBox = 3,
  Rotation = 4,
  OpenIdle = 5
}
local ChildNodePath = {
  [ChildLevelFlag.Level1] = "O_env_baoxiang_lv01",
  [ChildLevelFlag.Level2] = "O_env_baoxiang_lv02",
  [ChildLevelFlag.Level3] = "O_env_baoxiang_lv03",
  [ChildLevelFlag.Level4] = "O_env_baoxiang_lv04",
  [ChildLevelFlag.Level5] = "O_env_baoxiang_lv05",
  [ChildLevelFlag.Level6] = "O_env_baoxiang_lv06"
}
local EffectFlag = {
  UpgradeBgEffect = 1,
  UpgradeEffect = 2,
  OpenBgEffect = 3,
  OpenEffect = 4,
  UpgradeSpecialEffect = 5
}
local EffectPath = {
  [EffectFlag.UpgradeBgEffect] = "Assets/Main/Prefabs/UI/ExplorerTreasure/Eff_ui_xiangzi_update_noramlquan.prefab",
  [EffectFlag.UpgradeEffect] = "Assets/Main/Prefabs/UI/ExplorerTreasure/Eff_ui_xiangzi_update_noraml.prefab",
  [EffectFlag.OpenBgEffect] = "Assets/Main/Prefabs/UI/ExplorerTreasure/Eff_ui_xiangzi_bgopen.prefab",
  [EffectFlag.OpenEffect] = "Assets/Main/Prefabs/UI/ExplorerTreasure/Eff_ui_xiangzi_open.prefab",
  [EffectFlag.UpgradeSpecialEffect] = "Assets/Main/Prefabs/UI/ExplorerTreasure/Eff_ui_xiangzi_update_special.prefab"
}
local AnimName = {
  [BoxStatusFlag.Idle] = "idle",
  [BoxStatusFlag.Upgrade] = "upgrade",
  [BoxStatusFlag.OpenBox] = "open",
  [BoxStatusFlag.Rotation] = "rotation",
  [BoxStatusFlag.OpenIdle] = "open_idle"
}
local bg_effect_root_path = "BgEffectRoot"
local effect_root_path = "EffectRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  self:ClearEffect()
  self:ClearTimer()
end

local function ComponentDefine(self)
  self.u_i_model = self:AddComponent(KillZombieALKirovModel, "UIModel")
  self.u_i_model:Init(Draw2DUIModelType.KillZombieBoxUpgrade)
  self.bg_effect_root = self:AddComponent(UIBaseContainer, bg_effect_root_path).transform
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path).transform
end

local function ComponentDestroy(self)
  self.u_i_model = nil
  self.bg_effect_root = nil
  self.effect_root = nil
end

local function DataDefine(self)
  self.allEffect = {}
  self.pointId = nil
  self.openTimer = nil
  self.level = nil
end

local function DataDestroy(self)
  self:ClearEffect()
  self:ClearTimer()
  self.pointId = nil
  self.allEffect = nil
  self.level = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener()
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitPanel(self, level)
  level = level or 1
  if level == self.level then
    return
  end
  self.level = level
  self:SetModelShow()
end

local function SetModelShow(self)
  if self.level == nil or self.level <= 0 then
    self.level = 1
  end
  self.u_i_model:ReInit(ChildNodePath[self.level], nil, AnimName[BoxStatusFlag.Idle])
end

local function ShowBoxOpenPanel(self, level)
  level = level or 1
  if level == self.level then
    return
  end
  self.level = level
  self.u_i_model:ReInit(ChildNodePath[level], nil, AnimName[BoxStatusFlag.OpenIdle], nil)
end

local function UpgradeBox(self, quality, upgrade, callback)
  self:InitPanel(quality)
  local flag = quality == ChildLevelFlag.Level5 and EffectFlag.UpgradeSpecialEffect or EffectFlag.UpgradeEffect
  self:PlayEffect(flag, self.effect_root)
  self:PlayEffect(EffectFlag.UpgradeBgEffect, self.bg_effect_root)
  local anim, sound
  if upgrade then
    anim = AnimName[BoxStatusFlag.Upgrade]
    sound = self:GetUpgradeSoundId(quality)
  else
    anim = AnimName[BoxStatusFlag.Rotation]
    sound = 50102
  end
  DataCenter.LWSoundManager:PlaySound(sound, false)
  self.u_i_model:PlayAnimation(anim, function()
    if callback then
      callback()
    end
    if self.u_i_model then
      self.u_i_model:PlayAnimation(AnimName[BoxStatusFlag.Idle])
    end
  end)
end

local function OpenBox(self, quality, callback)
  self:InitPanel(quality)
  self:PlayEffect(EffectFlag.OpenBgEffect, self.bg_effect_root)
  local sound = self:GetOpenSoundId(quality)
  DataCenter.LWSoundManager:PlaySound(sound, false)
  self.u_i_model:PlayAnimation(AnimName[BoxStatusFlag.OpenBox], function()
    if callback then
      callback()
    end
    if self.u_i_model then
      self.u_i_model:PlayAnimation(AnimName[BoxStatusFlag.OpenIdle])
    end
  end)
  if self.openTimer then
    self.openTimer:Stop()
  end
  self.openTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self and self.effect_root then
      self:PlayEffect(EffectFlag.OpenEffect, self.effect_root)
    end
  end, 2.3)
end

local function PlayEffect(self, flag, parent, duration, callback, finishCb)
  if flag then
    if self.allEffect == nil then
      return
    end
    return self:InstantiateAsync(flag, parent, duration, callback, finishCb)
  end
end

local function InstantiateAsync(self, flag, parent, duration, callback, finishCb)
  if flag then
    local data = self.allEffect[flag]
    if not data then
      data = {}
      self.allEffect[flag] = data
    else
      self:RemoveEffect(flag)
    end
    local path = EffectPath[flag]
    if path == nil or path == "" then
      return
    end
    local req = ResourceManager:InstantiateAsync(path)
    data.request = req
    req:completed("+", function(req)
      if req.isError then
        req:Destroy()
        return
      end
      local go = req.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      if parent then
        tf.parent = parent
      end
      tf:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      tf:Set_localRotation(0, 0, 0, 1)
      go:SetActive(true)
      if callback then
        callback()
      end
      tf.localScale = ResetScale
      if duration and 0 < duration then
        local timer = TimerManager:GetInstance():DelayInvoke(function()
          if finishCb then
            finishCb()
          end
          if self then
            self:RemoveEffect(path)
          end
        end, duration)
        data.delayTimer = timer
      end
      data.effectObj = req.gameObject
    end)
    return req
  end
end

local function RemoveEffect(self, flag)
  local data = self.allEffect[flag]
  if data ~= nil then
    if data.delayTimer then
      data.delayTimer:Stop()
      data.delayTimer = nil
    end
    if data.request then
      data.request:Destroy()
      data.request = nil
    end
    data.effectObj = nil
  end
end

local function ClearEffect(self)
  if self.allEffect then
    for _, v in pairs(self.allEffect) do
      if v then
        if v.delayTimer then
          v.delayTimer:Stop()
          v.delayTimer = nil
        end
        if v.request then
          v.request:Destroy()
          v.request = nil
        end
        v.effectObj = nil
      end
    end
    self.allEffect = {}
  end
end

local function ClearTimer(self)
  if self.openTimer then
    self.openTimer:Stop()
    self.openTimer = nil
  end
end

local function GetUpgradeSoundId(self, level)
  if level then
    if level <= ChildLevelFlag.Level2 then
      return 50103
    elseif level <= ChildLevelFlag.Level4 then
      return 50104
    else
      return 50105
    end
  end
end

local function GetOpenSoundId(self, level)
  if level then
    if level <= ChildLevelFlag.Level2 then
      return 50106
    elseif level <= ChildLevelFlag.Level4 then
      return 50107
    else
      return 50108
    end
  end
end

UIKillZombieBoxModelPanel.OnCreate = OnCreate
UIKillZombieBoxModelPanel.OnDestroy = OnDestroy
UIKillZombieBoxModelPanel.OnEnable = OnEnable
UIKillZombieBoxModelPanel.OnDisable = OnDisable
UIKillZombieBoxModelPanel.ComponentDefine = ComponentDefine
UIKillZombieBoxModelPanel.ComponentDestroy = ComponentDestroy
UIKillZombieBoxModelPanel.DataDefine = DataDefine
UIKillZombieBoxModelPanel.DataDestroy = DataDestroy
UIKillZombieBoxModelPanel.OnAddListener = OnAddListener
UIKillZombieBoxModelPanel.OnRemoveListener = OnRemoveListener
UIKillZombieBoxModelPanel.InitPanel = InitPanel
UIKillZombieBoxModelPanel.SetModelShow = SetModelShow
UIKillZombieBoxModelPanel.ShowBoxOpenPanel = ShowBoxOpenPanel
UIKillZombieBoxModelPanel.UpgradeBox = UpgradeBox
UIKillZombieBoxModelPanel.OpenBox = OpenBox
UIKillZombieBoxModelPanel.PlayEffect = PlayEffect
UIKillZombieBoxModelPanel.InstantiateAsync = InstantiateAsync
UIKillZombieBoxModelPanel.RemoveEffect = RemoveEffect
UIKillZombieBoxModelPanel.ClearEffect = ClearEffect
UIKillZombieBoxModelPanel.ClearTimer = ClearTimer
UIKillZombieBoxModelPanel.GetUpgradeSoundId = GetUpgradeSoundId
UIKillZombieBoxModelPanel.GetOpenSoundId = GetOpenSoundId
return UIKillZombieBoxModelPanel
