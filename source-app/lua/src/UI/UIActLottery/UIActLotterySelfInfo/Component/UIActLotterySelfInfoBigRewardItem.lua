local base = UIBaseContainer
local UIActLotterySelfInfoBigRewardItem = BaseClass("UIActLotterySelfInfoBigRewardItem", UIBaseContainer)
local UIActLotterySelfInfoFirstNoItem = require("UI.UIActLottery.UIActLotterySelfInfo.Component.UIActLotterySelfInfoFirstNoItem")
local Localization = CS.GameEntry.Localization
local special_content_path = "SpecialContent"
local special_name_path = "SpecialContent/specialName"
local special_time_path = "SpecialContent/specialTime"
local special_no_val_path = "SpecialContent/specialNoVal"
local reward1_content_path = "Reward1Content"
local reward1_name_path = "Reward1Content/infoContent/reward1Name"
local reward1_time_path = "Reward1Content/infoContent/reward1Time"
local reward1_tip_path = "Reward1Content/infoContent/reward1Tip"
local reward1_open_btn_path = "Reward1Content/infoContent/reward1OpenBtn"
local no_val_item_path = "Reward1Content/NoValItem"
local no_val_content_path = "Reward1Content/NoValContent"
local reward2_content_path = "Reward2Content"
local reward2_name_path = "Reward2Content/reward2Name"
local reward2_time_path = "Reward2Content/reward2Time"
local reward3_content_path = "Reward3Content"
local reward3_name_path = "Reward3Content/reward3Name"
local reward3_time_path = "Reward3Content/reward3Time"
local line_path = "Line"
local reward1_open_btn_img_path = "Reward1Content/infoContent/reward1OpenBtn/reward1OpenBtnImg"

function UIActLotterySelfInfoBigRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActLotterySelfInfoBigRewardItem:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActLotterySelfInfoBigRewardItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "")
  self.special_content = self:AddComponent(UIImage, special_content_path)
  self.special_name = self:AddComponent(UITextMeshProUGUIEx, special_name_path)
  self.special_time = self:AddComponent(UITextMeshProUGUIEx, special_time_path)
  self.special_no_val = self:AddComponent(UITextMeshProUGUIEx, special_no_val_path)
  self.reward1_content = self:AddComponent(UIImage, reward1_content_path)
  self.reward1_name = self:AddComponent(UITextMeshProUGUIEx, reward1_name_path)
  self.reward1_time = self:AddComponent(UITextMeshProUGUIEx, reward1_time_path)
  self.reward1_tip = self:AddComponent(UITextMeshProUGUIEx, reward1_tip_path)
  self.reward1_open_btn = self:AddComponent(UIButton, reward1_open_btn_path)
  self.no_val_item = self:AddComponent(UIImage, no_val_item_path)
  self.no_val_content = self:AddComponent(UIBaseContainer, no_val_content_path)
  self.reward2_content = self:AddComponent(UIImage, reward2_content_path)
  self.reward2_name = self:AddComponent(UITextMeshProUGUIEx, reward2_name_path)
  self.reward2_time = self:AddComponent(UITextMeshProUGUIEx, reward2_time_path)
  self.reward3_content = self:AddComponent(UIImage, reward3_content_path)
  self.reward3_name = self:AddComponent(UITextMeshProUGUIEx, reward3_name_path)
  self.reward3_time = self:AddComponent(UITextMeshProUGUIEx, reward3_time_path)
  self.line = self:AddComponent(UIImage, line_path)
  self.reward1_open_btn_img = self:AddComponent(UIImage, reward1_open_btn_img_path)
  self.no_val_item:SetActive(false)
  self.no_val_item.gameObject:GameObjectCreatePool()
  self.no_val_item_list = {}
  self.reward1_open_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UIActLotterySelfInfoBigRewardItem:ComponentDestroy()
  self.special_content = nil
  self.special_name = nil
  self.special_time = nil
  self.special_no_val = nil
  self.reward1_content = nil
  self.reward1_name = nil
  self.reward1_time = nil
  self.reward1_tip = nil
  self.reward1_open_btn = nil
  self.no_val_item = nil
  self.no_val_content = nil
  self.reward2_content = nil
  self.reward2_name = nil
  self.reward2_time = nil
  self.reward3_content = nil
  self.reward3_name = nil
  self.reward3_time = nil
  self.line = nil
  self.reward1_open_btn_img = nil
end

function UIActLotterySelfInfoBigRewardItem:DataDefine()
end

function UIActLotterySelfInfoBigRewardItem:DataDestroy()
end

function UIActLotterySelfInfoBigRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActLotterySelfInfoBigRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActLotterySelfInfoBigRewardItem:SetData(activityId, data, totalNum, scroll_view, index)
  self.activityId = activityId
  self.data = data
  self.totalNum = totalNum
  self.scroll_view = scroll_view
  self.index = index
  self.itemDayNum = self.data.day
  self.curDayNumReal, self.nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
  self:RefreshView()
  self:Update1000MS()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

