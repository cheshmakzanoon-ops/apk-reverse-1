local UIPVEPackList = BaseClass("UIPVEPackList", UIBaseContainer)
local base = UIBaseContainer
local UIPVEPackItem = require("UI.UIPVE.UIPVEMain.Component.UIPVEPackItem")
local Localization = CS.GameEntry.Localization
local list_path = ""
local TagTypes = {
  WelfareTagType.PvePack,
  WelfareTagType.EnergyBank
}

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
  self.list_go = self:AddComponent(UIBaseContainer, list_path)
end

local function ComponentDestroy(self)
  self.list_go = nil
end

local function DataDefine(self)
  self.paidPackId = nil
  self.dataList = {}
  self.itemReqs = {}
  self.itemList = {}
end

local function DataDestroy(self)
  self.paidPackId = nil
  self.dataList = nil
  self.itemReqs = nil
  self.itemList = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PaySuccess, self.OnPaySuccess)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnPackInfoUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PaySuccess, self.OnPaySuccess)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnPackInfoUpdate)
  base.OnRemoveListener(self)
end

local function Refresh(self)
  self.dataList = self:GetDataListInternal()
  self:ClearItems()
  self:ShowItems()
end

local function ShowItems(self)
  for i, data in ipairs(self.dataList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIPVEPackItem, function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      go.name = tostring(i)
      go:SetActive(true)
      go.transform:SetParent(self.list_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.list_go:AddComponent(UIPVEPackItem, go.name)
      item:SetData(data)
      self.itemList[i] = item
    end)
  end
end

local function ClearItems(self)
  if table.count(self.itemList) > 0 then
    self.list_go:RemoveComponents(UIPVEPackItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

local function GetDataListInternal(self)
  local dataList = {}
  for _, tagType in ipairs(TagTypes) do
    local tagInfoList = WelfareController.getShowTagInfoListByType(tagType)
    for _, tagInfo in ipairs(tagInfoList) do
      local showPackIds = tagInfo:GetPveShowPacks()
      local showLevels = tagInfo:GetPveShowLevels()
      if table.hasvalue(showLevels, DataCenter.BattleLevel.levelId) then
        for _, packId in ipairs(showPackIds) do
          if packId ~= self.paidPackId then
            local pack = GiftPackManager.get(packId)
            if pack and not pack:isBought() then
              local data = {}
              data.tagInfo = tagInfo
              data.packId = packId
              table.insert(dataList, data)
              break
            end
          end
        end
      end
    end
  end
  return dataList
end

local function OnPaySuccess(self, id)
  self.paidPackId = id
  self:Refresh()
end

local function OnPackInfoUpdate(self)
  self:Refresh()
end

UIPVEPackList.OnCreate = OnCreate
UIPVEPackList.OnDestroy = OnDestroy
UIPVEPackList.ComponentDefine = ComponentDefine
UIPVEPackList.ComponentDestroy = ComponentDestroy
UIPVEPackList.DataDefine = DataDefine
UIPVEPackList.DataDestroy = DataDestroy
UIPVEPackList.OnEnable = OnEnable
UIPVEPackList.OnDisable = OnDisable
UIPVEPackList.OnAddListener = OnAddListener
UIPVEPackList.OnRemoveListener = OnRemoveListener
UIPVEPackList.Refresh = Refresh
UIPVEPackList.ShowItems = ShowItems
UIPVEPackList.ClearItems = ClearItems
UIPVEPackList.GetDataListInternal = GetDataListInternal
UIPVEPackList.OnPaySuccess = OnPaySuccess
UIPVEPackList.OnPackInfoUpdate = OnPackInfoUpdate
return UIPVEPackList
