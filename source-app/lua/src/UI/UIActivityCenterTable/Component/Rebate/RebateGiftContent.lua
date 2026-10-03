local RebateGiftContent = BaseClass("RebateGiftContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")

function RebateGiftContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RebateGiftContent:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function RebateGiftContent:OnAddListener()
  base.OnAddListener(self)
end

function RebateGiftContent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RebateGiftContent:ComponentDefine()
  self.title = self:AddComponent(UIText, "Top/title")
  self.subTitle = self:AddComponent(UIText, "Top/subTitle")
  self.InfoBtn = self:AddComponent(UIButton, "Top/InfoBtn")
  self.InfoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.openTime = self:AddComponent(UIText, "Top/TimeBg/openTime")
  self.valueTxt = self:AddComponent(UIText, "Top/valueTxt")
  self.tipTxt = self:AddComponent(UIText, "Bottom/tipTxt")
  self.tipTxt:SetLocalText(2000547)
  self.PriceText = self:AddComponent(UIText, "Bottom/BuyButton/PriceText")
  self.BuyButton = self:AddComponent(UIButton, "Bottom/BuyButton")
  self.BuyButton:SetOnClick(function()
    self:OnBuyButtonClick()
  end)
  self.BuyButton:SetSafeClickMode(true)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, "Bottom/BuyButton/UIGiftPackagePoint")
  self.mustGetTxt = self:AddComponent(UIText, "Bottom/mustGet/tag/mustGetTxt")
  self.mustGetTxt:SetLocalText(2000545)
  self.mustGetResItem = self:AddComponent(UICommonResItem, "Bottom/mustGet/mustGetResItem")
  self.randomGetTxt = self:AddComponent(UIText, "Bottom/randomGet/randomGetContent/randomGetTxt")
  self.randomGetTxt:SetLocalText(2000546)
  self.ScrollView = self:AddComponent(UIScrollView, "Bottom/randomGet/randomGetContent/ScrollView")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
end

function RebateGiftContent:ComponentDestroy()
  self.title = nil
  self.subTitle = nil
  self.InfoBtn = nil
  self.openTime = nil
  self.valueTxt = nil
  self.tipTxt = nil
  self.PriceText = nil
  self.BuyButton = nil
  self.giftPackPoint = nil
  self.mustGetTxt = nil
  self.mustGetResItem = nil
  self.randomGetTxt = nil
  self.ScrollView = nil
end

function RebateGiftContent:DataDefine()
end

function RebateGiftContent:DataDestroy()
end

function RebateGiftContent:SetData(activityId)
  self.activityId = activityId
  if self.activityId == nil then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityDetailData = DataCenter.ActivityListDataManager:GetActEventInfo(self.activityId)
  if self.activityData == nil or self.activityDetailData == nil then
    self.activityPackageData = nil
    self.packageData = nil
    self.showActivityPackageData = nil
    self.showPackageData = nil
    return
  end
  self.activityPackageData = nil
  self.packageData = nil
  self.showActivityPackageData = nil
  self.showPackageData = nil
  for k, v in pairs(self.activityDetailData.exchangeAndRewards) do
    local giftId = v.exchange
    local pack = GiftPackageData.get(tostring(giftId))
    self.showActivityPackageData = v
    self.showPackageData = pack
    if pack and not pack:isBought() and pack:isTimeValid() then
      self.activityPackageData = v
      self.packageData = pack
      break
    end
  end
  self:RefreshView()
end

function RebateGiftContent:RefreshView()
  if self.activityId == nil then
    return
  end
  self.title:SetLocalText(self.activityData.activityName)
  self.subTitle:SetLocalText(self.activityData.desc_info)
  self:RefreshTimeView()
  if self.packageData then
    self.PriceText:SetText(self.packageData:getPriceText())
    CS.UIGray.SetGray(self.BuyButton.transform, false, true)
  else
    self.PriceText:SetLocalText(2000180)
    CS.UIGray.SetGray(self.BuyButton.transform, true, false)
  end
  self.giftPackPoint:RefreshPoint(self.packageData)
  if self.showPackageData then
    local fixReward = self.showPackageData:getItems(true)
    local showReward
    local targetGoodId = 0
    if self.activityData.tableInfo == TableName.Activity_Rebate then
      local line = LocalController:instance():getLine(TableName.Activity_Rebate, self.activityData.subType)
      if line then
        targetGoodId = tonumber(line.cost_goodsid)
      end
    end
    local count = table.count(fixReward)
    for i = 1, count do
      local reward = fixReward[i]
      if reward and reward.itemId == targetGoodId then
        showReward = reward
        break
      end
    end
    if showReward == nil and 0 < count then
      showReward = fixReward[1]
    end
    self.mustGetResItem:SetActive(showReward ~= nil)
    if showReward then
      self.mustGetResItem:ReInit(showReward)
    end
  else
    self.mustGetResItem:SetActive(false)
  end
  self:ClearScroll()
  self.randomReward = self.showActivityPackageData and self.showActivityPackageData.randomReward or {}
  if 0 < #self.randomReward then
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(#self.randomReward)
    self.ScrollView:RefillCells()
  else
    self.ScrollView:SetActive(false)
  end
end

function RebateGiftContent:OnBuyButtonClick()
  if self.packageData then
    DataCenter.PayManager:CallPayment(self.packageData)
  else
  end
end

function RebateGiftContent:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UICommonResItem)
end

function RebateGiftContent:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UICommonResItem, itemObj)
  local rewardData = self.randomReward[index]
  local param = {}
  param.rewardType = rewardData.type
  if type(rewardData.value) == "table" then
    param.itemId = rewardData.value.id
    param.count = rewardData.value.num
  else
    param.count = rewardData.value
  end
  cellItem:ReInit(param)
end

function RebateGiftContent:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UICommonResItem)
end

function RebateGiftContent:Update1000MS()
  self:RefreshTimeView()
end

function RebateGiftContent:RefreshTimeView()
  if self.activityData == nil then
    return
  end
  local endTime = self.activityData.endTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = endTime - curTime
  if 0 < deltaTime then
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    self.openTime:SetText(showTime)
  else
    self.openTime:SetText("")
  end
end

function RebateGiftContent:OnInfoBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

return RebateGiftContent
