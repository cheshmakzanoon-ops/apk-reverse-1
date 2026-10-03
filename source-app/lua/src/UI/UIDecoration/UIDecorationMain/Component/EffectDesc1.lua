local EffectDesc1 = BaseClass("EffectDesc1", UIBaseContainer)
local base = UIBaseContainer
local cell = require("UI.UIDecoration.UIDecorationMain.Component.EffectCell")
local quality_path = "QualityBg/QualityText"
local name_path = "NameText"
local use_title_path = "UseTitle"
local use_effect_path = "UseEffect"
local own_title_path = "OwnTitle"
local own_effect_path = "OwnEffect"
local quality_bg_path = "QualityBg"
local prefab_path = "Assets/Main/Prefabs/UI/ActivityCenter/BarterShop/DecoraionEffectCell.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.quality = self:AddComponent(UIText, quality_path)
  self.name = self:AddComponent(UIText, name_path)
  self.use_title = self:AddComponent(UIText, use_title_path)
  self.use_title:SetLocalText(320564)
  self.use_effect = self:AddComponent(UIBaseContainer, use_effect_path)
  self.own_title = self:AddComponent(UIText, own_title_path)
  self.own_effect = self:AddComponent(UIBaseContainer, own_effect_path)
  self.own_title:SetLocalText(320565)
  self.quality_bg = self:AddComponent(UIImage, quality_bg_path)
end

local function ComponentDestroy(self)
  self.use_effect:RemoveComponents(cell)
  self.own_effect:RemoveComponents(cell)
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
end

local function ReInit(self, data)
  self.data = data
  self:RefreshView()
end

local function RefreshView(self)
  self.quality:SetText(self.data.quality)
  self.name:SetText(self.data.name)
  self.name:SetColor(self.data.color)
  self.quality_bg:LoadSprite(self.data.qualityBg)
  self.use_effect:RemoveComponents(cell)
  self.own_effect:RemoveComponents(cell)
  if string.IsNullOrEmpty(self.data.useEffect) then
    self.use_title:SetActive(false)
    self.use_effect:SetActive(false)
  else
    self.use_title:SetActive(true)
    self.use_effect:SetActive(true)
    for k, v in ipairs(self.data.wearEffects) do
      self:GameObjectInstantiateAsync(prefab_path, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.use_effect.transform)
        go.transform:Set_localPosition(ResetPosition)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local item = self.use_effect:AddComponent(cell, go.name)
        item:ReInit(v)
      end)
    end
  end
  if string.IsNullOrEmpty(self.data.ownEffect) then
    self.own_title:SetActive(false)
    self.own_effect:SetActive(false)
  else
    self.own_title:SetActive(true)
    self.own_effect:SetActive(true)
    for k, v in ipairs(self.data.ownEffects) do
      self:GameObjectInstantiateAsync(prefab_path, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.own_effect.transform)
        go.transform:Set_localPosition(ResetPosition)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local item = self.own_effect:AddComponent(cell, go.name)
        item:ReInit(v)
      end)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

EffectDesc1.OnCreate = OnCreate
EffectDesc1.OnDestroy = OnDestroy
EffectDesc1.OnEnable = OnEnable
EffectDesc1.OnDisable = OnDisable
EffectDesc1.ComponentDefine = ComponentDefine
EffectDesc1.ComponentDestroy = ComponentDestroy
EffectDesc1.DataDefine = DataDefine
EffectDesc1.DataDestroy = DataDestroy
EffectDesc1.ReInit = ReInit
EffectDesc1.RefreshView = RefreshView
return EffectDesc1
