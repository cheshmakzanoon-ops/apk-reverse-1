local LWUIRefundApplicationItem = BaseClass("LWUIRefundApplicationItem", UIBaseContainer)
local base = UIBaseContainer
local M = LWUIRefundApplicationItem
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local sub_title_txt_path = "System/DSubTitle"
local message_txt_path = "System/DMessage"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local reward_content_path = "System/DScroll/DViewport/DContent/DReward"
local reward_item_path = "System/DScroll/DViewport/DContent/MailRewardItem"
local reward_hero_item_path = "System/DScroll/DViewport/DContent/HeroRewardItem"
local item_bg_path = "System/itemBg"
local d_scroll_path = "System/DScroll"
local check_btn_path = "System/CheckBtn"
local check_btn_select_path = "System/CheckBtn/CheckBtnSelect"
local itemWidth = 800
local itemHeight = 710
local itemHeightNoReward = 410
local CheckBtnState = {Select = 0, UnSelect = 1}
local CannotRefundSeasonMap = {
  [CannotRefundReason.HAS_REFUNDED] = "refund_interface_pack_refunded",
  [CannotRefundReason.Reach_LIMIT] = "refund_interface_pack_maxed",
  [CannotRefundReason.REFUNDING] = "refund_interface_pack_handling",
  [CannotRefundReason.REWARD_NOT_ENOUGH] = "refund_interface_pack_Insufficiency",
  [CannotRefundReason.BUILDING] = "refund_desc_building",
  [CannotRefundReason.CARD_USE] = "refund_desc_privilege"
}
local CannotRefundSeasonMap_GoldBlock = {
  [CannotRefundReason.HAS_REFUNDED] = "refund_desc_goldbrick_status",
  [CannotRefundReason.Reach_LIMIT] = "refund_interface_pack_maxed",
  [CannotRefundReason.REFUNDING] = "refund_interface_pack_handling",
  [CannotRefundReason.REWARD_NOT_ENOUGH] = "refund_interface_pack_Insufficiency",
  [CannotRefundReason.BUILDING] = "refund_desc_building",
  [CannotRefundReason.CARD_USE] = "refund_desc_privilege"
}

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.rewarditem = self.transform:Find(reward_item_path).gameObject
  self.rewarditem:GameObjectCreatePool()
  self.rewardheroitem = self.transform:Find(reward_hero_item_path).gameObject
  self.rewardheroitem:GameObjectCreatePool()
  self.item_bg = self:AddComponent(UIImage, item_bg_path)
  self.d_scroll = self:AddComponent(UIScrollRect, d_scroll_path)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.checkBtn = self:AddComponent(UIButton, check_btn_path)
  self.checkBtn:SetOnClick(function()
    self:OnClickCheckBtn()
  end)
  self.checkBtnSelect = self:AddComponent(UIBaseContainer, check_btn_select_path)
end

function M:ComponentDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(HeroRewardItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
  self.item_bg = nil
  self.d_scroll = nil
  self.root = nil
  self.checkBtn = nil
  self.checkBtnSelect = nil
end

function M:DataDefine()
  self.selectBtnState = CheckBtnState.UnSelect
end

function M:DataDestroy()
  self.selectBtnState = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWRefundRecPayListClickOrder, self.OnRecCLickOrder)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.LWRefundRecPayListClickOrder, self.OnRecCLickOrder)
  base.OnRemoveListener(self)
end

function M:ReInit(payData, ctrl)
  self.ctrl = ctrl
  self.payData = payData
  self:SetContent()
  self:SetReward()
end

function M:SetContent()
  self.subTitleTxt:SetText(self:GetProductName())
  if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
    self.messageTxt:SetLocalText("refund_desc_goldbrick")
  else
    self.messageTxt:SetLocalText("refund_interface_pack_description")
  end
  local _strTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.payData.time)
  self.timeTxt:SetText(_strTime)
  if self.payData.cannotReasonType == CannotRefundReason.NONE then
    self.subTitleTxt:SetColorRGBA(0.1843137254901961, 0.1803921568627451, 0.18823529411764706, 1.0)
    self.messageTxt:SetColorRGBA(0.1843137254901961, 0.1803921568627451, 0.18823529411764706, 1.0)
    self.checkBtn:SetActive(true)
  else
    self.subTitleTxt:SetColorRGBA(0.6431372549019608, 0.6196078431372549, 0.6078431372549019, 1.0)
    self.messageTxt:SetColorRGBA(0.6431372549019608, 0.6196078431372549, 0.6078431372549019, 1.0)
    self.checkBtn:SetActive(false)
  end
  self:InitCurState()
  self.checkBtnSelect:SetActive(self.selectBtnState == CheckBtnState.Select)
