local TacticalEquipItem = BaseClass("TacticalEquipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.imgFrameBg = self:AddComponent(UIImage, "frameBg")
  self.imgFrameBgIcon = self:AddComponent(UIImage, "frameBg/frameBgIcon")
  self.compRedPoint = self:AddComponent(UIBaseContainer, "redPoint")
  self.textLevel = self:AddComponent(UITextMeshProUGUIEx, "level")
  self.eventTriggerBtn = self:AddComponent(UIEventTrigger, "btn")
  self.compResItem = self:AddComponent(UICommonResItem, "resItem")
  self.eventTriggerBtn:OnPointerClick(function(eventData)
    self:OnBtnClick(eventData)
  end)
  self:SetRedDot(false)
  self:SetBtnActive(true)
end

local function ComponentDestroy(self)
  self.imgFrameBg = nil
  self.imgFrameBgIcon = nil
  self.compResItem = nil
  self.compRedPoint = nil
  self.textLevel = nil
  self.eventTriggerBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TacticalEquipItem:SetData(equipData, slot)
  self.equipData = equipData
  self.slot = slot
  self.textLevel:SetActive(false)
  if self.equipData == nil then
    self.compResItem:SetActive(false)
    self:RefreshEquipBgIcon()
  else
    self:RefreshEquipItem()
  end
end

function TacticalEquipItem:SetConfigData(config)
  if config == nil then
    return
  end
  local param = UICommonResItem.Param.New()
  param.rewardType = RewardType.CommonEquip
  param.itemId = config.id
  param.count = 1
  param.enableClick = false
  self.compResItem:ReInit(param)
  self.compResItem:SetActive(true)
  self.compResItem:SetFlagActive(false)
  self.textLevel:SetText(string.format("Lv.%d", config.level))
  self.textLevel:SetActive(true)
end

function TacticalEquipItem:SetRedDot(visible)
  self.compRedPoint:SetActive(visible)
end

function TacticalEquipItem:SetItemCountActive(visible)
  if self.compResItem then
    self.compResItem:SetItemCountActive(visible)
  end
end

function TacticalEquipItem:SetShowNum(num)
  if self.compResItem then
    self.compResItem:SetItemCount(num)
  end
end

function TacticalEquipItem:SetBtnActive(active)
  if self.eventTriggerBtn then
    self.eventTriggerBtn:SetActive(active)
  end
end

function TacticalEquipItem:SetClick(callback)
  self.clickHandler = callback
end

function TacticalEquipItem:OnBtnClick(eventData)
  if eventData.pointerPressRaycast.gameObject.name ~= self.eventTriggerBtn.gameObject.name then
    return
  end
  if self.clickHandler then
    self.clickHandler(eventData)
  end
end

function TacticalEquipItem:RefreshEquipBgIcon()
  local path = string.format("Assets/Main/Sprites/UI/UILWSquadEquip/sj_zhanshuwuqi_zhuangbei_icon%s.png", self.slot)
  self.imgFrameBgIcon:LoadSprite(path)
  self.imgFrameBgIcon:SetNativeSize()
end

function TacticalEquipItem:RefreshEquipItem()
  local param = UICommonResItem.Param.New()
  param.rewardType = RewardType.CommonEquip
  param.itemId = self.equipData.cfgId
  param.count = self.equipData.num
  self.compResItem:ReInit(param)
  self.compResItem:SetActive(true)
  self.compResItem:SetFlagActive(false)
  if self.equipData.config then
    self.textLevel:SetText(string.format("Lv.%d", self.equipData.config.level))
    self.textLevel:SetActive(true)
  end
end

TacticalEquipItem.OnCreate = OnCreate
TacticalEquipItem.OnDestroy = OnDestroy
TacticalEquipItem.OnEnable = OnEnable
TacticalEquipItem.OnDisable = OnDisable
TacticalEquipItem.ComponentDefine = ComponentDefine
TacticalEquipItem.ComponentDestroy = ComponentDestroy
TacticalEquipItem.DataDefine = DataDefine
TacticalEquipItem.DataDestroy = DataDestroy
TacticalEquipItem.OnAddListener = OnAddListener
TacticalEquipItem.OnRemoveListener = OnRemoveListener
return TacticalEquipItem
