local base = UIBaseContainer
local ActivityRebateNewGiftComponent = BaseClass("ActivityRebateNewGiftComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local ActivityRebateNewGiftDetailComponent = require("UI.UIActivityCenterTable.Component.ActivityRebateNew.ActivityRebateNewGiftDetailComponent")
local ActivityRebateNewBoxComponent = require("UI.UIActivityCenterTable.Component.ActivityRebateNew.ActivityRebateNewBoxComponent")
local boxSize = 125

function ActivityRebateNewGiftComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityRebateNewGiftComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityRebateNewGiftComponent:ComponentDefine()
  self.textMainTitle = self:AddComponent(UIText, "Top/MainTitleText")
  self.textTime = self:AddComponent(UIText, "Top/TimeBg/TimeText")
  self.textDes = self:AddComponent(UIText, "Top/DescriptionText")
  self.btnInfo = self:AddComponent(UIButton, "Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.imgSliderBg = self:AddComponent(UIImage, "Progress/Background")
  self.slider = self:AddComponent(UISlider, "Progress/Background/Slider")
  self.compBoxContent = self:AddComponent(UIBaseContainer, "Progress/Boxes")
  self.compBoxTemplate = self:AddComponent(UIBaseContainer, "Progress/BoxTemplate")
  self.textProgress = self:AddComponent(UIText, "Progress/PorgressTitle/ProgressText")
  self.compBoxTemplate.gameObject:GameObjectCreatePool()
  self.compBoxes = {}
  self.compMainTab1 = self:AddComponent(UIBaseContainer, "Bottom/ToggleContent/MainTab1")
  self.compMainTab2 = self:AddComponent(UIBaseContainer, "Bottom/ToggleContent/MainTab2")
  self.compMainTab3 = self:AddComponent(UIBaseContainer, "Bottom/ToggleContent/MainTab3")
  self.compMainTab4 = self:AddComponent(UIBaseContainer, "Bottom/ToggleContent/MainTab4")
  self.compMainTab5 = self:AddComponent(UIBaseContainer, "Bottom/ToggleContent/MainTab5")
  self.btnLeft = self:AddComponent(UIButton, "Bottom/LeftBtn")
  self.btnLeft:SetOnClick(function()
    self:OnBtnLeftClick()
  end)
  self.btnRight = self:AddComponent(UIButton, "Bottom/RightBtn")
  self.btnRight:SetOnClick(function()
    self:OnBtnRightClick()
  end)
  self.compPackageContent = self:AddComponent(ActivityRebateNewGiftDetailComponent, "Bottom/PackageContent")
  self:InitTabs()
end

function ActivityRebateNewGiftComponent:ComponentDestroy()
  self.textMainTitle = nil
  self.textTime = nil
  self.btnInfo = nil
  self.slider = nil
  self.imgSliderBg = nil
  self.compBoxContent:RemoveComponents(ActivityRebateNewBoxComponent)
  self.compBoxTemplate.gameObject:GameObjectRecycleAll()
  self.compBoxes = nil
  self.compBoxContent = nil
  self.compBoxTemplate = nil
  self.textProgress = nil
  self.compMainTab1 = nil
  self.compMainTab2 = nil
  self.compMainTab3 = nil
  self.compMainTab4 = nil
  self.compMainTab5 = nil
  self.btnLeft = nil
  self.btnRight = nil
  self.compPackageContent = nil
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
end

function ActivityRebateNewGiftComponent:DataDefine()
  self.activityId = 0
end

function ActivityRebateNewGiftComponent:DataDestroy()
  self.activityId = nil
end

function ActivityRebateNewGiftComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityRebateNewReceiveProgressInfoSuccess, self.OnProgressInfoUpdate)
end

function ActivityRebateNewGiftComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityRebateNewReceiveProgressInfoSuccess, self.OnProgressInfoUpdate)
  base.OnRemoveListener(self)
end

function ActivityRebateNewGiftComponent:SetData(activityId, isInit)
  self.activityId = activityId
  self:UpdateData(isInit)
  self:UpdateAll()
end

