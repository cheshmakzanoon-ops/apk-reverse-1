local base = UIBaseView
local UILWSeasonDonateFishView = BaseClass("UILWSeasonDonateFishView", base)
local UILWSeasonDonateFishItem = require("UI.LWSeason6.UILWSeasonDonateFish.Component.UILWSeasonDonateFishItem")
local Localization = CS.GameEntry.Localization
local go_LW_Simple_Slider_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/LW_Simple_Slider"
local txt_Slider_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/LW_Simple_Slider/txt_Slider"
local img_Slider_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/LW_Simple_Slider/img_Slider"
local sli_Slider_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/LW_Simple_Slider/Slider"
local txt_Count_path = "UICommonPopUpPanel_NoToggle/Content/bottm/count_panel/txt_Count"
local txt_Time_path = "UICommonPopUpPanel_NoToggle/Content/bottm/count_panel/txt_Time"
local sr_ScrollView_path = "UICommonPopUpPanel_NoToggle/Content/bottomRoot/ScrollView"
local btn_BtnBack_path = "UICommonPopUpPanel_NoToggle/Content/bottomRoot/BtnBack"
local txt_empty_path = "UICommonPopUpPanel_NoToggle/Content/bottomRoot/ScrollView/txt_empty"
local btn_quickDonation_path = "UICommonPopUpPanel_NoToggle/Content/bottm/btn_quickDonation"
local btn_Donation_path = "UICommonPopUpPanel_NoToggle/Content/bottm/btn_Donation"
local txt_reward_count1_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards/reward1/txt_reward_count1"
local txt_reward_count2_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards/reward2/txt_reward_count2"
local img_reward1_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards/reward1/img_reward1"
local img_reward2_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards/reward2/img_reward2"
local go_reward2_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards/reward2"
local go_reward1_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards/reward1"
local go_donate_rewards_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/donate_rewards"
local go_fly_point_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/p_btn_currency_1/fly_point"
local rImg_img_fishs_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/img_Bg/img_fishs"
local txt_p_text_currency_num_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/p_btn_currency_1/root/p_text_currency_num_1"
local img_p_text_currency_icon_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/p_btn_currency_1/root/p_text_currency_icon_1"
local btn_p_btn_currency_1_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/p_btn_currency_1"
local btn_InfoBtn_path = "UICommonPopUpPanel_NoToggle/Content/topRoot/InfoBtn"

function UILWSeasonDonateFishView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.canTip = true
  self.logicDonate = self:GetUserData()
  self.ctrl:SetLogic(self.logicDonate)
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetPlayerFishInfo)
  self:RefreshView()
end

function UILWSeasonDonateFishView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonDonateFishView:ComponentDefine()
  self.go_LW_Simple_Slider = self:AddComponent(UIBaseContainer, go_LW_Simple_Slider_path)
  self.txt_Slider = self:AddComponent(UIText, txt_Slider_path)
  self.img_Slider = self:AddComponent(UIImage, img_Slider_path)
  self.sli_Slider = self:AddComponent(UISlider, sli_Slider_path)
  self.txt_Count = self:AddComponent(UIText, txt_Count_path)
  self.txt_Time = self:AddComponent(UIText, txt_Time_path)
  self.sr_ScrollView = self:AddComponent(UIScrollView, sr_ScrollView_path)
  self.btn_BtnBack = self:AddComponent(UIButton, btn_BtnBack_path)
  self.txt_empty = self:AddComponent(UIText, txt_empty_path)
  self.btn_quickDonation = self:AddComponent(UIButton, btn_quickDonation_path)
  self.btn_Donation = self:AddComponent(UIButton, btn_Donation_path)
  self.txt_reward_count1 = self:AddComponent(UIText, txt_reward_count1_path)
  self.txt_reward_count2 = self:AddComponent(UIText, txt_reward_count2_path)
  self.img_reward1 = self:AddComponent(UIImage, img_reward1_path)
  self.img_reward2 = self:AddComponent(UIImage, img_reward2_path)
  self.go_reward2 = self:AddComponent(UIBaseContainer, go_reward2_path)
  self.go_reward1 = self:AddComponent(UIBaseContainer, go_reward1_path)
  self.go_donate_rewards = self:AddComponent(UIBaseContainer, go_donate_rewards_path)
  self.go_fly_point = self:AddComponent(UIBaseContainer, go_fly_point_path)
  self.rImg_img_fishs = self:AddComponent(UIRawImage, rImg_img_fishs_path)
  self.txt_p_text_currency_num = self:AddComponent(UIText, txt_p_text_currency_num_path)
  self.img_p_text_currency_icon = self:AddComponent(UIImage, img_p_text_currency_icon_path)
  self.btn_p_btn_currency_1 = self:AddComponent(UIButton, btn_p_btn_currency_1_path)
  self.btn_InfoBtn = self:AddComponent(UIButton, btn_InfoBtn_path)
  self.rewardViews = {
    [1] = {
      icon = self.img_reward1,
      go = self.go_reward1,
      txt = self.txt_reward_count1
    },
    [2] = {
      icon = self.img_reward2,
      go = self.go_reward2,
      txt = self.txt_reward_count2
    }
  }
  self.titleViews = {
    icon = self.img_p_text_currency_icon,
    txt = self.txt_p_text_currency_num
  }
  self.btn_p_btn_currency_1:SetOnClick(function()
    self:OnBtnCurrencyClick()
  end)
  self.btn_BtnBack:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_quickDonation:SetOnClick(BindCallback(self, self.ClickQuickDonate))
  self.btn_Donation:SetOnClick(BindCallback(self, self.ClickDonate))
  self.btn_InfoBtn:SetOnClick(BindCallback(self, self.ClickInfo))
  self.itemIndex = 0
  self.scrollCellPool = {}
  self.sr_ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.sr_ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.CurrencyId = DataCenter.SeasonMilitaryManager:GetMilitaryItemId()
