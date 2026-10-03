local LWUIMasteryHaveChoosedComp = BaseClass("LWUIMasteryHaveChoosedComp", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local LWUIMasteryHaveChooseCompItem = require("UI.LWUIMastery.Component.LWUIMasteryHaveChooseCompItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local selectHomeBg_path = "selectHomeBg"
local homeItem_path = "MasteryItemContent/home"
local level_info_path = "MasteryInfoContent/MasteryInfo/desTxt"
local showSkillBtn_path = "MasteryInfoContent/skillBtns/showSkillBtn"
local changeMasteryBtn_path = "MasteryInfoContent/skillBtns/changeMasteryBtn"
local skill_btn_red_point_path = "MasteryInfoContent/skillBtns/showSkillBtn/skillBtnRedPoint"
local levelContent_path = "MasteryInfoContent/MasteryInfo/levelContent"
local levelContent_container_path = "MasteryInfoContent/MasteryInfo/levelContent/"
local levelSlider_path = "lv_exp_content/Slider"
local levelSliderText_path = "lv_exp_content/Slider/SliderText"
local levelTxt_path = "LevelTxt"
local expNumTxt_path = "lv_exp_content/ExpNumTxt"
local addExpBtn_path = "addExpBtn"
local upgrade_red_path = "addExpBtn/upgradeRed"
local selectHomeIcon_path = "CardImg/selectHomeIcon"
local save_exp_content_path = "MasteryInfoContent/MasteryInfo/saveExpContent"
local save_exp_txt_path = "MasteryInfoContent/MasteryInfo/saveExpContent/saveExpTxt"
local save_exp_tip_btn_path = "MasteryInfoContent/MasteryInfo/saveExpContent/saveExpTxt/saveExpTipBtn"
local t_c_card_entry_bg_path = "TopButtons/TCCardEntryBg"
local t_c_card_red_point_path = "TopButtons/TCCardEntryBg/TCCardEntryIcon/TCCardRedPoint"
local skill_entry_btn_path = "TopButtons/SkillEntryBg"
local skill_red_point_path = "TopButtons/SkillEntryBg/SkillEntryIcon/redPoint"
local skill_entry_name_path = "TopButtons/SkillEntryBg/SkillEntryName"
local reset_book_bg_path = "TopButtons/ResetBookBg"
local reset_book_red_point_path = "TopButtons/ResetBookBg/ResetBookIcon/ResetBookRedPoint"
local reset_book_name_path = "TopButtons/ResetBookBg/ResetBookName"
local maxLvExp_txt_path = "MasteryInfoContent/MasteryInfo/levelContent/max_content/maxLvExp_txt"
local max_txt_path = "MasteryInfoContent/MasteryInfo/levelContent/max_content/max_txt"
local max_content_path = "MasteryInfoContent/MasteryInfo/levelContent/max_content"
local lv_exp_content_path = "MasteryInfoContent/MasteryInfo/levelContent/lv_exp_content"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshSkillBtnRed()
  self:RefreshTcCardBtnRed()
end

local function ComponentDefine(self)
  self.selectHomeBg = self:AddComponent(UIBaseContainer, selectHomeBg_path)
  self.homeItems = {}
  for i = 1, 3 do
    local itemPath = homeItem_path .. i
    local homeItem = self:AddComponent(LWUIMasteryHaveChooseCompItem, itemPath)
    self.homeItems[i] = homeItem
  end
  self.level_info = self:AddComponent(UIText, level_info_path)
  self.showSkillBtn = self:AddComponent(UIButton, showSkillBtn_path)
  self.showSkillBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowSkillBtnClick()
  end)
  self.skill_btn_red_point = self:AddComponent(UIBaseContainer, skill_btn_red_point_path)
  self.changeMasteryBtn = self:AddComponent(UIButton, changeMasteryBtn_path)
  self.changeMasteryBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChangeMasteryBtnClick()
  end)
  self.levelSlider = self:AddComponent(UISlider, levelContent_container_path .. levelSlider_path)
  self.levelSliderText = self:AddComponent(UIText, levelContent_container_path .. levelSliderText_path)
  self.levelTxt = self:AddComponent(UIText, levelContent_container_path .. levelTxt_path)
  self.expNumTxt = self:AddComponent(UIText, levelContent_container_path .. expNumTxt_path)
  self.upgrade_red = self:AddComponent(UIBaseComponent, levelContent_container_path .. upgrade_red_path)
  self.addExpBtn = self:AddComponent(UIButton, levelContent_container_path .. addExpBtn_path)
  self.addExpBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAddExpBtnClick()
  end)
  self.selectHomeIcon = self:AddComponent(UIImage, levelContent_container_path .. selectHomeIcon_path)
  self.save_exp_content = self:AddComponent(UIBaseContainer, save_exp_content_path)
  self.save_exp_txt = self:AddComponent(UIText, save_exp_txt_path)
  self.save_exp_tip_btn = self:AddComponent(UIButton, save_exp_tip_btn_path)
  self.save_exp_tip_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSaveExpTipClick()
  end)
  self.tcCardEntryBtn = self:AddComponent(UIButton, t_c_card_entry_bg_path)
  self.tcCardEntryBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnTCCardEntryBtnClick()
  end)
  self.tcCardRedDot = self:AddComponent(UIBaseContainer, t_c_card_red_point_path)
  self.tcCardEntryBtn:SetActive(TacticalCardUtil.IsFunctionOpen())
  self.maxLvExp_txt = self:AddComponent(UIText, maxLvExp_txt_path)
  self.max_txt = self:AddComponent(UIText, max_txt_path)
  self.lv_exp_content = self:AddComponent(UIBaseContainer, lv_exp_content_path)
  self.max_content = self:AddComponent(UIBaseContainer, max_content_path)
  self.level_content = self:AddComponent(UIBaseContainer, levelContent_path)
  self.skill_entry_btn = self:AddComponent(UIButton, skill_entry_btn_path)
  self.skill_entry_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUse, {anim = true, playEffect = false})
  end)
  self.skill_red_point = self:AddComponent(UIImage, skill_red_point_path)
  self.skill_entry_name = self:AddComponent(UITextMeshProUGUIEx, skill_entry_name_path)
  self.skill_entry_name:SetLocalText("150001")
  self.reset_book_bg = self:AddComponent(UIButton, reset_book_bg_path)
  self.reset_book_bg:SetOnClick(function()
    self:OnClickResetBook()
  end)
  self.reset_book_red_point = self:AddComponent(UIBaseComponent, reset_book_red_point_path)
  self.reset_book_name = self:AddComponent(UITextMeshProUGUIEx, reset_book_name_path)
  self.reset_book_name:SetLocalText("goods_name_640012")
