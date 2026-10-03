local UILWHelpGiftPackageRewardGetView = BaseClass("UILWHelpGiftPackageRewardGetView", UIBaseView)
local base = UIBaseView
local UIRewardPlayerItem = require("UI.UILWHelpGiftPackageRewardGet.Component.UIRewardPlayerItem")
local helpPurchaseKey = "activity_bargain_shop_desc15"
local helpKey = "activity_bargain_shop_desc16"
local helpBtnKey = "activity_bargain_shop_desc17"
local purchaseKey = "activity_bargain_shop_desc18"
local btnKey = "activity_bargain_shop_desc19"
local thanksKey = "activity_bargain_shop_desc44"
local Localization = CS.GameEntry.Localization

function UILWHelpGiftPackageRewardGetView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UILWHelpGiftPackageRewardGetView:ComponentDefine()
  self.resItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.resName_text = self:AddComponent(UIText, "layout/itemName")
  self.economiizeDes_text = self:AddComponent(UIText, "layout/desLayOut/economizeDes")
  self.economiizeDesLayout = self:AddComponent(UIBaseContainer, "layout/desLayOut")
  self.economizeDesIcon = self:AddComponent(UIImage, "layout/desLayOut/icon")
  self.helpDes_text = self:AddComponent(UIText, "layout/helpDes")
  self.getBtn = self:AddComponent(UIButton, "layout/getBtn")
  self.getBtn_text = self:AddComponent(UIText, "layout/getBtn/TrainBtnText")
  self.playerList = self:AddComponent(UIScrollView, "layout/scrollView_playerList")
  self.getBtn:SetOnClick(function()
    self:OnGetBtnClick()
  end)
  self.playerList:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.playerList:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function UILWHelpGiftPackageRewardGetView:OnGetBtnClick()
  self.ctrl:CloseSelf()
end

function UILWHelpGiftPackageRewardGetView:ComponentDestroy()
  self.resItem = nil
  self.resName_text = nil
  self.economiizeDes_text = nil
  self.helpDes_text = nil
  self.getBtn = nil
  self.getBtn_text = nil
  self.playerList = nil
end

function UILWHelpGiftPackageRewardGetView:ShowScroll()
  self:ClearScroll()
  local count = #self.playerDataList
  self.playerList:SetTotalCount(count)
  if 0 < count then
    self.playerList:RefillCells()
  end
end

function UILWHelpGiftPackageRewardGetView:ClearScroll()
  self.playerList:ClearCells()
  self.playerList:RemoveComponents(UIRewardPlayerItem)
end

function UILWHelpGiftPackageRewardGetView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.playerList:AddComponent(UIRewardPlayerItem, itemObj)
  item:ReInit(self.playerDataList[index])
end

function UILWHelpGiftPackageRewardGetView:ReInit()
  self.data = self:GetUserData()
  if self.data.helpPlayers and table.count(self.data.helpPlayers) > 0 then
    self.economiizeDesLayout:SetActive(true)
    self.playerList:SetActive(true)
    self.playerDataList = self.data.helpPlayers
    local actData = DataCenter.ActBargainShopData:GetInfoByActId(self.data.activityId)
    if actData then
      local reducePrice = actData:GetProductReducePrice(self.data.uuid)
      self.economiizeDes_text:SetLocalText(helpPurchaseKey, reducePrice)
      local actTemplate = DataCenter.ActivityListDataManager:GetActivityDataById(self.data.activityId)
      local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(actTemplate.para_2))
      self.economizeDesIcon:LoadSprite(iconPath)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.economiizeDes_text.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.economiizeDesLayout.transform)
    end
    self.helpDes_text:SetLocalText(helpKey)
    self.getBtn_text:SetLocalText(helpBtnKey)
    self:ShowScroll()
  else
    self.economiizeDesLayout:SetActive(false)
    self.playerList:SetActive(false)
    self.helpDes_text:SetLocalText(purchaseKey)
    self.getBtn_text:SetLocalText(btnKey)
  end
  local rewardData = {
    rewardType = self.data.reward[1].type,
    itemId = self.data.reward[1].value.itemId,
    count = self.data.reward[1].value.addNum
  }
  self.resItem:ReInit(rewardData)
  self.resName_text:SetText(DataCenter.RewardManager:GetNameByType(rewardData.rewardType, rewardData.itemId))
end

function UILWHelpGiftPackageRewardGetView:OnDeleteCell(itemObj, index)
  self.playerList:RemoveComponent(itemObj.name, UIRewardPlayerItem)
end

function UILWHelpGiftPackageRewardGetView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHelpGiftPackageRewardGetView:OnEnable()
  base.OnEnable(self)
end

function UILWHelpGiftPackageRewardGetView:OnDisable()
  base.OnDisable(self)
end

function UILWHelpGiftPackageRewardGetView:DataDefine()
end

function UILWHelpGiftPackageRewardGetView:DataDestroy()
end

return UILWHelpGiftPackageRewardGetView