end

function UILWSeasonDonateFishView:ComponentDestroy()
  self:ClearScroll()
  self.scrollCellPool = nil
  self.itemIndex = nil
  self.recoverReqPending = nil
  self.titleViews = nil
  self.rewardViews = nil
  self.go_LW_Simple_Slider = nil
  self.txt_Slider = nil
  self.img_Slider = nil
  self.sli_Slider = nil
  self.txt_Count = nil
  self.txt_Time = nil
  self.sr_ScrollView = nil
  self.btn_BtnBack = nil
  self.txt_empty = nil
  self.btn_quickDonation = nil
  self.btn_Donation = nil
  self.txt_reward_count1 = nil
  self.txt_reward_count2 = nil
  self.img_reward1 = nil
  self.img_reward2 = nil
  self.go_reward2 = nil
  self.go_reward1 = nil
  self.go_donate_rewards = nil
  self.go_fly_point = nil
  self.rImg_img_fishs = nil
  self.txt_p_text_currency_num = nil
  self.img_p_text_currency_icon = nil
  self.btn_p_btn_currency_1 = nil
  self.btn_InfoBtn = nil
end

function UILWSeasonDonateFishView:OnAddListener()
  self:AddUIListener(EventId.UpdateSelfCampScienceInfo, self.RefreshInfo)
  self:AddUIListener(EventId.UpdateCampScienceList, self.RefreshSlider)
  self:AddUIListener(EventId.CampScienceDonateSuccess, self.CampScienceDonateSuccessHandle)
  self:AddUIListener(EventId.RefreshMyFishList, self.RefreshView)
  self:AddUIListener(EventId.UpdateAllianceGovernmentCommonEnergyList, self.RefreshSlider)
  self:AddUIListener(EventId.AllianceEnergyDonateSuccess, self.AllianceEnergyDonateSuccessHandle)
end

function UILWSeasonDonateFishView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateSelfCampScienceInfo, self.RefreshInfo)
  self:RemoveUIListener(EventId.UpdateCampScienceList, self.RefreshSlider)
  self:RemoveUIListener(EventId.CampScienceDonateSuccess, self.CampScienceDonateSuccessHandle)
  self:RemoveUIListener(EventId.RefreshMyFishList, self.RefreshView)
  self:RemoveUIListener(EventId.UpdateAllianceGovernmentCommonEnergyList, self.RefreshSlider)
  self:RemoveUIListener(EventId.AllianceEnergyDonateSuccess, self.AllianceEnergyDonateSuccessHandle)
end

function UILWSeasonDonateFishView:OnBtnCurrencyClick()
  LWResourceLackUtil:GotoGoodsItemLack(self.CurrencyId, 1)
end

