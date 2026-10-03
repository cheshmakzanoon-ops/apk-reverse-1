local UIEquipMaterial = BaseClass("UIEquipMaterial", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.itemId = 0
end

local function DataDestroy(self)
  self.itemId = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnClickBtn(self)
  if self.callBack ~= nil then
    self.callBack(self.itemId, self)
  end
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.selectedFrame = self:AddComponent(UIImage, "SelectedFrame")
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    OnClickBtn(self)
  end)
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.selectedFrame = nil
  self.btn = nil
end

local function SetData(self, materialData, clickCallBack)
  self.itemId = materialData.id
  local param1 = {
    rewardType = RewardType.RESOURCE_ITEM,
    itemId = self.itemId,
    count = materialData.count
  }
  self.resItem:ReInit(param1)
  self.callBack = clickCallBack
end

local function SetSelected(self, selected)
  self.selectedFrame:SetActive(selected)
end

UIEquipMaterial.OnCreate = OnCreate
UIEquipMaterial.OnDestroy = OnDestroy
UIEquipMaterial.OnEnable = OnEnable
UIEquipMaterial.OnDisable = OnDisable
UIEquipMaterial.DataDefine = DataDefine
UIEquipMaterial.DataDestroy = DataDestroy
UIEquipMaterial.ComponentDefine = ComponentDefine
UIEquipMaterial.ComponentDestroy = ComponentDestroy
UIEquipMaterial.SetData = SetData
UIEquipMaterial.SetSelected = SetSelected
return UIEquipMaterial
