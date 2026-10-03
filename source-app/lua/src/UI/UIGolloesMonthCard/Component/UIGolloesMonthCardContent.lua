local UIGolloesMonthCardContent = BaseClass("UIGolloesMonthCardContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local Param = DataClass("Param", ParamData)
local ParamData = {
  monthCardInfo
}
local title_path = "bookBg/TitleText"
local desc_path = "bookBg/DescText"
local benefitDesc_path = "bookBg/Benefits/benefit%s/desc%s"
local benefitBtn_path = "bookBg/Benefits/benefit%s"
local benefit5Desc_path = "bookBg/benefit5/benifit5Anim/desc5"
local benefit5Btn_path = "bookBg/benefit5"
local buyTip_path = "bookBg/buyTip"
local buyBtn_path = "bookBg/BuyButton"
local buyBtnTxt_path = "bookBg/BuyButton/PriceText"
local jumpBtn_path = "bookBg/gotoCampBtn"
local jumpBtnTxt_path = "bookBg/gotoCampBtn/gotoTxt"
local remainTime_path = "bookBg/leftTime"
local buyerTxt_path = "bookBg/buyer"
local buyerNameTxt_path = "bookBg/buyer/buyerName"
local sellerTxt_path = "bookBg/seller"
local sellerNameTxt_path = "bookBg/seller/sellerName"
local isEffectImg_path = "bookBg/inEffect"
local inEffectTxt_path = "bookBg/inEffect/inEffectDesc"
local inEffectEff_path = "bookBg/inEffect/VFX_ui_zhang_inEffect"
local caidaiEff_path = "VFX_uimonthcardpanel_caidai"
local rewardsTip_path = "bookBg/benefit5/benifit5Anim/desc5"
local rewardTb_path = "bookBg/Scroll View/Viewport/Content/reward"
local infoBtn_path = "bookBg/benefit5/benifit5Anim/desc5/infoBtn"
local remainDays_path = "bookBg/remainDays"
local remainDaysTxt_path = "bookBg/remainTxt"
local discountDesc1_path = "bookBg/discountDesc_1"
local discountDesc2_path = "bookBg/discountDesc_2"
local point_path = "bookBg/BuyButton/UIGiftPackagePoint"

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
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.RefreshUI)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.descN = self:AddComponent(UIText, desc_path)
  self.benefitDescTb = {}
  self.benefitBtnTb = {}
  for i = 1, 4 do
    self.benefitDescTb[i] = self:AddComponent(UIText, string.format(benefitDesc_path, i, i))
    self.benefitBtnTb[i] = self:AddComponent(UIButton, string.format(benefitBtn_path, i))
    self.benefitBtnTb[i]:SetOnClick(function()
      self:ShowBenefitTip(i)
    end)
  end
  self.rewardsTb = {}
  for i = 1, 5 do
    local newReward = {}
    local tempReward = self:AddComponent(UIBaseContainer, rewardTb_path .. i)
    newReward.rootN = tempReward
    local tempIcon = tempReward:AddComponent(UIImage, "rewardItem/clickBtn/ItemIcon")
    newReward.iconN = tempIcon
    local tempNum = tempReward:AddComponent(UIText, "rewardItem/clickBtn/NumText")
    newReward.numN = tempNum
    local qualityBg = tempReward:AddComponent(UIImage, "rewardItem/clickBtn/ImgQuality")
    newReward.qualityBgN = qualityBg
    local tempBtn = tempReward:AddComponent(UIButton, "rewardItem/clickBtn")
    tempBtn:SetOnClick(function()
      self:OnClickReward(i)
    end)
    newReward.btnN = tempBtn
    table.insert(self.rewardsTb, newReward)
  end
  self.rewardTipN = self:AddComponent(UIText, rewardsTip_path)
  self.rewardTipN:SetLocalText(320337)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.buyTipN = self:AddComponent(UIText, buyTip_path)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtnN:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.buyBtnTxtN = self:AddComponent(UIText, buyBtnTxt_path)
  self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtnN:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.jumpBtnTxtN = self:AddComponent(UIText, jumpBtnTxt_path)
  self.jumpBtnTxtN:SetLocalText(320253)
  self.remainTimeN = self:AddComponent(UIText, remainTime_path)
  self.buyerTxtN = self:AddComponent(UIText, buyerTxt_path)
  self.buyerNameTxtN = self:AddComponent(UIText, buyerNameTxt_path)
  self.sellerTxtN = self:AddComponent(UIText, sellerTxt_path)
  self.sellerNameTxtN = self:AddComponent(UIText, sellerNameTxt_path)
  self.inEffectIconN = self:AddComponent(UIBaseContainer, isEffectImg_path)
  self.animInEffectN = self:AddComponent(UIAnimator, isEffectImg_path)
  self.inEffectTxtN = self:AddComponent(UIText, inEffectTxt_path)
  self.inEffectTxtN:SetLocalText(320534)
  self.inEffectEffN = self:AddComponent(UIBaseContainer, inEffectEff_path)
  self.inEffectEffN:SetActive(false)
  self.caidaiEffN = self:AddComponent(UIBaseContainer, caidaiEff_path)
  self.caidaiEffN:SetActive(false)
  self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
  self.remainDaysN = self:AddComponent(UIText, remainDays_path)
  self.remainDaysTxtN = self:AddComponent(UIText, remainDaysTxt_path)
  self.discountDesc1N = self:AddComponent(UIText, discountDesc1_path)
  self.discountDesc1N:SetLocalText(320532)
  self.discountDesc2N = self:AddComponent(UIText, discountDesc2_path)
  self.discountDesc2N:SetLocalText(320533)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.descN = nil
  self.benefitDescTb = nil
  self.benefitBtnTb = nil
  self.buyTipN = nil
  self.buyBtnN = nil
  self.jumpBtnN = nil
  self.jumpBtnTxtN = nil
  self.buyBtnTxtN = nil
  self.remainTimeN = nil
  self.point_rect = nil
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
      local strRewards = monthCardConf.reward_show or ""
      local strArrRewards = string.split(strRewards, "|")
      for i, v in ipairs(strArrRewards) do
        local strArrParams = string.split(v, ";")
        local oneReward = {}
        oneReward.icon = strArrParams[1]
        oneReward.num = strArrParams[2]
        oneReward.title = strArrParams[3]
        oneReward.content = strArrParams[4]
        oneReward.qualityBg = strArrParams[5]
        table.insert(self.rewardsList, oneReward)
      end
    end
  end
  self:RefreshUI()
  self:RefreshRewards()