end

local function ComponentDestroy(self)
  self.selectHomeBg = nil
  self.homeItems = nil
  self.level_info = nil
  self.showSkillBtn = nil
  self.changeMasteryBtn = nil
  self.skill_btn_red_point = nil
  self.levelSlider = nil
  self.levelSliderText = nil
  self.levelTxt = nil
  self.expNumTxt = nil
  self.addExpBtn = nil
  self.upgrade_red = nil
  self.selectHomeIcon = nil
  self.save_exp_content = nil
  self.save_exp_txt = nil
  self.save_exp_tip_btn = nil
  self.maxLvExp_txt = nil
  self.max_txt = nil
  self.lv_exp_content = nil
  self.max_content = nil
  self.skill_entry_btn = nil
  self.skill_red_point = nil
  self.skill_entry_name = nil
  self.reset_book_bg = nil
  self.reset_book_red_point = nil
  self.reset_book_name = nil
end

local function DataDefine(self)
  self.masteryData = nil
  self.selectHomeId = 0
  self.heroSpineLoadRequest = nil
  self.lastSpinePath = nil
  local condition = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k5")
  self.tcCardConditionSeason = 4
  self.tcCardConditionLv = 100
  self.tcCardExpItemId = 14501
  if not string.IsNullOrEmpty(condition) then
    local list = string.split(condition, "|")
    if 3 <= #list then
      self.tcCardConditionLv = tonumber(list[1])
      self.tcCardConditionSeason = tonumber(list[2])
      self.tcCardExpItemId = tonumber(list[3])
    end
  end
end

