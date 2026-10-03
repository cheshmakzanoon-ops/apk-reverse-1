local UIActSlotMidItem = BaseClass("UIActSlotMidItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local img_path = "img"
local bg_path = "bg"
local effect_path = "effect"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.effect = self:AddComponent(UIVfx, effect_path)
end

local function ComponentDestroy(self)
  self.img = nil
  self.bg = nil
  self.effect = nil
end

local function DataDefine(self)
  self.showData = nil
  self.isBlur = nil
end

local function DataDestroy(self)
  self.showData = nil
  self.isBlur = nil
end

local function SetData(self, showData, isBlur, effectPath)
  self.effect:SetActive(false)
  self.showData = showData
  self.isBlur = false
  if isBlur then
    self.isBlur = isBlur
  end
  self.effectPath = effectPath
  self:Refresh()
end

local function Refresh(self)
  if self.showData == nil then
    return
  end
  local path = ""
  if not self.isBlur then
    path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, self.showData.iconTemp.icon)
  else
    path = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, self.showData.iconTemp.icon_blur)
  end
  self.img:LoadSprite(path)
  self.img:SetNativeSize()
  local bgPath = ""
  if not self.isBlur then
    bgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, self.showData.iconTemp.icon_bg)
  else
    bgPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(UIAssets.UIActSlotMachineSpritePath, self.showData.iconTemp.icon_bg_blur)
  end
  self.bg:LoadSprite(bgPath)
  self.bg:SetNativeSize()
end

local function PlayEffect(self)
  local effectPath = "Assets/_Art_LastWar/Effect/Prefab/UI/laba/Eff_ui_actslotmachinemain_glow.prefab"
  if not string.IsNullOrEmpty(self.effectPath) then
    effectPath = self.effectPath
  end
  self.effect:SetActive(true)
  self.effect:Play(effectPath, {
    lifeType = UIVfxLifeType.Stay
  })
end

UIActSlotMidItem.OnCreate = OnCreate
UIActSlotMidItem.OnDestroy = OnDestroy
UIActSlotMidItem.ComponentDefine = ComponentDefine
UIActSlotMidItem.ComponentDestroy = ComponentDestroy
UIActSlotMidItem.DataDefine = DataDefine
UIActSlotMidItem.DataDestroy = DataDestroy
UIActSlotMidItem.SetData = SetData
UIActSlotMidItem.Refresh = Refresh
UIActSlotMidItem.PlayEffect = PlayEffect
return UIActSlotMidItem