end

local function RefreshUI(self)
  self.titleN:SetLocalText(320243)
  self.descN:SetLocalText(320251)
  for i = 1, #self.benefitDescTb do
    self.benefitDescTb[i]:SetLocalText(self.benefitsList[i].name)
  end
  self.buyerTxtN:SetLocalText(320270)
  self.buyerNameTxtN:SetText(LuaEntry.Player.name)
  self.sellerTxtN:SetLocalText(320271)
  self.sellerNameTxtN:SetLocalText(320272)
  self.buyTipN:SetLocalText(320252)
  if self.param.monthCardInfo:IsBought() then
    self.jumpBtnN:SetActive(true)
    self.buyBtnN:SetActive(false)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.param.monthCardInfo.endTime - curTime
    local days = math.ceil(remainTime / (OneDayTime * 1000))
    self.remainDaysTxtN:SetLocalText(310134)
    self.remainDaysN:SetLocalText(320531, days)
    self.inEffectIconN:SetActive(true)
    if not self.isBought then
      self:ShowBuySuccEff()
      self.isBought = true
    end
  else
    self.jumpBtnN:SetActive(false)
    self.buyBtnN:SetActive(true)
    self.buyBtnTxtN:SetText(self.param.monthCardInfo:GetPriceText())
    self.remainTimeN:SetText("")
    self.inEffectIconN:SetActive(false)
    self.remainDaysTxtN:SetLocalText(320530)
    self.remainDaysN:SetLocalText(320531, 30)
  end
  self.point_rect:RefreshPoint(self.param.monthCardInfo:GetPackageData())
