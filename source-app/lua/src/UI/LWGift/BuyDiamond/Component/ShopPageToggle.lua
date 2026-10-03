local ShopPageToggle = BaseClass("ShopPageToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local noSelectName_path = "NoSelectActivityName"
local selectName_path = "SelectActivityName"
local red_point_path = "RedPoint"
local red_num_path = "RedPoint/RedNum"
local new_dot_path = "NewDot"
local select_img_path = "select"
local btn_path = "TypeButton"
local icon_path = "Mask/Icon"
local finTip_path = "finTip"
local unselectColor = Color.New(1, 0.8901961, 0.7921569, 1)
local unselectAlpha = 0.7

local function OnCreate(self, index, rechargeId)
  base.OnCreate(self)
  self.index = index
  self.rechargeId = rechargeId
  self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
  self.noSelectName = self:AddComponent(UIText, noSelectName_path)
  self.selectName = self:AddComponent(UIText, selectName_path)
  self.redPoint = self:AddComponent(UIImage, red_point_path)
  self.redNum = self:AddComponent(UIText, red_num_path)
  self.newDot = self:AddComponent(UIBaseContainer, new_dot_path)
  self.select = self:AddComponent(UIImage, select_img_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.finTip = self:AddComponent(UIBaseContainer, finTip_path)
end

local function OnDestroy(self)
  self.rechargeId = nil
  self.canvasGroup = nil
  self.noSelectName = nil
  self.selectName = nil
  self.redPoint = nil
  self.redNum = nil
  self.newDot = nil
  self.select = nil
  self.btn = nil
  self.icon = nil
  self.finTip = nil
  base.OnDestroy(self)
end

local function SetData(self)
  self.data = WelfareController.getShowTagInfoById(self.rechargeId)
  if self.data == nil then
    return
  end
  self.noSelectName:SetLocalText(self.data:getName())
  self.selectName:SetLocalText(self.data:getName())
  local currentId = self.view.ctrl:GetPage()
  if currentId == self.index then
    self:SetSelect()
  else
    self:SetUnSelect()
  end
  self.icon:SetActive(false)
  self.finTip:SetActive(self.data:CheckIfIsToEnd() and not DataCenter.ActivityListDataManager:GetClickActIdRecord(self.data:GetActivityId()))
  self:RefreshRedAndNewTag()
end

local function SetUnSelect(self)
  self.select:SetActive(false)
  self.noSelectName:SetActive(true)
  self.selectName:SetActive(false)
end

local function SetSelect(self)
  self.select:SetActive(true)
  self.noSelectName:SetActive(false)
  self.selectName:SetActive(true)
end

local function OnClick(self)
  DataCenter.ArrowManager:RemoveArrow()
  self.view:OnToggleItemClick(self.index)
  if self.data then
    local actId = tostring(self.data:GetActivityId())
    if not string.IsNullOrEmpty(actId) then
      DataCenter.ActivityListDataManager:SetClickActIdRecord(actId)
      if self.data.GetActivityType and self.data:GetActivityType() == EnumActivity.ActCalendar.Type then
        PostEventLog.Track(PostEventLog.Defines.C_Activity_Calendar_Entry_Count)
      end
    end
    if self.data.OnShowPage ~= nil then
      self.data:OnShowPage()
    end
  end
end

local function RefreshEndMark(self)
  if not self.data or not self.finTip then
    return
  end
  self.finTip:SetActive(self.data:CheckIfIsToEnd() and not DataCenter.ActivityListDataManager:GetClickActIdRecord(self.data:GetActivityId()))
end

function ShopPageToggle:RefreshRedAndNewTag()
  if self.data == nil then
    return
  end
  local showNew = false
  if self.data.CanShowNewTag ~= nil and self.data:CanShowNewTag() == true then
    showNew = true
  end
  self.newDot:SetActive(showNew)
  if not showNew then
    local redNum = self.data:getRedDotNum()
    self.redPoint:SetActive(0 < redNum)
    self.redNum:SetText(redNum)
  else
    self.redPoint:SetActive(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.SevenDayGetReward, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.ActRewardState, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.RefreshDataPersonalArms, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.RefreshDataAllianceArms, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.ActBattlePassRed, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.OnActBossAttackTimesRefresh, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.RefreshActivityEndMark, self.RefreshEndMark)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.RefreshMainUIDailyPackBtnNewTag, self.RefreshRedAndNewTag)
  self:AddUIListener(EventId.RechargeFreeRewardReceiveStateUpdate, self.RefreshRedAndNewTag)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshWelfareRedDot, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.SevenDayGetReward, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.ActRewardState, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.RefreshDataPersonalArms, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.RefreshDataAllianceArms, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.ActBattlePassRed, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.OnActBossAttackTimesRefresh, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.RefreshActivityEndMark, self.RefreshEndMark)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.RefreshMainUIDailyPackBtnNewTag, self.RefreshRedAndNewTag)
  self:RemoveUIListener(EventId.RechargeFreeRewardReceiveStateUpdate, self.RefreshRedAndNewTag)
  base.OnRemoveListener(self)
end

ShopPageToggle.OnCreate = OnCreate
ShopPageToggle.OnDestroy = OnDestroy
ShopPageToggle.SetData = SetData
ShopPageToggle.SetUnSelect = SetUnSelect
ShopPageToggle.SetSelect = SetSelect
ShopPageToggle.OnClick = OnClick
ShopPageToggle.OnAddListener = OnAddListener
ShopPageToggle.OnRemoveListener = OnRemoveListener
ShopPageToggle.RefreshEndMark = RefreshEndMark
return ShopPageToggle
