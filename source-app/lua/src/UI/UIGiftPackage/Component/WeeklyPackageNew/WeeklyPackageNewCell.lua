local WeeklyPackageNewCell = BaseClass("WeeklyPackageNewCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local WeeklyPackageNewItem = require("UI.UIGiftPackage.Component.WeeklyPackageNew.WeeklyPackageNewItem")
local container_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:RecycleAsset()
  self:ComponentDestroy()
  self:DestroyChildNode()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.containerN = self:AddComponent(UIBaseContainer, container_path)
end

local function ComponentDestroy(self)
  self.containerN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, tempPackage, originN)
  self.originN = originN
  self.packageInfo = tempPackage
  self.packageId = tempPackage:getID()
  if self.packageId == "-1" then
    if self.packageItem then
      self.packageItem:SetActive(false)
    end
  else
    self:ShowPackage()
  end
end

local function RefreshByExternal(self)
  if self.packageItem and not IsNull(self.packageItem.gameObject) then
    self.packageItem:UpdateByExternal()
  end
end

local function ShowPackage(self)
  local bgParam = self.packageInfo:getPopupImageH()
  bgParam = string.IsNullOrEmpty(bgParam) and "1" or bgParam
  local tempAsset = string.format("Assets/Main/Prefabs/UI/GiftPackage/WeeklyPackageNew/WeeklyPackageNewItem%s.prefab", bgParam)
  if tempAsset == self.cacheAsset then
    self.packageItem:SetItem(self.packageInfo, self.originN)
  else
    self:RecycleAsset()
    self.cacheAsset = tempAsset
    
    local function callback(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.containerN.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.name = "item" .. NameCount
      NameCount = NameCount + 1
      self.packageItem = self.containerN:AddComponent(WeeklyPackageNewItem, go.name)
      self.packageItem:SetItem(self.packageInfo, self.originN)
      self:RefreshByExternal()
    end
    
    local tempGo = self.view:GetWeeklyPackageModel(self.cacheAsset)
    if tempGo then
      callback(tempGo)
    else
      self.model = ResourceManager:InstantiateAsync(tempAsset)
      self.model:completed("+", function()
        callback(self.model)
      end)
    end
  end
end

local function RecycleAsset(self)
  if self.cacheAsset and self.model then
    if self.packageItem then
      self.packageItem:SetActive(false)
    end
    self.view:RecycleOneWeeklyPackageModel(self.cacheAsset, self.model)
    self.cacheAsset = nil
  elseif self.model then
    self.model:Destroy()
  end
  self.cacheAsset = nil
  self.model = nil
end

WeeklyPackageNewCell.OnCreate = OnCreate
WeeklyPackageNewCell.OnDestroy = OnDestroy
WeeklyPackageNewCell.ComponentDefine = ComponentDefine
WeeklyPackageNewCell.ComponentDestroy = ComponentDestroy
WeeklyPackageNewCell.DataDefine = DataDefine
WeeklyPackageNewCell.DataDestroy = DataDestroy
WeeklyPackageNewCell.OnAddListener = OnAddListener
WeeklyPackageNewCell.OnRemoveListener = OnRemoveListener
WeeklyPackageNewCell.SetItem = SetItem
WeeklyPackageNewCell.ShowPackage = ShowPackage
WeeklyPackageNewCell.RecycleAsset = RecycleAsset
WeeklyPackageNewCell.RefreshByExternal = RefreshByExternal
return WeeklyPackageNewCell
