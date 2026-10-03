local UIKillZombieBoxItem = BaseClass("UIKillZombieBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BoxNormalIcon = {
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_box01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_lvbox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_lanbox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_zibox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_chengbox01.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_hongbox01.png"
}
local BoxOpenIcon = {
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_box02.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_lvbox02.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_lanbox02.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_zibox02.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_chengbox02.png",
  "Assets/Main/TextureEx/UIActivityKillZombie/wxy_jiangjunshilian_hongbox02.png"
}
local LevelFlag = {
  Level1 = 1,
  Level2 = 2,
  Level3 = 3,
  Level4 = 4,
  Level5 = 5,
  Level6 = 6
}
local EffectFlag = {
  FlyTrail = 1,
  LightBox1 = 2,
  LightBox2 = 3,
  LightBox3 = 4,
  Lighting1 = 5,
  Lighting2 = 6,
  Lighting3 = 7,
  Open1 = 8,
  Open2 = 9,
  Open3 = 10
}
local LightEffectFlag = {
  [LevelFlag.Level1] = EffectFlag.LightBox1,
  [LevelFlag.Level2] = EffectFlag.LightBox2,
  [LevelFlag.Level3] = EffectFlag.LightBox3,
  [LevelFlag.Level4] = EffectFlag.LightBox3,
  [LevelFlag.Level5] = EffectFlag.LightBox3,
  [LevelFlag.Level6] = EffectFlag.LightBox3
}
local OpenEffectFlag = {
  [LevelFlag.Level1] = EffectFlag.Open1,
  [LevelFlag.Level2] = EffectFlag.Open2,
  [LevelFlag.Level3] = EffectFlag.Open3,
  [LevelFlag.Level4] = EffectFlag.Open3,
  [LevelFlag.Level5] = EffectFlag.Open3,
  [LevelFlag.Level6] = EffectFlag.Open3
}
local LightingEffectFlag = {
  [LevelFlag.Level1] = EffectFlag.Lighting1,
  [LevelFlag.Level2] = EffectFlag.Lighting2,
  [LevelFlag.Level3] = EffectFlag.Lighting3,
  [LevelFlag.Level4] = EffectFlag.Lighting3,
  [LevelFlag.Level5] = EffectFlag.Lighting3,
  [LevelFlag.Level6] = EffectFlag.Lighting3
}
local EffectPath = {
  [EffectFlag.FlyTrail] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxUpgrade_trail.prefab",
  [EffectFlag.LightBox1] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxChangeGlow01.prefab",
  [EffectFlag.LightBox2] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxChangeGlow02.prefab",
  [EffectFlag.LightBox3] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxChangeGlow03.prefab",
  [EffectFlag.Lighting1] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxUpgrade_saoguang01.prefab",
  [EffectFlag.Lighting2] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxUpgrade_saoguang02.prefab",
  [EffectFlag.Lighting3] = "Assets/_Art_LastWar/Effect/Prefab/VX/UIKillZombieBoxUpgrade_saoguang03.prefab",
  [EffectFlag.Open1] = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/Eff_UIKillZombieBox_baoxiang01.prefab",
  [EffectFlag.Open2] = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/Eff_UIKillZombieBox_baoxiang02.prefab",
  [EffectFlag.Open3] = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/Eff_UIKillZombieBox_baoxiang03.prefab"
}
local progress_path = "SliderRoot/Progress"
local click_path = "Click"
local effect_root_path = "Root/EffectRoot"
local bar_effect_root_path = "SliderRoot/Progress/BarEffectRoot"
local progress_finish_path = "SliderRoot/ProgressFinish"
local root_path = "Root"
local RESET_SCALE = ResetScale
local LARGE_SCALE

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
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
end

local function ComponentDefine(self)
  self.rawImgNormalIcon = self:AddComponent(UIRawImage, "Root/Unlock/Normal/NormalIcon")
  self.compUnlock = self:AddComponent(UIBaseContainer, "Root/Unlock")
  self.compLock = self:AddComponent(UIBaseContainer, "Root/Lock")
  self.progress = self:AddComponent(UIBaseContainer, progress_path)
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnItemClick))
  self.effect_root = self:AddComponent(UIBaseContainer, effect_root_path)
  self.bar_effect_root = self:AddComponent(UIBaseContainer, bar_effect_root_path)
  self.bar_effect_root:SetActive(false)
  self.progress_finish = self:AddComponent(UIImage, progress_finish_path)
  self.progress_finish:SetActive(false)
  self.root = self:AddComponent(UIBaseContainer, root_path)
