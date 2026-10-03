local ActValentineSendGiftContent = BaseClass("ActValentineSendGiftContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "itemObj/UICommonResItem"
local tip1_des_path = "tipContent/tip1Content/tip1Des"
local tip2_des_path = "tipContent/tip2Content/tip2Des"
local give_btn_path = "giveBtn"
local give_btn_img_path = "giveBtn/giveBtnImg"
local give_btn_txt_path = "giveBtn/giveBtnTxt"

function ActValentineSendGiftContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ActValentineSendGiftContent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActValentineSendGiftContent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.tip1_des = self:AddComponent(UITextMeshProUGUIEx, tip1_des_path)
  self.tip2_des = self:AddComponent(UITextMeshProUGUIEx, tip2_des_path)
  self.give_btn = self:AddComponent(UIButton, give_btn_path)
  self.give_btn_txt = self:AddComponent(UITextMeshProUGUIEx, give_btn_txt_path)
  self.give_btn:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
end

function ActValentineSendGiftContent:ComponentDestroy()
  self.u_i_common_res_item = nil
  self.tip1_des = nil
  self.tip2_des = nil
  self.give_btn = nil
  self.give_btn_txt = nil
end

function ActValentineSendGiftContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function ActValentineSendGiftContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
end

function ActValentineSendGiftContent:Refresh(pointType, pointUuid, ownerUid, activityId)
  self.pointType = pointType
  self.pointUuid = pointUuid
  self.ownerUid = ownerUid
  self.activityId = activityId
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo then
    self.actEndTime = self.activityInfo.endTime
  end
  self.actTemp = DataCenter.ValentineDataManager:GetActSendTempByActId(self.activityId)
  if self.actTemp == nil then
    return
  end
  local goodInfo = self.actTemp.gift_good
  self.targetItem = goodInfo[1]
  self:RefreshView()
end

function ActValentineSendGiftContent:RefreshView()
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItem)
  local param = {
    rewardType = RewardType.GOODS,
    itemId = self.targetItem
  }
  self.u_i_common_res_item:ReInit(param)
  local itemName = DataCenter.ItemTemplateManager:GetName(self.targetItem)
  self.tip1_des:SetText(itemName)
  if 0 < curNum then
    self.give_btn_txt:SetLocalText("thxgiv_ListSend")
  else
    self.give_btn_txt:SetLocalText("2000630")
  end
  self.tip2_des:SetText(Localization:GetString("activity_torch_relay_desc_37") .. curNum)
end

function ActValentineSendGiftContent:OnGiveBtnClick()
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItem)
  if curNum <= 0 then
    LWResourceLackUtil:GotoGoodsItemLack(self.targetItem, 1)
  else
    DataCenter.GiftSystemManager:SendGift(self.targetItem, self.ownerUid, false, "", 1)
  end
end

function ActValentineSendGiftContent:Update1000MS()
  if not self.actEndTime then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.actEndTime + 1000 then
    self:SetActive(false)
  end
end

return ActValentineSendGiftContent
