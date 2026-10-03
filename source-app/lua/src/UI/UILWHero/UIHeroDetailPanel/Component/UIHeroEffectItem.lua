local UIHeroEffectItem = BaseClass("UIHeroEffectItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.skillBtn = self:AddComponent(UIButton, "ContentContainer")
  self.skillIcon = self:AddComponent(UIImage, "ContentContainer/Icon")
  self.lockContent = self:AddComponent(UIImage, "ContentContainer/LockContent")
  self.contentContainer = self:AddComponent(UIBaseContainer, "ContentContainer")
  self.skillBtn:SetOnClick(function()
    if self.callback then
      self.callback(self.id, self)
    end
  end)
end

local function ComponentDestroy(self)
  self.root = nil
  self.skillBtn = nil
  self.skillIcon = nil
  self.lockContent = nil
  self.contentContainer = nil
end

local function StopUnlockEffect(self)
  if self.delayEffect then
    self.delayEffect:Stop()
    self.delayEffect = nil
  end
  if self.m_unlockEffect and not IsNull(self.m_unlockEffect.gameObject) then
    self.m_unlockEffect.gameObject:SetActive(false)
  end
end

local function OnDestroy(self)
  StopUnlockEffect(self)
  if self.m_willUnlockEffectRequest then
    self:GameObjectDestroy(self.m_willUnlockEffectRequest)
    self.m_willUnlockEffectRequest = nil
  end
  if self.m_unlockEffect then
    self:GameObjectDestroy(self.m_unlockEffect)
  end
  self.m_willUnlockEffect = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  StopUnlockEffect(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowWillUnlockEffect(self, isShow)
  self.unlockEffectShow = isShow
  if not self.m_willUnlockEffect and isShow then
    if not self.m_willUnlockEffectRequest then
      self.m_willUnlockEffectRequest = self:GameObjectInstantiateAsync(UIAssets.HeroUniqueWeaponSkillWillUnlockEffect, function(request)
        local go = request.gameObject
        if not IsNull(go) then
          self.m_willUnlockEffect = go
          local transform = self.m_willUnlockEffect.transform
          transform:SetParent(self.transform)
          transform:Set_localScale(1.3, 1.3, 1.3)
          local rectTransform = transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
          rectTransform:Set_anchoredPosition(0, 14)
          go:SetActive(self.unlockEffectShow)
        end
      end)
    end
  elseif self.m_willUnlockEffect then
    self.m_willUnlockEffect:SetActive(self.unlockEffectShow)
  end
end

local function WaitAndShowUnlockEffect(self)
  self.delayEffect = TimerManager:GetInstance():DelayInvoke(function()
    UIGray.SetGray(self.skillIcon.transform, false, true)
    self.lockContent:SetActive(false)
  end, 0.5)
end

local function PlayUnlockEffect(self)
  if not self.m_unlockEffect then
    self.m_unlockEffect = self:GameObjectInstantiateAsync(UIAssets.HeroUniqueWeaponSkillUnlockEffect, function(request)
      local go = request.gameObject
      if not IsNull(go) then
        local transform = go.transform
        transform:SetParent(self.transform)
        transform:Set_localScale(1.1, 1.1, 1.1)
        local rectTransform = transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
        rectTransform:Set_anchoredPosition(0, 15)
        go:SetActive(false)
        go:SetActive(true)
        ShowWillUnlockEffect(self, false)
      end
      WaitAndShowUnlockEffect(self)
    end)
  end
end

local function SetData(self, id, icon, locked, callback)
  self.skillIcon:LoadSprite(icon)
  self.lockContent:SetActive(locked)
  if locked then
    UIGray.SetGray(self.skillIcon.transform, true, true)
    self.lockContent:SetActive(true)
  else
    UIGray.SetGray(self.skillIcon.transform, false, true)
    self.lockContent:SetActive(false)
  end
  self.callback = callback
  self.id = id
end

UIHeroEffectItem.OnCreate = OnCreate
UIHeroEffectItem.OnDestroy = OnDestroy
UIHeroEffectItem.OnEnable = OnEnable
UIHeroEffectItem.OnDisable = OnDisable
UIHeroEffectItem.DataDefine = DataDefine
UIHeroEffectItem.DataDestroy = DataDestroy
UIHeroEffectItem.OnAddListener = OnAddListener
UIHeroEffectItem.OnRemoveListener = OnRemoveListener
UIHeroEffectItem.ShowWillUnlockEffect = ShowWillUnlockEffect
UIHeroEffectItem.PlayUnlockEffect = PlayUnlockEffect
UIHeroEffectItem.WaitAndShowUnlockEffect = WaitAndShowUnlockEffect
UIHeroEffectItem.SetData = SetData
UIHeroEffectItem.ComponentDefine = ComponentDefine
UIHeroEffectItem.ComponentDestroy = ComponentDestroy
return UIHeroEffectItem
