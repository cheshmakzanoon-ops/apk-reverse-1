local UILWMonthCardContent = BaseClass("UILWMonthCardContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local UIGray = CS.UIGray
local Param = DataClass("Param", ParamData)
local ParamData = {
  monthCardInfo
}
local title_path = "bookBg/TitleText"
local desc_path = "bookBg/DescText"
local desc_txt_path = "bookBg/descContent/DescText%s"
local buyTip_path = "bookBg/buyTip"
local buyBtn_path = "bookBg/BtnContent/BuyButton"
local buyBtnTxt_path = "bookBg/BtnContent/BuyButton/PriceText"
local originPriceText_path = "bookBg/BtnContent/BuyButton/originPriceText"
local jumpBtn_path = "bookBg/BtnContent/gotoCampBtn"
local jumpBtnTxt_path = "bookBg/BtnContent/gotoCampBtn/gotoTxt"
local claimBtn_path = "bookBg/BtnContent/claimBtn"
local claimBtnTxt_path = "bookBg/BtnContent/claimBtn/claimBtnTxt"
local remainTime_path = "bookBg/leftTime"
local isEffectImg_path = "bookBg/inEffect"
local inEffectTxt_path = "bookBg/inEffect/inEffectDesc"
local inEffectEff_path = "bookBg/inEffect/VFX_ui_zhang_inEffect"
local caidaiEff_path = "VFX_uimonthcardpanel_caidai"
local rewardTb_path = "bookBg/Scroll View/Viewport/Content/reward"
local daily_rewardTb_path = "bookBg/DailyScrollView/Viewport/Content/dailyReward"
local remainDays1_path = "bookBg/remainDayContent/remainDays1"
local remainDays2_path = "bookBg/remainDayContent/remainDays2"
local remainDaysTxt_path = "bookBg/remainDayContent/remainTxt"
local discountDesc1_path = "bookBg/discountDesc_1"
local discountDesc2_path = "bookBg/discountDesc_2"
local point_path = "bookBg/BtnContent/BuyButton/UIGiftPackagePoint"
local getNowTxt_path = "bookBg/getNowTxt"
local getNowValueTxt_path = "bookBg/getNowValueTxt"
local valueNumTxt_path = "bookBg/valueContent/valueNumTxt"
local valueTxt_path = "bookBg/valueContent/valueTxt"
local getDailyTxt_path = "bookBg/getDailyTxt"
local remainDayTxt1_path = "bookBg/BtnContent/gotoCampBtn/RemainText1"
local remainDayTxt2_path = "bookBg/BtnContent/claimBtn/RemainText2"
local buyBtn_effect_path = "bookBg/BtnContent/BuyButton/Effect"
local extend_month_card_tips_text_path = "bookBg/BtnContent/BuyButton/ExtendMonthCardTipsText"
local btn_truck_insurance_path = "bookBg/BtnTruckInsurance"
local truck_insurance_ren_point_path = "bookBg/BtnTruckInsurance/TruckInsuranceRenPoint"
local btn_truck_insurance_desc_path = "bookBg/BtnTruckInsurance/BtnTruckInsuranceDesc"
local full_reward_tips_path = "bookBg/BtnTruckInsurance/FullRewardTips"
local full_reward_desc_path = "bookBg/BtnTruckInsurance/FullRewardTips/FullRewardDesc"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonthCardInfoUpdated, self.RefreshUI)
  self:AddUIListener(EventId.OnPassDay, self.RefreshUI)
  self:AddUIListener(EventId.GetTruckInsuranceReward, self.RefreshTruckInsuranceBtn)
  self:AddUIListener(EventId.RefreshTruckInsuranceRefundPage, self.RefreshTruckInsuranceBtn)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.RefreshUI)
  self:RemoveUIListener(EventId.OnPassDay, self.RefreshUI)
  self:RemoveUIListener(EventId.GetTruckInsuranceReward, self.RefreshTruckInsuranceBtn)
  self:RemoveUIListener(EventId.RefreshTruckInsuranceRefundPage, self.RefreshTruckInsuranceBtn)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.descN = self:AddComponent(UIText, desc_path)
  self.descTxtTb = {}
  for i = 1, 5 do
    self.descTxtTb[i] = self:AddComponent(UIText, string.format(desc_txt_path, i))
  end
  self.rewardsTb = {}
  for i = 1, 10 do
    local newReward = self:AddComponent(UICommonResItem, rewardTb_path .. i)
    table.insert(self.rewardsTb, newReward)
  end
  self.dailyRewardsTb = {}
  for i = 1, 10 do
    local newReward = self:AddComponent(UICommonResItem, daily_rewardTb_path .. i)
    table.insert(self.dailyRewardsTb, newReward)
  end
  self.buyTipN = self:AddComponent(UIText, buyTip_path)
  self.buyBtnN = self:AddComponent(LWBtnBuyRefundRemind, buyBtn_path)
  self.buyBtnN:SetBuyClickAction(function()
    self:OnClickBuyBtn()
  end)
  self.buyBtnN:SetSafeClickMode(true)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.jumpBtnTxtN = self:AddComponent(UIText, jumpBtnTxt_path)
  self.jumpBtnTxtN:SetLocalText(320253)
  self.claimBtnN = self:AddComponent(UIButton, claimBtn_path)
  self.claimBtnN:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.claimBtnTxtN = self:AddComponent(UIText, claimBtnTxt_path)
  self.claimBtnTxtN:SetLocalText(2000157)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.inEffectIconN = self:AddComponent(UIBaseContainer, isEffectImg_path)
  self.animInEffectN = self:AddComponent(UIAnimator, isEffectImg_path)
  self.inEffectTxtN = self:AddComponent(UIText, inEffectTxt_path)
  self.inEffectTxtN:SetLocalText(320534)
  self.inEffectEffN = self:AddComponent(UIBaseContainer, inEffectEff_path)
  self.inEffectEffN:SetActive(false)
  self.caidaiEffN = self:AddComponent(UIBaseContainer, caidaiEff_path)
  self.caidaiEffN:SetActive(false)
  self.remainDaysN1 = self:AddComponent(UIText, remainDays1_path)
  self.remainDaysN2 = self:AddComponent(UIText, remainDays2_path)
  self.remainDaysTxtN = self:AddComponent(UIText, remainDaysTxt_path)
  self.discountDesc1N = self:AddComponent(UIText, discountDesc1_path)
  self.discountDesc1N:SetLocalText(320532)
  self.discountDesc2N = self:AddComponent(UIText, discountDesc2_path)
  self.discountDesc2N:SetLocalText(320533)
  self.getNowTxt = self:AddComponent(UIText, getNowTxt_path)
  self.getNowTxt:SetLocalText(2000153)
  self.getNowValueTxt = self:AddComponent(UIText, getNowValueTxt_path)
  self.valueNumTxt = self:AddComponent(UIText, valueNumTxt_path)
  self.valueTxt = self:AddComponent(UIText, valueTxt_path)
  self.valueTxt:SetLocalText(2000155)
  self.getDailyTxt = self:AddComponent(UIText, getDailyTxt_path)
  self.getDailyTxt:SetLocalText(2000154)
  self.remainDayBottomTxt1 = self:AddComponent(UIText, remainDayTxt1_path)
  self.remainDayBottomTxt2 = self:AddComponent(UIText, remainDayTxt2_path)
  self.buyBtnEffect = self:AddComponent(UIBaseContainer, buyBtn_effect_path)
  self.extend_month_card_tips_text = self:AddComponent(UIText, extend_month_card_tips_text_path)
  self.btn_truck_insurance = self:AddComponent(UIButton, btn_truck_insurance_path)
  self.btn_truck_insurance:SetOnClick(function()
    self:OnClickTruckInsurance()
  end)
  self.truck_insurance_ren_point = self:AddComponent(UIBaseContainer, truck_insurance_ren_point_path)
  self.btn_truck_insurance_desc = self:AddComponent(UITextMeshProUGUIEx, btn_truck_insurance_desc_path)
  self.full_reward_tips = self:AddComponent(UIBaseContainer, full_reward_tips_path)
  self.full_reward_desc = self:AddComponent(UITextMeshProUGUIEx, full_reward_desc_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.descN = nil
  self.descTxtTb = nil
  self.buyTipN = nil
  self.buyBtnN = nil
  self.jumpBtnN = nil
  self.jumpBtnTxtN = nil
  self.claimBtnN = nil
  self.claimBtnTxtN = nil
  self.remainTimeN = nil
  self.remainDaysN1 = nil
  self.remainDaysN2 = nil
  self.extend_month_card_tips_text = nil
  self.btn_truck_insurance = nil
  self.truck_insurance_ren_point = nil
  self.btn_truck_insurance_desc = nil
  self.full_reward_tips = nil
  self.full_reward_desc = nil
end

local function DataDefine(self)
  self.param = nil
  self.view = nil
  self.isBought = false
  
  function self.TimerAction()
    self:RefreshRemainTime()
  end
  
  self.benefitsList = nil
end

local function DataDestroy(self)
  self.param = nil
  self.view = nil
  self.isBought = nil
  self.TimerAction = nil
  self.benefitsList = nil
end

local function ReInit(self, param, view)
  self.param = param
  self.view = view
  self.isBought = self.param.monthCardInfo:IsBought()
  if not self.benefitsList then
    local monthCardConf = LocalController:instance():getLine("monthcard", self.param.monthCardInfo:GetId())
    if monthCardConf then
      self.benefitsList = {}
      local names = string.split(monthCardConf.right_name, "|")
      local descs = string.split(monthCardConf.right_des, "|")
      for i = 1, 5 do
        self.benefitsList[i] = {}
        self.benefitsList[i].name = names[i]
        self.benefitsList[i].desc = descs[i]
      end
      self.rewardsList = {}
      local strRewards = monthCardConf.reward_show_now or ""
      self.rewardsList = DataCenter.RewardManager:ParseRewardsStr(strRewards)
      local extraReward = self:GetExtraReward()
      table.insert(self.rewardsList, extraReward)
      self.dailyRewardsList = {}
      strRewards = monthCardConf.reward_show_daily or ""
      self.dailyRewardsList = DataCenter.RewardManager:ParseRewardsStr(strRewards)
    end
  end
  self:RefreshUI()
  self:RefreshRewards()
end

function UILWMonthCardContent:GetExtraReward()
  local monthCardCfg = self.param.monthCardInfo:GetMonthCardCfg()
  local giftId = tonumber(monthCardCfg.alliance_gift)
  local param1_icon = GetTableData(TableName.AllianceGiftGroup, giftId, "icon")
  local param2_name = GetTableData(TableName.AllianceGiftGroup, giftId, "name")
  local param3_title = GetTableData(TableName.AllianceGiftGroup, giftId, "title")
  local param4_num = 1
  local param5_color = GetTableData(TableName.AllianceGiftGroup, giftId, "color")
  local rewardData = {}
  rewardData.iconName = string.format(LoadPath.UIAllianceGift, param1_icon)
  rewardData.itemName = Localization:GetString(param2_name)
  rewardData.itemDesc = Localization:GetString(param3_title)
  rewardData.isLocal = true
  rewardData.count = param4_num
  rewardData.itemColor = param5_color
  rewardData.rewardType = RewardType.ALLIANCE_GIFT
  rewardData.itemId = param1_icon
  return rewardData
end

local function RefreshUI(self)
  self.titleN:SetLocalText(2000148)
  local targetLv = 1
  local buildId = BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  if buildData and targetLv < buildData.level then
    targetLv = buildData.level
  end
  local buildDescTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId, targetLv)
  local descArray = {}
  if not string.IsNullOrEmpty(buildDescTemp.para4) then
    descArray = string.split_ss_array(buildDescTemp.para4, ";")
  end
  self.descN:SetText(Localization:GetString(200009) .. " " .. Localization:GetString(300665, targetLv))
  local descList = {
    2000666,
    2000661,
    2000662
  }
  local isOpenTruckInsurance = DataCenter.MonthCardNewManager:IsOpenTruckInsurance()
  if isOpenTruckInsurance then
    table.insert(descList, "month_card_desc_25")
  end
  local showCount = #descList
  for i = 1, #self.descTxtTb do
    if i <= showCount then
      self.descTxtTb[i]:SetActive(true)
      self.descTxtTb[i]:SetLocalText(descList[i])
    else
      self.descTxtTb[i]:SetActive(false)
    end
  end
  self.buyTipN:SetLocalText(320252)
  self.buyBtnN:Init(self.param.monthCardInfo.packageData)
  if self.param.monthCardInfo:IsBought() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.param.monthCardInfo.endTime - curTime
    local days = math.ceil(remainTime / (OneDayTime * 1000))
    local maxDays = LuaEntry.DataConfig:TryGetNum("monthcard_purchase", "k1") * 30
    local isCanBuy = maxDays >= days + 30
    local todayClaimed = self.param.monthCardInfo:IsTodayClaimed()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
    local hasParkingLotFour = buildData and buildData.level > 0
    if todayClaimed then
      self.jumpBtnN:SetActive(not hasParkingLotFour)
      self.buyBtnN:SetActive(isCanBuy)
      self.claimBtnN:SetActive(hasParkingLotFour)
      self.claimBtnTxtN:SetLocalText(hasParkingLotFour and 170003 or 2000157)
      UIGray.SetGray(self.claimBtnN.transform, true, false)
    else
      self.jumpBtnN:SetActive(false)
      self.buyBtnN:SetActive(isCanBuy)
      self.claimBtnN:SetActive(true)
      UIGray.SetGray(self.claimBtnN.transform, false, true)
    end
    self.extend_month_card_tips_text:SetActive(true)
    self.remainDaysTxtN:SetLocalText(2000156)
    self.remainDaysN1:SetText(days)
    self.remainDayBottomTxt1:SetLocalText("monthcard_countdown", days)
    self.remainDayBottomTxt2:SetLocalText("monthcard_countdown", days)
    self.inEffectIconN:SetActive(false)
    self.buyBtnEffect:SetActive(days <= 3)
    if not self.isBought then
      self:ShowBuySuccEff()
      self.isBought = true
    end
  else
    self.jumpBtnN:SetActive(false)
    self.buyBtnN:SetActive(true)
    self.claimBtnN:SetActive(false)
    self.remainTimeN:SetText("")
    self.inEffectIconN:SetActive(false)
    self.remainDaysTxtN:SetLocalText("monthcard_duration")
    self.remainDaysN1:SetText(30)
    self.remainDayBottomTxt1:SetText("")
    self.remainDayBottomTxt2:SetText("")
    self.extend_month_card_tips_text:SetActive(false)
  end
  self.buyBtnN:RefreshPoint()
  self.getNowValueTxt:SetText(string.format("+%s", self.param.monthCardInfo:GetPackageData():getDiamond()))
  self.valueNumTxt:SetText(toInt(self.param.monthCardInfo:GetPackageData():getPercent()) .. "%")
  self:RefreshTruckInsuranceBtn()
