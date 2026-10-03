local base = UIBaseContainer
local ActivityRebateNewGiftDetailComponent = BaseClass("ActivityRebateNewGiftDetailComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")

function ActivityRebateNewGiftDetailComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActivityRebateNewGiftDetailComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActivityRebateNewGiftDetailComponent:ComponentDefine()
  self.imgPackageIcon = self:AddComponent(UIImage, "PackageIcon")
  self.textPackageTitle = self:AddComponent(UIText, "PackageTitleText")
  self.textPackageDescription = self:AddComponent(UIText, "PackageDescriptionText")
  self.textMustGet = self:AddComponent(UIText, "MustGet/MustGetText")
  self.textMustGet:SetText(Localization:GetString("total_mobilization_desc2"))
  self.textRandomGet = self:AddComponent(UIText, "RandomGet/RandomGetText")
  self.textRandomGet:SetText(Localization:GetString("total_mobilization_desc3"))
  self.textDiscount = self:AddComponent(UIText, "DiscountInfo/DiscountText")
  self.textDiscountPercent = self:AddComponent(UIText, "DiscountInfo/DiscountTextPercent")
  self.textDiscountPercent:SetText(Localization:GetString("%"))
  self.btnBuyButton = self:AddComponent(LWBtnBuyRefundRemind, "BuyButton")
  self.btnBuyButton:SetBuyClickAction(function()
    self:OnBtnBuyButtonClick()
  end)
  self.btnBuyButton:SetSafeClickMode(true)
  self.rewardsMustGet = {}
  for i = 1, 10 do
    local newReward = self:AddComponent(UICommonResItem, "MustGet/MustGetReward/Viewport/Content/reward" .. i)
    table.insert(self.rewardsMustGet, newReward)
  end
  self.rewardsRandomGet = {}
  for i = 1, 10 do
    local newReward = self:AddComponent(UICommonResItem, "RandomGet/RandomGetReward/Viewport/Content/randomReward" .. i)
    table.insert(self.rewardsRandomGet, newReward)
  end
end

function ActivityRebateNewGiftDetailComponent:ComponentDestroy()
  self.textPackageTitle = nil
  self.textPackageDescription = nil
  self.textMustGet = nil
  self.textRandomGet = nil
  self.textDiscount = nil
  self.textDiscountPercent = nil
  self.textDiscountSub = nil
  self.btnBuyButton = nil
  self.rewardsMustGet = nil
  self.rewardsRandomGet = nil
end

function ActivityRebateNewGiftDetailComponent:DataDefine()
end

function ActivityRebateNewGiftDetailComponent:DataDestroy()
end

function ActivityRebateNewGiftDetailComponent:OnAddListener()
  base.OnAddListener(self)
end

function ActivityRebateNewGiftDetailComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActivityRebateNewGiftDetailComponent:SetData(data, activityId, class)
  self.giftData = data
  if self.giftData == nil then
    return
  end
  self.packageData = GiftPackageData.get(tostring(self.giftData.exchangeId))
  if self.packageData == nil then
    return
  end
  self.activityId = activityId
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityData == nil then
    return
  end
  self.class = class
  self:UpdateAll()
end

function ActivityRebateNewGiftDetailComponent:UpdateAll()
  if self.giftData == nil or self.packageData == nil then
    return
  end
  self.textPackageTitle:SetText(self.packageData:getNameText())
  local boughtTimes = self.packageData:getHasGetCount()
  local totalTimes = self.packageData:getBuyTimes()
  local leftTimes = math.max(0, totalTimes - boughtTimes)
  self.textPackageDescription:SetLocalText("total_mobilization_desc1", leftTimes, totalTimes)
  self.textDiscount:SetLocalText("320002", string.format("%s", self.packageData:getPercent()))
  self.textDiscountPercent:SetText("%")
  local iconPath = DataCenter.ActivityRebateNewManager:GetPackageIconByClass(checknumber(self.class))
  self.imgPackageIcon:LoadSprite(iconPath)
  self:UpdateMustGet()
  self:UpdateRandomReward()
  self:UpdateBuy()
end

function ActivityRebateNewGiftDetailComponent:UpdateMustGet()
  local function GetMustGetReward()
    local res = {}
    
    if self.packageData == nil or self.activityData == nil then
      return res
    end
    local fixReward = self.packageData:getItems(true)
    local showReward
    local targetGoodId = checknumber(self.activityData.para_2)
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
    table.insert(res, showReward)
    local diamondWorth = tonumber(self.packageData:getDiamond())
    if diamondWorth and 0 < diamondWorth then
      local param = {}
      param.rewardType = RewardType.GOLD
      param.count = diamondWorth
      table.insert(res, param)
    end
    for i = 1, count do
      local reward = fixReward[i]
      if reward and reward.rewardType == RewardType.ALLIANCE_GIFT then
        table.insert(res, reward)
      end
    end
    return res
  end
  
  local rewards = GetMustGetReward()
  for i, v in ipairs(self.rewardsMustGet) do
    if i <= #rewards then
      v:SetActive(true)
      v:ReInit(rewards[i])
    else
      v:SetActive(false)
    end
  end
end

function ActivityRebateNewGiftDetailComponent:UpdateRandomReward()
  if self.packageData == nil then
    return
  end
  local rewards = self.giftData.randomReward or {}
  for i, v in ipairs(self.rewardsRandomGet) do
    if i <= #rewards then
      v:SetActive(true)
      local para = {}
      para.rewardType = RewardType.GOODS
      para.itemId = rewards[i].value.id or 0
      para.count = rewards[i].value.num
      v:ReInit(para)
    else
      v:SetActive(false)
    end
  end
end

function ActivityRebateNewGiftDetailComponent:UpdateBuy()
  self.btnBuyButton:Init(self.packageData)
  if self.packageData and self.packageData:canGet() then
    CS.UIGray.SetGray(self.btnBuyButton.transform, false, true)
  else
    self.btnBuyButton:SetPriceText(Localization:GetString("total_mobilization_desc4"))
    CS.UIGray.SetGray(self.btnBuyButton.transform, true, false)
  end
  self.btnBuyButton:RefreshPoint()
end

function ActivityRebateNewGiftDetailComponent:OnBtnBuyButtonClick()
  if self.packageData ~= nil then
    DataCenter.ActivityRebateNewManager:BuyGift(self.packageData, self.activityId)
  end
end

return ActivityRebateNewGiftDetailComponent
