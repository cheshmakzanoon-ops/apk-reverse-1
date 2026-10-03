local TriggerPointAttackBox = BaseClass("TriggerPointAttackBox")
local Resource = CS.GameEntry.Resource
local CollectionBlood = require("Scene.PVEBattleLevel.CollectionBlood")
local model_path = "Model"
local AnimName = {
  Attack = "attack",
  Open = "open",
  Show = "show"
}
local EffectName = {
  [AnimName.Show] = "Assets/Main/Prefabs/PVELevel/TriggerAttackBoxEffectShow.prefab",
  [AnimName.Open] = "Assets/Main/Prefabs/PVELevel/TriggerAttackBoxEffectOpen.prefab"
}

function TriggerPointAttackBox:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function TriggerPointAttackBox:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function TriggerPointAttackBox:ComponentDefine()
  local have, component = self.gameObject:TryGetComponent(typeof(CS.UnityEngine.Collider))
  if have then
    self.collider = component
  end
  local model = self.transform:Find(model_path)
  if model ~= nil then
    self.anim = model:GetComponentInChildren(typeof(CS.SimpleAnimation))
  end
end

function TriggerPointAttackBox:ComponentDestroy()
  self.collider = nil
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

function TriggerPointAttackBox:DataDefine()
  self.flyTexts = {}
  self.param = {}
  self.curBlood = 0
  self.maxBlood = 0
  self.collectionBlood = nil
  self.effectIns = {}
end

function TriggerPointAttackBox:DataDestroy()
  self:DestroyAllEffect()
  for k, v in pairs(self.flyTexts) do
    k:Destroy()
    v:Stop()
  end
  if self.collectionBlood ~= nil then
    self.collectionBlood:Destroy()
    self.collectionBlood = nil
  end
  self.param = {}
  self.curBlood = 0
  self.flyTexts = {}
  self.maxBlood = 0
  self.effectIns = {}
end

function TriggerPointAttackBox:ReInit(param)
  self.param = param
  self.transform:Set_position(param.pos.x, param.pos.y, param.pos.z)
  self.transform.localRotation = Quaternion.Euler(0, 0, 0)
  self.curBlood = self.param.blood
  self.maxBlood = self.param.blood
  if self.param.isInitFinish then
    self:PlayRewardBoxOpen()
  else
    self:PlayAppearAnim()
  end
end

function TriggerPointAttackBox:PlayAppearAnim()
  if self.collider ~= nil then
    self.collider.enabled = true
  end
  self:PlayAnim(AnimName.Show)
  self:LoadEffect(EffectName[AnimName.Show])
end

function TriggerPointAttackBox:OnCutOnce(attack)
  attack = 1
  if attack <= self.curBlood then
    self.curBlood = self.curBlood - attack
  else
    self.curBlood = 0
  end
  if DataCenter.BattleLevel:CanShowBlood() then
    DataCenter.BattleLevel:AddOneFlyBlood(attack, self.param.pos)
  end
  self:PlayWaveAnim()
  self:CheckCollectionBlood()
  self:ShowShakeWhite()
end

function TriggerPointAttackBox:GetBloodLeftCnt()
  return self.curBlood
end

function TriggerPointAttackBox:CheckCollectionBlood()
  if self.curBlood == 0 then
    if self.collectionBlood ~= nil then
      self.collectionBlood:Destroy()
      self.collectionBlood = nil
    end
    self:PlayRewardBoxOpen()
  elseif DataCenter.BattleLevel:CanShowBlood() then
    if self.collectionBlood == nil then
      local param = {}
      param.curBlood = self.curBlood
      param.maxBlood = self.maxBlood
      param.rotation = DataCenter.BattleLevel:GetCameraRotation()
      param.visible = true
      param.pos = self.gameObject.transform.position
      self.collectionBlood = CollectionBlood.New(param)
    else
      self.collectionBlood:RefreshBlood(self.curBlood, self.maxBlood)
    end
  end
end

function TriggerPointAttackBox:RefreshCameraRotation(rotation)
  if self.collectionBlood ~= nil then
    self.collectionBlood:RefreshCameraRotation(rotation)
  end
end

function TriggerPointAttackBox:PlayWaveAnim()
  self:PlayAnim(AnimName.Attack)
end

function TriggerPointAttackBox:PlayAnim(animName)
  if self.anim ~= nil then
    if self.anim:IsPlaying(animName) then
      self.anim:Rewind(animName)
    else
      self.anim:Play(animName)
    end
  end
end

function TriggerPointAttackBox:PlayRewardBoxOpen()
  if self.collider ~= nil then
    self.collider.enabled = false
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_pve_box_get, false)
  self:PlayAnim(AnimName.Open)
  self:LoadEffect(EffectName[AnimName.Open])
end

function TriggerPointAttackBox:ShowShakeWhite()
end

function TriggerPointAttackBox:LoadEffect(effectPath)
  if effectPath ~= nil and effectPath ~= "" and self.effectIns[effectPath] == nil then
    self.effectIns[effectPath] = Resource:InstantiateAsync(effectPath)
    self.effectIns[effectPath]:completed("+", function(req)
      local transform = req.gameObject.transform
      transform:Set_position(self.param.pos.x, self.param.pos.y, self.param.pos.z)
      transform.localScale = ResetScale
      req.gameObject:SetActive(true)
    end)
  end
end

function TriggerPointAttackBox:DestroyEffect(effectPath)
  if self.effectIns[effectPath] ~= nil then
    self.effectIns[effectPath]:Destroy()
    self.effectIns[effectPath] = nil
  end
end

function TriggerPointAttackBox:DestroyAllEffect()
  for k, v in pairs(self.effectIns) do
    v:Destroy()
  end
  self.effectIns = {}
end

function TriggerPointAttackBox:GetOpenAnimTime()
  if self.anim ~= nil then
    return self.anim:GetClipLength(AnimName.Open) + 0.5
  end
  return 0
end

return TriggerPointAttackBox