end

local function RefreshRewards(self)
  for i, v in ipairs(self.rewardsTb) do
    if i <= #self.rewardsList then
      v:SetActive(true)
      v:ReInit(self.rewardsList[i])
    else
      v:SetActive(false)
    end
  end
  for i, v in ipairs(self.dailyRewardsTb) do
    if i <= #self.dailyRewardsList then
      v:SetActive(true)
      v:ReInit(self.dailyRewardsList[i])
    else
      v:SetActive(false)
    end
  end
end

local function OnClickBtn(self)
  local todayClaimed = self.param.monthCardInfo:IsTodayClaimed()
  if todayClaimed then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
    if buildData and buildData.level == 0 then
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR, WorldTileBtnType.GolloesCamp)
    end
  else
    self.view.ctrl:ClaimDailyRewards(self.param.monthCardInfo.monthCardId)
  end
end

local function OnClickBuyBtn(self)
  if self.param.monthCardInfo.packageData then
    self.view.ctrl:BuyGift(self.param.monthCardInfo.packageData)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
  end
end

local function ShowBuySuccEff(self)
  self.inEffectIconN:SetActive(false)
  self.animInEffectN:Play("V_ui_gulu_ineffect", 0, 0)
  self.caidaiEffN:SetActive(true)
  local tempCaidaiEff = self.caidaiEffN
  TimerManager:GetInstance():DelayInvoke(function()
    if tempCaidaiEff and tempCaidaiEff.gameObject then
      tempCaidaiEff:SetActive(false)
    end
  end, 3)
