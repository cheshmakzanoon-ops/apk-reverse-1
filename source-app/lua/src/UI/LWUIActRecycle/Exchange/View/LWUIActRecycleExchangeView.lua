local LWUIActRecycleExchangeView = BaseClass("LWUIActRecycleExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local LWUICommonResBarComponent = require("UI.UICommon.Component.LWUICommonResBarComponent")
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local LWUICommonExchangeShopPanelHorizontalComponent_Recycle = require("UI.ActivityCommon.LWUICommonExchangeShop.LWUICommonExchangeShop_Recycle.LWUICommonExchangeShopPanelHorizontalComponent_Recycle")
local LWUICommonExchangeShopItemHorizontalComponent_Recycle = require("UI.ActivityCommon.LWUICommonExchangeShop.LWUICommonExchangeShop_Recycle.LWUICommonExchangeShopItemHorizontalComponent_Recycle")

function LWUIActRecycleExchangeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIActRecycleExchangeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleExchangeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 2)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compLWUICommonResBar1 = self.viewSkin:AddComponent(self, LWUICommonResBarComponent, 4)
  self.compLWUICommonResBar2 = self.viewSkin:AddComponent(self, LWUICommonResBarComponent, 5)
  self.btnHistory = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnHistory:SetOnClick(function()
    self:OnBtnHistoryClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compProgressItem = self.viewSkin:AddComponent(self, UICommonResItem, 8)
  self.imgProgressSlider = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compUICommonToggleList = self.viewSkin:AddComponent(self, UICommonToggleListComponent, 11)
  self.compLWUICommonExchangeShopPanelHorizontalRecycle01 = self.viewSkin:AddComponent(self, LWUICommonExchangeShopPanelHorizontalComponent_Recycle, 12)
  self.compTips = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.compLWUICommonExchangeShopPanelHorizontalRecycle02 = self.viewSkin:AddComponent(self, LWUICommonExchangeShopPanelHorizontalComponent_Recycle, 16)
  self.rawImgBanner = self.viewSkin:AddComponent(self, UIRawImage, 17)
  self.simpleAnimationProgress = self.viewSkin:AddComponent(self, UISimpleAnimation, 18)
end

function LWUIActRecycleExchangeView:ComponentDestroy()
  self.viewSkin = nil
  self.btnUICommonBlackMask = nil
  self.compCommonActivityPopUpBgPart = nil
  self.textDes = nil
  self.compLWUICommonResBar1 = nil
  self.compLWUICommonResBar2 = nil
  self.btnHistory = nil
  self.textBtn = nil
  self.compProgressItem = nil
  self.imgProgressSlider = nil
  self.textProgress = nil
  self.compUICommonToggleList = nil
  self.compLWUICommonExchangeShopPanelHorizontalRecycle01 = nil
  self.compTips = nil
  self.textTips = nil
  self.btnLWInfo = nil
  self.compLWUICommonExchangeShopPanelHorizontalRecycle02 = nil
  self.rawImgBanner = nil
  self.simpleAnimationProgress = nil
end

function LWUIActRecycleExchangeView:DataDefine()
  self.initializedToggles = {}
  self.preProgressItemHaveCount = nil
  self.preBoxItemGetCount = nil
end

function LWUIActRecycleExchangeView:DataDestroy()
  self.initializedToggles = nil
  self.preProgressItemHaveCount = nil
  self.preBoxItemGetCount = nil
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

function LWUIActRecycleExchangeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActRecycleExchangeSuccessMsg, self.OnExchangeSuccess)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
  self:AddUIListener(EventId.ActRecycleExchangeChangeToggle, self.OnExchangeChangeToggle)
  self:AddUIListener(EventId.ActRecycleExchangeRefreshProgressMsg, self.OnRefreshProgress)
end

function LWUIActRecycleExchangeView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActRecycleExchangeSuccessMsg, self.OnExchangeSuccess)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
  self:RemoveUIListener(EventId.ActRecycleExchangeChangeToggle, self.OnExchangeChangeToggle)
  self:RemoveUIListener(EventId.ActRecycleExchangeRefreshProgressMsg, self.OnRefreshProgress)
  base.OnRemoveListener(self)
end

function LWUIActRecycleExchangeView:OnOpen()
  self.activityId, self.defaultSelectIndex = self:GetUserData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    DataCenter.ActRecycleManager:PrintRealErrorLog("LWUIActRecycleExchangeView: activityInfo is nil activityId = " .. tostring(self.activityId))
    return
  end
  self.mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(self.activityInfo.subType)
  if self.mainTemplate == nil then
    DataCenter.ActRecycleManager:PrintRealErrorLog("LWUIActRecycleExchangeView: mainTemplate is nil subType = " .. tostring(self.activityInfo.subType))
    return
  end
  self.data = DataCenter.ActRecycleManager:GetData(self.activityId)
  if self.data == nil then
    DataCenter.ActRecycleManager:PrintRealErrorLog("LWUIActRecycleExchangeView: data is nil activityId = " .. tostring(self.activityId))
    return
  end
  self:InitToggle()
  self:RefreshBaseView()
  self:RefreshProgress(false)
  self:RefreshExchangeDailyLimit()
