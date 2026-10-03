local WeeklyPackageMain = BaseClass("WeeklyPackageMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WeeklyPackageItem = require("UI.UIGiftPackage.Component.WeeklyPackage.WeeklyPackageItem")
local title_path = "MsgBg/TitleText"
local subTitle_path = "MsgBg/TopBg/weeklyBg/DescText"
local refreshCD_path = "MsgBg/DescText (1)"
local svPackages_path = "MsgBg/Scroll View"
local emptyTip_path = "MsgBg/emptyTip"

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

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.RefreshDiamondCount)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshDiamondCount)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(320047)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetLocalText(320316)
  self.refreshCdN = self:AddComponent(UIText, refreshCD_path)
  self.refreshCdN:SetLocalText(320317)
  self.svPackagesN = self:AddComponent(UIScrollView, svPackages_path)
  self.svPackagesN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.svPackagesN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetText("")
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.refreshCdN = nil
  self.diamondNumN = nil
end

local function DataDefine(self)
  self.packageList = {}
  self.cell = {}
end

local function DataDestroy(self)
  self.packageList = nil
  self.cell = nil
  self:ClearScroll()
end

local function ReInit(self, targetPackageId)
  self.packageList = GiftPackageData.GetWeeklyPackageList()
  local hasFree = GiftPackageData.CheckIfHasFreeWeeklyPackage()
  table.sort(self.packageList, function(a, b)
    if a.isWeeklyFreePackage then
      return hasFree
    elseif b.isWeeklyFreePackage then
      return not hasFree
    else
      local remainA = a:canGet()
      local remainB = b:canGet()
      if remainA ~= remainB then
        return remainA
      else
        return a:getID() < b:getID()
      end
    end
  end)
  local isTargetGiftId = self:GetPackageIndexById(targetPackageId)
  self:RefreshPackages(targetPackageId, isTargetGiftId)
  self:RefreshDiamondCount()
end

local function RefreshPackages(self, targetPackageId, isTargetGiftId)
  if #self.packageList > 0 then
    self.svPackagesN:SetActive(true)
    self.emptyTipN:SetActive(false)
    self.svPackagesN:SetTotalCount(#self.packageList)
    if targetPackageId and isTargetGiftId then
      self.svPackagesN:ScrollToCell(isTargetGiftId, 10000)
      TimerManager:GetInstance():DelayInvoke(function()
        self.cell[isTargetGiftId]:ShowArrow()
      end, 0.5)
    else
      self.svPackagesN:RefillCells()
    end
  else
    self.svPackagesN:SetActive(false)
    self.emptyTipN:SetActive(true)
  end
end

local function RefreshDiamondCount(self)
end

local function GetPackageIndexById(self, packId)
  if packId then
    for i, v in ipairs(self.packageList) do
      if v:getID() == packId then
        return i
      end
    end
  end
  return nil
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svPackagesN:AddComponent(WeeklyPackageItem, itemObj)
  local tempPackage = self.packageList[index]
  cellItem:SetItem(tempPackage)
  self.cell[index] = cellItem
end

local function OnItemMoveOut(self, itemObj, index)
  self.svPackagesN:RemoveComponent(itemObj.name, WeeklyPackageItem)
end

local function ClearScroll(self)
  self.svPackagesN:ClearCells()
  self.svPackagesN:RemoveComponents(WeeklyPackageItem)
end

WeeklyPackageMain.OnCreate = OnCreate
WeeklyPackageMain.OnDestroy = OnDestroy
WeeklyPackageMain.OnAddListener = OnAddListener
WeeklyPackageMain.OnRemoveListener = OnRemoveListener
WeeklyPackageMain.ComponentDefine = ComponentDefine
WeeklyPackageMain.ComponentDestroy = ComponentDestroy
WeeklyPackageMain.DataDefine = DataDefine
WeeklyPackageMain.DataDestroy = DataDestroy
WeeklyPackageMain.ReInit = ReInit
WeeklyPackageMain.RefreshPackages = RefreshPackages
WeeklyPackageMain.OnItemMoveIn = OnItemMoveIn
WeeklyPackageMain.OnItemMoveOut = OnItemMoveOut
WeeklyPackageMain.RefreshDiamondCount = RefreshDiamondCount
WeeklyPackageMain.GetPackageIndexById = GetPackageIndexById
WeeklyPackageMain.ClearScroll = ClearScroll
return WeeklyPackageMain
