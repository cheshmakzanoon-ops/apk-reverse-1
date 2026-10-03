local BountyHunterBossHpBarComponent = BaseClass("BountyHunterBossHpBarComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local boss_hp_slider_path = "Root/BossHpSlider"
local hp_text_path = "Root/HpText"
local anim_path = "Root"

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
  self.hpSlider = self:AddComponent(UISlider, boss_hp_slider_path)
  self.hpText = self:AddComponent(UIText, hp_text_path)
  self.anim = self:AddComponent(UISimpleAnimation, anim_path)
end

local function ComponentDestroy(self)
  self.hpSlider = nil
  self.hpText = nil
  self.anim = nil
end

local function DataDefine(self)
  self.isShowing = false
end

local function DataDestroy(self)
  self.isShowing = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function BountyHunterBossHpBarComponent:ShowHpBar(monsterData)
  if not self.gameObject or not monsterData then
    return
  end
  self.curHp = nil
  self.anim:Play("Show")
  local curHp = monsterData.curHp or 0
  local maxHp = monsterData.maxHp or 1
  self:UpdateHpInfo(curHp, maxHp)
  self.isShowing = true
end

function BountyHunterBossHpBarComponent:HideHpBar(isPlayAnim)
  if not self.gameObject then
    return
  end
  if isPlayAnim and self.isShowing then
    self.anim:Play("Hide")
  else
    self.anim:SampleAnimationAtTime("Hide", 1)
  end
  self.isShowing = false
end

function BountyHunterBossHpBarComponent:UpdateHpProgress(hurtParams)
  if not hurtParams then
    return
  end
  local hpChange = hurtParams.hpChange
  local newHp = hurtParams.newHp
  local maxHp = hurtParams.maxHp
  if self.curHp ~= nil and newHp > self.curHp then
    return
  end
  self.curHp = newHp
  self:UpdateHpInfo(newHp, maxHp)
end

function BountyHunterBossHpBarComponent:UpdateHpInfo(cur, max)
  if max == 0 then
    self.hpSlider:SetValue(0)
  else
    self.hpSlider:SetValue(cur / max)
  end
  self.hpText:SetText(string.format("%s/%s", cur, max))
end

BountyHunterBossHpBarComponent.OnCreate = OnCreate
BountyHunterBossHpBarComponent.OnDestroy = OnDestroy
BountyHunterBossHpBarComponent.OnEnable = OnEnable
BountyHunterBossHpBarComponent.OnDisable = OnDisable
BountyHunterBossHpBarComponent.ComponentDefine = ComponentDefine
BountyHunterBossHpBarComponent.ComponentDestroy = ComponentDestroy
BountyHunterBossHpBarComponent.DataDefine = DataDefine
BountyHunterBossHpBarComponent.DataDestroy = DataDestroy
BountyHunterBossHpBarComponent.OnAddListener = OnAddListener
BountyHunterBossHpBarComponent.OnRemoveListener = OnRemoveListener
return BountyHunterBossHpBarComponent
