local UILWWeeklyPackageMain = BaseClass("UILWWeeklyPackageMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWWeeklyPackageItem = require("UI.UIGiftPackage.Component.UILWWeeklyPackage.UILWWeeklyPackageItem")
local emptyTip_path = "Rect_Package/Rect_Bottom/EmptyTipText"
local packageScrollView_path = "Rect_Package/Rect_Bottom/PackageScroll"
local packageContent_path = "Rect_Package/Rect_Bottom/PackageScroll/Viewport/Content"
local remainTimeText_path = "Rect_Package/Rect_Top/RemainTimeText"
local descText_path = "Rect_Package/Rect_Top/Txt_Desc"
local titleText_path = "Rect_Package/Rect_Top/Txt_GiftTitle"

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

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.packageList then
    return nil
  end
  local taskId = self.packageList[index]
  local item = loopScroll:NewListViewItem("WeeklyPackageGfit")
  local script = self.packageContentN:GetComponent(item.gameObject.name, UILWWeeklyPackageItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.packageContentN:AddComponent(UILWWeeklyPackageItem, objectName)
  end
  script:SetActive(true)
  script:SetItem(taskId, self.buyState, self.actId)
  return item
end

local function ComponentDefine(self)
  self.packageItemsTb = {}
  self.emptyTipN = self:AddComponent(UIText, emptyTip_path)
  self.emptyTipN:SetActive(false)
  self.packageScrollViewN = self:AddComponent(UILoopListView2, packageScrollView_path)
  self.packageScrollViewN:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.packageContentN = self:AddComponent(UIBaseContainer, packageContent_path)
  self.remainTimeTextN = self:AddComponent(UIText, remainTimeText_path)
  self.remainTimeTextN:SetText("")
  self.descTextN = self:AddComponent(UIText, descText_path)
  self.titleTextN = self:AddComponent(UIText, titleText_path)
end

local function ComponentDestroy(self)
  self.emptyTipN = nil
  self.packageScrollViewN = nil
  self.packageContentN = nil
  self.remainTimeTextN = nil
  self.descTextN = nil
  self.titleTextN = nil
end

local function DataDefine(self)
  self.itemIndex = 1
  self.hasInitPacks = false
  
  function self.timer_action()
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.hasInitPacks = nil
  self.timer_action = nil
  self.jumpPackageGroupId = nil
end

local function OnRefreshAll(self)
  self:RefreshAll()
end

local function ReInit(self, newPageTagId, jumpPackageGroupId)
  if jumpPackageGroupId then
    self.jumpPackageGroupId = tostring(jumpPackageGroupId)
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  self.packageList = GiftPackageData.GetWeeklyPackageNewList()
  if #self.packageList == 0 then
    self.packageScrollViewN:SetActive(false)
    self.emptyTipN:SetActive(true)
  else
    self.packageScrollViewN:SetActive(true)
    self.emptyTipN:SetActive(false)
    self:RefreshPackages()
  end
end

local function RefreshPackages(self)
  if self.hasInitPacks then
    self.packageScrollViewN:SetListItemCount(#self.packageList, false, false)
    self.packageScrollViewN:RefreshAllShownItem()
  else
    self.packageScrollViewN:SetListItemCount(#self.packageList, false, false)
    self.hasInitPacks = true
    if self.jumpPackageGroupId then
      local jumpIndex = 1
      for i, v in ipairs(self.packageList) do
        if v._tableData.group == self.jumpPackageGroupId then
          jumpIndex = i
          break
        end
      end
      jumpIndex = math.max(0, jumpIndex - 1)
      self.packageScrollViewN:MovePanelToItemIndex(jumpIndex)
      TimerManager:GetInstance():DelayInvoke(function()
        if self.packageScrollViewN then
          local item = self.packageScrollViewN:GetShownItemByItemIndex(jumpIndex)
          local pos = item.gameObject.transform.position
          local param = {
            position = Vector2.New(pos.x, pos.y - 50),
            positionType = PositionType.Screen,
            useLiteAnim = true
          }
          DataCenter.ArrowManager:ShowArrow(param)
        end
      end, 0.5)
    end
  end
end

local function ClearScroll(self)
  self.packageContentN:RemoveComponents(UILWWeeklyPackageItem)
  self.packageScrollViewN:ClearAllItems()
end

local function RefreshTime(self)
  if not self.nextWeekDayTime then
    self.nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.nextWeekDayTime - curTime
  if remainTime <= 0 then
    self.nextWeekDayTime = UITimeManager:GetInstance():GetNextWeekDay(1)
    remainTime = self.nextWeekDayTime - curTime
  end
  self.remainTimeTextN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.8, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddTimer()
  self:RefreshTime()
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
  self.jumpPackageGroupId = nil
end

UILWWeeklyPackageMain.OnCreate = OnCreate
UILWWeeklyPackageMain.OnDestroy = OnDestroy
UILWWeeklyPackageMain.OnAddListener = OnAddListener
UILWWeeklyPackageMain.OnRemoveListener = OnRemoveListener
UILWWeeklyPackageMain.ComponentDefine = ComponentDefine
UILWWeeklyPackageMain.ComponentDestroy = ComponentDestroy
UILWWeeklyPackageMain.DataDefine = DataDefine
UILWWeeklyPackageMain.DataDestroy = DataDestroy
UILWWeeklyPackageMain.ReInit = ReInit
UILWWeeklyPackageMain.OnRefreshAll = OnRefreshAll
UILWWeeklyPackageMain.RefreshAll = RefreshAll
UILWWeeklyPackageMain.RefreshPackages = RefreshPackages
UILWWeeklyPackageMain.ClearScroll = ClearScroll
UILWWeeklyPackageMain.OnGetItemByIndex = OnGetItemByIndex
UILWWeeklyPackageMain.RefreshTime = RefreshTime
UILWWeeklyPackageMain.DeleteTimer = DeleteTimer
UILWWeeklyPackageMain.AddTimer = AddTimer
UILWWeeklyPackageMain.OnEnable = OnEnable
UILWWeeklyPackageMain.OnDisable = OnDisable
return UILWWeeklyPackageMain
