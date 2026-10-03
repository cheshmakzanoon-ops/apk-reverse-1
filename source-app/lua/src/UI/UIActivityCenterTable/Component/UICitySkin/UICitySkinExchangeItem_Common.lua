local UICitySkinExchangeItem_Common = BaseClass("UICitySkinExchangeItem_Common", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UICitySkinExchangeCostItem = require("UI.UIActivityCenterTable.Component.UICitySkin.UICitySkinExchangeCostItem")
local needItemsContainerPath = "Rect_NeedItems/Viewport/Content"
local rewardBtnPath = "Btn_Reward"
local rewardBtnTxtPath = "Btn_Reward/Txt_Reward"
local exchangedTimesTextPath = "ExchangedTimes"
local targetItemPath = "TargetItem"
local gotoBtnPath = "Btn_Goto"
local templateItemPath = "Rect_NeedItems/UICommonResItem"
local arrowIconPath = "ArrowIcon"
local bgPath = "Bg"
local rawBgPath = "RawBg"
local discountTagPath = "DiscountTag"
local rareTagPath = "RareTag"
local discountTextPath = "DiscountTag/DiscountText"
local conditionTextPath = "ConditionText"
local encore_tag_path = "EncoreTag"
local encore_text_path = "EncoreTag/EncoreText"
local ExchangeTxtKey = "2000846"
local HaveTxtKey = "building_center_desc23"
local patternPath = "Bg1/pattern"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearRewardItems()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.needItemsContainer = self:AddComponent(UIBaseContainer, needItemsContainerPath)
  self.rewardBtn = self:AddComponent(UIButton, rewardBtnPath)
  self.rewardBtn:SetOnClick(function()
    if not self.data then
      return
    end
    local meetBuyCondition, tips = self:IsMeetBuyCondition()
    if not meetBuyCondition then
      UIUtil.ShowTips(tips)
      return
    end
    if self.exchangeCallBack then
      self.exchangeCallBack(self.data)
    end
  end)
  self.rewardBtnText = self:AddComponent(UIText, rewardBtnTxtPath)
  self.exchangedTimesText = self:AddComponent(UIText, exchangedTimesTextPath)
  self.targetItem = self:AddComponent(UICommonResItem, targetItemPath)
  self.gotoBtn = self:AddComponent(UIButton, gotoBtnPath)
  self.gotoBtn:SetOnClick(function()
    if self.gotoCallBack then
      self.gotoCallBack()
    end
  end)
  self.templateItem = self:AddComponent(UIBaseContainer, templateItemPath)
  self.templateItem.gameObject:GameObjectCreatePool()
  self.discountTag = self:AddComponent(UIImage, discountTagPath)
  self.rareTag = self:AddComponent(UIImage, rareTagPath)
  self.discountText = self:AddComponent(UIText, discountTextPath)
  self.encore_tag = self:AddComponent(UIImage, encore_tag_path)
  self.encore_text = self:AddComponent(UITextMeshProUGUIEx, encore_text_path)
  if self.transform and self.transform:Find(conditionTextPath) then
    self.conditionText = self:AddComponent(UIText, conditionTextPath)
  end
  self.bg1 = self:AddComponent(UIImage, "Bg1")
  self.bg2 = self:AddComponent(UIImage, "Bg2")
  self.patternImg = self:AddComponent(UIRawImage, patternPath)
end

local function ComponentDestroy(self)
  self.needItemsContainer = nil
  self.rewardBtn = nil
  self.exchangedTimesText = nil
  self.targetItem = nil
  self.gotoBtn = nil
  self.discountTag = nil
  self.rareTag = nil
  self.discountText = nil
  self.encore_tag = nil
  self.encore_text = nil
  self.conditionText = nil
  self.patternImg = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
  self.exchangeCallBack = nil
  self.gotoCallBack = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetShowConditionText(self, show)
  if show then
    self.rewardBtn:SetAnchoredPositionXY(268.64, -0.5)
    self.gotoBtn:SetAnchoredPositionXY(268.64, -0.5)
    self.exchangedTimesText:SetAnchoredPositionXY(268.64, 44.37)
    self.conditionText:SetActive(true)
  else
    self.rewardBtn:SetAnchoredPositionXY(268.64, -13.2)
    self.gotoBtn:SetAnchoredPositionXY(268.64, -13.2)
    self.exchangedTimesText:SetAnchoredPositionXY(268.64, 31.1)
    self.conditionText:SetActive(false)
  end
end

local function IsMeetBuyCondition(self)
  if not self.data then
    return false
  end
  local buyCondition = self.data.buy_condition or {}
  local meetBuyCondition = true
  local tips = ""
  if not table.IsNullOrEmpty(buyCondition) then
    local selfLevel = DataCenter.BuildManager:GetMainLevel()
    for type, value in pairs(buyCondition) do
      if type == 1 then
        local needLevel = tonumber(value) or 0
        if selfLevel < needLevel then
          meetBuyCondition = false
          tips = string.format("%s %s", tips, UIUtil.GetString("", "activity_99051desc_5", needLevel))
          break
        end
      end
    end
  end
  if meetBuyCondition then
    local commonBuyConditions = DataCenter.RewardManager:ParseBuyConditionStr(self.data.common_buy_condition)
    local inconsistentConditions = DataCenter.RewardManager:GetInconsistentBuyConditions(commonBuyConditions)
    if not table.IsNullOrEmpty(inconsistentConditions) then
      meetBuyCondition = false
      tips = DataCenter.RewardManager:ConvertBuyConditionToText(inconsistentConditions[1])
    end
  end
  return meetBuyCondition, tips
end

local function RefreshBtns(self)
  if not self.data then
    self.rewardBtn:SetActive(false)
    self.gotoBtn:SetActive(false)
    return
  end
  self.rewardBtn:SetActive(true)
  self.gotoBtn:SetActive(false)
  if self.data.isRewardDecoAndEternal then
    UIGray.SetGray(self.rewardBtn.transform, true, false)
    self.rewardBtnText:SetLocalText(HaveTxtKey)
    return
  end
  local meetCondition, tips = IsMeetBuyCondition(self)
  if not meetCondition then
    if self.conditionText then
      SetShowConditionText(self, true)
      self.conditionText:SetText(tips)
    end
    UIGray.SetGray(self.rewardBtn.transform, true, true)
    self.rewardBtnText:SetLocalText(ExchangeTxtKey)
    return
  elseif self.conditionText then
    SetShowConditionText(self, false)
  end
  if self.data.curCount >= self.data.maxCount then
    UIGray.SetGray(self.rewardBtn.transform, true, false)
    self.rewardBtnText:SetLocalText(ExchangeTxtKey)
  else
    UIGray.SetGray(self.rewardBtn.transform, false, true)
    self.rewardBtnText:SetLocalText(ExchangeTxtKey)
    local needItems = self.data.needItems
    for id, count in pairs(needItems) do
      local haveCount = DataCenter.ItemData:GetItemRealCount(id)
      if count > haveCount then
        self.rewardBtn:SetActive(false)
        self.gotoBtn:SetActive(true)
        return
      end
    end
  end
end

local function ClearRewardItems(self)
  if self.needItemsContainer then
    self.needItemsContainer:RemoveComponents(UICitySkinExchangeCostItem)
  end
  if self.templateItem and not IsNull(self.templateItem.gameObject) then
    self.templateItem.gameObject:GameObjectRecycleAll()
  end
  self.needItemsObj = {}
end

local function RefreshShowItems(self)
  self:ClearRewardItems()
  if not self.data then
    return
  end
  local needItems = self.data.needItems
  local i = 1
  for id, count in pairs(needItems) do
    local obj = self.templateItem.gameObject:GameObjectSpawn(self.needItemsContainer.transform)
    local go = obj.gameObject
    local transform = obj.transform
    transform:SetParent(self.needItemsContainer.transform)
    transform:Set_localScale(0.78, 0.78, 1)
    transform:Set_sizeDelta(92, 92)
    transform:Set_pivot(0.5, 0.5)
    go.name = "item" .. i
    local cell = self.needItemsContainer:AddComponent(UICitySkinExchangeCostItem, go.name)
    local data = {}
    data.id = id
    data.count = count
    cell:SetData(data)
    self.needItemsObj[i] = cell
    i = i + 1
  end
  if not table.IsNullOrEmpty(self.data.reward) then
    self.targetItem:SetActive(true)
    self.targetItem:ReInit(self.data.reward[1])
  else
    self.targetItem:SetActive(false)
  end
end

local function SetData(self, data, exchangeCallBack, gotoCallBack, actId)
  self.data = data
  self:RefreshBtns()
  self:RefreshShowItems()
  local remainCount = 0
  if data.curCount >= data.maxCount then
    remainCount = 0
  else
    remainCount = data.maxCount - data.curCount
  end
  self.exchangedTimesText:SetLocalText(2000843, remainCount)
  self.exchangeCallBack = exchangeCallBack
  self.gotoCallBack = gotoCallBack
  self.actId = actId
  self:RefreshPattern()
  if self.data.tips_type == 0 then
    self.discountTag:SetActive(false)
    self.rareTag:SetActive(false)
    self.encore_tag:SetActive(false)
  elseif self.data.tips_type == 1 then
    self.discountTag:SetActive(false)
    self.rareTag:SetActive(true)
    self.encore_tag:SetActive(false)
  elseif self.data.tips_type == 2 then
    self.discountTag:SetActive(true)
    self.rareTag:SetActive(false)
    self.encore_tag:SetActive(false)
    self.discountText:SetLocalText("activity_convert_tipstype2")
  elseif self.data.tips_type == 3 then
    self.discountTag:SetActive(false)
    self.rareTag:SetActive(false)
    self.encore_tag:SetActive(true)
    self.encore_text:SetLocalText("activity_convert_tipstype3")
  end
  self.actBaseData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if self.actBaseData then
    self:RefreshCommonNode(self.actBaseData:GetShowConfigTemp())
  end
end

local function RefreshCommonNode(self, showTemp)
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec2) then
    local picNameList = string.split(showTemp.pic_spec2, "|")
    local name1 = picNameList[1]
    if name1 and not string.IsNullOrEmpty(name1) then
      self.bg1:LoadSpriteAuto(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.CitySkinExchangeFestivalPath, name1))
    end
    local name2 = picNameList[2]
    if name2 and not string.IsNullOrEmpty(name2) then
      self.bg2:LoadSpriteAuto(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.CitySkinExchangeFestivalPath, name2))
    end
  end
