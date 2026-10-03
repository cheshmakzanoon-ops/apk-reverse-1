local UITopItem = BaseClass("UITopItem", UIBaseContainer)
local base = UIBaseContainer

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
  EventManager:GetInstance():Broadcast(EventId.EnableOneUITopItem)
end

local showNeedCount = 100000

local function OnAddBtnClick(self)
  if self.addBtncallBack then
    self:addBtncallBack()
    return
  end
  if self.itemId then
    LWResourceLackUtil:GotoGoodsItemLack(self.itemId, showNeedCount)
  elseif self.resourceType == ResourceType.Gold then
    local data = {}
    table.insert(data, {
      resType = self.resourceType,
      need = 100000
    })
    LWResourceLackUtil:GotoResLack(data)
  end
end

local function SetShowAddBtn(self, state)
  self.addBtn:SetActive(state)
end

local function ComponentDefine(self)
  self.imgIcon = self:AddComponent(UIImage, "root/resourceIcon")
  self.textNum = self:AddComponent(UIText, "root/resourceNum")
  self.addBtn = self:AddComponent(UIButton, "root/AddBtn")
  self.addBtn:SetOnClick(function()
    OnAddBtnClick(self)
  end)
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
  self.addBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetData(self, itemId, resourceType, addBtncallBack)
  self.itemId = itemId
  self.resourceType = resourceType
  self.addBtncallBack = addBtncallBack
  local iconPath = self:GetIconName()
  self.imgIcon:LoadSprite(iconPath)
  local resNum = self:GetCurNum()
  self.textNum:SetText(string.GetFormattedSeperatorNum(resNum))
end

local function RefreshData(self)
  local resNum = self:GetCurNum()
  if self.textNum then
    self.textNum:SetText(string.GetFormattedSeperatorNum(resNum))
  end
end

local function GetIconName(self)
  if self.itemId ~= nil then
    return DataCenter.ItemTemplateManager:GetIconPath(self.itemId)
  elseif self.resourceType ~= nil then
    return DataCenter.ResourceManager:GetResourceIconByType(self.resourceType)
  end
  return ""
end

local function GetCurNum(self)
  if self.itemId ~= nil then
    return DataCenter.ItemData:GetItemCount(self.itemId)
  elseif self.resourceType ~= nil then
    return LuaEntry.Resource:GetCntByResType(self.resourceType)
  end
  return 0
end

UITopItem.OnCreate = OnCreate
UITopItem.OnDestroy = OnDestroy
UITopItem.OnEnable = OnEnable
UITopItem.ComponentDefine = ComponentDefine
UITopItem.ComponentDestroy = ComponentDestroy
UITopItem.DataDefine = DataDefine
UITopItem.DataDestroy = DataDestroy
UITopItem.SetData = SetData
UITopItem.GetIconName = GetIconName
UITopItem.GetCurNum = GetCurNum
UITopItem.RefreshData = RefreshData
UITopItem.SetShowAddBtn = SetShowAddBtn
return UITopItem