end

local function ComponentDestroy(self)
  self:ClearTween()
  self.rawImgNormalIcon = nil
  self.compUnlock = nil
  self.compLock = nil
  self.progress = nil
  self.click = nil
  self.effect_root = nil
  self.bar_effect_root = nil
  self.progress_finish = nil
  self.root:SetLocalScale(RESET_SCALE)
  self.root = nil
end

local function DataDefine(self)
  LARGE_SCALE = Vector3.New(1.2, 1.2, 1.2)
  self.parent = nil
  self.quality = nil
  self.isOpen = nil
  self.allEffect = {}
  self.sliderShow = nil
  self.openTimer = nil
  self.isLightOn = nil
end

local function DataDestroy(self)
  self:ClearTimer()
  self:ClearEffect()
  self.parent = nil
  self.quality = nil
  self.isOpen = nil
  self.allEffect = nil
  self.sliderShow = nil
  self.isLightOn = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitData(self)
  self.compLock:SetActive(true)
  self.compUnlock:SetActive(false)
end

local function SetData(self, parent, param)
  if param then
    local quality = param.boxQuality
    self.quality = quality
    self.rawImgNormalIcon:LoadSprite(BoxNormalIcon[quality])
    local rewardInfo = param.receivedRewardInfo
    self.rewardData = rewardInfo and DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo)
  end
  self.parent = parent
end

local function ShowItemOpen(self, param)
  if param then
    local quality = param.boxQuality
    local rewardInfo = param.receivedRewardInfo
    self.rewardData = rewardInfo and DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo)
    self.compLock:SetActive(false)
    self.compUnlock:SetActive(true)
    self.rawImgNormalIcon:LoadSprite(BoxOpenIcon[quality])
    self.progress_finish:SetActive(self.sliderShow)
    self.bar_effect_root:SetActive(false)
    self.isOpen = true
  end
end

local function ShowProgressBar(self, show)
  self.sliderShow = show
  self.progress:SetActive(show)
end

local function DisplayItemUnlock(self, callback)
  if self.parent then
    local effectPath = EffectPath[EffectFlag.FlyTrail]
    local startPos = self.parent.position
    local endPos = self.effect_root.transform.position
    UIUtil.DoFlySimpleFunc(effectPath, startPos, endPos, 0.3, nil, function()
      self:PlayProgressEffect(callback)
    end)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Baoxiang_Spark_Fly, false)
  end
end

local function PlayProgressEffect(self, callback)
  if self.isLightOn then
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Baoxiang_Spark_Hit, false)
  self:SetCommonShow(false)
  if self.barTimer then
    self.barTimer:Stop()
  end
  self.bar_effect_root:SetActive(true)
  self:SetBoxLightOnState(callback)
  self.barTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.bar_effect_root:SetActive(false)
    self.progress_finish:SetActive(self.sliderShow)
    self.isLightOn = true
    if self.barTimer then
      self.barTimer:Stop()
    end
  end, 0.5)
end

local function SetBoxLightOnState(self, callback)
  self:PlayEffect(LightEffectFlag[self.quality], 1, nil, callback)
  self:PlayEffect(LightingEffectFlag[self.quality])
  self.compLock:SetActive(false)
  self.compUnlock:SetActive(true)
end

local function SetCommonShow(self, show)
  local scale = show and RESET_SCALE or LARGE_SCALE
  self:DoBoxScaleTween(scale)
end

local function PlayBoxOpen(self)
  self:LightOnTheBox()
  if self.rewardData then
    self:ClearOpenTimer()
    self.openTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ClearOpenTimer()
      self:RemoveEffect(LightingEffectFlag[self.quality])
      self:PlayEffect(OpenEffectFlag[self.quality])
      self.rawImgNormalIcon:LoadSprite(BoxOpenIcon[self.quality])
      self.isOpen = true
    end, 2.3)
  end
end

local function LightOnTheBox(self, last)
  self:ClearTimer()
  if self.isLightOn then
    return false
  end
  self.isLightOn = true
  self:PlayEffect(LightEffectFlag[self.quality], 1)
  self:PlayEffect(LightingEffectFlag[self.quality])
  self.compLock:SetActive(false)
  self.compUnlock:SetActive(true)
  self.bar_effect_root:SetActive(false)
  self.progress_finish:SetActive(self.sliderShow)
  self:SetCommonShow(not last)
  return true
