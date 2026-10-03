local WeeklyPackageMain = BaseClass("WeeklyPackageMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WeeklyPackageNewCell = require("UI.UIGiftPackage.Component.WeeklyPackageNew.WeeklyPackageNewCell")
local emptyTip_path = "emptyTip"
local content_path = "packages/ScrollView/Content"
local freePackageBtn_path = "freePackageBtn"
local freePackageOpen_path = "freePackageBtn/opened"
local freePackageOpenEff_path = "freePackageBtn/VFX_ui_zhoukabaoxiang_xiaoOpen"
local freePackageUnopen_path = "freePackageBtn/unopen"
local freePackageUnopenEff_path = "freePackageBtn/VFX_ui_zhoukabaoxiang_xiao"
local freeTxt_path = "freePackageBtn/freeTxt"
local dotsContainer_path = "PointArea"
local dotsTemplate_path = "Template/UIScrollPackPoint"
local origin_path = "packages/origin"
local packageScrollView_path = "packages/ScrollView"
local packageContent_path = "packages/ScrollView/Viewport/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnRefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnRefreshAll)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.packageItemsTb = {}
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetLocalText(320346)
  self.emptyTipN:SetActive(false)
  self.freePackageBtnAnimN = self:AddComponent(UIAnimator, freePackageBtn_path)
  self.freePackageBtnN = self:AddComponent(UIButton, freePackageBtn_path)
  self.freePackageBtnN:SetActive(false)
  self.freePackageBtnN:SetOnClick(function()
    self:OnClickClaimFreePackage()
  end)
  self.freePackageOpenN = self:AddComponent(UIImage, freePackageOpen_path)
  self.freePackageOpenEffN = self:AddComponent(UIBaseContainer, freePackageOpenEff_path)
  self.freePackageUnopenN = self:AddComponent(UIImage, freePackageUnopen_path)
  self.freePackageUnopenEffN = self:AddComponent(UIBaseContainer, freePackageUnopenEff_path)
  self.freeTxtN = self:AddComponent(UIText, freeTxt_path)
  self.dotsContainerN = self:AddComponent(UIBaseContainer, dotsContainer_path)
  self.dotsTemplateN = self:AddComponent(UIBaseContainer, dotsTemplate_path)
  self.dotsTemplateN.gameObject:GameObjectCreatePool()
  self.originN = self:AddComponent(UIBaseContainer, origin_path)
  self.packageScrollViewN = self:AddComponent(UIScrollView, packageScrollView_path)
  self.packageScrollViewN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.packageScrollViewN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.packageScrollViewN:SetOnValueChanged(function()
    self:OnScrollViewChange()
  end)
  self.eventTriggerN = self:AddComponent(UIEventTrigger, packageContent_path)
  self.eventTriggerN:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.eventTriggerN:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.eventTriggerN:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
end

local function ComponentDestroy(self)
  self.emptyTipN = nil
  self.freePackageBtnN = nil
  self.freePackageOpenN = nil
  self.freePackageUnopenN = nil
  self.freeTxtN = nil
  self.originN = nil
  self.packagesTb = nil
  self.packageItemsTb = nil
end

local function DataDefine(self)
  self.listGO = {}
  self.curPackageIndex = 2
  self.loadedNum = 0
end

local function DataDestroy(self)
  self.listGO = nil
  self.curPackageIndex = nil
  self.loadedNum = nil
end

local function OnRefreshAll(self)
  self:RefreshAll()
end

local function ReInit(self, targetPackageId)
  self.packageList = GiftPackageData.GetWeeklyPackageNewList(true)
  self.curPackageIndex = self:GetPackageIndexById(targetPackageId) or 2
  self:RefreshAll()
end

local function RefreshDots(self)
  self.dotsTemplateN.gameObject:GameObjectRecycleAll()
  self.dotGoDic = {}
  if #self.packageList > 2 then
    for i = 2, #self.packageList - 1 do
      local item = self.dotsTemplateN.gameObject:GameObjectSpawn(self.dotsContainerN.transform)
      item.name = "dot_" .. i
      local obj = item.transform:Find("Select").gameObject
      self.dotGoDic[i] = obj
    end
  end
end

local function RefreshAll(self)
  self.packageList = GiftPackageData.GetWeeklyPackageNewList()
  if self.curPackageIndex <= 1 then
    self.curPackageIndex = 2
  end
  if self.curPackageIndex >= #self.packageList then
    self.curPackageIndex = #self.packageList - 1
  end
  self:RefreshDots()
  if #self.packageList == 0 then
    self.packageScrollViewN:SetActive(false)
    self.emptyTipN:SetActive(true)
  else
    self.packageScrollViewN:SetActive(true)
    self.emptyTipN:SetActive(false)
    self:RefreshPackages()
    self:SelectCurPackage()
  end
end

local function SelectCurPackage(self, reTarget)
  if reTarget then
    self.packageScrollViewN:ScrollToCell(self.curPackageIndex - 1, 2000)
  end
  self:SelectDot(self.curPackageIndex)
end

local function SelectDot(self, index)
  for i, v in pairs(self.dotGoDic) do
    if i == index then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
end

local function RefreshPackages(self)
  self:ClearScroll()
  self.packageScrollViewN:SetTotalCount(#self.packageList)
  self.packageScrollViewN:RefillCells(self.curPackageIndex - 1)
end

local function RefreshFreePackage(self)
  if not GiftPackageData.CheckIfHasFreeWeeklyPackage() then
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
    self.freePackageOpenN:SetActive(true)
    self.freePackageUnopenN:SetActive(false)
    self.freeTxtN:SetLocalText(170003)
  else
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    self.freePackageOpenN:SetActive(false)
    self.freePackageUnopenN:SetActive(true)
    self.freeTxtN:SetLocalText(320227)
  end
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
  local cellItem = self.packageScrollViewN:AddComponent(WeeklyPackageNewCell, itemObj)
  local packageInfo = self.packageList[index]
  cellItem:SetItem(packageInfo, self.originN)
  self.packageItemsTb[index] = cellItem
  self:OnScrollViewChange()
end

local function OnItemMoveOut(self, itemObj, index)
  self.packageScrollViewN:RemoveComponent(itemObj.name, WeeklyPackageNewCell)
end

local function OnScrollViewChange(self)
  for i, v in pairs(self.packageItemsTb) do
    if v then
      v:RefreshByExternal()
    end
  end
end

local function ClearScroll(self)
  self.packageScrollViewN:ClearCells()
  self.packageScrollViewN:RemoveComponents(WeeklyPackageNewCell)
end

local function OnBeginDrag(self, eventData)
  self.packageScrollViewN:OnBeginDrag(eventData)
end

local function OnDrag(self, eventData)
  self.packageScrollViewN:OnDrag(eventData)
end

local function OnEndDrag(self, eventData)
  self.packageScrollViewN:OnEndDrag(eventData)
  self.packageScrollViewN:StopMovement()
  local indexOffset = 0
  if self.packageItemsTb[self.curPackageIndex] then
    local tempItem = self.packageItemsTb[self.curPackageIndex]
    if not IsNull(tempItem.gameObject) then
      local scaleFactor = UIManager:GetInstance():GetScaleFactor()
      local offsetV3 = tempItem.transform.position - self.originN.transform.position
      local offset = offsetV3.x + 442 * scaleFactor
      if offset < -20 then
        indexOffset = 1
      elseif 20 < offset then
        indexOffset = -1
      end
    end
  end
  self.curPackageIndex = self.curPackageIndex + indexOffset
  self.curPackageIndex = math.max(self.curPackageIndex, 2)
  self.curPackageIndex = math.min(self.curPackageIndex, #self.packageList - 1)
  self:SelectCurPackage(true)
end

local function OnClickClaimFreePackage(self)
  local hasFree = GiftPackageData.CheckIfHasFreeWeeklyPackage()
  if hasFree then
    self.freePackageBtnAnimN:Play("V_ui_zhoukabaoxiang_01_open", 0, 0)
    self.claimFreeTimer = TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.BuyFreeWeeklyPackage, false)
      self.claimFreeTimer = nil
    end, 0.5)
  else
    UIUtil.ShowTipsId(170003)
  end
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
WeeklyPackageMain.OnRefreshAll = OnRefreshAll
WeeklyPackageMain.RefreshAll = RefreshAll
WeeklyPackageMain.SelectCurPackage = SelectCurPackage
WeeklyPackageMain.RefreshDots = RefreshDots
WeeklyPackageMain.RefreshPackages = RefreshPackages
WeeklyPackageMain.RefreshFreePackage = RefreshFreePackage
WeeklyPackageMain.OnPageScroll = OnPageScroll
WeeklyPackageMain.OnItemMoveIn = OnItemMoveIn
WeeklyPackageMain.OnItemMoveOut = OnItemMoveOut
WeeklyPackageMain.OnScrollViewChange = OnScrollViewChange
WeeklyPackageMain.ClearScroll = ClearScroll
WeeklyPackageMain.OnBeginDrag = OnBeginDrag
WeeklyPackageMain.OnDrag = OnDrag
WeeklyPackageMain.OnEndDrag = OnEndDrag
WeeklyPackageMain.GetPackageIndexById = GetPackageIndexById
WeeklyPackageMain.OnClickClaimFreePackage = OnClickClaimFreePackage
WeeklyPackageMain.SelectDot = SelectDot
return WeeklyPackageMain