end

function LWUIActRecycleExchangeView:RefreshBaseView()
  local cost = self.mainTemplate:GetCostData()
  if cost == nil then
    return
  end
  self.compLWUICommonResBar1:SetData(cost.itemId)
  self.compLWUICommonResBar2:SetData(self.mainTemplate.ticket_item)
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.activityId)
  self.compCommonActivityPopUpBgPart:SetCloseCallback(function()
    self.ctrl:CloseSelf()
  end)
  self.compCommonActivityPopUpBgPart:SetTitle("activity_99165_train1_1_title")
  self.textBtn:SetLocalText("activity_99165_train2_1_btn")
  if not string.IsNullOrEmpty(self.mainTemplate.res_shopbanner) then
    self.rawImgBanner:LoadSpriteAsync(self.mainTemplate.res_shopbanner)
  end
end

function LWUIActRecycleExchangeView:RefreshProgress(isShowAnim)
  local cost = self.mainTemplate:GetCostData()
  if cost == nil then
    return
  end
  local boxItemId = cost.itemId
  self.compProgressItem:ReInit(cost)
  self.compProgressItem:SetImgQuailtyShow(false)
  local progressItemId = self.mainTemplate.point_item
  local progressItemHaveCount = DataCenter.ItemData:GetItemCount(progressItemId)
  local boxItemTotalGetCount = self.data:GetTotalBoxItemGetCount()
  local boxItemTotalGetLimit = self.mainTemplate:GetBoxItemGetLimit()
  local isOverLimit = boxItemTotalGetCount >= boxItemTotalGetLimit
  local needNum = self.mainTemplate:GetBoxItemGetNeedNum()
  if needNum <= 0 then
    return
  end
  if isOverLimit then
    self.textProgress:SetLocalText("activity_99165_box_2_des")
    self.imgProgressSlider:SetFillAmount(1)
    self.compLWUICommonResBar1:RefreshData()
    self.simpleAnimationProgress:Enable(false)
  elseif not isShowAnim or self.preProgressItemHaveCount == nil then
    self.textProgress:SetText(progressItemHaveCount % needNum .. "/" .. needNum)
    self.imgProgressSlider:SetFillAmount(math.min(progressItemHaveCount % needNum / needNum, 1))
    self.compLWUICommonResBar1:RefreshData()
    self.simpleAnimationProgress:Enable(false)
  else
    local isGetBoxItem = self.preBoxItemGetCount ~= nil and boxItemTotalGetCount > self.preBoxItemGetCount
    if isGetBoxItem then
      self.textProgress:SetText(progressItemHaveCount % needNum .. "/" .. needNum)
      self.imgProgressSlider:SetFillAmount(math.min(progressItemHaveCount % needNum / needNum, 1))
      self.simpleAnimationProgress:Enable(false)
      self.simpleAnimationProgress:Enable(true)
      local flyTime = 0.8
      local curPos = self.compProgressItem.transform.position
      local flyPos = self.compLWUICommonResBar1.transform.position
      local iconPath = DataCenter.ItemTemplateManager:GetIconPath(boxItemId)
      UIUtil.DoFly(RewardType.GOODS, math.min(boxItemTotalGetCount - self.preBoxItemGetCount, 1), iconPath, curPos, flyPos, nil, nil, function()
        if self.compLWUICommonResBar1 then
          self.compLWUICommonResBar1:RefreshData()
        end
      end, nil, flyTime)
    else
      self:PlayTweenProgress(self.preProgressItemHaveCount, progressItemHaveCount, needNum)
    end
  end
  self.preProgressItemHaveCount = progressItemHaveCount
  self.preBoxItemGetCount = boxItemTotalGetCount
end

function LWUIActRecycleExchangeView:InitToggle()
  local data = {}
  local data1 = {}
  data1.name = Localization:GetString("activity_99165_train1_3_tab")
  data1.selectBgPath = self.mainTemplate:GetSelectedTagIconPath()
  data1.unselectBgPath = self.mainTemplate:GetUnselectedTagIconPath()
  local data2 = {}
  data2.name = Localization:GetString("activity_99165_train1_4_tab")
  data2.selectBgPath = self.mainTemplate:GetSelectedTagIconPath()
  data2.unselectBgPath = self.mainTemplate:GetUnselectedTagIconPath()
  data.itemsDataList = {data1, data2}
  
  function data.onItemSelect(index, itemData)
    self:OnSelectToggle(index, itemData)
  end
  
  data.defaultSelectIndex = self.defaultSelectIndex or 1
  
  function data.isShowRed(index, itemData)
    if index == 2 and self.data then
      return self.data:GetExchangeShopRed() > 0
    end
    return false
  end
  
  self.compUICommonToggleList:ReInit(data)
