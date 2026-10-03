local UIActMonopolyShopItem = BaseClass("UIActMonopolyShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIActMonopolyShopResItem = require("UI.UIActMonopoly.UIActMonopolyShop.Component.UIActMonopolyShopResItem")
local UIActMonopolyShopExchangeItem = require("UI.UIActMonopoly.UIActMonopolyShop.Component.UIActMonopolyShopExchangeItem")
local timeTxt_path = "Ani/TimeContent/Txt_Times"
local shopItemCell_path = "Ani/shopItemCell"
local content_path = "Ani/ScrollView/Viewport/Content"
local exchange_content_path = "Ani/exchangeContent"
local raw_bg_path = "Ani/bg/rawBg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearAllItem()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, "Ani")
  self.timeTxt = self:AddComponent(UIText, timeTxt_path)
  self.shopItems = {}
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.shopItemCell = self:AddComponent(UIBaseContainer, shopItemCell_path)
  self.shopItemCell:SetActive(false)
  self.shopItemCell.gameObject:GameObjectCreatePool()
  self.exchange_content = self:AddComponent(UIActMonopolyShopExchangeItem, exchange_content_path)
  self.raw_bg = self:AddComponent(UIRawImage, raw_bg_path)
end

local function ComponentDestroy(self)
  self:RemoveTimer()
  self.exchange_content = nil
  self.raw_bg = nil
end

local function DataDefine(self)
  self.actId = nil
  self.data = nil
end

local function DataDestroy(self)
  self.actId = nil
  self.data = nil
end

local function SetData(self, actId, data)
  self:RemoveTimer()
  self.actId = actId
  self.data = data
  self:RefreshView()
  self:Update1000MS()
end

local function ClearAllItem(self)
  self.content:RemoveComponents(UIActMonopolyShopResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.shopItemCell.gameObject:GameObjectRecycleAll()
  self.shopItems = {}
end

local function RefreshView(self)
  local dataNum = #self.data.shopArr
  local itemNum = #self.shopItems
  local normalItemNum = dataNum - 1
  self.animator:SetActive(true)
  if normalItemNum ~= itemNum then
    self:ClearAllItem()
    for i = 1, normalItemNum do
      local index = i
      local item = self.shopItemCell.gameObject:GameObjectSpawn(self.content.transform)
      item.name = index
      local obj = self.content:AddComponent(UIActMonopolyShopResItem, item.name)
      obj:SetActive(true)
      self.shopItems[index] = obj
    end
  end
  for i = 1, normalItemNum do
    self.shopItems[i]:SetData(self.actId, self.data, i + 1)
  end
  self.exchange_content:SetData(self.actId, self.data, 1)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if activityInfo == nil then
    return
  end
  local showTemp = activityInfo:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  local imgStr = showTemp.pic_spec4
  local imgList = string.split(imgStr, "|")
  if #imgList == 7 then
    self.raw_bg:LoadSprite(string.format(UIAssets.UIActMonopolyTexturePath, imgList[5]))
  end
  local paraTemp = DataCenter.ActMonopolyDataManager:GetMonopolyParaTempById(activityInfo.richman_para)
  if paraTemp ~= nil and not string.IsNullOrEmpty(paraTemp.shop_text_color) then
    local splitPara = string.split(paraTemp.shop_text_color, "|")
    if #splitPara == 3 then
      local splitTextColor = string.split(splitPara[2], ",")
      if #splitTextColor == 4 then
        self.timeTxt:SetColorRGBA255(tonumber(splitTextColor[1]), tonumber(splitTextColor[2]), tonumber(splitTextColor[3]), tonumber(splitTextColor[4]))
      end
    end
  end
end

local function Update1000MS(self)
  if self.data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.data.endTime * 1000 - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.timeTxt:SetText(countDownTimeStr)
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function PlayAniDelayTime(self, delay)
  self:RemoveTimer()
  self.animator:SetActive(false)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.animator:SetActive(true)
    self.animator:Play("Eff_dwf_shangdian_jiangli_dakai")
  end, delay)
end

UIActMonopolyShopItem.OnCreate = OnCreate
UIActMonopolyShopItem.OnDestroy = OnDestroy
UIActMonopolyShopItem.ComponentDefine = ComponentDefine
UIActMonopolyShopItem.ComponentDestroy = ComponentDestroy
UIActMonopolyShopItem.DataDefine = DataDefine
UIActMonopolyShopItem.DataDestroy = DataDestroy
UIActMonopolyShopItem.SetData = SetData
UIActMonopolyShopItem.Update1000MS = Update1000MS
UIActMonopolyShopItem.ClearAllItem = ClearAllItem
UIActMonopolyShopItem.RefreshView = RefreshView
UIActMonopolyShopItem.PlayAniDelayTime = PlayAniDelayTime
UIActMonopolyShopItem.RemoveTimer = RemoveTimer
return UIActMonopolyShopItem
