local TacticalWeaponCriticalItem = BaseClass("TacticalWeaponCriticalItem", UIBaseContainer)
local base = UIBaseContainer
local hit_text1_path = "HitText1"
local hit_text2_path = "HitText2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function StopAnim(self)
  if self.sequence1 then
    self.sequence1:Kill()
    self.sequence1 = nil
  end
  if self.sequence2 then
    self.sequence2:Kill()
    self.sequence2 = nil
  end
  if self.sequence3 then
    self.sequence3:Kill()
    self.sequence3 = nil
  end
end

local function OnDestroy(self)
  StopAnim(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.hitText1 = self:AddComponent(UIText, hit_text1_path)
  self.hitText1:SetLocalText(391037)
  self.hitText2 = self:AddComponent(UIText, hit_text2_path)
  self.hitText2:SetActive(false)
end

local function ComponentDestroy(self)
  self.hit_text1 = nil
  self.hit_text2 = nil
end

local function Show(self, type, finishCallback)
  StopAnim(self)
  self:SetLocalPositionXYZ(0, -45, 0)
  self:SetActive(true)
  self.hitText1:SetActive(true)
  self.hitText2:SetActive(false)
  if type == 1 then
    self.hitText1:SetLocalText(391037)
    self.hitText2:SetLocalText(391038, 2)
  elseif type == 2 then
    self.hitText1:SetLocalText(141148)
    self.hitText2:SetLocalText(121002)
  end
  local time = 0.1
  self.hitText1.transform.localScale = Vector3.New(4, 4, 1)
  self.sequence1 = CS.DG.Tweening.DOTween.Sequence()
  self.sequence1:AppendInterval(time)
  self.sequence1:AppendCallback(function()
    self.hitText1.transform.localScale = Vector3.New(0.98, 0.98, 1)
  end)
  self.sequence1:AppendInterval(time)
  self.sequence1:AppendCallback(function()
    self.hitText1.transform.localScale = Vector3.New(1.01, 1.01, 1)
  end)
  self.sequence1:AppendInterval(time)
  self.sequence1:AppendCallback(function()
    self.hitText1.transform.localScale = Vector3.New(1.0, 1.0, 1)
  end)
  self.sequence2 = CS.DG.Tweening.DOTween.Sequence()
  self.sequence2:AppendInterval(time)
  self.sequence2:AppendCallback(function()
    self.hitText2:SetActive(true)
    self.hitText2.transform.localScale = Vector3.New(4, 4, 1)
  end)
  self.sequence2:AppendInterval(time)
  self.sequence2:AppendCallback(function()
    self.hitText2.transform.localScale = Vector3.New(0.98, 0.98, 1)
  end)
  self.sequence2:AppendInterval(time)
  self.sequence2:AppendCallback(function()
    self.hitText2.transform.localScale = Vector3.New(1.01, 1.01, 1)
  end)
  self.sequence2:AppendInterval(time)
  self.sequence2:AppendCallback(function()
    self.hitText2.transform.localScale = Vector3.New(1.0, 1.0, 1)
  end)
  self.sequence3 = CS.DG.Tweening.DOTween.Sequence()
  self.sequence3:AppendInterval(time * 6)
  self.sequence3:AppendCallback(function()
    self.transform:DOLocalMoveY(0, time * 4):OnComplete(function()
      self:SetActive(false)
      if finishCallback then
        finishCallback(self)
      end
    end)
  end)
end

TacticalWeaponCriticalItem.OnCreate = OnCreate
TacticalWeaponCriticalItem.OnDestroy = OnDestroy
TacticalWeaponCriticalItem.ComponentDefine = ComponentDefine
TacticalWeaponCriticalItem.ComponentDestroy = ComponentDestroy
TacticalWeaponCriticalItem.Show = Show
return TacticalWeaponCriticalItem