local function DataDestroy(self)
  self.masteryData = nil
  self.selectHomeId = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  self.lastSpinePath = nil
  self.tcCardConditionLv = nil
  self.tcCardConditionSeason = nil
  self.tcCardExpItemId = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWMasteryChangeMsgGet, self.RefreshSkillBtnRed)
  self:AddUIListener(EventId.LWMasterySkillUp, self.RefreshSkillBtnRed)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnRefreshMasterExp)
  self:AddUIListener(EventId.MasteryUseSkill, self.RefreshSkillRedPoint)
  self:AddUIListener(EventId.MasteryNewbieRewardState, self.RefreshResetBookRedPoint)
  self:AddUIListener(EventId.OnAfterWindowDestroy, self.OnRefreshMasterExp)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWMasteryChangeMsgGet, self.RefreshSkillBtnRed)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.RefreshSkillBtnRed)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnRefreshMasterExp)
  self:RemoveUIListener(EventId.MasteryUseSkill, self.RefreshSkillRedPoint)
  self:RemoveUIListener(EventId.MasteryNewbieRewardState, self.RefreshResetBookRedPoint)
  self:RemoveUIListener(EventId.OnAfterWindowDestroy, self.OnRefreshMasterExp)
end

local function ReInit(self)
  self.masteryData = DataCenter.MasteryManager:GetData()
  self.selectHomeId = self.masteryData.home_id
  for i = 1, 3 do
    local homeItem = self.homeItems[i]
    local homeId = MasteryHomeShowList[i]
    homeItem:SetData(homeId, 0, function(homeId)
      self:OnMasteryItemClick(homeId)
    end)
  end
  self:Refresh()
end

local function Refresh(self)
  self:RefreshItems()
  self:RefreshInfoContent()
  self:RefreshSkillRedPoint()
  self:RefreshResetBookRedPoint()
end

local function RefreshItems(self)
  for _, item in pairs(self.homeItems) do
    item:SetSelectData(self.selectHomeId)
  end
  local imgName = ""
  local imgPath = ""
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(self.selectHomeId)
  if showTemp then
    local spinePath = showTemp.mastery_spine
    if self.lastSpinePath ~= spinePath then
      if self.heroSpineLoadRequest ~= nil then
        self.heroSpineLoadRequest:Destroy()
        self.heroSpineLoadRequest = nil
      end
      local request = ResourceManager:InstantiateAsync(spinePath)
      self.heroSpineLoadRequest = request
      request:completed("+", function()
        if request.isError or request.gameObject == nil then
          self.heroSpineLoadRequest = nil
          return
        end
        request.gameObject:SetActive(true)
        local rectTransform = request.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
        if rectTransform ~= nil then
          local spineScale = 1
          local spinePos = {0, 0}
          rectTransform:SetParent(self.selectHomeBg.transform)
          rectTransform:Set_localScale(spineScale, spineScale, 1)
          rectTransform:Set_anchoredPosition(spinePos[1], spinePos[2], 0)
        end
      end)
      self.lastSpinePath = spinePath
    end
  end
  self:RefreshSkillBtnRed()
  self:RefreshTcCardBtnRed()
end

local function RefreshSkillBtnRed(self)
  if self.masteryData then
    local red = self.masteryData.home_id == self.selectHomeId and SeasonRedPointUtils.SeasonMastery()
    self.skill_btn_red_point:SetActive(red)
  end
end

function LWUIMasteryHaveChoosedComp:RefreshTcCardBtnRed()
  self.tcCardRedDot:SetActive(self:IsExistTcCardRed())
end

function LWUIMasteryHaveChoosedComp:IsExistTcCardRed()
  local equipRed = TacticalCardUtil.IsExistAnySlotShowRedDot()
  local cacheRed = TacticalCardUtil.IsExistCardCachaRed()
  return equipRed or cacheRed
end

local function RefreshSelectContent(self)
  self:RefreshItems()
end

local function RefreshInfoContent(self)
  local curLv = self.masteryData.level
  local maxLevel = DataCenter.MasteryManager:GetMaxLevel()
  self.levelTxt:SetLocalText("season_mastery_163", curLv)
  self:RefreshSelectHomeIcon()
  self:OnRefreshMasterExp()
end

function LWUIMasteryHaveChoosedComp:SetDesText(text)
  if self.prevDesText == nil or self.prevDesText ~= text then
    self.level_info:SetLocalText(text)
    self.prevDesText = text
  end
end

function LWUIMasteryHaveChoosedComp:SetDesTextPosY(pos)
  if self.prevDesTextPosY == nil or self.prevDesTextPosY ~= pos then
    self.level_info:SetAnchoredPositionXY(0, pos)
    self.prevDesTextPosY = pos
  end
