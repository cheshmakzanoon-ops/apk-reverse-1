local GiftBoxRewardBoxItemNew = BaseClass("GiftBoxRewardBoxItemNew", UIBaseContainer)
local base = UIBaseContainer
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local Localization = CS.GameEntry.Localization
local img_quality_path = "UICommonResItem/clickBtn/ImgQuality"
local item_icon_path = "UICommonResItem/clickBtn/ItemIcon"
local receive_btn_path = "canRec/receiveBtn"
local receive_btn_text_path = "canRec/receiveBtn/Btn/receiveBtnText"
local received_txt_path = "hasRecd/receivedTxt"

function GiftBoxRewardBoxItemNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GiftBoxRewardBoxItemNew:OnDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function GiftBoxRewardBoxItemNew:ComponentDefine()
  self._num_txt = self:AddComponent(UIText, "Num")
  self._box_img = self:AddComponent(UIImage, "BoxBtn/BoxImg")
  self._box_red_dot = self:AddComponent(UIBaseContainer, "RedPoint")
  self._effect = self:AddComponent(UIBaseContainer, "Effect")
  self._canRec_node = self:AddComponent(UIBaseContainer, "canRec")
  self._hasRecd_node = self:AddComponent(UIBaseContainer, "hasRecd")
  self._noRec_node = self:AddComponent(UIBaseContainer, "noRec")
  self._noRec_title_txt = self:AddComponent(UITextMeshProUGUIEx, "noRec/noRecTitle")
  self._noRec_title_txt:SetLocalText("airdrop_supply_desc4")
  self._noRec_value_txt = self:AddComponent(UITextMeshProUGUIEx, "noRec/value")
  self.receive_btn_text = self:AddComponent(UIText, receive_btn_text_path)
  self.receive_btn_text:SetLocalText("airdrop_supply_desc3")
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self._reward_item = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:OnClickBox()
  end)
  self.received_txt = self:AddComponent(UITextMeshProUGUIEx, received_txt_path)
  self.received_txt:SetLocalText("airdrop_supply_desc2")
end

function GiftBoxRewardBoxItemNew:DataDefine()
end

function GiftBoxRewardBoxItemNew:DataDestroy()
end

function GiftBoxRewardBoxItemNew:ReInit(param, activityId)
  self.param = param
  self.activityId = activityId
  if self.param == nil then
    return
  end
  local rewardData = DataCenter.RewardManager:ParseRewardInfo(self.param.reward[1])
  self._num_txt:SetText(param.targetScore)
  self._canRec_node:SetActive(self.param.state ~= 1)
  self._hasRecd_node:SetActive(self.param.state == 1)
  self._noRec_node:SetActive(self.param.state ~= 1)
  local selfScore = DataCenter.ActGiftBoxData:GetActScoreById(tonumber(self.activityId))
  if self.param.state == 1 then
    self._box_red_dot:SetActive(false)
    self._effect:SetActive(false)
    rewardData.isShowReceFlag = true
  else
    self._box_red_dot:SetActive(selfScore >= param.targetScore)
    self._effect:SetActive(selfScore >= param.targetScore)
    self._canRec_node:SetActive(selfScore >= param.targetScore)
    self._noRec_node:SetActive(selfScore < param.targetScore)
    if selfScore < param.targetScore then
      self._noRec_value_txt:SetText(string.format("%d/%d", selfScore, param.targetScore))
    end
  end
  self._reward_item:ReInit(rewardData)
  CS.UIGray.SetGray(self.img_quality.transform, self.param.state == 0 and selfScore < param.targetScore, false)
  CS.UIGray.SetGray(self.item_icon.transform, self.param.state == 0 and selfScore < param.targetScore, false)
end

function GiftBoxRewardBoxItemNew:OnClickBox()
  if self.param then
    local selfScore = DataCenter.ActGiftBoxData:GetActScoreById(self.activityId)
    if self.param.state == 0 and selfScore >= self.param.targetScore then
      SFSNetwork.SendMessage(MsgDefines.GiftBoxReceive, toInt(self.activityId), self.param.index)
    else
      local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
      param.position = self:GetPosition()
      param.dir = param.position.x > -1150 and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
      param.deltaX = param.dir == UIPersonalArmsRewardTipView.Direction.RIGHT and -30 or 30
      param.rewardList = self.param.reward
      param.closePassClick = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    end
  end
end

return GiftBoxRewardBoxItemNew
