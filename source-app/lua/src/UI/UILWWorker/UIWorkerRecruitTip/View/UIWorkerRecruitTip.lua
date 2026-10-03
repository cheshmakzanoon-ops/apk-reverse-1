local UIWorkerRecruitTip = BaseClass("UIWorkerRecruitTip", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
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
  self.recruitRateDetailInfo = self:AddComponent(UIHeroRecruitTipRateDetailInfo, "Root/Common_bg/recruitRateDetailInfo")
  self.textTitle:SetLocalText(110117)
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.closeBtn = nil
  self.textTitle = nil
  self.recruitRateInfo = nil
end

local function DataDefine(self)
  local param = self:GetUserData()
  self.lotteryData = param.lotteryData
  self.selectIndex = 1
  self.dataList = nil
end

local function DataDestroy(self)
  self.lotteryData = nil
  self.selectIndex = nil
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
  self.propId1 = LuaEntry.DataConfig:TryGetNum("worker_recruit", "k9")
  self.propId2 = LuaEntry.DataConfig:TryGetNum("worker_recruit", "k10")
  if self.lotteryData then
    local workerDropInfoDetail = self.lotteryData.workerDropInfoDetail or ""
    local dropInfoDetailIdStr = string.split(workerDropInfoDetail, "|")
    self.propId1 = tonumber(dropInfoDetailIdStr[1])
    self.propId2 = tonumber(dropInfoDetailIdStr[2])
  end
  self.selectIndex = 1
  self.dataList = {
    HeroRecruitRateShowType.DetailInfo
  }
  if self.propId2 > 0 then
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
    local dropInfoDetail = GetTableData(TableName.DropInfoDetail, self.propId1, "dropInfoDetail")
    self.recruitRateDetailInfo:SetData(dropInfoDetail)
  elseif selectType == HeroRecruitRateShowType.GPPDetailInfo then
    local dropInfoDetail = GetTableData(TableName.DropInfoDetail, self.propId2, "dropInfoDetail")
    self.recruitRateDetailInfo:SetData(dropInfoDetail)
  end
end

local function OnTabClick(self, index)
  if self.selectIndex == index then
    return
  end
  self.selectIndex = index
  self:UpdateView()
end

UIWorkerRecruitTip.OnCreate = OnCreate
UIWorkerRecruitTip.OnDestroy = OnDestroy
UIWorkerRecruitTip.ComponentDefine = ComponentDefine
UIWorkerRecruitTip.ComponentDestroy = ComponentDestroy
UIWorkerRecruitTip.DataDefine = DataDefine
UIWorkerRecruitTip.DataDestroy = DataDestroy
UIWorkerRecruitTip.OnOpen = OnOpen
UIWorkerRecruitTip.UpdateView = UpdateView
UIWorkerRecruitTip.RefreshSelectContent = RefreshSelectContent
UIWorkerRecruitTip.RefreshInfoContent = RefreshInfoContent
UIWorkerRecruitTip.OnTabClick = OnTabClick
return UIWorkerRecruitTip