function ActivityRebateNewGiftComponent:UpdateData(isInit)
  if self.activityId == nil then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActivityListDataManager:GetActEventInfo(self.activityId)
  local clearCurSelect = false
  if isInit or self.curSelectClass == nil then
    clearCurSelect = true
  else
    local giftData = DataCenter.ActivityRebateNewManager:GetGiftDataByClass(self.activityId, self.curSelectClass)
    if giftData ~= nil then
      local giftId = giftData.exchangeId
      local pack = GiftPackageData.get(tostring(giftId))
      if not (pack ~= nil and pack:canGet()) or not pack:isTimeValid() then
        clearCurSelect = true
      end
    end
  end
  if clearCurSelect then
    self.curSelectClass = DataCenter.ActivityRebateNewManager:GetDefaultSelectClass(self.activityId)
  end
end

function ActivityRebateNewGiftComponent:InitTabs()
  local function AddTab(tabRoot, tag)
    local tab = {}
    
    tab.root = tabRoot
    tab.select = tab.root:AddComponent(UIBaseContainer, "Select")
    tab.textSelect = tab.root:AddComponent(UIText, "Select/SelectText")
    tab.textUnSelect = tab.root:AddComponent(UIText, "UnselectText")
    tab.btn = tab.root:AddComponent(UIButton, "Btn")
    tab.btn:SetOnClick(function()
      self:OnSelectClass(tag)
    end)
    self.tabs[tag] = tab
  end
  
  self.tabs = {}
  AddTab(self.compMainTab1, DataCenter.ActivityRebateNewManager.PackageClass.One)
  AddTab(self.compMainTab2, DataCenter.ActivityRebateNewManager.PackageClass.Two)
  AddTab(self.compMainTab3, DataCenter.ActivityRebateNewManager.PackageClass.Three)
  AddTab(self.compMainTab4, DataCenter.ActivityRebateNewManager.PackageClass.Four)
  AddTab(self.compMainTab5, DataCenter.ActivityRebateNewManager.PackageClass.Five)
end

function ActivityRebateNewGiftComponent:UpdateAll()
  if self.activityData == nil or self.activityDetailData == nil then
    return
  end
  self.textMainTitle:SetLocalText(self.activityData.activityName)
  self.textDes:SetLocalText(self.activityData.desc_info)
  self:UpdateTime()
  self:UpdateToggle(true)
  self:UpdateGiftContent()
  self:UpdateProgress(true)
end

function ActivityRebateNewGiftComponent:Update1000MS()
  self:UpdateTime()
end

function ActivityRebateNewGiftComponent:UpdateTime()
  if self.activityData == nil then
    return
  end
  local endTime = self.activityData.endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = endTime - curTime
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.textTime:SetText(showTime)
  else
    self.textTime:SetText("")
  end
end

function ActivityRebateNewGiftComponent:UpdateGiftContent()
  if self.activityId == nil or self.activityData == nil then
    return
  end
  if self.curSelectClass == nil then
    return
  end
  self.btnLeft:SetActive(self.curSelectClass > DataCenter.ActivityRebateNewManager.PackageClass.One)
  self.btnRight:SetActive(self.curSelectClass < DataCenter.ActivityRebateNewManager.PackageClass.Five)
  local contentData = DataCenter.ActivityRebateNewManager:GetGiftDataByClass(self.activityId, self.curSelectClass)
  if contentData == nil then
    return
  end
  self.compPackageContent:SetData(contentData, self.activityId, self.curSelectClass)
end

function ActivityRebateNewGiftComponent:UpdateToggle(isInit)
  local function SetTabText(class, text)
    if self.tabs[class] ~= nil then
      self.tabs[class].textSelect:SetLocalText(text)
      
      self.tabs[class].textUnSelect:SetLocalText(text)
    end
  end
  
  if isInit then
    SetTabText(DataCenter.ActivityRebateNewManager.PackageClass.One, "total_mobilization_title3")
    SetTabText(DataCenter.ActivityRebateNewManager.PackageClass.Two, "total_mobilization_title4")
    SetTabText(DataCenter.ActivityRebateNewManager.PackageClass.Three, "total_mobilization_title5")
    SetTabText(DataCenter.ActivityRebateNewManager.PackageClass.Four, "total_mobilization_title6")
    SetTabText(DataCenter.ActivityRebateNewManager.PackageClass.Five, "total_mobilization_title7")
  end
  for i, v in pairs(self.tabs) do
    local isSelect = i == self.curSelectClass
    v.select:SetActive(isSelect)
    v.textSelect:SetActive(isSelect)
    v.textUnSelect:SetActive(not isSelect)
  end