function UILWSeasonDonateFishView:ClickQuickDonate()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  local donateInfo = self.logicDonate:GetDonateInfo()
  if donateInfo == nil then
    return
  end
  local selectList = self.ctrl:GetSelectList()
  local alreadyCount = 0
  for _, count in pairs(selectList) do
    alreadyCount = alreadyCount + count
  end
  local quickCount = donateInfo.curCount - alreadyCount
  if quickCount <= 0 then
    return
  end
  local showDataCount = #self.showDataList
  local progressInfo = self.logicDonate:GetProgressInfo()
  local curExp = progressInfo.curValue
  local maxExp = progressInfo.maxValue
  if progressInfo.oo then
    maxExp = 99999999
  end
  local curAddValue = 0
  local curSelectList = self.ctrl:GetSelectList()
  for id, count in pairs(curSelectList) do
    local m = DataCenter.FishMetaManager:GetMeta(id)
    curAddValue = curAddValue + m.donation * count
  end
  for index = 1, showDataCount do
    local showData = self.showDataList[index]
    local meta = DataCenter.FishMetaManager:GetMeta(showData.id)
    local opCount = self.ctrl:GetSelectCount(showData.id)
    if maxExp <= curExp + curAddValue then
      break
    end
    local remainExp = maxExp - (curExp + curAddValue)
    local expLimitCount = math.ceil(remainExp / meta.donation)
    local canDonateCount = math.min(showData.num - opCount, quickCount, expLimitCount)
    if 0 < canDonateCount then
      quickCount = quickCount - canDonateCount
      selectList[showData.id] = opCount + canDonateCount
    end
    curAddValue = curAddValue + canDonateCount * meta.donation
    if quickCount <= 0 then
      break
    end
  end
  self.ctrl:SetSelectList(selectList)
  for _, v in pairs(self.scrollCellPool) do
    v:RefreshSelectCount()
  end
  self:RefreshSelectState()
end

function UILWSeasonDonateFishView:ClickDonate()
  DataCenter.LWSoundManager:PlaySound(6100020, false)
  local selectList = self.ctrl:GetSelectList()
  self.logicDonate:ToDonate(selectList)
  self.ctrl:SetSelectList({})
  self:RefreshSelectState()
end

function UILWSeasonDonateFishView:ClickInfo()
  local param = {}
  param.activityRulesStr = Localization:GetString("season_s6_government_skill_desc86")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWSeasonDonateFishView:CampScienceDonateSuccessHandle()
  DataCenter.LWSoundManager:PlaySound(6100018, false)
  local icon = self.logicDonate:GetProgressIcon()
  UIUtil.DoFly(RewardType.GOODS, 2, icon, self.sr_ScrollView.transform.position, self.txt_Slider.transform.position, nil, nil, function()
    DataCenter.LWSoundManager:PlaySound(1000105, false)
  end, nil, nil, nil, nil)
  local extraIcon = DataCenter.ItemTemplateManager:GetIconPath(self.CurrencyId)
  UIUtil.DoFly(RewardType.GOODS, 2, extraIcon, self.sr_ScrollView.transform.position, self.go_fly_point.transform.position, nil, nil, function()
    DataCenter.LWSoundManager:PlaySound(1000105, false)
  end, nil, nil, nil, nil)
  self:RefreshView()
end

function UILWSeasonDonateFishView:AllianceEnergyDonateSuccessHandle()
  DataCenter.LWSoundManager:PlaySound(6100018, false)
  local icon = self.logicDonate:GetProgressIcon()
  UIUtil.DoFly(RewardType.GOODS, 2, icon, self.sr_ScrollView.transform.position, self.txt_Slider.transform.position, nil, nil, function()
    DataCenter.LWSoundManager:PlaySound(1000105, false)
  end, nil, nil, nil, nil)
  local extraIcon = DataCenter.ItemTemplateManager:GetIconPath(self.CurrencyId)
  UIUtil.DoFly(RewardType.GOODS, 2, extraIcon, self.sr_ScrollView.transform.position, self.go_fly_point.transform.position, nil, nil, function()
    DataCenter.LWSoundManager:PlaySound(1000105, false)
  end, nil, nil, nil, nil)
  self:RefreshView()
end

