local ActGiftGivingContent = BaseClass("ActGiftGivingContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "itemObj/UICommonResItem"
local tip1_des_path = "tipContent/tip1Content/tip1Des"
local tip2_des_path = "tipContent/tip2Content/tip2Des"
local give_btn_path = "giveBtn"
local give_btn_img_path = "giveBtn/giveBtnImg"
local give_btn_txt_path = "giveBtn/giveBtnTxt"

function ActGiftGivingContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ActGiftGivingContent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActGiftGivingContent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.tip1_des = self:AddComponent(UITextMeshProUGUIEx, tip1_des_path)
  self.tip2_des = self:AddComponent(UITextMeshProUGUIEx, tip2_des_path)
  self.give_btn = self:AddComponent(UIButton, give_btn_path)
  self.give_btn_img = self:AddComponent(UIImage, give_btn_img_path)
  self.give_btn_txt = self:AddComponent(UITextMeshProUGUIEx, give_btn_txt_path)
  self.give_btn:SetOnClick(function()
    self:OnGiveBtnClick()
  end)
end

function ActGiftGivingContent:ComponentDestroy()
  self.u_i_common_res_item = nil
  self.tip1_des = nil
  self.tip2_des = nil
  self.give_btn = nil
  self.give_btn_img = nil
  self.give_btn_txt = nil
end

function ActGiftGivingContent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftGivingGive, self.SendActGiftGivingGiveMsg)
end

function ActGiftGivingContent:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftGivingGive, self.SendActGiftGivingGiveMsg)
end

function ActGiftGivingContent:Refresh(pointType, pointUuid, ownerUid, activityId, actEndTime)
  self.pointType = pointType
  self.pointUuid = pointUuid
  self.ownerUid = ownerUid
  self.activityId = activityId
  self.actEndTime = actEndTime
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActGiftGivingDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(self.activityInfo)
  self.targetItem = self.activityTemp.give_item
  self:RefreshView()
end

function ActGiftGivingContent:RefreshView()
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItem)
  local param = {
    rewardType = RewardType.GOODS,
    itemId = self.targetItem
  }
  self.u_i_common_res_item:ReInit(param)
  if 0 < curNum then
    self.tip1_des:SetLocalText("thxgiv_MapSent")
    self.give_btn_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_1.png")
    self.give_btn_txt:SetLocalText("thxgiv_ListSend")
  else
    self.tip1_des:SetLocalText("thxgiv_MapSent_lack")
    self.give_btn_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png")
    self.give_btn_txt:SetLocalText("thxgiv_MapTurkeyGet")
  end
  self.tip2_des:SetText(Localization:GetString("activity_torch_relay_desc_37") .. curNum)
end

function ActGiftGivingContent:SendActGiftGivingGiveMsg()
  self:RefreshView()
end

function ActGiftGivingContent:OnGiveBtnClick()
  local curNum = DataCenter.ItemData:GetItemCount(self.targetItem)
  if curNum <= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftGivingDropPanel, {anim = true}, self.activityId)
  else
    local returnGiftUuid = 0
    local leavingMessage = ""
    SFSNetwork.SendMessage(MsgDefines.ThanksgivingGive, self.activityId, self.ownerUid, 1, returnGiftUuid, leavingMessage)
  end
end

function ActGiftGivingContent:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.actEndTime + 1000 then
    self:SetActive(false)
  end
end

return ActGiftGivingContent
