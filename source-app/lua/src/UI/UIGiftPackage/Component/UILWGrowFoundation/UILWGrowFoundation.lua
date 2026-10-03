local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UILWGrowFoundation = BaseClass("UILWGrowFoundation", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UILWGrowFoundationTargetItem = require("UI.UIGiftPackage.Component.UILWGrowFoundation.UILWGrowFoundationTargetItem")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local titleNameText_path = "TitleNameText"
local descriptionText_path = "DescriptionText"
local buyBtn_path = "BuyBtn"
local buyBtnPriceText_path = "BuyBtn/PriceText"
local buyBtnText_path = "BuyBtn/BtnText"
local buyBtnGiftPackPoint_path = "BuyBtn/UIGiftPackagePoint"
local targetsScroll_path = "TargetScroll"
local targetsSrollContent_path = "TargetScroll/Viewport/Content"
local time_content_path = "TimeContent"
local txt_times_path = "TimeContent/Txt_Times"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ClearScroll(self)
  self.targetContent:RemoveComponents(UILWGrowFoundationTargetItem)
  self.targetScroll:ClearAllItems()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshGiftPack)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnRefresh)
  self:AddUIListener(EventId.OnClaimRewardEffFinish, self.ResortTargetList)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshGiftPack)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnRefresh)
  self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.ResortTargetList)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.targets then
    return nil
  end
  local taskId = self.targets[index]
  local item = loopScroll:NewListViewItem("GrowTargetItem")
  local script = self.targetContent:GetComponent(item.gameObject.name, UILWGrowFoundationTargetItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.targetContent:AddComponent(UILWGrowFoundationTargetItem, objectName)
  end
  script:SetActive(true)
  script:SetItem(taskId, self.buyState, self.actId)
  return item
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleNameText_path)
  self.descText = self:AddComponent(UIText, descriptionText_path)
  self.targetScroll = self:AddComponent(UILoopListView2, targetsScroll_path)
  self.targetScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.targetContent = self:AddComponent(UIBaseContainer, targetsSrollContent_path)
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, buyBtn_path)
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnText = self:AddComponent(UIText, buyBtnText_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.txt_times = self:AddComponent(UITextMeshProUGUIEx, txt_times_path)
end

local function ComponentDestroy(self)
  self.titleText = nil
  self.descText = nil
  self.targetScroll = nil
  self.targetContent = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.time_content = nil
  self.txt_times = nil
end

local function DataDefine(self)
  self.itemIndex = 0
  self.initTargets = false
end

local function DataDestroy(self)
  self.itemIndex = nil
  self.initTargets = nil
end

local function RefreshGiftPack(self)
  if not self.buyState and self.actDetailInfo then
    self.giftPackGroupId = self.actDetailInfo:GetStageGiftPackGroupId(1)
    local packs = GiftPackageData.GetPacksByGroupId(self.giftPackGroupId)
    if not table.IsNullOrEmpty(packs) then
      self.giftPackData = packs[1]
    else
      self.giftPackData = nil
    end
  end
end

local function SortTargets(self)
  if self.targets then
    table.sort(self.targets, function(a, b)
      local aTaskValue = DataCenter.TaskManager:FindTaskInfo(a)
      local bTaskValue = DataCenter.TaskManager:FindTaskInfo(b)
      local aState = TaskState.NoComplete
      if aTaskValue then
        aState = aTaskValue.state
      end
      local bState = TaskState.NoComplete
      if bTaskValue then
        bState = bTaskValue.state
      end
      if aState ~= bState then
        if aState == TaskState.CanReceive then
          return true
        elseif bState == TaskState.CanReceive then
          return false
        elseif aState == TaskState.NoComplete then
          return true
        elseif bState == TaskState.NoComplete then
          return false
        end
      end
      return a < b
    end)
  end
end

local function ResortTargetList(self)
  if self.actDetailInfo then
    SortTargets(self)
    self.targetScroll:SetListItemCount(#self.targets, false, false)
    self.targetScroll:RefreshAllShownItem()
  end
end

local function FilterTargets(self)
  if self.targets then
    local tempTargets = {}
    for i, v in ipairs(self.targets) do
      local taskValue = DataCenter.TaskManager:FindTaskInfo(v)
      if taskValue then
        table.insert(tempTargets, v)
      end
    end
    self.targets = tempTargets
  end
end

local function OnRefresh(self, actId)
  if actId ~= self.actId then
    return
  end
  self.actDetailInfo = DataCenter.ActivityListDataManager:GetActEventInfo(self.actId)
  if self.actDetailInfo then
    self.buyState = false
    if self.actDetailInfo then
      self.buyState = self.actDetailInfo.extraData.buy_gift == 1
    end
    if not self.buyState then
      RefreshGiftPack(self)
    end
    if not self.initTargets then
      self:InitTargetList()
    else
      FilterTargets(self)
      ResortTargetList(self)
      self.targetScroll:RefreshAllShownItem()
    end
    self:RefreshUI()
  end
end

local function RequestActivityDetialInfo(self)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.actId))
end

