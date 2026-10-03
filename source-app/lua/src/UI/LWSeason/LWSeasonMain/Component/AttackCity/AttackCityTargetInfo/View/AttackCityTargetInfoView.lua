local SeasonAttackCityTargetInfoView = BaseClass("SeasonAttackCityTargetInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AttackCityTaskContent = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityTargetInfo.Component.AttackCityTaskContent")
local AttackCityRankContent = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityTargetInfo.Component.AttackCityRankContent")
local AttackCityRankRewardContent = require("UI.LWSeason.LWSeasonMain.Component.AttackCity.AttackCityTargetInfo.Component.AttackCityRankRewardContent")
local titlePath = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local black_mask_path = "UICommonPopUpTitle/panel"
local tab_path = "Root/TabLayout/Tab%d"
local tab_btn_path = "Btn"
local tab_select_path = "Select"
local tab_unselect_path = "UnSelect"
local tab_name_path = "name"
local taskContent_path = "Root/Content/taskContent"
local rankContent_path = "Root/Content/rankContent"
local rankRewardContent_path = "Root/Content/rankRewardContent"
local tipTxt_path = "Root/tipTxt"

function SeasonAttackCityTargetInfoView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function SeasonAttackCityTargetInfoView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAttackCityTargetInfoView:ComponentDefine()
  self.title = self:AddComponent(UIText, titlePath)
  self.title:SetLocalText(456517)
  self.tipTxt = self:AddComponent(UIText, tipTxt_path)
  self.tipTxt:SetLocalText(456548)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtnN = self:AddComponent(UIButton, black_mask_path)
  self.maskBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tabs = {}
  for i = 1, 3 do
    local tab = {}
    local rootPath = string.format(tab_path, i)
    tab.tab = self:AddComponent(UIBaseContainer, rootPath)
    tab.tab_select = tab.tab:AddComponent(UIBaseContainer, tab_select_path)
    tab.tab_unselect = tab.tab:AddComponent(UIBaseContainer, tab_unselect_path)
    tab.tab_name = tab.tab:AddComponent(UIText, tab_name_path)
    tab.tab_btn = tab.tab:AddComponent(UIButton, tab_btn_path)
    local index = i
    tab.tab_btn:SetOnClick(function()
      self:DoSelectTabIndex(index)
    end)
    self.tabs[i] = tab
  end
  self.taskContent = self:AddComponent(AttackCityTaskContent, taskContent_path)
  self.rankContent = self:AddComponent(AttackCityRankContent, rankContent_path)
  self.rankRewardContent = self:AddComponent(AttackCityRankRewardContent, rankRewardContent_path)
end

function SeasonAttackCityTargetInfoView:ComponentDestroy()
  self.title = nil
  self.tipTxt = nil
  self.close_btn = nil
  self.maskBtnN = nil
  for i = 1, #self.tabs do
    self.tabs[i] = nil
  end
  self.tabs = nil
end

function SeasonAttackCityTargetInfoView:DataDefine()
  self.activityId = self:GetUserData()
  self.selectIndex = 1
  self.showTabData = {
    ActivityAttackCityTargetType.Task,
    ActivityAttackCityTargetType.Rank,
    ActivityAttackCityTargetType.RankReward
  }
  self.showContent = {
    [ActivityAttackCityTargetType.Task] = self.taskContent,
    [ActivityAttackCityTargetType.Rank] = self.rankContent,
    [ActivityAttackCityTargetType.RankReward] = self.rankRewardContent
  }
end

function SeasonAttackCityTargetInfoView:DataDestroy()
  self.activityId = nil
  self.selectIndex = nil
  self.showTabData = nil
  self.showContent = nil
end

function SeasonAttackCityTargetInfoView:OnAddListener()
  base.OnAddListener(self)
end

function SeasonAttackCityTargetInfoView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonAttackCityTargetInfoView:RefreshBar()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab_select:SetActive(i == self.selectIndex)
    end
  end
end

function SeasonAttackCityTargetInfoView:RefreshContent()
  local curType = self.showTabData[self.selectIndex]
  if curType == nil then
    return
  end
  for k, v in pairs(self.showContent) do
    if k == curType then
      v:SetActive(true)
      v:SetData(self.activityId)
    else
      v:SetActive(false)
    end
  end
end

function SeasonAttackCityTargetInfoView:DoSelectTabIndex(index)
  if index == self.selectIndex then
    return
  end
  self.selectIndex = index
  self:RefreshBar()
  self:RefreshContent()
end

function SeasonAttackCityTargetInfoView:ReInit()
  for i = 1, #self.tabs do
    if self.showTabData[i] ~= nil then
      self.tabs[i].tab:SetActive(true)
      self.tabs[i].tab_name:SetText(self:GetTabNameByType(self.showTabData[i]))
    else
      self.tabs[i].tab:SetActive(false)
    end
  end
  self:RefreshBar()
  self:RefreshContent()
end

function SeasonAttackCityTargetInfoView:GetTabNameByType(type)
  local name = ""
  if type == ActivityAttackCityTargetType.Task then
    name = Localization:GetString("456530")
  elseif type == ActivityAttackCityTargetType.Rank then
    name = Localization:GetString("456531")
  elseif type == ActivityAttackCityTargetType.RankReward then
    name = Localization:GetString("456532")
  end
  return name
end

return SeasonAttackCityTargetInfoView
