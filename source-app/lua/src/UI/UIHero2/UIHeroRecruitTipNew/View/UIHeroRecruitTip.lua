local UIHeroRecruitTip = BaseClass("UIHeroRecruitTip", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroRecruitTipRateInfo = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateInfo")
local UIHeroRecruitTipRateDetailInfo = require("UI.UIHero2.UIHeroRecruitTipNew.Component.UIHeroRecruitTipRateDetailInfo")
local tab_btn_path = "Btn"
local tab_select_path = "Select"
local tab_unselect_path = "UnSelect"
local tab_name_path = "Group/titleText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/Common_bg_orange/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText")
  self.tabList = {}
  for i = 1, 2 do
    local tabItem = self:AddComponent(UIBaseContainer, "Root/TabLayout/Tab" .. i)
    tabItem.tab_select = tabItem:AddComponent(UIBaseContainer, tab_select_path)
    tabItem.tab_unselect = tabItem:AddComponent(UIBaseContainer, tab_unselect_path)
    tabItem.tab_name = tabItem:AddComponent(UIText, tab_name_path)
    tabItem.tab_btn = tabItem:AddComponent(UIButton, tab_btn_path)
    tabItem.tab_btn:SetOnClick(function()
      self:OnTabClick(i)
    end)
    self.tabList[i] = tabItem
  end
  self.recruitRateInfo = self:AddComponent(UIHeroRecruitTipRateInfo, "Root/Common_bg/recruitRateInfo")
  self.recruitRateDetailInfo = self:AddComponent(UIHeroRecruitTipRateDetailInfo, "Root/Common_bg/recruitRateDetailInfo")
  self.textTitle:SetLocalText(110117)
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.tabList = nil
  self.recruitRateInfo = nil
  self.recruitRateDetailInfo = nil
end

local function DataDefine(self)
  self.selectIndex = 2
  self.lotteryId = nil
  self.dataList = nil
end

local function DataDestroy(self)
  self.selectIndex = nil
  self.lotteryId = nil
  self.dataList = nil
end

local function GetTabNameByShowType(type)
  local name = ""
  if type == HeroRecruitRateShowType.DetailInfo then
    name = Localization:GetString("gacha_rate_detail_title_1")
  elseif type == HeroRecruitRateShowType.GPPDetailInfo then
    name = Localization:GetString("gacha_rate_detail_title_2")
  end
  return name
end

local function OnOpen(self)
  self.lotteryId = self:GetUserData()
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if self.lotteryData == nil then
    return
  end
  self.selectIndex = 1
  self.dataList = {
    HeroRecruitRateShowType.DetailInfo
  }
  if not string.IsNullOrEmpty(self.lotteryData.pity_dropInfoDetail) then
    table.insert(self.dataList, HeroRecruitRateShowType.GPPDetailInfo)
  end
  for i = 1, #self.tabList do
    if self.dataList[i] ~= nil then
      self.tabList[i]:SetActive(true)
      local tabName = GetTabNameByShowType(self.dataList[i])
      self.tabList[i].tab_name:SetText(tabName)
    else
      self.tabList[i]:SetActive(false)
    end
  end
  self.recruitRateInfo:SetData(self.lotteryId)
  self:UpdateView()
end

local function UpdateView(self)
  self:RefreshSelectContent()
  self:RefreshInfoContent()
end

local function RefreshSelectContent(self)
  for i = 1, #self.tabList do
    if self.dataList[i] ~= nil then
      if i == self.selectIndex then
        self.tabList[i].tab_select:SetActive(true)
      else
        self.tabList[i].tab_select:SetActive(false)
      end
    end
  end
end

local function RefreshInfoContent(self)
  local selectType = self.dataList[self.selectIndex]
  if selectType == HeroRecruitRateShowType.DetailInfo then
    self.recruitRateInfo:SetActive(false)
    self.recruitRateDetailInfo:SetActive(true)
    self.recruitRateDetailInfo:SetDataNew(self.lotteryData:GetDropInfoDetailData())
  elseif selectType == HeroRecruitRateShowType.GPPDetailInfo then
    self.recruitRateInfo:SetActive(false)
    self.recruitRateDetailInfo:SetActive(true)
    self.recruitRateDetailInfo:SetDataNew(self.lotteryData:GetPityDropInfoDetailData())
  end
end

local function OnTabClick(self, index)
  if self.selectIndex == index then
    return
  end
  self.selectIndex = index
  self:UpdateView()
end

UIHeroRecruitTip.OnCreate = OnCreate
UIHeroRecruitTip.OnDestroy = OnDestroy
UIHeroRecruitTip.ComponentDefine = ComponentDefine
UIHeroRecruitTip.ComponentDestroy = ComponentDestroy
UIHeroRecruitTip.DataDefine = DataDefine
UIHeroRecruitTip.DataDestroy = DataDestroy
UIHeroRecruitTip.OnOpen = OnOpen
UIHeroRecruitTip.UpdateView = UpdateView
UIHeroRecruitTip.RefreshSelectContent = RefreshSelectContent
UIHeroRecruitTip.RefreshInfoContent = RefreshInfoContent
UIHeroRecruitTip.OnTabClick = OnTabClick
return UIHeroRecruitTip