local function SetData(self, actId)
  self.actId = actId
  if not self.actId then
    return
  end
  self.actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.actId)
  if not self.actData then
    return
  end
  self:InitUI()
  self:Update1000MS()
  RequestActivityDetialInfo(self)
end

local function InitUI(self)
  if self.actData then
    self.titleText:SetLocalText(self.actData.name)
    self.descText:SetLocalText(self.actData.desc_info)
  end
end

local function InitTargetList(self)
  if self.actDetailInfo then
    self.targets = self.actDetailInfo:GetStageQuests(1)
    FilterTargets(self)
    SortTargets(self)
    self.targetScroll:SetListItemCount(#self.targets, false, false)
    self.initTargets = true
  end
end

local function RefreshUI(self)
  if self.buyState or not self.giftPackData then
    self.buyBtn:SetActive(false)
    self.time_content:SetActive(false)
  else
    self.buyBtn:SetActive(true)
    self.time_content:SetActive(true)
    if self.giftPackData then
      self.buyBtn:Init(self.giftPackData)
      self.buyBtn:RefreshPoint()
    end
  end
end

local function OnClickBtn(self)
  if self.giftPackData then
    if self.giftPackData:isTimeValid() then
      DataCenter.PayManager:CallPayment(self.giftPackData, "GoldExchangeView")
    else
      UIUtil.ShowTipsId(2000431)
    end
  else
    UIUtil.ShowTipsId(2000431)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.initTargets = false
end

local function OnDisable(self)
  base.OnDisable(self)
  self.initTargets = false
end

local function Update1000MS(self)
  if self.actData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.actData.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
end

UILWGrowFoundation.OnCreate = OnCreate
UILWGrowFoundation.OnDestroy = OnDestroy
UILWGrowFoundation.OnAddListener = OnAddListener
UILWGrowFoundation.OnRemoveListener = OnRemoveListener
UILWGrowFoundation.ComponentDefine = ComponentDefine
UILWGrowFoundation.ComponentDestroy = ComponentDestroy
UILWGrowFoundation.DataDefine = DataDefine
UILWGrowFoundation.DataDestroy = DataDestroy
UILWGrowFoundation.OnRefresh = OnRefresh
UILWGrowFoundation.SetData = SetData
UILWGrowFoundation.InitUI = InitUI
UILWGrowFoundation.RefreshUI = RefreshUI
UILWGrowFoundation.OnClickBtn = OnClickBtn
UILWGrowFoundation.OnGetItemByIndex = OnGetItemByIndex
UILWGrowFoundation.OnEnable = OnEnable
UILWGrowFoundation.OnDisable = OnDisable
UILWGrowFoundation.ClearScroll = ClearScroll
UILWGrowFoundation.InitTargetList = InitTargetList
UILWGrowFoundation.RefreshGiftPack = RefreshGiftPack
UILWGrowFoundation.ResortTargetList = ResortTargetList
UILWGrowFoundation.Update1000MS = Update1000MS
return UILWGrowFoundation
