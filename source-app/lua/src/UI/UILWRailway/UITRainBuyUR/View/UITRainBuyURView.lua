local base = UIBaseView
local UITRainBuyURView = BaseClass("UITRainBuyURView", base)
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")

function UITRainBuyURView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UITRainBuyURView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITRainBuyURView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "Panel")
  self.closeBtn = self:AddComponent(UIButton, "Root/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self:CloseSelf()
  end)
  self.title = self:AddComponent(UIText, "Root/title")
  self.title2 = self:AddComponent(UIText, "Root/title2")
  self.subTitle = self:AddComponent(UIText, "Root/subTitle")
  self.gift = self:AddComponent(UIBaseComponent, "Root/Gift")
  self.discount = self:AddComponent(UIText, "Root/Gift/discount/value")
  self.rewardContent = self:AddComponent(UIBaseContainer, "Root/Gift/ScrollRect/ViewPort/Content")
  self.desc = self:AddComponent(UIText, "Root/Gift/desc")
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, "Root/Gift/buyBtn")
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickBuy()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.item = self:AddComponent(UIBaseComponent, "Root/Item")
  self.desc2 = self:AddComponent(UIText, "Root/Item/desc2")
  self.costTxt = self:AddComponent(UIText, "Root/Item/costTxt")
  self.smallIcon = self:AddComponent(UIImage, "Root/Item/costTxt/smallIcon")
  self.useBtn = self:AddComponent(UIButton, "Root/Item/useBtn")
  self.useBtn:SetOnClick(function()
    self:OnClickUse()
  end)
  self.tipBtn = self:AddComponent(UIButton, "Root/TipBtn")
  self.tipBtn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function UITRainBuyURView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UITRainBuyURView:ComponentDestroy()
end

function UITRainBuyURView:DataDefine()
  local itemId = DataCenter.LWAllyStationDataManager.BUY_TRAIN_GIFT_ID
  self.packageInfo = GiftPackManager.get(itemId)
end

function UITRainBuyURView:DataDestroy()
end

function UITRainBuyURView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceTrainBuySuccess, self.CloseSelf)
end

function UITRainBuyURView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceTrainBuySuccess, self.CloseSelf)
end

function UITRainBuyURView:Refresh()
  local cur, max = DataCenter.LWAllyStationDataManager:BuyCount()
  self.subTitle:SetLocalText("alliance_train_060", cur .. "/" .. max)
  if self.packageInfo then
    self.title:SetText(self.packageInfo:getNameText())
    self.buyBtn:Init(self.packageInfo)
    self.buyBtn:RefreshPoint()
  else
    self.title:SetLocalText(458535)
  end
  local itemId = DataCenter.LWAllyStationDataManager.BUY_TRAIN_COST_ITEM
  local have = DataCenter.ItemData:GetItemCount(itemId)
  if 1 <= have or self.packageInfo == nil then
    self.gift:SetActive(false)
    self.item:SetActive(true)
    if self.packageInfo then
      self.desc2:SetText(self.packageInfo:getDescText())
    end
    self.costTxt:SetText(have .. "/1")
    self.costTxt:SetColor(GreenColor)
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    self.smallIcon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
  else
    self.gift:SetActive(true)
    self.item:SetActive(false)
    self.discount:SetText(self.packageInfo:getPercent() .. "%")
    self.desc:SetText(self.packageInfo:getDescText())
    self:RefreshReward()
  end
end

function UITRainBuyURView:OnClickBuy()
  if self.packageInfo and self.packageInfo:getID() ~= -1 then
    if self.packageInfo._serverData.buys and self.packageInfo._serverData.buys >= self.packageInfo._tableData.buy_times then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString(458638, self.packageInfo._tableData.buy_times))
    else
      DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UITrainBuy)
      self:CloseSelf()
    end
  end
end

function UITRainBuyURView:OnClickUse()
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainBuy)
end

function UITRainBuyURView:OnTipBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainProbability, {anim = true})
end

function UITRainBuyURView:ClearReward()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.rewardReqs then
    for _, req in pairs(self.rewardReqs) do
      req:Destroy()
    end
  end
  self.rewardReqs = {}
end

function UITRainBuyURView:RefreshReward()
  self:ClearReward()
  local curRewardList = self.packageInfo:getItems()
  for i, data in ipairs(curRewardList) do
    self:AddOneReward(i, data)
  end
end

function UITRainBuyURView:AddOneReward(i, data, isLost)
  self.rewardReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if IsNull(req.gameObject) then
      return
    end
    local go = req.gameObject
    local index = i
    local nameStr = "UICommonResItem" .. index
    go.name = nameStr
    go:SetActive(true)
    local transform = go.transform
    transform:SetParent(self.rewardContent.transform)
    transform:Set_sizeDelta(150, 150)
    transform:Set_localScale(1.1, 1.1, 1)
    transform:Set_pivot(0, 1)
    local item = self.rewardContent:AddComponent(UICommonResItem, nameStr)
    item:ReInit(data)
  end)
end

return UITRainBuyURView
