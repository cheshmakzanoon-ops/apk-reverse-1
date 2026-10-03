local SkillChipSmallItem = BaseClass("SkillChipSmallItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local click_btn_path = "clickBtn"
local bg_path = "clickBtn/Bg"
local icon_path = "clickBtn/Icon"
local level_text_path = "clickBtn/LevelText"
local unset_btn_path = "clickBtn/UnsetBtn"
local count_text_path = "clickBtn/CountText"
local masterset_bg_path = "masterBg"
local masterset_text_path = "masterBg/masterTxt"
local selected_path = "Selected"
local wearing_path = "clickBtn/Wearing"
local border_path = "clickBtn/border"
local ItemType = {Goods = 1, Chip = 2}

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
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self, self.skillChipInfo)
    end
  end)
  self.eventTrigger = self:AddComponent(UIEventTrigger, click_btn_path)
  self.eventTrigger:onLongPress(function()
    if self.longPressCallback then
      self.longPressCallback(self, self.skillChipInfo)
    end
  end)
  self.eventTrigger:OnPointerUp(function()
    if self.pointerUpCallback then
      self.pointerUpCallback(self, self.skillChipInfo)
    end
  end)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.unset_btn = self:AddComponent(UIButton, unset_btn_path)
  self.unset_btn:SetOnClick(function()
    if self.unsetCallback then
      self.unsetCallback(self, self.skillChipInfo)
    end
  end)
  self.unset_trigger = self:AddComponent(UIEventTrigger, unset_btn_path)
  self.unset_trigger:onLongPress(function()
    if self.unsetLongPressCallback then
      self.unsetLongPressCallback(self, self.skillChipInfo)
    end
  end)
  self.unset_trigger:OnPointerUp(function()
    if self.unsetPointerUpCallback then
      self.unsetPointerUpCallback(self, self.skillChipInfo)
    end
  end)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.masterset_bg = self:AddComponent(UIImage, masterset_bg_path)
  self.masterset_text = self:AddComponent(UIText, masterset_text_path)
  self.selected = self:AddComponent(UIImage, selected_path)
  self.selected:SetActive(false)
  self.wearing = self:AddComponent(UIImage, wearing_path)
  self.wearing:SetActive(false)
  self.border = self:AddComponent(UIImage, border_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, skillChipInfo)
  if not skillChipInfo then
    self:SetActive(false)
    return
  end
  self.skillChipInfo = DataCenter.TacticalChipManager:GetChipInfo(skillChipInfo.uuid)
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, skillChipInfo.configId))
  self.icon:LoadSpriteAuto(self.skillChipInfo:GetIcon())
  self.border:SetActive(true)
  self.itemInfo = skillChipInfo
end

function SkillChipSmallItem:SetItemInfo(itemInfo)
  if itemInfo.type == ItemType.Goods then
    self:SetChipExpItem(itemInfo)
  else
    self:SetChipItem(itemInfo)
  end
end

function SkillChipSmallItem:SetChipItem(itemInfo)
  if not itemInfo then
    return
  end
  self.skillChipInfo = DataCenter.TacticalChipManager:GetChipInfo(itemInfo.uuid)
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, itemInfo.configId))
  self.icon:LoadSpriteAuto(self.skillChipInfo:GetIcon())
  self.border:SetActive(true)
  self.itemInfo = itemInfo
end

function SkillChipSmallItem:SetChipExpItem(chipExpItemInfo)
  if not chipExpItemInfo then
    return
  end
  self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.GOODS, chipExpItemInfo.configId))
  self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, chipExpItemInfo.configId))
  self.border:SetActive(false)
  self.itemInfo = chipExpItemInfo
end

function SkillChipSmallItem:SetShowCount(count)
  if 0 < count then
    self.masterset_text:SetText(count)
    self.masterset_bg:SetActive(true)
  else
    self.masterset_bg:SetActive(false)
  end
end

local function SetSelected(self, selected)
  self.selected:SetActive(selected)
end

local function SetOnClick(self, callback)
  self.clickCallback = callback
end

local function SetIsWearing(self, isWearing)
  self.wearing:SetActive(isWearing)
  if isWearing then
    self.masterset_bg:SetActive(false)
  end
end

local function SetOnLongPress(self, callback)
  self.longPressCallback = callback
end

local function SetOnPointerUp(self, callback)
  self.pointerUpCallback = callback
end

local function SetSelectNumber(self, selectNumber)
  selectNumber = selectNumber or 0
  if self.maxNumber then
    if 0 < selectNumber then
      self.count_text:SetText(string.format("%d/%d", selectNumber, self.maxNumber))
      self.unset_btn:SetActive(true)
    else
      self.count_text:SetText(self.maxNumber)
      self.unset_btn:SetActive(false)
    end
  end
end

local function SetOnUnsetClick(self, callback)
  self.unsetCallback = callback
end

local function SetOnUnsetLongPress(self, callback)
  self.unsetLongPressCallback = callback
end

local function SetOnUnsetPointerUp(self, callback)
  self.unsetPointerUpCallback = callback
end

SkillChipSmallItem.OnCreate = OnCreate
SkillChipSmallItem.OnDestroy = OnDestroy
SkillChipSmallItem.ComponentDefine = ComponentDefine
SkillChipSmallItem.ComponentDestroy = ComponentDestroy
SkillChipSmallItem.DataDefine = DataDefine
SkillChipSmallItem.DataDestroy = DataDestroy
SkillChipSmallItem.OnEnable = OnEnable
SkillChipSmallItem.OnDisable = OnDisable
SkillChipSmallItem.SetData = SetData
SkillChipSmallItem.SetSelected = SetSelected
SkillChipSmallItem.SetOnClick = SetOnClick
SkillChipSmallItem.SetIsWearing = SetIsWearing
SkillChipSmallItem.SetOnLongPress = SetOnLongPress
SkillChipSmallItem.SetSelectNumber = SetSelectNumber
SkillChipSmallItem.SetOnPointerUp = SetOnPointerUp
SkillChipSmallItem.SetOnUnsetClick = SetOnUnsetClick
SkillChipSmallItem.SetOnUnsetLongPress = SetOnUnsetLongPress
SkillChipSmallItem.SetOnUnsetPointerUp = SetOnUnsetPointerUp
return SkillChipSmallItem
