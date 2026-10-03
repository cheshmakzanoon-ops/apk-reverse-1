local LWUIActBountyHunterShopResItemComponent = BaseClass("LWUIActBountyHunterShopResItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local SoftMaskUtil = CS.SoftMaskUtil
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local root_path = ""
local bg_path = "bg"
local UICommonResItem_path = "UICommonResItem"
local itemName_path = "itemName"
local privceTxt_path = "priceContent/privceTxt"
local imgCostItem_path = "priceContent/ImgCostItem"

function LWUIActBountyHunterShopResItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActBountyHunterShopResItemComponent:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterShopResItemComponent:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.UpdateGold, self.OnRefreshGold)
end

function LWUIActBountyHunterShopResItemComponent:OnDisable()
  base.OnDisable(self)
  self:RemoveUIListener(EventId.UpdateGold, self.OnRefreshGold)
end

function LWUIActBountyHunterShopResItemComponent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.bgBtn = self:AddComponent(UIButton, bg_path)
  self.bgBtn:SetOnClick(function()
    self:OnBgBtnClick()
  end)
  self.uiCommonResItem = self:AddComponent(UICommonResItem, UICommonResItem_path)
  self.bgRawImg = self:AddComponent(UIRawImage, bg_path)
  self.itemName = self:AddComponent(UIText, itemName_path)
  self.imgCostItem = self:AddComponent(UIImage, imgCostItem_path)
  self.privceTxt = self:AddComponent(UIText, privceTxt_path)
end

function LWUIActBountyHunterShopResItemComponent:ComponentDestroy()
end

function LWUIActBountyHunterShopResItemComponent:DataDefine()
  self.actId = nil
  self.shopData = nil
  self.index = nil
  self.itemData = nil
  self.packageInfo = nil
end

function LWUIActBountyHunterShopResItemComponent:DataDestroy()
  self.actId = nil
  self.shopData = nil
  self.index = nil
  self.itemData = nil
  self.packageInfo = nil
end

function LWUIActBountyHunterShopResItemComponent:SetData(activityId, data, uuid)
  self.activityId = activityId
  self.data = data
  self.uuid = uuid
  self:RefreshView()
end

function LWUIActBountyHunterShopResItemComponent:RefreshView()
  if self.activityId == nil or self.data == nil then
    return
  end
  local goodsId
  local goodsNum = 0
  local goodsName = ""
  local goodsStr = self.data.tmpData.goodsid
  local goodsArr = string.string2array_i_oneSep(goodsStr, ";")
  if #goodsArr == 2 then
    goodsId = goodsArr[1]
    goodsNum = goodsArr[2]
    goodsName = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, goodsId)
  end
  local rewardData = {
    count = goodsNum,
    itemId = goodsId,
    rewardType = RewardType.GOODS
  }
  self.uiCommonResItem:ReInit(rewardData)
  local showTxt = Localization:GetString("2000291", self.data.tmpData.buy_times - self.data.giftData.buyCount)
  self.itemName:SetText(showTxt)
  self:RefreshCostText()
end

function LWUIActBountyHunterShopResItemComponent:RefreshCostText()
  if self.data.giftData.buyCount < self.data.tmpData.buy_times then
    if self.data.tmpData.buy_type == 3 then
      self.imgCostItem:SetActive(false)
      self.privceTxt:SetLocalText("activity_hunter_trade_desc3")
    else
      self.imgCostItem:SetActive(true)
      local spritePath = DataCenter.RewardManager:GetPicByType(RewardType.GOLD)
      self.imgCostItem:LoadSprite(spritePath)
      local costNum = tonumber(self.data.tmpData.cost_list)
      local curNum = LuaEntry.Player.gold
      local showStr = costNum
      if costNum > curNum then
        showStr = string.format("<color=#dd2828> %s</color>", costNum)
      end
      self.privceTxt:SetText(showStr)
    end
    CS.UIGray.SetGray(self.root.transform, false, true)
  else
    self.imgCostItem:SetActive(false)
    self.privceTxt:SetLocalText(320268)
    CS.UIGray.SetGray(self.root.transform, true, true)
  end
end

function LWUIActBountyHunterShopResItemComponent:OnBgBtnClick()
  if self.activityId == nil or self.data == nil then
    return
  end
  if self.data.giftData.buyCount >= self.data.tmpData.buy_times then
    return
  end
  if self.data.tmpData.buy_type == 3 then
    SFSNetwork.SendMessage(MsgDefines.BountyHunterEventShopBuy, tonumber(self.activityId), self.data.giftData.confId, self.uuid)
  else
    local costNum = tonumber(self.data.tmpData.cost_list)
    local curNum = LuaEntry.Player.gold
    if costNum <= curNum then
      SFSNetwork.SendMessage(MsgDefines.BountyHunterEventShopBuy, tonumber(self.activityId), self.data.giftData.confId, self.uuid)
    else
      LWResourceLackUtil:GotoResLack({
        {
          resType = ResourceType.Gold,
          need = costNum
        }
      })
    end
  end
end

function LWUIActBountyHunterShopResItemComponent:OnRefreshGold()
  self:RefreshCostText()
end

return LWUIActBountyHunterShopResItemComponent