end

function LWUIMasteryHaveChoosedComp:SetLvContentPosY(pos)
  if self.prevLvContentPosY == nil or self.prevLvContentPosY ~= pos then
    self.level_content:SetAnchoredPositionXY(0, pos)
    self.prevLvContentPosY = pos
  end
end

function LWUIMasteryHaveChoosedComp:OnRefreshMasterExp()
  if self.masteryData == nil then
    return
  end
  self.upgrade_red:SetActive(DataCenter.MasteryManager:CheckCanUpgradeByGoods())
  local curLv = self.masteryData.level
  local maxLevel = DataCenter.MasteryManager:GetMaxLevel()
  local maxExp = DataCenter.MasteryManager:GetLevelMaxExp(curLv)
  local curExp = math.min(self.masteryData.exp, maxExp)
  if maxExp == 0 then
    maxExp = 1
  end
  if curLv >= maxLevel then
    curExp = 0
  end
  if curLv >= self.tcCardConditionLv and SeasonUtil.GetSeason() >= self.tcCardConditionSeason then
    self.lv_exp_content:SetActive(false)
    self.max_content:SetActive(true)
    local count = DataCenter.ResourceItemDataManager:GetCountByItemId(self.tcCardExpItemId)
    self.maxLvExp_txt:SetLocalText("battle_card_exp_now", string.GetFormattedStr2(count))
    self:SetDesText("battle_card_exp_max_info")
    self:SetLvContentPosY(65)
    self:SetDesTextPosY(40)
    self.save_exp_content:SetActive(false)
  else
    self.lv_exp_content:SetActive(true)
    self.max_content:SetActive(false)
    self.save_exp_content:SetActive(true)
    if curLv >= maxLevel then
      self.save_exp_txt:SetLocalText("season_mastery_170", string.GetFormattedStr2(tonumber(self.masteryData.saveExp)))
      self.save_exp_tip_btn:SetActive(true)
    else
      self.save_exp_txt:SetLocalText("season_mastery_190", maxLevel)
      self.save_exp_tip_btn:SetActive(false)
    end
    local progressval = curExp / maxExp
    self.levelSlider:SetValue(progressval)
    self.levelSliderText:SetText("")
    self.expNumTxt:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(tonumber(curExp)), string.GetFormattedSeparatorNum(tonumber(maxExp))))
    self:SetDesText("season_mastery_091")
    self:SetLvContentPosY(49.9)
    self:SetDesTextPosY(20)
  end
end

local function RefreshSelectHomeIcon(self)
  local iconPath = string.format(LoadPath.ItemPath, "icon_zhuanjinghuobi")
  local homeId = self.masteryData.home_id
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(homeId)
  if showTemp then
    iconPath = showTemp:GetIconFullPath()
  end
  self.selectHomeIcon:LoadSprite(iconPath)
end

local function OnShowSkillBtnClick(self)
  local params = {}
  params.tabType = MasteryTabType.MasterSkillTab
  params.data = {
    homeId = self.selectHomeId
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryCenterTab, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, params)
end

local function OnChangeMasteryBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasteryChangeHome, {anim = true})
end

local function OnMasteryItemClick(self, homeId)
  if self.selectHomeId == homeId then
    return
  end
  local showTemp = DataCenter.MasteryManager:GetHomeShowTempByHomeId(homeId)
  if not showTemp.lock then
    self.selectHomeId = homeId
    self:RefreshSelectContent()
  else
    UIUtil.ShowTipsId("season_mastery_104")
  end
end

local function OnAddExpBtnClick(self)
  local curLv = self.masteryData.level
  local curExp = self.masteryData.exp
  local maxExp = DataCenter.MasteryManager:GetLevelMaxExp(curLv)
  if maxExp == 0 then
    maxExp = 1
  end
  local itemId = LuaEntry.DataConfig:TryGetNum("lw_season_mastery", "k3")
  local own = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
  local need = own + (maxExp - curExp)
  local shouldAutoExitWhenComplete = true
  if curLv == DataCenter.MasteryManager:GetMaxLevel() then
    if SeasonUtil.GetSeason() < self.tcCardConditionSeason then
      UIUtil.ShowTipsId("400013")
    else
      itemId = self.tcCardExpItemId
      shouldAutoExitWhenComplete = false
    end
  end
  if itemId == nil then
    return
  end
  if curExp < maxExp then
    LWResourceLackUtil:GotoResourceItemLackWithAutoExit(itemId, need, shouldAutoExitWhenComplete)
  else
  end