end

local function PlayEffect(self, flag, duration, callback, finishCb)
  if flag then
    if self.allEffect == nil then
      return
    end
    return self:InstantiateAsync(flag, duration, callback, finishCb)
  end
end

local function InstantiateAsync(self, flag, duration, callback, finishCb)
  if flag and EffectPath[flag] then
    local data = self.allEffect[flag]
    if not data then
      data = {}
      self.allEffect[flag] = data
    else
      self:RemoveEffect(flag)
    end
    local req = CS.GameEntry.Resource:InstantiateAsync(EffectPath[flag])
    data.request = req
    req:completed("+", function(request)
      if request.isError then
        request:Destroy()
        return
      end
      local go = request.gameObject
      local tf = go.transform
      tf.localScale = VecZero
      tf.parent = self.effect_root.transform
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
          self:RemoveEffect(flag)
        end, duration)
        data.delayTimer = timer
      end
      data.effectObj = request.gameObject
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

local function OnItemClick(self)
  if self.isOpen then
    if self.isFinish == nil then
      self.isFinish = self.view.isFinish
    end
    if self.isFinish and not table.IsNullOrEmpty(self.rewardData) then
      local size = self.effect_root:GetSizeDelta()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.effect_root, self.rewardData, 0, size.y / 2)
    end
  end
end

local function ClearOpenTimer(self)
  if self.openTimer then
    self.openTimer:Stop()
    self.openTimer = nil
  end
end

local function ClearTimer(self)
  if self.openTimer then
    self.openTimer:Stop()
    self.openTimer = nil
  end
  if self.barTimer then
    self.barTimer:Stop()
    self.barTimer = nil
  end
end

local function DoBoxScaleTween(self, size)
  self:ClearTween()
  local sequence = DOTween.Sequence()
  sequence:Append(self.root.transform:DOScale(size, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad))
  sequence:OnComplete(function()
    self.root:SetLocalScale(size)
    self:ClearTween()
  end)
  self.sequence = sequence
end

local function ClearTween(self)
  if IsNotNull(self.sequence) then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
end

UIKillZombieBoxItem.OnCreate = OnCreate
UIKillZombieBoxItem.OnDestroy = OnDestroy
UIKillZombieBoxItem.OnEnable = OnEnable
UIKillZombieBoxItem.OnDisable = OnDisable
UIKillZombieBoxItem.ComponentDefine = ComponentDefine
UIKillZombieBoxItem.ComponentDestroy = ComponentDestroy
UIKillZombieBoxItem.DataDefine = DataDefine
UIKillZombieBoxItem.DataDestroy = DataDestroy
UIKillZombieBoxItem.OnAddListener = OnAddListener
UIKillZombieBoxItem.OnRemoveListener = OnRemoveListener
UIKillZombieBoxItem.InitData = InitData
UIKillZombieBoxItem.SetData = SetData
UIKillZombieBoxItem.DisplayItemUnlock = DisplayItemUnlock
UIKillZombieBoxItem.PlayProgressEffect = PlayProgressEffect
UIKillZombieBoxItem.SetBoxLightOnState = SetBoxLightOnState
UIKillZombieBoxItem.SetCommonShow = SetCommonShow
UIKillZombieBoxItem.PlayBoxOpen = PlayBoxOpen
UIKillZombieBoxItem.ShowItemOpen = ShowItemOpen
UIKillZombieBoxItem.ShowProgressBar = ShowProgressBar
UIKillZombieBoxItem.PlayEffect = PlayEffect
UIKillZombieBoxItem.InstantiateAsync = InstantiateAsync
UIKillZombieBoxItem.RemoveEffect = RemoveEffect
UIKillZombieBoxItem.ClearEffect = ClearEffect
UIKillZombieBoxItem.OnItemClick = OnItemClick
UIKillZombieBoxItem.ClearOpenTimer = ClearOpenTimer
UIKillZombieBoxItem.ClearTimer = ClearTimer
UIKillZombieBoxItem.LightOnTheBox = LightOnTheBox
UIKillZombieBoxItem.DoBoxScaleTween = DoBoxScaleTween
UIKillZombieBoxItem.ClearTween = ClearTween
return UIKillZombieBoxItem