end

local function RefreshRewards(self)
  for i, v in ipairs(self.rewardsTb) do
    if i <= #self.rewardsList then
      v.rootN:SetActive(true)
      local rewardInfo = self.rewardsList[i]
      v.iconN:LoadSprite(string.format("Assets/Main/Sprites/ItemIcons/%s", rewardInfo.icon))
      v.numN:SetText(rewardInfo.num)
      v.qualityBgN:LoadSprite(string.format("Assets/Main/Sprites/ItemIcons/%s", rewardInfo.qualityBg))
    else
      v.rootN:SetActive(false)
    end
  end
end

local function OnClickBtn(self)
  if self.param.monthCardInfo:IsBought() then
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE, WorldTileBtnType.GolloesCamp)
  else
    self.view.ctrl:BuyGift(self.param.monthCardInfo.packageData)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
  end
end

local function ShowBenefitTip(self, benefitIndex)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.benefitBtnTb[benefitIndex].transform.position + Vector3.New(0, -65, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString(self.benefitsList[benefitIndex].desc)
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 386
  local tempPivot = 0.5
  param.pivot = tempPivot
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function ShowBuySuccEff(self)
  self.inEffectIconN:SetActive(true)
  self.animInEffectN:Play("V_ui_gulu_ineffect", 0, 0)
  self.caidaiEffN:SetActive(true)
  local tempCaidaiEff = self.caidaiEffN
  TimerManager:GetInstance():DelayInvoke(function()
    if tempCaidaiEff and tempCaidaiEff.gameObject then
      tempCaidaiEff:SetActive(false)
    end
  end, 3)
end

local function OnClickReward(self, index)
  if index <= #self.rewardsList then
    local title = self.rewardsList[index].title
    local content = self.rewardsList[index].content
    local param = {}
    param.itemName = title
    param.itemDesc = content
    param.alignObject = self.rewardsTb[index].rootN
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

local function OnClickInfoBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.infoBtnN.transform.position + Vector3.New(25, 20, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("320339")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 400
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIGolloesMonthCardContent.OnCreate = OnCreate
UIGolloesMonthCardContent.OnDestroy = OnDestroy
UIGolloesMonthCardContent.OnAddListener = OnAddListener
UIGolloesMonthCardContent.OnRemoveListener = OnRemoveListener
UIGolloesMonthCardContent.ComponentDefine = ComponentDefine
UIGolloesMonthCardContent.ComponentDestroy = ComponentDestroy
UIGolloesMonthCardContent.DataDefine = DataDefine
UIGolloesMonthCardContent.DataDestroy = DataDestroy
UIGolloesMonthCardContent.ReInit = ReInit
UIGolloesMonthCardContent.RefreshUI = RefreshUI
UIGolloesMonthCardContent.Param = Param
UIGolloesMonthCardContent.AddTimer = AddTimer
UIGolloesMonthCardContent.DelTimer = DelTimer
UIGolloesMonthCardContent.OnClickBtn = OnClickBtn
UIGolloesMonthCardContent.RefreshRemainTime = RefreshRemainTime
UIGolloesMonthCardContent.ShowBenefitTip = ShowBenefitTip
UIGolloesMonthCardContent.ShowClaimEff = ShowClaimEff
UIGolloesMonthCardContent.ShowBuySuccEff = ShowBuySuccEff
UIGolloesMonthCardContent.OnClickReward = OnClickReward
UIGolloesMonthCardContent.OnClickInfoBtn = OnClickInfoBtn
UIGolloesMonthCardContent.RefreshRewards = RefreshRewards
return UIGolloesMonthCardContent