end

function ActivityRebateNewGiftComponent:OnSelectClass(class)
  if self.curSelectClass == nil or self.curSelectClass ~= class then
    self.curSelectClass = class
    self:UpdateToggle()
    self:UpdateGiftContent()
  end
end

function ActivityRebateNewGiftComponent:UpdateProgress(isInit)
  if self.activityId == nil then
    return
  end
  if isInit then
    self:InitProgressContent()
  end
  self:UpdateProgressContent()
end

function ActivityRebateNewGiftComponent:InitProgressContent()
  if self.activityId == nil then
    return
  end
  self.compBoxTemplate:SetActive(false)
  local progressData = DataCenter.ActivityRebateNewManager:GetProgressData(self.activityId)
  local boxCount = #progressData
  local sliderWidth = self.imgSliderBg.rectTransform.rect.width
  if 0 < boxCount then
    local deltaWidth = sliderWidth / boxCount
    if table.IsNullOrEmpty(self.compBoxes) then
      self.compBoxes = {}
      for i, v in ipairs(progressData) do
        local item = self.compBoxTemplate.gameObject:GameObjectSpawn(self.compBoxContent.transform)
        item.name = "progress" .. i
        local obj = self.compBoxContent:AddComponent(ActivityRebateNewBoxComponent, item.name)
        obj:SetActive(true)
        obj:SetAnchoredPositionXY(i * deltaWidth, 0)
        self.compBoxes[i] = obj
      end
    end
  end
end

function ActivityRebateNewGiftComponent:UpdateProgressContent()
  local function GetProgressFillAmount()
    local res = 0
    
    local progressData = DataCenter.ActivityRebateNewManager:GetProgressData(self.activityId)
    if not table.IsNullOrEmpty(progressData) then
      local curScore = DataCenter.ActivityRebateNewManager:GetCurrentProgressScore(self.activityId)
      local totalCount = #progressData
      local maxScore = 0
      local reachedIndex = 0
      local reachedScore = 0
      for i, v in ipairs(progressData) do
        if curScore >= v.score then
          reachedIndex = i
          reachedScore = v.score
        end
        if maxScore < v.score then
          maxScore = v.score
        end
      end
      if curScore >= maxScore then
        res = 1
      else
        local nextIndex = reachedIndex + 1
        if progressData[nextIndex] ~= nil then
          local nextScore = progressData[nextIndex].score
          res = reachedIndex / totalCount + (curScore - reachedScore) / (nextScore - reachedScore) * 1 / totalCount
        end
      end
    end
    return res
  end
  
  if self.activityId == nil then
    return
  end
  local curScore = DataCenter.ActivityRebateNewManager:GetCurrentProgressScore(self.activityId)
  self.textProgress:SetText(tostring(curScore))
  local progress = GetProgressFillAmount()
  self.slider:SetValue(progress)
  if self.compBoxes ~= nil then
    local progressData = DataCenter.ActivityRebateNewManager:GetProgressData(self.activityId)
    for i, v in ipairs(progressData) do
      if self.compBoxes[i] ~= nil then
        self.compBoxes[i]:SetData(v, self.activityId)
      end
    end
  end
end

function ActivityRebateNewGiftComponent:OnBtnInfoClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function ActivityRebateNewGiftComponent:OnBtnLeftClick()
  if self.curSelectClass == nil then
    return
  end
  if self.curSelectClass > DataCenter.ActivityRebateNewManager.PackageClass.One then
    self:OnSelectClass(self.curSelectClass - 1)
  end
end

function ActivityRebateNewGiftComponent:OnBtnRightClick()
  if self.curSelectClass == nil then
    return
  end
  if self.curSelectClass < DataCenter.ActivityRebateNewManager.PackageClass.Five then
    self:OnSelectClass(self.curSelectClass + 1)
  end
end

function ActivityRebateNewGiftComponent:OnProgressInfoUpdate()
  self:UpdateProgress()
end

return ActivityRebateNewGiftComponent
