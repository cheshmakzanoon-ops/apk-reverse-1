local UIActGiftBoxRewardView = BaseClass("UIActGiftBoxRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local GiftBoxRewardCell = require("UI.UIActGiftBox.UIActGiftBoxReward.Component.GiftBoxRewardCell")
local title_path = "PopUpTitle/Common_img_title/titleText"
local Content = "PopUpTitle/Common_bg_orange2"
local Txt_ItemReward = "PopUpTitle/Common_bg_orange2/ScrollView1/PropRewardsText"
local Rect_ItemContent = "PopUpTitle/Common_bg_orange2/ScrollView1/VerContent/Viewport/Content1"
local Txt_GiftReward = "PopUpTitle/Common_bg_orange2/ScrollView2/GiftRewardsText"
local Rect_GiftContent = "PopUpTitle/Common_bg_orange2/ScrollView2/Viewport/Content2"
local closeBtn_path = "PopUpTitle/CloseBtn"
local maskBtn_path = "panel"
local item_reward_tip_text_path = "PopUpTitle/Common_bg_orange2/ScrollView1/VerContent/PropRewardsTipText"

function UIActGiftBoxRewardView:OnCreate()
  PostEventLog.Track(PostEventLog.Defines.OpenGiftBoxRewardPreviewPanel, {})
  base.OnCreate(self)
  self.actId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIActGiftBoxRewardView:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActGiftBoxRewardView:OnEnable()
  base.OnEnable(self)
end

function UIActGiftBoxRewardView:OnDisable()
  base.OnDisable(self)
end

function UIActGiftBoxRewardView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleTxtN = self:AddComponent(UIText, title_path)
  self.itemRewardTipTxtN = self:AddComponent(UIText, item_reward_tip_text_path)
  self.itemRewardTipTxtN:SetLocalText(2800062)
  self.content = self:AddComponent(UIBaseContainer, Content)
  self._itemReward_txt = self:AddComponent(UIText, Txt_ItemReward)
  self._itemContent_rect = self:AddComponent(UIBaseContainer, Rect_ItemContent)
  self._giftReward_txt = self:AddComponent(UIText, Txt_GiftReward)
  self._giftContent_rect = self:AddComponent(UIBaseContainer, Rect_GiftContent)
end

function UIActGiftBoxRewardView:ComponentDestroy()
  self.createBtnTxtN = nil
  self.closeBtnN = nil
end

function UIActGiftBoxRewardView:DataDefine()
end

function UIActGiftBoxRewardView:DataDestroy()
end

function UIActGiftBoxRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftBoxLotteryCount, self.OnRefresh)
end

function UIActGiftBoxRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftBoxLotteryCount, self.OnRefresh)
end

function UIActGiftBoxRewardView:ReInit()
  self.titleTxtN:SetLocalText(390334)
  self._itemReward_txt:SetLocalText(372512)
  self._giftReward_txt:SetLocalText(372513)
  if self.actId then
    SFSNetwork.SendMessage(MsgDefines.GetActivityGiftBoxLotteryCount, self.actId)
  end
end

function UIActGiftBoxRewardView:OnRefresh()
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(self.actId)
  self.listReward = DataCenter.ActGiftBoxData:GetActReward(self.actId)
  self:SetAllCellDestroy()
  self:RefreshItemReward(self.listReward.itemReward)
  local rewardList = self:MergeSameQualityBox(self.listReward.giftReward)
  self:RefreshBoxReward(rewardList)
end

function UIActGiftBoxRewardView:MergeSameQualityBox(rewardList)
  local mergeList = {}
  table.sort(rewardList, function(a, b)
    return a.id < b.id
  end)
  for k, v in ipairs(rewardList) do
    local data = mergeList[v.quality]
    if data then
      for _, v1 in ipairs(v.propReward) do
        v1.id = v.id
        table.insert(data.propReward, v1)
      end
    else
      mergeList[v.quality] = v
      for _, v1 in ipairs(v.propReward) do
        v1.id = v.id
      end
    end
  end
  for k, v in pairs(mergeList) do
    local totalProp = 0
    for k1, v1 in pairs(v.propReward) do
      totalProp = totalProp + v1.prop
    end
    for k1, v1 in pairs(v.propReward) do
      v1.resultProp = v1.prop / totalProp
    end
  end
  for k, v in pairs(mergeList) do
    table.sort(v.propReward, function(a, b)
      local template1 = DataCenter.ItemTemplateManager:GetItemTemplate(a.itemId)
      local template2 = DataCenter.ItemTemplateManager:GetItemTemplate(b.itemId)
      if template1.quality ~= template2.quality then
        return template1.quality > template2.quality
      else
        return a.id < b.id
      end
    end)
  end
  return mergeList
end

function UIActGiftBoxRewardView:RefreshItemReward(listReward)
  self.modelItem = {}
  if listReward then
    for i = 1, table.count(listReward) do
      self.modelItem[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._itemContent_rect.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.name = "item_reward_" .. i
        local cell = self._itemContent_rect:AddComponent(UICommonResItem, go.name)
        cell:ReInit(listReward[i])
        if listReward[i].resultProp then
          cell.name_text:SetActive(true)
          cell:SetNameText(string.format("%.2f%%", listReward[i].resultProp * 100), 16, 28)
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
      end)
    end
  end
end

function UIActGiftBoxRewardView:SetAllCellDestroy()
  self._itemContent_rect:RemoveComponents(UICommonResItem)
  if self.modelItem ~= nil then
    for k, v in pairs(self.modelItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self._giftContent_rect:RemoveComponents(GiftBoxRewardCell)
  if self.modelGift ~= nil then
    for k, v in pairs(self.modelGift) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIActGiftBoxRewardView:RefreshBoxReward(giftReward)
  if giftReward then
    self.modelGift = {}
    local lotteryList = self.actData.lotteryList
    for i = 1, table.count(giftReward) do
      self.modelGift[i] = self:GameObjectInstantiateAsync(UIAssets.GiftBoxRewardCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._giftContent_rect.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "item_gift_" .. i
        local cell = self._giftContent_rect:AddComponent(GiftBoxRewardCell, go.name)
        cell:ReInit(giftReward[i], lotteryList, self.actId)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
      end)
    end
  end
end

return UIActGiftBoxRewardView
