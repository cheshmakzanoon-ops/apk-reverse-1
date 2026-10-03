local UISliderBtnInputField = BaseClass("UISliderBtnInputField", UIBaseContainer)
local base = UIBaseContainer

function UISliderBtnInputField:OnCreate()
  base.OnCreate(self)
  self.slider = self:TryAddComponent(UISlider, "Slider")
  if self.slider then
    self.slider:SetOnValueChanged(function(value)
      self:OnInputSliderChanged(value)
    end)
  end
  self.btnSub = self:TryAddComponent(UILongPressTrigger, "subBtn")
  if self.btnSub then
    self.btnSub:SetCallback(function()
      return self:OnSubBtnClick()
    end)
  end
  self.btnAdd = self:TryAddComponent(UILongPressTrigger, "addBtn")
  if self.btnAdd then
    self.btnAdd:SetCallback(function()
      return self:OnAddBtnClick()
    end)
  end
  self.inputField = self:TryAddComponent(UIInput, "InputFieldEx")
  if self.inputField then
    self.inputField:SetOnValueChange(function(value)
      self:OnInputFieldChanged(value)
    end)
  end
  self.textMeshPro = self:TryAddComponent(UITextMeshProUGUIEx, "InputFieldEx/Text Area/Text")
  self.minNum = 0
  self.maxNum = 0
  self.granularity = 1
end

function UISliderBtnInputField:OnDestroy()
  if self.btnAdd then
    self.btnAdd:StopLongPressListener()
  end
  if self.btnSub then
    self.btnSub:StopLongPressListener()
  end
  self.slider = nil
  self.btnSub = nil
  self.btnAdd = nil
  self.inputField = nil
  self.textMeshPro = nil
  base.OnDestroy(self)
end

function UISliderBtnInputField:OnEnable()
  base.OnEnable(self)
end

function UISliderBtnInputField:OnDisable()
  base.OnDisable(self)
end

function UISliderBtnInputField:Init(min, max, default, handler, granularity, enableLongPress)
  self:SetMaxNum(max)
  self:SetMinNum(min)
  self:SetDefaultNum(default)
  self:SetOnNumChangedHandler(handler)
  self:SetGranularity(granularity)
  self.curNum = nil
  if self.maxNum < self.minNum then
    Logger.LogError("min > max!  min.." .. self.minNum .. " max:" .. self.maxNum)
    return
  end
  if self.defaultNum == nil or self.defaultNum < self.minNum or self.defaultNum > self.maxNum then
    self.defaultNum = self.minNum
  end
  self:SetValue(self.defaultNum)
  self.enableLongPress = enableLongPress == true or enableLongPress == nil
  if self.enableLongPress and self.btnAdd then
    self.btnAdd:StartLongPressListener()
  end
  if self.enableLongPress and self.btnSub then
    self.btnSub:StartLongPressListener()
  end
end

function UISliderBtnInputField:SetOnNumChangedHandler(callback)
  self.onNumChangedHandler = callback
end

function UISliderBtnInputField:SetMaxNum(maxNum)
  self.maxNum = maxNum
  if self.slider then
    self.slider:SetMax(self.maxNum)
  end
end

function UISliderBtnInputField:SetMinNum(minNum)
  self.minNum = minNum
  if self.slider then
    self.slider:SetMin(self.minNum)
  end
end

function UISliderBtnInputField:SetDefaultNum(num)
  self.defaultNum = num
end

function UISliderBtnInputField:SetGranularity(num)
  if num then
    if num <= 0 then
      Logger.LogError("UISliderBtnInputField:SetGranularity() \233\162\151\231\178\146\229\186\166\228\184\141\232\131\189\229\176\143\228\186\1421")
      return
    end
    self.granularity = num
  end
end

function UISliderBtnInputField:GetCurNum()
  return self.curNum
end

function UISliderBtnInputField:SetCurNum(num)
  local value = Mathf.Clamp(num, self.minNum, self.maxNum)
  self:SetValue(value)
end

function UISliderBtnInputField:OnInputFieldChanged(value)
  if self.ignoreRedundantRefresh then
    self.ignoreRedundantRefresh = false
    return
  end
  value = toInt(value)
  if value == nil then
    return
  end
  value = Mathf.Clamp(value, self.minNum, self.maxNum)
  self:SetValue(value)
end

function UISliderBtnInputField:OnInputSliderChanged(value)
  local newNum = 0
  if self.slider and self.slider:IsWholeNumbers() then
    newNum = toInt(value)
  else
    local percentNum = value * self.maxNum
    newNum = math.floor(percentNum + 0.5)
    newNum = math.max(self.minNum, newNum)
    newNum = math.min(self.maxNum, newNum)
  end
  self:SetValue(newNum)
end

function UISliderBtnInputField:OnSubBtnClick()
  local newNum = math.max(self.minNum, self.curNum - self.granularity)
  self:SetValue(newNum)
  return self.curNum > self.minNum
end

function UISliderBtnInputField:OnAddBtnClick()
  local newNum = math.min(self.maxNum, self.curNum + self.granularity)
  self:SetValue(newNum)
  return self.curNum < self.maxNum
end

function UISliderBtnInputField:SetValue(value)
  self.curNum = value
  self:RefreshBtnStatus()
  self:RefreshSlider()
  if self.onNumChangedHandler then
    self.onNumChangedHandler(self.curNum)
  end
  if self.enableLongPress and self.btnAdd then
    self.btnAdd:StartLongPressListener()
  end
  if self.enableLongPress and self.btnSub then
    self.btnSub:StartLongPressListener()
  end
end

function UISliderBtnInputField:RefreshBtnStatus()
  local canSub = self.curNum > self.minNum
  local canAdd = self.curNum < self.maxNum
  if self.btnAdd then
    CS.UIGray.SetGray(self.btnAdd.transform, not canAdd, canAdd)
  end
  if self.btnSub then
    CS.UIGray.SetGray(self.btnSub.transform, not canSub, canSub)
  end
end

function UISliderBtnInputField:RefreshSlider()
  if not self.slider then
    return
  end
  if self.slider:IsWholeNumbers() then
    self.slider:SetValue(self.curNum)
  else
    self.slider:SetValue(self.curNum / self.maxNum)
  end
end

function UISliderBtnInputField:SetTipText(content, alignment)
  if self.inputField then
    self.ignoreRedundantRefresh = true
    self.inputField:SetText(content)
    self.ignoreRedundantRefresh = false
  end
  if alignment and self.textMeshPro then
    self.textMeshPro:SetAlignment(alignment)
  end
end

return UISliderBtnInputField