end

function M:SetReward()
  self.rewardContent:SetActive(true)
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardContent:RemoveComponents(HeroRewardItem)
  self.rewarditem.gameObject:GameObjectRecycleAll()
  self.rewardheroitem.gameObject:GameObjectRecycleAll()
  local reward = self.payData.rewards
  local rewardNum = table.count(reward)
  if rewardNum <= 0 then
    self.item_bg:SetActive(false)
    self.d_scroll:SetActive(false)
    self.root:SetSizeDeltaXY(itemWidth, itemHeightNoReward)
  else
    self.item_bg:SetActive(true)
    self.d_scroll:SetActive(true)
    self.root:SetSizeDeltaXY(itemWidth, itemHeight)
  end
  self:ShowReward(reward)
end

function M:GatherReward(itemsList)
  local resultMap = {}
  for _, item in pairs(itemsList) do
    if item.type then
      local type = item.type
      local id = item.id or 0
      local key = id .. "_" .. type
      if resultMap[key] then
        resultMap[key].num = resultMap[key].num + item.num
      else
        resultMap[key] = {
          id = id,
          type = type,
          num = item.num
        }
      end
    end
  end
  local resultList = {}
  for _, item in pairs(resultMap) do
    table.insert(resultList, item)
  end
  return resultList
end

function M:ShowReward(rewards)
  local gatherRewardList = self:GatherReward(rewards)
  if gatherRewardList ~= nil and table.count(gatherRewardList) > 0 then
    for _, iteminfo in pairs(gatherRewardList) do
      local itemId = iteminfo.id
      local itemCnt = iteminfo.num
      local type = iteminfo.type
      local param = {
        rewardType = type,
        itemId = itemId,
        count = itemCnt
      }
      self:ShowRewardItem(param)
    end
  end
end

function M:ShowRewardItem(rewardData)
  NameCount = NameCount + 1
  if rewardData.rewardType == RewardType.HERO then
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewardheroitem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(HeroRewardItem, item.name)
    local param = {}
    param.heroId = rewardData.itemId
    param.count = rewardData.count
    local heroName = GetTableData(TableName.LW_Hero, rewardData.itemId, "first_name")
    local heroQuality = GetTableData(TableName.LW_Hero, rewardData.itemId, "quality")
    param.name = string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(heroQuality), Localization:GetString(heroName))
    obj:RefreshData(param)
  else
    local objName = rewardData.rewardType .. NameCount
    local item = self.rewarditem:GameObjectSpawn(self.rewardContent.transform)
    item.name = objName
    local obj = self.rewardContent:AddComponent(UICommonResItem, item.name)
    obj:ReInit(rewardData)
    local isGray = self.payData.cannotReasonType == CannotRefundReason.REWARD_NOT_ENOUGH and not self.payData.rewardEnough
    CS.UIGray.SetGray(item.transform, isGray, true)
  end
end

function M:InitCurState()
  local ifSelect = self.ctrl:IsSelect(self.payData.orderId)
  if ifSelect then
    self.selectBtnState = CheckBtnState.Select
  else
    self.selectBtnState = CheckBtnState.UnSelect
  end
end

function M:OnClickCheckBtn()
  if not self.payData then
    Logger.LogError("payData is nil")
    return
  end
  if self.selectBtnState == CheckBtnState.Select then
    self.selectBtnState = CheckBtnState.UnSelect
    self.ctrl:DeSelectOrder()
  else
    self.selectBtnState = CheckBtnState.Select
    self.ctrl:SetSelectOrder(self.payData.orderId)
  end
  EventManager:GetInstance():Broadcast(EventId.LWRefundRecPayListClickOrder)
  self.checkBtnSelect:SetActive(self.selectBtnState == CheckBtnState.Select)
end

function M:GetProductName()
  local reason = self.payData.cannotReasonType
  local exchangeName = Localization:GetString(self.payData.exchangeName)
  if reason == CannotRefundReason.NONE then
    return exchangeName
  end
  local str = CannotRefundSeasonMap[reason]
  if DataCenter.LWRefundManager.CurRefundListPfType == RefundListPfType.GoldBlock then
    str = CannotRefundSeasonMap_GoldBlock[reason]
  else
    str = CannotRefundSeasonMap[reason]
  end
  if str == nil then
    Logger.LogError(" GetProductName str is nil,reason ==" .. reason)
    return ""
  end
  return Localization:GetString(str, exchangeName)
end

function M:OnRecCLickOrder()
  self:InitCurState()
  self.checkBtnSelect:SetActive(self.selectBtnState == CheckBtnState.Select)
end

return LWUIRefundApplicationItem
