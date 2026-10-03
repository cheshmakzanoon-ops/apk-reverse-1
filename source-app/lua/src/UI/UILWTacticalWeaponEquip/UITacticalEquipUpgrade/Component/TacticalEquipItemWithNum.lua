local TacticalEquipItemWithNum = BaseClass("TacticalEquipItemWithNum", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TacticalEquipItemWithNum:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalEquipItemWithNum:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalEquipItemWithNum:OnEnable()
  base.OnEnable(self)
end

function TacticalEquipItemWithNum:OnDisable()
  base.OnDisable(self)
end

function TacticalEquipItemWithNum:ComponentDefine()
  self.compResItem = self:AddComponent(UICommonResItem, "resItem")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "num")
  self.click_btn = self:AddComponent(UIButton, "clickBtn")
  self.click_btn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self, self.feedData)
    end
  end)
  self.eventTrigger = self:AddComponent(UIEventTrigger, "clickBtn")
  self.eventTrigger:onLongPress(function()
    if self.longPressCallback then
      self.longPressCallback(self, self.feedData)
    end
  end)
  self.eventTrigger:OnPointerUp(function()
    if self.pointerUpCallback then
      self.pointerUpCallback(self, self.feedData)
    end
  end)
  self.eventTrigger:OnBeginDrag(function(eventData)
    if self.beginDragCallback then
      self.beginDragCallback(eventData)
    end
  end)
  self.eventTrigger:OnEndDrag(function(eventData)
    if self.endDragCallback then
      self.endDragCallback(eventData)
    end
  end)
  self.eventTrigger:OnDrag(function(eventData)
    if self.dragCallback then
      self.dragCallback(eventData)
    end
  end)
  self.unset_btn = self:AddComponent(UIButton, "deleteBtn")
  self.unset_btn:SetOnClick(function()
    if self.unsetCallback then
      self.unsetCallback(self, self.feedData)
    end
  end)
  self.unset_trigger = self:AddComponent(UIEventTrigger, "deleteBtn")
  self.unset_trigger:onLongPress(function()
    if self.unsetLongPressCallback then
      self.unsetLongPressCallback(self, self.feedData)
    end
  end)
  self.unset_trigger:OnPointerUp(function()
    if self.unsetPointerUpCallback then
      self.unsetPointerUpCallback(self, self.feedData)
    end
  end)
end

function TacticalEquipItemWithNum:ComponentDestroy()
  self.compResItem = nil
  self.textNum = nil
  self.btnClick = nil
  self.btnDelete = nil
end

function TacticalEquipItemWithNum:DataDefine()
end

function TacticalEquipItemWithNum:DataDestroy()
end

function TacticalEquipItemWithNum:SetData(feedData)
  self.feedData = feedData
  self:RefreshEquipItem()
  self:SetSelectNumber(feedData.useNum)
end

function TacticalEquipItemWithNum:RefreshEquipItem()
  local param = UICommonResItem.Param.New()
  param.rewardType = RewardType.CommonEquip
  param.itemId = self.feedData.equip.cfgId
  param.count = self.feedData.equip.num
  param.enableClick = false
  self.compResItem:ReInit(param)
  self.compResItem:SetActive(true)
  self.compResItem:SetItemCountActive(false)
end

function TacticalEquipItemWithNum:SetSelectNumber(selectNumber)
  selectNumber = selectNumber or 0
  local maxCount = self.feedData.equip.num
  if maxCount then
    if 0 < selectNumber then
      self.textNum:SetText(string.format("%d/%d", selectNumber, maxCount))
      self.unset_btn:SetActive(true)
    else
      self.textNum:SetText(string.format("%d/%d", 0, maxCount))
      self.unset_btn:SetActive(false)
    end
  end
  self.feedData.useNum = selectNumber
end

function TacticalEquipItemWithNum:SetOnClick(callback)
  self.clickCallback = callback
end

function TacticalEquipItemWithNum:SetOnLongPress(callback)
  self.longPressCallback = callback
end

function TacticalEquipItemWithNum:SetOnPointerUp(callback)
  self.pointerUpCallback = callback
end

function TacticalEquipItemWithNum:SetOnUnsetClick(callback)
  self.unsetCallback = callback
end

function TacticalEquipItemWithNum:SetOnUnsetLongPress(callback)
  self.unsetLongPressCallback = callback
end

function TacticalEquipItemWithNum:SetOnUnsetPointerUp(callback)
  self.unsetPointerUpCallback = callback
end

function TacticalEquipItemWithNum:SetOnBeginDrag(callback)
  self.beginDragCallback = callback
end

function TacticalEquipItemWithNum:SetOnEndDrag(callback)
  self.endDragCallback = callback
end

function TacticalEquipItemWithNum:SetOnDrag(callback)
  self.dragCallback = callback
end

return TacticalEquipItemWithNum