end

function LWUIActRecycleExchangeView:OnSelectToggle(index)
  self.compTips:SetActive(index == 1)
  self.simpleAnimationProgress:SetActive(index == 1)
  self.compLWUICommonResBar1:SetActive(index == 1)
  self.compLWUICommonExchangeShopPanelHorizontalRecycle01:SetActive(index == 1)
  self.compLWUICommonExchangeShopPanelHorizontalRecycle02:SetActive(index == 2)
  if index == 1 then
    if self.mainTemplate then
      local needNum = self.mainTemplate:GetBoxItemGetNeedNum()
      self.textDes:SetLocalText("activity_99165_train1_2_desc", needNum, 1)
    end
  else
    self.textDes:SetLocalText("activity_99165_train2_1_desc")
  end
  if not self.initializedToggles[index] then
    if index == 1 then
      local param = {}
      param.dataList = self.data:GetRecycleShopDataList()
      param.customItemComponent = LWUICommonExchangeShopItemHorizontalComponent_Recycle
      self.compLWUICommonExchangeShopPanelHorizontalRecycle01:ReInit(param)
    else
      local param = {}
      param.dataList = self.data:GetExchangeShopDataList()
      param.customItemComponent = LWUICommonExchangeShopItemHorizontalComponent_Recycle
      
      function param.getIsShowToggle()
        if self.data then
          return self.data:IsExchangeShopRedOn()
        end
        return false
      end
      
      function param.onToggleValueChanged(value)
        if self.data then
          return self.data:SetExchangeShopRedOn(value)
        end
      end
      
      self.compLWUICommonExchangeShopPanelHorizontalRecycle02:ReInit(param)
    end
    self.initializedToggles[index] = true
  end
end

function LWUIActRecycleExchangeView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleExchangeView:OnBtnHistoryClick()
  local index = self.compUICommonToggleList:GetCurSelectIndex()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleExchangeHistory, {anim = true}, self.activityId, index)
end

function LWUIActRecycleExchangeView:OnExchangeSuccess()
  self:RefreshExchangeDailyLimit()
end

function LWUIActRecycleExchangeView:OnRefreshProgress()
  self:RefreshProgress(true)
  self.compLWUICommonResBar2:RefreshData()
end

function LWUIActRecycleExchangeView:OnBtnLWInfoClick()
  if self.mainTemplate == nil then
    return
  end
  local param = {}
  param.alignObject = self.btnLWInfo.transform
  param.yPosFix = 50
  param.xPosFix = -150
  param.desc = Localization:GetString("activity_99165_train1_8_desc", self.mainTemplate.ticket_dayadd)
  param.showArrow = false
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleTip, {anim = true}, param)
end

function LWUIActRecycleExchangeView:RefreshExchangeDailyLimit()
  if self.data == nil then
    return
  end
  local curNum = self.data:GetExchangeDailyLimitTodayNum()
  local limitNum = self.data:GetExchangeDailyLimitTotalNum()
  self.textTips:SetLocalText("activity_99165_train1_7_desc", curNum, limitNum)
end

function LWUIActRecycleExchangeView:OnRefreshActivityRedDot()
  self.compUICommonToggleList:UpdateRed()
end

function LWUIActRecycleExchangeView:OnExchangeChangeToggle(evt)
  if evt and evt.index then
    self.compUICommonToggleList:SetSelectIndex(evt.index)
  end
end

function LWUIActRecycleExchangeView:PlayTweenProgress(preHaveCount, curHaveCount, needNum)
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  local tempValue = preHaveCount
  self.tween = DOTween.To(function()
    return tempValue
  end, function(value)
    if self.textProgress then
      self.textProgress:SetText(math.floor(value % needNum) .. "/" .. needNum)
    end
    if self.imgProgressSlider then
      self.imgProgressSlider:SetFillAmount(math.min(value % needNum / needNum, 1))
    end
  end, curHaveCount, 0.5):SetEase(CS.DG.Tweening.Ease.InOutCubic):OnComplete(function()
    self.tween = nil
    if self.compLWUICommonResBar1 then
      self.compLWUICommonResBar1:RefreshData()
    end
  end)
end

function LWUIActRecycleExchangeView:Update1000MS()
  if self.activityInfo ~= nil then
    local endTime = self.activityInfo:GetShowEndTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if endTime < curTime then
      self.ctrl:CloseSelf()
      return
    end
  end
end

return LWUIActRecycleExchangeView