end

local function OnSaveExpTipClick(self)
  local param = {}
  local season = SeasonUtil.GetSeason()
  local condition = LuaEntry.DataConfig:TryGetStr("battle_card_param", "k5")
  local conditionSeason = 4
  if not string.IsNullOrEmpty(condition) then
    local list = string.split(condition, "|")
    conditionSeason = tonumber(list[2])
  end
  if season and season >= conditionSeason then
    param.activityRulesStr = Localization:GetString("battle_card_exp_info_s4")
  else
    param.activityRulesStr = Localization:GetString("season_mastery_171")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

local function OnTCCardEntryBtnClick(self)
  TacticalCardUtil.OpenTacticalCardMain()
end

function LWUIMasteryHaveChoosedComp:OnClickResetBook()
  local status = DataCenter.MasteryManager:GetNewbieRewardStatus()
  if status == 1 then
    SFSNetwork.SendMessage(MsgDefines.LwSeasonMasteryNewbieRewardClaim)
  elseif status == 2 then
    local k2 = LuaEntry.DataConfig:TryGetNum("mastery_newbie", "k2", 10)
    UIUtil.ShowTips(Localization:GetString("season_mastery_S1_2025_tips2", k2))
  end
end

function LWUIMasteryHaveChoosedComp:RefreshSkillRedPoint()
  local have = DataCenter.MasteryManager:HaveSkillCanUse()
  self.skill_red_point:SetActive(have)
end

function LWUIMasteryHaveChoosedComp:RefreshResetBookRedPoint()
  local state = DataCenter.MasteryManager:GetNewbieRewardStatus()
  if state == 1 then
    self.reset_book_bg:SetActive(true)
    self.reset_book_red_point:SetActive(true)
  elseif state == 2 then
    self.reset_book_bg:SetActive(true)
    self.reset_book_red_point:SetActive(false)
  else
    self.reset_book_bg:SetActive(false)
  end
end

LWUIMasteryHaveChoosedComp.OnCreate = OnCreate
LWUIMasteryHaveChoosedComp.OnDestroy = OnDestroy
LWUIMasteryHaveChoosedComp.OnEnable = OnEnable
LWUIMasteryHaveChoosedComp.ComponentDefine = ComponentDefine
LWUIMasteryHaveChoosedComp.ComponentDestroy = ComponentDestroy
LWUIMasteryHaveChoosedComp.DataDefine = DataDefine
LWUIMasteryHaveChoosedComp.DataDestroy = DataDestroy
LWUIMasteryHaveChoosedComp.OnAddListener = OnAddListener
LWUIMasteryHaveChoosedComp.OnRemoveListener = OnRemoveListener
LWUIMasteryHaveChoosedComp.ReInit = ReInit
LWUIMasteryHaveChoosedComp.Refresh = Refresh
LWUIMasteryHaveChoosedComp.RefreshItems = RefreshItems
LWUIMasteryHaveChoosedComp.RefreshInfoContent = RefreshInfoContent
LWUIMasteryHaveChoosedComp.RefreshSelectContent = RefreshSelectContent
LWUIMasteryHaveChoosedComp.RefreshSelectHomeIcon = RefreshSelectHomeIcon
LWUIMasteryHaveChoosedComp.RefreshSkillBtnRed = RefreshSkillBtnRed
LWUIMasteryHaveChoosedComp.OnShowSkillBtnClick = OnShowSkillBtnClick
LWUIMasteryHaveChoosedComp.OnChangeMasteryBtnClick = OnChangeMasteryBtnClick
LWUIMasteryHaveChoosedComp.OnMasteryItemClick = OnMasteryItemClick
LWUIMasteryHaveChoosedComp.OnAddExpBtnClick = OnAddExpBtnClick
LWUIMasteryHaveChoosedComp.OnSaveExpTipClick = OnSaveExpTipClick
LWUIMasteryHaveChoosedComp.OnTCCardEntryBtnClick = OnTCCardEntryBtnClick
return LWUIMasteryHaveChoosedComp
