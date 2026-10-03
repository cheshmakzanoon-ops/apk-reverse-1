local TradeResItem = BaseClass("PlayerResourceReportCell", UIBaseContainer)
local base = UIBaseContainer
local input_path = "InputField"
local slider_path = "Slider"
local add_btn_path = "AddButton"
local sub_btn_path = "ReduceButton"
local icon_path = "BagItem/Image"

local function OnCreate(self, ...)
  local tempType = (...)
  base.OnCreate(self)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    self:OnValueChange(value)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:OnAdd()
  end)
  self.sub_btn = self:AddComponent(UIButton, sub_btn_path)
  self.sub_btn:SetOnClick(function()
    self:OnSub()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self:InitData(tempType)
end

local function OnDestroy(self)
  self.input = nil
  self.slider = nil
  self.add_btn = nil
  self.sub_btn = nil
  self.icon = nil
  base.OnDestroy(self)
end

local function InitData(self, resType)
  self.type = resType
  self.icon:LoadSprite(CS.ResourceUtils.GetResourceImagePath(self.type))
  self.curNum = 0
  self.maxNum = 0
  self.slider:SetValue(0)
  self.input:SetText("0")
end

local function RefreshData(self)
  self.curNum = self.view.ctrl:GetCurNumByResType(self.type)
  self.maxNum = self.view.ctrl:GetMaxNumByResType(self.type)
  self.input:SetText(self.curNum)
  local percent = self.curNum / math.max(1, self.maxNum)
  self.slider:SetValue(percent)
end

local function OnAdd(self)
  self.curNum = self.view.ctrl:GetCurNumByResType(self.type)
  self.maxNum = self.view.ctrl:GetMaxNumByResType(self.type)
  local changeNum = self.view.ctrl:GetCurResourceChangeByTotal(self.curNum, self.maxNum, true)
  self:SetValueData(changeNum)
end

local function OnSub(self)
  self.curNum = self.view.ctrl:GetCurNumByResType(self.type)
  self.maxNum = self.view.ctrl:GetMaxNumByResType(self.type)
  local changeNum = self.view.ctrl:GetCurResourceChangeByTotal(self.curNum, self.maxNum, false)
  self:SetValueData(changeNum)
end

local function OnValueChange(self, val)
  local cnt = math.floor(val * self.maxNum + 0.5)
  self.input:SetText(cnt)
  self.curNum = cnt
  self.view.ctrl:SetCurNumByResType(self.type, cnt)
  self.view:UpdateViewState()
end

local function SetValueData(self, data)
  local count = math.max(0, data)
  local percent = count / math.max(1, self.maxNum)
  self.slider:SetValue(percent)
end

local function IptOnValueChange(self, value)
  local cnt = tonumber(value)
  if cnt < 0 then
    cnt = 0
  end
  if cnt > self.maxNum then
    cnt = self.maxNum
  end
  cnt = math.floor(cnt + 0.5)
  self.input:SetText(cnt)
  local percent = cnt / math.max(1, self.maxNum)
  self.slider:SetValue(percent)
end

TradeResItem.OnCreate = OnCreate
TradeResItem.OnDestroy = OnDestroy
TradeResItem.InitData = InitData
TradeResItem.RefreshData = RefreshData
TradeResItem.OnAdd = OnAdd
TradeResItem.OnSub = OnSub
TradeResItem.OnValueChange = OnValueChange
TradeResItem.SetValueData = SetValueData
TradeResItem.IptOnValueChange = IptOnValueChange
return TradeResItem
