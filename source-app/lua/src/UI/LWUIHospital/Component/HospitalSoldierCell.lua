local HospitalSoldierCell = BaseClass("HospitalSoldierCell", UIBaseContainer)
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local base = UIBaseContainer

function HospitalSoldierCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function HospitalSoldierCell:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "Slider")
  self.count_text = self:AddComponent(UIText, "count_text")
  self.soldierDetail = self:AddComponent(UISoldierItem, "UISoldierDetails_Item")
  self.addBtn = self:AddComponent(UIButton, "addBtn")
  self.subtractBtn = self:AddComponent(UIButton, "subtractBtn")
  self.cur_count_input = self:AddComponent(UIInput, "curCountInput")
  self.gray_image = self:AddComponent(UIImage, "GrayImage")
  self.slider:SetOnValueChanged(function(value)
    self:OnCountSliderValueChanged(value)
  end)
  self.addBtn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
  self.subtractBtn:SetOnClick(function()
    self:OnSubtractBtnClick()
  end)
  self.cur_count_input:SetOnEndEdit(function(value)
    self:OnCurCountInputValueChange(value)
  end)
end

function HospitalSoldierCell:OnCountSliderValueChanged(value)
  local number = math.floor(value)
  number = number > self.minValue and number or self.minValue
  self.cur_count_input:SetText(number)
  if number ~= value then
    self.slider:SetValue(number)
  end
  self.callBack(self.index, number, self.isEdit)
end

function HospitalSoldierCell:ReInit(param, isTreating)
  self.callBack = param.callback
  self.index = param.index
  self.isEdit = false
  local max = param.dead
  self.slider.unity_uislider.maxValue = max
  self.slider.unity_uislider.minValue = 0
  local curCount = param.curCount
  if max < curCount then
    curCount = max
  elseif curCount <= 0 then
    curCount = 1
  end
  param.curCount = curCount
  self.slider:SetValue(curCount)
  self.isEdit = true
  self.count_text:SetText(math.floor(max))
  local elevenData = T11Util.GetSelfCurSoldierData()
  self.soldierDetail:SetData(DataCenter.SoldierDataManager:GetTemplate(param.armyId), elevenData)
  self.cur_count_input:SetText(math.floor(curCount))
  self.gray_image:SetActive(isTreating)
end

function HospitalSoldierCell:OnAddBtnClick()
  self.isEdit = true
  local curValue = self.slider:GetValue()
  if curValue < self.slider.unity_uislider.maxValue then
    self.slider:SetValue(curValue + 1)
  end
end

function HospitalSoldierCell:OnSubtractBtnClick()
  self.isEdit = true
  local curValue = self.slider:GetValue()
  if curValue > self.minValue then
    self.slider:SetValue(curValue - 1)
  end
end

function HospitalSoldierCell:OnCurCountInputValueChange(value)
  self.isEdit = true
  local curCount = tonumber(value) or self.slider:GetValue()
  if curCount > self.slider.unity_uislider.maxValue then
    curCount = self.slider.unity_uislider.maxValue
  elseif curCount < self.minValue then
    curCount = 1
  end
  self.slider:SetValue(curCount)
  self.cur_count_input:SetText(math.floor(curCount))
end

function HospitalSoldierCell:DataDefine()
  self.param = nil
  self.callBack = nil
  self.index = nil
  self.minValue = 1
  self.isEdit = 1
end

function HospitalSoldierCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HospitalSoldierCell:DataDestroy()
  self.param = nil
  self.minValue = nil
  self.isEdit = nil
end

function HospitalSoldierCell:ComponentDestroy()
  self.slider = nil
  self.count_text = nil
  self.soldierDetail = nil
  self.addBtn = nil
  self.subtractBtn = nil
  self.cur_count_input = nil
  self.gray_image = nil
end

return HospitalSoldierCell
