local AlScienceHitRatio = BaseClass("AlScienceHitRatio", UIBaseContainer)
local base = UIBaseContainer
local hit_text1_path = "HitText1"
local hit_text2_path = "HitText2"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self:ClearSequence()
end

local function Show(self, ratio, parentContainer)
  self:ClearSequence()
  self.parentContainer = parentContainer
  self:SetActive(true)
  self.hitText1:SetActive(true)
  self.hitText2:SetActive(false)
  self.hitText2:SetLocalText(391038, ratio)
  local time = 0.1
  self.hitText1.transform.localScale = Vector3.New(4, 4, 1)
  local sequence1 = CS.DG.Tweening.DOTween.Sequence()
  self.sequence1 = sequence1
  sequence1:AppendInterval(time)
  sequence1:AppendCallback(function()
    self.hitText1.transform.localScale = Vector3.New(0.98, 0.98, 1)
  end)
  sequence1:AppendInterval(time)
  sequence1:AppendCallback(function()
    self.hitText1.transform.localScale = Vector3.New(1.01, 1.01, 1)
  end)
  sequence1:AppendInterval(time)
  sequence1:AppendCallback(function()
    self.hitText1.transform.localScale = Vector3.New(1.0, 1.0, 1)
  end)
  local sequence2 = CS.DG.Tweening.DOTween.Sequence()
  self.sequence2 = sequence2
  sequence2:AppendInterval(time)
  sequence2:AppendCallback(function()
    self.hitText2:SetActive(true)
    self.hitText2.transform.localScale = Vector3.New(4, 4, 1)
  end)
  sequence2:AppendInterval(time)
  sequence2:AppendCallback(function()
    self.hitText2.transform.localScale = Vector3.New(0.98, 0.98, 1)
  end)
  sequence2:AppendInterval(time)
  sequence2:AppendCallback(function()
    self.hitText2.transform.localScale = Vector3.New(1.01, 1.01, 1)
  end)
  sequence2:AppendInterval(time)
  sequence2:AppendCallback(function()
    self.hitText2.transform.localScale = Vector3.New(1.0, 1.0, 1)
  end)
  local sequence3 = CS.DG.Tweening.DOTween.Sequence()
  self.sequence3 = sequence3
  sequence3:AppendInterval(time * 12)
  sequence3:AppendCallback(function()
    self.transform:DOLocalMoveY(10, time * 4):OnComplete(function()
      local go = self.gameObject
      if go then
        self:SetActive(false)
        if self.parentContainer then
          self.parentContainer:RemoveComponent(self.gameObject.name)
        end
        go:GameObjectRecycle()
      end
    end)
  end)
end

local function ClearSequence(self)
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

AlScienceHitRatio.OnCreate = OnCreate
AlScienceHitRatio.OnDestroy = OnDestroy
AlScienceHitRatio.ComponentDefine = ComponentDefine
AlScienceHitRatio.ComponentDestroy = ComponentDestroy
AlScienceHitRatio.Show = Show
AlScienceHitRatio.ClearSequence = ClearSequence
return AlScienceHitRatio
