local UIHeroPreviewLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPreviewLine")
local UIHeroUniqueWeaponPreviewLine = BaseClass("UIHeroUniqueWeaponPreviewLine", UIHeroPreviewLine)
local base = UIHeroPreviewLine
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  if self.m_lineEffectRequest then
    self:GameObjectDestroy(self.m_lineEffectRequest)
    self.m_lineEffectRequest = nil
  end
  self.m_lineEffect = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  if self.m_lineEffect then
    self.m_lineEffect:SetActive(false)
  end
end

local function PlayeLineEffect(self)
  self.lineEffectShow = isShow
  if not self.m_lineEffect then
    if not self.m_lineEffectRequest then
      self.m_lineEffectRequest = self:GameObjectInstantiateAsync(UIAssets.HeroUniqueWeaopnAttrLineFlashEffect, function(request)
        local go = request.gameObject
        if not IsNull(go) then
          self.m_lineEffect = go
          local transform = self.m_lineEffect.transform
          transform:SetParent(self.transform)
          transform:Set_localScale(0.75, 0.8, 0.8)
          local rectTransform = transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
          rectTransform:Set_anchoredPosition(0, 0)
          go:SetActive(false)
          go:SetActive(true)
        end
      end)
    end
  else
    self.m_lineEffect:SetActive(false)
    self.m_lineEffect:SetActive(true)
  end
end

UIHeroUniqueWeaponPreviewLine.OnCreate = OnCreate
UIHeroUniqueWeaponPreviewLine.OnDestroy = OnDestroy
UIHeroUniqueWeaponPreviewLine.OnEnable = OnEnable
UIHeroUniqueWeaponPreviewLine.OnDisable = OnDisable
UIHeroUniqueWeaponPreviewLine.PlayeLineEffect = PlayeLineEffect
return UIHeroUniqueWeaponPreviewLine
