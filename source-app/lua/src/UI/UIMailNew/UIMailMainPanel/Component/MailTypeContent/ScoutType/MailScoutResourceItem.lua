local MailScoutReosurceItem = BaseClass("MailScoutReosurceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local resource_icon_path = "Icon"
local resource_count_path = "Count"

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
  self.BtnN = self:AddComponent(UIButton, this_path)
  self.BtnN:SetOnClick(function()
    self:OnClick()
  end)
  self.ResourceIconN = self:AddComponent(UIImage, resource_icon_path)
  self.ResourceCountN = self:AddComponent(UIText, resource_count_path)
end

local function ComponentDestroy(self)
  self.BtnN = nil
  self.ResourceIconN = nil
  self.ResourceCountN = nil
end

local function DataDefine(self)
  self.type = 0
  self.value = 0
end

local function DataDestroy(self)
  self.type = nil
  self.value = nil
end

local function RefreshData(self, resourceData)
  self.type = type(resourceData.type) == "number" and resourceData.type or resourceData.type.value
  self.value = type(resourceData.value) == "number" and resourceData.value or resourceData.value.value
  if self.type == ResourceType.ResourceItem then
    self.id = type(resourceData.id) == "number" and resourceData.id or resourceData.id.value
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.id)
    if template ~= nil then
      self.ResourceIconN:LoadSprite(string.format(LoadPath.ItemPath, template.pic))
    end
  else
    self.ResourceIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.type))
  end
  self.ResourceCountN:SetText(string.GetFormattedStr(self.value))
end

local function OnClick(self)
  if self.type == ResourceType.FarmBox then
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = Localization:GetString("300143")
    param.alignObject = self.ResourceIconN
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

MailScoutReosurceItem.OnCreate = OnCreate
MailScoutReosurceItem.OnDestroy = OnDestroy
MailScoutReosurceItem.OnEnable = OnEnable
MailScoutReosurceItem.OnDisable = OnDisable
MailScoutReosurceItem.ComponentDefine = ComponentDefine
MailScoutReosurceItem.ComponentDestroy = ComponentDestroy
MailScoutReosurceItem.DataDefine = DataDefine
MailScoutReosurceItem.DataDestroy = DataDestroy
MailScoutReosurceItem.RefreshData = RefreshData
MailScoutReosurceItem.OnClick = OnClick
return MailScoutReosurceItem