function UILWSeasonDonateFishView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.sr_ScrollView:AddComponent(UILWSeasonDonateFishItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:ReInit(self.showDataList[index], self.logicDonate)
end

function UILWSeasonDonateFishView:OnItemMoveOut(itemObj, index)
end

function UILWSeasonDonateFishView:ClearScroll()
  self.scrollCellPool = {}
  self.sr_ScrollView:ClearCells()
  self.sr_ScrollView:RemoveComponents(UILWSeasonDonateFishItem)
end

function UILWSeasonDonateFishView:RefreshView()
  local showProgressIcon = self.logicDonate:GetProgressIcon()
  self.img_Slider:LoadSprite(showProgressIcon)
  self:ClearScroll()
  self:RefreshSV()
  self:RefreshInfo()
  self:RefreshSlider()
  self:RefreshSelectState()
  self:UpdateCurrency()
end

function UILWSeasonDonateFishView:UpdateCurrency()
  if self.titleViews then
    local currencyNum = DataCenter.ItemData:GetItemCount(self.CurrencyId)
    self.titleViews.txt:SetText(string.GetFormattedSeperatorNum(currencyNum))
  end
end

function UILWSeasonDonateFishView:RefreshSV()
  local tempDataList = self.logicDonate:GetShowDonateList()
  self.showDataList = {}
  for i, v in ipairs(tempDataList) do
    local meta = DataCenter.FishMetaManager:GetMeta(v.id)
    if meta.donation > 0 then
      table.insert(self.showDataList, v)
    end
  end
  table.sort(self.showDataList, function(a, b)
    local aFish = DataCenter.FishMetaManager:GetMeta(a.id)
    local bFish = DataCenter.FishMetaManager:GetMeta(b.id)
    return aFish.donation > bFish.donation
  end)
  local hasCount = #self.showDataList == 0
  self.txt_empty:SetActive(hasCount)
  self.sr_ScrollView:SetTotalCount(#self.showDataList)
  self.sr_ScrollView:RefillCells()
end

function UILWSeasonDonateFishView:RefreshSlider()
  local sliderInfo = self.logicDonate:GetProgressInfo()
  local oo = sliderInfo.oo
  if oo then
    self.sli_Slider:SetValue(1)
    self.txt_Slider:SetLocalText("season_camp_science_ui_25")
  elseif sliderInfo.max and not sliderInfo.donShowTip then
    self.sli_Slider:SetValue(1)
    self.txt_Slider:SetLocalText("150072")
  else
    self.sli_Slider:SetValue(sliderInfo.curValue / sliderInfo.maxValue)
    self.txt_Slider:SetText(string.GetFormattedStr(sliderInfo.curValue) .. "/" .. string.GetFormattedStr(sliderInfo.maxValue))
  end
  self.recoverReqPending = nil
end

function UILWSeasonDonateFishView:RefreshInfo()
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.CurrencyId)
  self.titleViews.icon:LoadSprite(iconPath)
  local donateInfo = self.logicDonate:GetDonateInfo()
  if donateInfo ~= nil then
    self.txt_Count:SetLocalText("season_s6_government_skill_desc04", donateInfo.curCount .. "/" .. donateInfo.maxCount)
    self:RefreshTime()
  end
end

function UILWSeasonDonateFishView:RefreshSelectState()
  local selectList = self.ctrl:GetSelectList()
  local canDonation = table.count(selectList) > 0
  self.rImg_img_fishs:SetActive(canDonation)
  CS.UIGray.SetGray(self.btn_Donation.transform, not canDonation, canDonation)
  local icon = self.logicDonate:GetProgressIcon()
  self.rewardViews[1].icon:LoadSprite(icon)
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.CurrencyId)
  self.rewardViews[2].icon:LoadSprite(iconPath)
  local progressCount = 0
  local extraCount, addExtraCount = self.logicDonate:GetExtraCount(selectList)
  extraCount = extraCount or 0
  addExtraCount = addExtraCount or 0
  for id, count in pairs(selectList) do
    local meta = DataCenter.FishMetaManager:GetMeta(id)
    progressCount = progressCount + meta.donation * count
  end
  self.rewardViews[1].txt:SetText(string.GetFormattedStr(progressCount))
  if 0 < addExtraCount then
    self.rewardViews[2].txt:SetText(string.GetFormattedStr(extraCount) .. "<color=#3EE66D>+" .. string.GetFormattedStr(addExtraCount) .. "</color>")
  else
    self.rewardViews[2].txt:SetText(string.GetFormattedStr(extraCount))
  end
  if self.go_donate_rewards:GetActiveInHierarchy() == false and canDonation then
    DataCenter.LWSoundManager:PlaySound(6100017, false)
  end
  self.go_donate_rewards:SetActive(canDonation)
end

function UILWSeasonDonateFishView:RefreshTime()
  local donateInfo = self.logicDonate:GetDonateInfo()
  if donateInfo ~= nil then
    local recoverIng = donateInfo.curCount ~= donateInfo.maxCount
    self.txt_Time:SetActive(recoverIng)
    if recoverIng then
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      local needTime = donateInfo.nextRecoverTime + 1 - serverTime
      local hasTime = 0 < needTime
      self.txt_Time:SetActive(hasTime)
      if hasTime then
        self.txt_Time:SetLocalText("season_s6_government_skill_desc05", UITimeManager:GetInstance():MilliSecondToFmtString(needTime))
      elseif not self.recoverReqPending then
        self.logicDonate:RecoverTimeFinish()
        self.recoverReqPending = true
      end
    end
  end
end

function UILWSeasonDonateFishView:Update100MS()
  self:RefreshTime()
end

function UILWSeasonDonateFishView:AddSelectCount(id, count)
  self.ctrl:AddSelectCount(id, count)
  self:RefreshSelectState()
end

return UILWSeasonDonateFishView