function UIActLotterySelfInfoBigRewardItem:RefreshView()
  self.line:SetActive(self.index < self.totalNum - 1)
  local firstTickerArr = self.data.firstTickerArr
  local winningNum = 0
  local secondNum = self.data.secondNum
  local commonNum = self.data.commonNum
  if firstTickerArr and 0 < #firstTickerArr then
    for i, v in ipairs(firstTickerArr) do
      if 0 < v.winning then
        winningNum = v.tickerNumber
      end
    end
  end
  if 0 < winningNum then
    self.special_name:SetText(DataCenter.ActLotteryDataManager:GetLotteryRankName(1, true))
    self.special_content:SetActive(true)
    self.special_no_val:SetText(winningNum)
  else
    self.special_content:SetActive(false)
  end
  if firstTickerArr and 0 < #firstTickerArr then
    self.reward1_content:SetActive(true)
    self.reward1_name:SetText(DataCenter.ActLotteryDataManager:GetLotteryRankName(1))
    local isOpenFirstContent = self.data.isOpenFirst == nil or self.data.isOpenFirst == true
    self.no_val_content:SetActive(isOpenFirstContent)
    local imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
    if not isOpenFirstContent then
      imgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png"
    end
    self.reward1_open_btn_img:LoadSprite(imgPath)
    for i, v in ipairs(firstTickerArr) do
      if self.no_val_item_list[i] == nil then
        local showIndex = "Item" .. i
        local item = self.no_val_item.gameObject:GameObjectSpawn(self.no_val_content.transform)
        item.name = showIndex
        local obj = self.no_val_content:AddComponent(UIActLotterySelfInfoFirstNoItem, item.name)
        self.no_val_item_list[i] = obj
      end
      self.no_val_item_list[i]:SetActive(true)
      self.no_val_item_list[i]:SetData(v)
    end
    for i = #firstTickerArr + 1, #self.no_val_item_list do
      self.no_val_item_list[i]:SetActive(false)
    end
  else
    self.reward1_content:SetActive(false)
  end
  if secondNum and 0 < secondNum then
    self.reward2_content:SetActive(true)
    self.reward2_name:SetText(DataCenter.ActLotteryDataManager:GetLotteryRankName(2) .. "x" .. secondNum)
  else
    self.reward2_content:SetActive(false)
  end
  if commonNum and 0 < commonNum then
    self.reward3_content:SetActive(true)
    self.reward3_name:SetText(DataCenter.ActLotteryDataManager:GetLotteryRankName(3) .. "x" .. commonNum)
  else
    self.reward3_content:SetActive(false)
  end
  if self.itemDayNum <= self.curDayNumReal then
    self.reward1_tip:SetLocalText("thxgiv_Lottery_text_2")
  end
  local curItemOpenTimeStr = DataCenter.ActLotteryDataManager:GetLotteryOpenTimeByDayNum(self.activityId, self.itemDayNum)
  self.special_time:SetText(curItemOpenTimeStr)
  self.reward1_time:SetText(curItemOpenTimeStr)
  self.reward2_time:SetText(curItemOpenTimeStr)
  self.reward3_time:SetText(curItemOpenTimeStr)
end

function UIActLotterySelfInfoBigRewardItem:ClearAllItem()
  self.no_val_content:RemoveComponents(UIActLotterySelfInfoFirstNoItem)
  for _, v in ipairs(self.no_val_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.no_val_item.gameObject:GameObjectRecycleAll()
  self.no_val_item_list = {}
end

function UIActLotterySelfInfoBigRewardItem:OnBtnClick()
  if self.data.isOpenFirst == nil or self.data.isOpenFirst == true then
    self.data.isOpenFirst = false
  else
    self.data.isOpenFirst = true
  end
  self:RefreshView()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
  self.scroll_view:OnItemSizeChanged(self.index)
end

function UIActLotterySelfInfoBigRewardItem:Update1000MS()
  if self.itemDayNum and self.curDayNumReal and self.itemDayNum > self.curDayNumReal then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.nextOpenTimeReal - curTime
    if leftTime < 0 then
      self.curDayNumReal, self.nextOpenTimeReal = DataCenter.ActLotteryDataManager:GetRealBigRewardTimeData(self.activityId)
      self.reward1_tip:SetLocalText("thxgiv_Lottery_text_2")
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root.transform)
      self.scroll_view:OnItemSizeChanged(self.index)
    else
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.reward1_tip:SetLocalText("thxgiv_Lottery_text_1", countDownTimeStr)
    end
  end
end

return UIActLotterySelfInfoBigRewardItem
