local TacticalEquipUpgradeLevelStageItem = BaseClass("TacticalEquipUpgradeLevelStageItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.imgStageProgressBg = self:AddComponent(UIImage, "stageProgressBg")
  self.textStageProgressNum = self:AddComponent(UITextMeshProUGUIEx, "stageProgressNum")
  self.eventTriggerBtn = self:AddComponent(UIEventTrigger, "btn")
  self.eventTriggerBtn:OnPointerClick(function(eventData)
    self:OnBtnClick(eventData)
  end)
end

local function ComponentDestroy(self)
  self.imgStageProgressBg = nil
  self.textStageProgressNum = nil
  self.eventTriggerBtn = nil
end

function TacticalEquipUpgradeLevelStageItem:SetData(index, total, callback)
  self.percent = math.floor(index / total * 100 + 0.5)
  self.textStageProgressNum:SetText(self.percent)
  self.callback = callback
end

function TacticalEquipUpgradeLevelStageItem:Refresh(curPercent)
  self.imgStageProgressBg:SetActive(self.percent > 0)
  local highLight = self.percent <= curPercent * 100
  if highLight then
    self.imgStageProgressBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeaponEquip/wxy_wurenjizujian_jieduandi01.png")
    self.textStageProgressNum:SetColorRGBA255(255, 255, 255, 255)
  else
    self.imgStageProgressBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeaponEquip/wxy_wurenjizujian_jieduandi02.png")
    self.textStageProgressNum:SetColorRGBA255(0, 118, 201, 255)
  end
end

function TacticalEquipUpgradeLevelStageItem:OnBtnClick(eventData)
  if eventData.pointerPressRaycast.gameObject.name ~= self.eventTriggerBtn.gameObject.name then
    return
  end
  if self.callback then
    self.callback(eventData)
  end
end

TacticalEquipUpgradeLevelStageItem.OnCreate = OnCreate
TacticalEquipUpgradeLevelStageItem.OnDestroy = OnDestroy
TacticalEquipUpgradeLevelStageItem.OnEnable = OnEnable
TacticalEquipUpgradeLevelStageItem.OnDisable = OnDisable
TacticalEquipUpgradeLevelStageItem.ComponentDefine = ComponentDefine
TacticalEquipUpgradeLevelStageItem.ComponentDestroy = ComponentDestroy
return TacticalEquipUpgradeLevelStageItem
