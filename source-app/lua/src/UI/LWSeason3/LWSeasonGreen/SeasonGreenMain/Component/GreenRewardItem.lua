local GreenRewardItem = BaseClass("GreenRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local receive_btn_path = "canRec/receiveBtn"
local receive_btn_text_path = "canRec/receiveBtn/Btn/receiveBtnText"
local received_txt_path = "hasRecd/receivedTxt"
local Content_path = "ScrollView/Viewport/Content"
local Item_path = "ScrollView/Viewport/Content/UICommonResItem"

function GreenRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GreenRewardItem:OnDestroy()
  self.ItemObj:GameObjectRecycleAll()
  self.Content:RemoveComponents(UICommonResItem)
  self:DataDestroy()
  base.OnDestroy(self)
end

function GreenRewardItem:ComponentDefine()
  self._bg = self:AddComponent(UIImage, "bg")
  self._num_txt = self:AddComponent(UIText, "Num")
  self._canRec_node = self:AddComponent(UIBaseContainer, "canRec")
  self._hasRecd_node = self:AddComponent(UIBaseContainer, "hasRecd")
  self._noRec_node = self:AddComponent(UIBaseContainer, "noRec")
  self._noRec_value_txt = self:AddComponent(UITextMeshProUGUIEx, "noRec/value")
  self.receive_btn_text = self:AddComponent(UIText, receive_btn_text_path)
  self.receive_btn_text:SetLocalText("airdrop_supply_desc3")
  self._box_red_dot = self:AddComponent(UIBaseContainer, "RedPoint")
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.receive_btn:SetOnClick(function()
    self:OnClickBox()
  end)
  self.received_txt = self:AddComponent(UITextMeshProUGUIEx, received_txt_path)
  self.received_txt:SetLocalText("airdrop_supply_desc2")
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self._reward_item = self:AddComponent(UIBaseContainer, Item_path)
  self.ItemObj = self._reward_item.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
end

function GreenRewardItem:DataDefine()
end

function GreenRewardItem:DataDestroy()
end

function GreenRewardItem:ReInit(index, param, curNum)
  self.param = param
  self.curNum = curNum
  if self.param == nil then
    return
  end
  local hasGet = self.param.state == 1
  local finish = curNum >= param.num
  self:RefreshItems()
  self._num_txt:SetText(param.num)
  self._hasRecd_node:SetActive(hasGet)
  self._canRec_node:SetActive(not hasGet)
  self._noRec_node:SetActive(not hasGet)
  local selfScore = self.curNum
  if hasGet then
    self._bg:SetColorRGBA(0.8980392, 0.9607843, 0.7529412, 1)
    self._box_red_dot:SetActive(false)
  else
    self._bg:SetColorRGBA(0.945098, 0.9294118, 0.9215686, 1)
    self._box_red_dot:SetActive(finish)
    self._canRec_node:SetActive(finish)
    if not finish then
      self._noRec_value_txt:SetText(string.format("%d/%d", selfScore, param.num))
      self._noRec_node:SetActive(true)
    else
      self._noRec_node:SetActive(false)
    end
  end
end

function GreenRewardItem:OnClickBox()
  if self.param then
    local selfScore = self.curNum
    if self.param.state == 0 and selfScore >= self.param.num then
      SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityProgressGetReward, self.param.index)
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

function GreenRewardItem:RefreshItems()
  local dataList = self.param and self.param.reward
  if not dataList then
    return
  end
  if not self.ItemList or #self.ItemList ~= #dataList then
    self.ItemList = {}
    self.ItemObj:GameObjectRecycleAll()
    self.Content:RemoveComponents(UICommonResItem)
    for i, v in ipairs(dataList) do
      local goItem = self.ItemObj:GameObjectSpawn(self.Content.transform)
      goItem.name = string.format("rewardItem_%d", i)
      goItem:SetActive(true)
      local theItem = self.Content:AddComponent(UICommonResItem, goItem.name)
      theItem._effect = theItem:AddComponent(UIVfx, "Effect", EffectAssets.ItemCanGetEffect, {
        lifeType = UIVfxLifeType.Stay
      })
      self.ItemList[i] = theItem
    end
  end
  local lock = self.param.state == 0 and self.curNum < self.param.num
  local hasGet = self.param.state == 1
  for i, v in ipairs(dataList) do
    local theItem = self.ItemList[i]
    local rewardData = DataCenter.RewardManager:ParseRewardInfo(v)
    rewardData.isShowReceFlag = hasGet
    theItem:ReInit(rewardData)
    CS.UIGray.SetGray(theItem.item_quality.transform, lock, false)
    CS.UIGray.SetGray(theItem.item_icon.transform, lock, false)
    if hasGet then
      theItem._effect:Stop()
    elseif self.curNum >= self.param.num then
      theItem._effect:Replay()
    else
      theItem._effect:Stop()
    end
  end
end

return GreenRewardItem