end

function UILWMonthCardContent:RefreshTruckInsuranceBtn()
  local isOpenTruckInsurance = DataCenter.MonthCardNewManager:IsOpenTruckInsurance()
  self.btn_truck_insurance:SetActive(isOpenTruckInsurance)
  if not isOpenTruckInsurance then
    return
  end
  self.btn_truck_insurance_desc:SetLocalText("month_card_title_01")
  self.full_reward_desc:SetLocalText("month_card_tips_04")
  local isShowTruckInsuranceRedDot = DataCenter.MonthCardNewManager:IsShowTruckInsuranceRedDot()
  self.truck_insurance_ren_point:SetActive(isShowTruckInsuranceRedDot)
  local isTruckInsuranceToLimit = DataCenter.MonthCardNewManager:IsTruckInsuranceToLimit()
  self.full_reward_tips:SetActive(isTruckInsuranceToLimit)
end

function UILWMonthCardContent:OnClickTruckInsurance()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITruckRewardInsurance)
end

UILWMonthCardContent.OnCreate = OnCreate
UILWMonthCardContent.OnDestroy = OnDestroy
UILWMonthCardContent.OnAddListener = OnAddListener
UILWMonthCardContent.OnRemoveListener = OnRemoveListener
UILWMonthCardContent.ComponentDefine = ComponentDefine
UILWMonthCardContent.ComponentDestroy = ComponentDestroy
UILWMonthCardContent.DataDefine = DataDefine
UILWMonthCardContent.DataDestroy = DataDestroy
UILWMonthCardContent.ReInit = ReInit
UILWMonthCardContent.RefreshUI = RefreshUI
UILWMonthCardContent.Param = Param
UILWMonthCardContent.OnClickBtn = OnClickBtn
UILWMonthCardContent.OnClickBuyBtn = OnClickBuyBtn
UILWMonthCardContent.ShowBuySuccEff = ShowBuySuccEff
UILWMonthCardContent.RefreshRewards = RefreshRewards
return UILWMonthCardContent
