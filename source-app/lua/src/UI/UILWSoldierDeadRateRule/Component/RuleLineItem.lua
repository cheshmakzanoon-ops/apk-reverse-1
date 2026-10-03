local base = UIBaseContainer
local RuleLineItem = BaseClass("RuleLineItem", base)
local name_txt_path = "Content/name_txt"
local val1_txt_path = "Content/val1_txt"
local val2_txt_path = "Content/val2_txt"
local img_div_path = "ImgDiv"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.val1_txt = self:AddComponent(UIText, val1_txt_path)
  self.val2_txt = self:AddComponent(UIText, val2_txt_path)
  self.img_div = self:AddComponent(UIImage, img_div_path)
end

local function ComponentDestroy(self)
  self.name_txt = nil
  self.val1_txt = nil
  self.val2_txt = nil
  self.img_div = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, name, val1, val2, index)
  self.name_txt:SetLocalText(name)
  self.val1_txt:SetText(val1)
  self.val2_txt:SetText(val2)
  self.img_div:SetActive(index % 2 ~= 0)
end

RuleLineItem.OnCreate = OnCreate
RuleLineItem.OnDestroy = OnDestroy
RuleLineItem.OnEnable = OnEnable
RuleLineItem.OnDisable = OnDisable
RuleLineItem.ComponentDefine = ComponentDefine
RuleLineItem.ComponentDestroy = ComponentDestroy
RuleLineItem.DataDefine = DataDefine
RuleLineItem.DataDestroy = DataDestroy
RuleLineItem.SetData = SetData
return RuleLineItem
