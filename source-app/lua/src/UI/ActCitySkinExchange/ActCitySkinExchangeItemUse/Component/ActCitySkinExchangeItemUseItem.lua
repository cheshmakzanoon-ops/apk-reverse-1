local ActCitySkinExchangeItemUseItem = BaseClass("ActCitySkinExchangeItemUseItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local item_name_info_path = "ItemNameInfo"
local item_have_path = "ItemHave"
local u_i_common_res_item_path = "UICommonResItem"
local goto_btn_path = "GotoBtn"
local mult_use_content_path = "MultUseContent"
local mult_use_btn_path = "MultUseContent/MultUseBtn"
local mult_use_text_path = "MultUseContent/MultUseBtn/MultUseText"

function ActCitySkinExchangeItemUseItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActCitySkinExchangeItemUseItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ActCitySkinExchangeItemUseItem:OnEnable()
  base.OnEnable(self)
end

function ActCitySkinExchangeItemUseItem:OnDisable()
  base.OnDisable(self)
end

function ActCitySkinExchangeItemUseItem:OnAddListener()
  base.OnAddListener(self)
end

function ActCitySkinExchangeItemUseItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ActCitySkinExchangeItemUseItem:ComponentDefine()
  self.item_name_info = self:AddComponent(UITextMeshProUGUIEx, item_name_info_path)
  self.item_have = self:AddComponent(UITextMeshProUGUIEx, item_have_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.mult_use_content = self:AddComponent(UIBaseContainer, mult_use_content_path)
  self.mult_use_btn = self:AddComponent(UIButton, mult_use_btn_path)
  self.mult_use_text = self:AddComponent(UITextMeshProUGUIEx, mult_use_text_path)
  self.goto_btn:SetOnClick(function()
    self:OnGoToBtnClick()
  end)
  self.mult_use_btn:SetOnClick(function()
    self:OnMultUseAllClick()
  end)
end

function ActCitySkinExchangeItemUseItem:ComponentDestroy()
end

function ActCitySkinExchangeItemUseItem:DataDefine()
  self.activityId = 0
  self.goodsId = 0
  self.recordNum = 0
end

function ActCitySkinExchangeItemUseItem:DataDestroy()
  self.activityId = nil
  self.goodsId = nil
  self.recordNum = nil
end

function ActCitySkinExchangeItemUseItem:SetData(activityId, goodsId, isFirst)
  self.activityId = activityId
  self.goodsId = goodsId
  local rewardInfo = {}
  rewardInfo.rewardType = RewardType.GOODS
  rewardInfo.itemId = self.goodsId
  self.u_i_common_res_item:ReInit(rewardInfo)
  local curNum = DataCenter.ItemData:GetItemCount(self.goodsId)
  if isFirst then
    self.recordNum = curNum
  end
  local itemName = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, self.goodsId)
  self.item_name_info:SetText(itemName)
  self.item_have:SetLocalText("activity_sports_useitem_desc2", curNum)
  self.mult_use_text:SetText("x" .. curNum)
  self.mult_use_content:SetActive(false)
  self.mult_use_content:SetActive(1 < curNum and curNum < self.recordNum)
  UIGray.SetGray(self.goto_btn.transform, curNum <= 0, true)
end

function ActCitySkinExchangeItemUseItem:OnGoToBtnClick()
  local curNum = DataCenter.ItemData:GetItemCount(self.goodsId)
  if 0 < curNum then
    local items = DataCenter.ItemData:GetItemById(self.goodsId)
    local itemCount = items and items.count or 0
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = items.uuid,
      num = 1
    })
  else
    UIUtil.ShowTipsId("activity_sports_useitem_desc3")
  end
end

function ActCitySkinExchangeItemUseItem:OnMultUseAllClick()
  local items = DataCenter.ItemData:GetItemById(self.goodsId)
  local itemCount = items and items.count or 0
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = items.uuid,
    num = itemCount
  })
end

return ActCitySkinExchangeItemUseItem
