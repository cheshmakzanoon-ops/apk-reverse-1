local BountyHunterMonsterHpComponent = BaseClass("BountyHunterMonsterHpComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local hp_slider_path = "HpSlider"

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
end

local function ComponentDefine(self)
  self.hpSlider = self:AddComponent(UISlider, hp_slider_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function BountyHunterMonsterHpComponent:HideHpBar()
  if not self.gameObject then
    return
  end
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self.gameObject:SetActive(false)
end

function BountyHunterMonsterHpComponent:RefreshHpBar(hurtParams)
  if not hurtParams then
    return
  end
  if not self.gameObject then
    return
  end
  self.gameObject:SetActive(true)
  local hpChange = hurtParams.hpChange or 0
  local newHp = hurtParams.newHp
  local maxHp = hurtParams.maxHp
  local fromProgress = (newHp - hpChange) / maxHp
  local targetProgress = newHp / maxHp
  if hpChange == 0 then
    self.hpSlider:SetValue(targetProgress)
    return
  end
  self:PlayBarChangeAni(fromProgress, targetProgress)
end

function BountyHunterMonsterHpComponent:PlayBarChangeAni(fromValue, toValue)
  local tempValue = fromValue
  
  local function Getter()
    return fromValue
  end
  
  local function Setter(x)
    tempValue = x
  end
  
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self.tween = DOTween.To(Getter, Setter, toValue, 0.5):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  
  function self.tween.onUpdate(x)
    if self.hpSlider then
      self.hpSlider:SetValue(tempValue)
    end
  end
  
  self.tween:OnComplete(function()
    self.tween = nil
  end)
end

BountyHunterMonsterHpComponent.OnCreate = OnCreate
BountyHunterMonsterHpComponent.OnDestroy = OnDestroy
BountyHunterMonsterHpComponent.OnEnable = OnEnable
BountyHunterMonsterHpComponent.OnDisable = OnDisable
BountyHunterMonsterHpComponent.ComponentDefine = ComponentDefine
BountyHunterMonsterHpComponent.ComponentDestroy = ComponentDestroy
BountyHunterMonsterHpComponent.DataDefine = DataDefine
BountyHunterMonsterHpComponent.DataDestroy = DataDestroy
BountyHunterMonsterHpComponent.OnAddListener = OnAddListener
BountyHunterMonsterHpComponent.OnRemoveListener = OnRemoveListener
return BountyHunterMonsterHpComponent
