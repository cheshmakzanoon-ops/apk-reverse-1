local base = UIBaseContainer
local CommonSelectItem = BaseClass("CommonSelectItem", base)
local selectBtn_path = ""
local desText_path = "nameTxt"
local selectFlag_path = "selectedIcon"

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
  self.selectBtn = self:AddComponent(UIButton, selectBtn_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.selectFlag = self:AddComponent(UIBaseContainer, selectFlag_path)
  self.selectBtn:SetOnClick(function()
    if self.clickCall then
      self.clickCall(self.index)
    end
  end)
end

local function ComponentDestroy(self)
  self.selectBtn = nil
  self.desText = nil
  self.selectFlag = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.data = nil
  self.index = nil
  self.clickCall = nil
end

function CommonSelectItem:ReInit(index, data, selected, clickCall)
  self.data = data
  self.index = index
  self.clickCall = clickCall
  self.selectFlag:SetActive(selected)
  self.desText:SetText(data.des)
  self:SetSelectFlag(false)
end

function CommonSelectItem:SetSelectFlag(selected)
  self.selectFlag:SetActive(selected)
  if selected then
    self.desText:SetColor(Color.FromHex("2a2830"))
  else
    self.desText:SetColor(Color.FromHex("8f8e97"))
  end
end

function CommonSelectItem:SetDes(des)
  self.desText:SetText(des)
end

CommonSelectItem.OnCreate = OnCreate
CommonSelectItem.OnDestroy = OnDestroy
CommonSelectItem.OnEnable = OnEnable
CommonSelectItem.OnDisable = OnDisable
CommonSelectItem.ComponentDefine = ComponentDefine
CommonSelectItem.ComponentDestroy = ComponentDestroy
CommonSelectItem.DataDefine = DataDefine
CommonSelectItem.DataDestroy = DataDestroy
return CommonSelectItem
