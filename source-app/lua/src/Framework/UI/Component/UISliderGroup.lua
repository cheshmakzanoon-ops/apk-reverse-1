local UISliderGroup = BaseClass("UISliderGroup", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UISliderGroup:OnCreate()
  base.OnCreate(self)
  self.slider = self:AddComponent(UISlider, "Slider")
  self.slider:SetOnValueChanged(function(value)
    self:OnInputSliderChanged(value)
  end)
  self.btnSub = self:AddComponent(UIButton, "subBtn")
  self.btnSub:SetOnClick(function()
    self:OnSubBtnClick()
  end)
  self.btnAdd = self:AddComponent(UIButton, "addBtn")
  self.btnAdd:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.textCurCount = self:AddComponent(UIInput, "numRoot/TextBg/curCount")
  self.textTips = self:AddComponent(UIText, "tips")
  self.minNum = 0
  self.maxNum = 0
  self.gap = 1
end

function UISliderGroup:OnDestroy()
  base.OnDestroy(self)
end

function UISliderGroup:OnEnable()
  base.OnEnable(self)
end

function UISliderGroup:OnDisable()
  base.OnDisable(self)
end

function UISliderGroup:ReInit()
  self.curNum = nil
  if self.maxNum < self.minNum then
    Logger.LogError("min > max!  min.." .. self.minNum .. " max:" .. self.maxNum)
    return
  end
  if self.defaultNum == nil or self.defaultNum < self.minNum or self.defaultNum > self.maxNum then
    self.defaultNum = self.minNum
  end
  self:SetInputText(self.defaultNum)
end

function UISliderGroup:SetOnNumChangedHandler(callback)
  self.onNumChangedHandler = callback
end

function UISliderGroup:SetMaxNum(maxNum)
  self.maxNum = maxNum
end

function UISliderGroup:SetMinNum(minNum)
  self.minNum = minNum
end

function UISliderGroup:SetDefaultNum(num)
  self.defaultNum = num
end

function UISliderGroup:SetCurNum(num)
  self:SetInputText(num)
end

function UISliderGroup:GetCurNum()
  return self.curNum
end

function UISliderGroup:SetGap(gap)
  self.gap = gap or 1
end

function UISliderGroup:SetTipText(content)
  self.textCurCount:SetText(content)
end

function UISliderGroup:OnInputSliderChanged(value)
  local newNum = 0
  if self.slider:IsWholeNumbers() then
    newNum = value
  else
    local percentNum = value * self.maxNum
    newNum = math.floor(percentNum + 0.5)
    if not self.locked then
      newNum = math.max(self.minNum, newNum)
      newNum = math.min(self.maxNum, newNum)
    end
  end
  self:SetInputText(newNum)
end

function UISliderGroup:OnSubBtnClick()
  local newNum = math.max(self.minNum, self.curNum - self.gap)
  self:SetInputText(newNum)
end

function UISliderGroup:OnAddBtnClick()
  local newNum = math.min(self.maxNum, self.curNum + self.gap)
  self:SetInputText(newNum)
end

function UISliderGroup:SetInputText(value)
  if value == self.curNum then
    self:RefreshSlider()
    return
  end
  self.curNum = value
  self:RefreshBtnStatus()
  self:RefreshSlider()
  if self.onNumChangedHandler then
    self.onNumChangedHandler(self.curNum)
  end
end

function UISliderGroup:RefreshBtnStatus()
  local canSub = self.curNum > self.minNum
  local canAdd = self.curNum < self.maxNum
  CS.UIGray.SetGray(self.btnSub.transform, not canSub, canSub)
  CS.UIGray.SetGray(self.btnAdd.transform, not canAdd, canAdd)
end

function UISliderGroup:RefreshSlider()
  if self.slider:IsWholeNumbers() then
    self.slider:SetValue(self.curNum)
  else
    self.slider:SetValue(self.curNum / math.max(1, self.maxNum))
  end
end

function UISliderGroup:SetInteractable(flag)
  self.slider:SetInteractable(flag)
  self.btnSub:SetInteractable(flag)
  self.btnAdd:SetInteractable(flag)
end

function UISliderGroup:InitTextInput()
  self.textCurCount:SetInteractable(true)
  self.textCurCount:SetOnValueChange(function(value)
    self:OnValueChange(value)
  end)
  self.textCurCount:SetOnEndEdit(function(value)
    self:SetOnEndEdit(value)
  end)
end

function UISliderGroup:OnValueChange(value)
  if self.locked then
    return
  end
  local num = tonumber(value)
  if not num then
    self:SetInputText(self.minNum)
    return
  end
  self.locked = true
  self:SetInputText(num)
  self.locked = false
end

function UISliderGroup:SetOnEndEdit(value)
  local num = tonumber(value)
  if not num then
    self:SetInputText(self.minNum)
    return
  end
  num = math.floor(num + 0.5)
  num = math.max(self.minNum, num)
  num = math.min(self.maxNum, num)
  self:SetInputText(num)
end

return UISliderGroup
