local UIEquipCostItem = BaseClass("UIEquipCostItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.icon = self:AddComponent(UIImage, "CostIcon")
  self.countText = self:AddComponent(UIText, "CostCountText")
end

local function ComponentDestroy(self)
  self.icon = nil
  self.countText = nil
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

local function SetData(self, data)
  if not data then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.data = data
  self:RefreshShowData()
end

local function RefreshShowData(self)
  if not self.data then
    return
  end
  if self.data.isResource then
    local resourceType = self.data.id
    self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
    local curHave = LuaEntry.Resource:GetCntByResType(resourceType)
    if curHave < self.data.value then
      self.countText:SetText(string.format("<color=#F53C3D>%s</color>/%s", string.GetFormattedStr(curHave), string.GetFormattedStr(self.data.value)))
    else
      self.countText:SetText(string.format("<color=#FFFFFF>%s</color>/%s", string.GetFormattedStr(curHave), string.GetFormattedStr(self.data.value)))
    end
  else
    self.icon:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(self.data.id))
    local curHave = DataCenter.ResourceItemDataManager:GetCountByItemId(self.data.id)
    if curHave < self.data.value then
      self.countText:SetText(string.format("<color=#F53C3D>%s</color>/%s", string.GetFormattedStr(curHave), string.GetFormattedStr(self.data.value)))
    else
      self.countText:SetText(string.format("<color=#FFFFFF>%s</color>/%s", string.GetFormattedStr(curHave), string.GetFormattedStr(self.data.value)))
    end
  end
end

UIEquipCostItem.OnCreate = OnCreate
UIEquipCostItem.OnDestroy = OnDestroy
UIEquipCostItem.ComponentDefine = ComponentDefine
UIEquipCostItem.ComponentDestroy = ComponentDestroy
UIEquipCostItem.DataDefine = DataDefine
UIEquipCostItem.DataDestroy = DataDestroy
UIEquipCostItem.OnEnable = OnEnable
UIEquipCostItem.OnDisable = OnDisable
UIEquipCostItem.RefreshShowData = RefreshShowData
UIEquipCostItem.SetData = SetData
return UIEquipCostItem