end

local function RefreshPattern(self)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if activityInfo == nil then
    self.patternImg:SetActive(false)
    return
  end
  local showTemp = activityInfo:GetShowConfigTemp()
  if showTemp == nil then
    self.patternImg:SetActive(false)
    return
  end
  local imgStr = showTemp.pic_spec3
  if string.IsNullOrEmpty(imgStr) then
    self.patternImg:SetActive(false)
    return
  end
  self.patternImg:SetActive(true)
  local fullPath = string.format(LoadPath.CitySkinExchangeFestivalPath, imgStr)
  self.patternImg:LoadSpriteAsyncWithCallback(fullPath, function()
    if self and self.patternImg then
      self.patternImg:SetNativeSize()
    end
  end)
end

UICitySkinExchangeItem_Common.OnCreate = OnCreate
UICitySkinExchangeItem_Common.OnDestroy = OnDestroy
UICitySkinExchangeItem_Common.OnEnable = OnEnable
UICitySkinExchangeItem_Common.OnDisable = OnDisable
UICitySkinExchangeItem_Common.ComponentDefine = ComponentDefine
UICitySkinExchangeItem_Common.ComponentDestroy = ComponentDestroy
UICitySkinExchangeItem_Common.DataDefine = DataDefine
UICitySkinExchangeItem_Common.DataDestroy = DataDestroy
UICitySkinExchangeItem_Common.OnAddListener = OnAddListener
UICitySkinExchangeItem_Common.OnRemoveListener = OnRemoveListener
UICitySkinExchangeItem_Common.SetData = SetData
UICitySkinExchangeItem_Common.RefreshBtns = RefreshBtns
UICitySkinExchangeItem_Common.ClearRewardItems = ClearRewardItems
UICitySkinExchangeItem_Common.RefreshShowItems = RefreshShowItems
UICitySkinExchangeItem_Common.IsMeetBuyCondition = IsMeetBuyCondition
UICitySkinExchangeItem_Common.RefreshCommonNode = RefreshCommonNode
UICitySkinExchangeItem_Common.RefreshPattern = RefreshPattern
return UICitySkinExchangeItem_Common
