local LWUIActBountyHunterShopItemComponent = BaseClass("LWUIActBountyHunterShopItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIActBountyHunterShopResItemComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterShop/Component/LWUIActBountyHunterShopResItemComponent")
local LWUIActBountyHunterShopExchangeItemComponent = require("UI/LWUIActBountyHunter/LWUIActBountyHunterShop/Component/LWUIActBountyHunterShopExchangeItemComponent")
local timeTxt_path = "Ani/TimeContent/Txt_Times"
local content_path = "Ani/ScrollView/Viewport/Content"
local exchange_content_path = "Ani/exchangeContent"
local raw_bg_path = "Ani/bg/rawBg"

function LWUIActBountyHunterShopItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterShopItemComponent:OnDestroy()
  self:ClearAllItem()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterShopItemComponent:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "Ani")
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.shopItems = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.exchange_content = self:AddComponent(LWUIActBountyHunterShopExchangeItemComponent, exchange_content_path)
  self.raw_bg = self:AddComponent(UIRawImage, raw_bg_path)
end

function LWUIActBountyHunterShopItemComponent:ComponentDestroy()
  self.exchange_content = nil
  self.raw_bg = nil
end

function LWUIActBountyHunterShopItemComponent:DataDefine()
end

function LWUIActBountyHunterShopItemComponent:DataDestroy()
end

function LWUIActBountyHunterShopItemComponent:SetData(activityId, uuid)
  self.activityId = activityId
  self.uuid = uuid
  self:RefreshView()
end

function LWUIActBountyHunterShopItemComponent:ClearAllItem()
  self.content:RemoveComponents(LWUIActBountyHunterShopResItemComponent)
  if not self.itemReqs then
    self.itemReqs = {}
    return
  end
  for _, req in pairs(self.itemReqs) do
    req:Destroy()
  end
  self.itemReqs = {}
end

function LWUIActBountyHunterShopItemComponent:RefreshView()
  self:ClearAllItem()
  if self.activityId == nil or self.uuid == nil then
    return
  end
  self.activityData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if self.activityData == nil then
    return
  end
  self.eventShopData = self.activityData:GetEventShopDataByUuid(self.uuid)
  if self.eventShopData == nil then
    return
  end
  if table.IsNullOrEmpty(self.eventShopData.giftData) then
    return
  end
  local diamondDataList = {}
  local packageData
  for i, v in pairs(self.eventShopData.giftData) do
    local tmpData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event_Shop, toInt(v.confId))
    if tmpData then
      if tmpData.buy_type == 1 or tmpData.buy_type == 4 then
        packageData = {tmpData = tmpData, giftData = v}
      else
        local data = {tmpData = tmpData, giftData = v}
        table.insert(diamondDataList, data)
      end
    end
  end
  table.sort(diamondDataList, function(a, b)
    return a.tmpData.order < b.tmpData.order
  end)
  for i, v in ipairs(diamondDataList) do
    self.itemReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterShop/BountyHunterShopItemExchangeCell.prefab", function(req)
      if req.isError then
        return
      end
      local go = req.gameObject
      go.name = tostring(i)
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local item = self.content:AddComponent(LWUIActBountyHunterShopResItemComponent, go.name)
      item:SetData(self.activityId, v, self.eventShopData.uuid)
    end)
  end
  self.exchange_content:SetData(self.activityId, packageData, self.eventShopData.uuid)
  self:Update1000MS()
end

function LWUIActBountyHunterShopItemComponent:Update1000MS()
  if self.eventShopData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.eventShopData.durationTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.timeTxt:SetText(countDownTimeStr)
end

return LWUIActBountyHunterShopItemComponent
