local p_text_title_path = "p_trans_root/content_title/UICommonRewardPopUp/Panel/ImgTitleBg/p_text_title"
local p_trans_root_path = "p_trans_root"
local p_text_military_name_path = "p_trans_root/p_comp_level/p_text_military_name"
local p_comp_military_path = "p_trans_root/p_comp_level"
local content_gain_path = "p_trans_root/content_gain"
local p_template_benefit_path = "p_trans_root/content_gain/p_content_benefit/p_template_benefit"
local content_path = "p_trans_root/content_gain/p_content_benefit/Viewport/Content"
local p_content_reward_path = "p_trans_root/content_gain/p_content_reward"
local p_scroll_view_path = "p_trans_root/content_gain/p_content_reward/p_scroll_view"
local p_btn_close_path = "p_btn_close"
local UILWSeasonMilitaryLevelComp = require("UI.LWSeason6.UILWSeasonMilitary.Comp.UILWSeasonMilitaryLevelComp")
local UILWSeasonMilitaryItemCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryItemCell")
local UILWSeasonMilitaryBenefitCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryBenefitCell")
local base = UIBaseView
local S6MilitaryLevelUpView = BaseClass("S6MilitaryLevelUpView", UIBaseView)

function S6MilitaryLevelUpView:ComponentDefine()
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_trans_root = self:AddComponent(UIBaseContainer, p_trans_root_path)
  self.p_text_military_name = self:AddComponent(UITextMeshProUGUIEx, p_text_military_name_path)
  self.p_comp_military = self:AddComponent(UILWSeasonMilitaryLevelComp, p_comp_military_path)
  self.content_gain = self:AddComponent(UIBaseContainer, content_gain_path)
  self.p_template_benefit = self:AddComponent(UIImage, p_template_benefit_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.p_content_reward = self:AddComponent(UIBaseContainer, p_content_reward_path)
  self.p_scroll_view = self:AddComponent(UIScrollViewSimple, p_scroll_view_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.itemPool = self.p_template_benefit.gameObject
  self.itemPool:GameObjectCreatePool()
end

function S6MilitaryLevelUpView:ComponentDestroy()
  self:Clear()
  self.p_text_title = nil
  self.p_trans_root = nil
  self.p_text_military_name = nil
  self.p_comp_military = nil
  self.content_gain = nil
  self.p_template_benefit = nil
  self.content = nil
  self.p_content_reward = nil
  self.p_scroll_view = nil
  self.p_btn_close = nil
end

function S6MilitaryLevelUpView:DataDefine()
end

function S6MilitaryLevelUpView:DataDestroy()
  self.Data = nil
end

function S6MilitaryLevelUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function S6MilitaryLevelUpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function S6MilitaryLevelUpView:OnAddListener()
  base.OnAddListener(self)
end

function S6MilitaryLevelUpView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function S6MilitaryLevelUpView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function S6MilitaryLevelUpView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(Mathf.Floor(checknumber(data.Level)))
    return self.Cell ~= nil
  end
  return false
end

function S6MilitaryLevelUpView:InitUi()
  if self.Data.IsAuto then
    self.p_text_title:SetLocalText("season_military_promote_rank_title")
  else
    self.p_text_title:SetLocalText("season_military_promote_success_title")
  end
  self.p_text_military_name:SetLocalText(self.Cell:GetName())
  self.p_comp_military:ReInit(self.Cell.level, LuaEntry.Player:GetSourceServerId(), 45)
  self:InitBenefit()
  local rewards = self.Cell:GetLevelUpReward()
  if not table.IsNullOrEmpty(rewards) then
    self.p_content_reward:SetActive(true)
    self.p_scroll_view:Init(UILWSeasonMilitaryItemCell)
    self.p_scroll_view:Clear()
    self.p_scroll_view:SetFixedItemSize(120, 120)
    for _, reward in pairs(rewards) do
      self.p_scroll_view:AddData(reward)
    end
    self.p_scroll_view:Show()
  else
    self.p_content_reward:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_gain.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_trans_root.transform)
end

function S6MilitaryLevelUpView:InitBenefit()
  local preCell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(checknumber(self.Cell.level) - 1)
  if preCell == nil then
    return
  end
  local goItem, theItem
  for index, descInfo in pairs(self.Cell:GetDescInfos()) do
    goItem = self.itemPool:GameObjectSpawn(self.content.transform)
    goItem.name = UIUtil.GetLoopListItemIndex(string.format("level_%s_benefit_%s_", self.Cell.level, index))
    goItem:SetActive(true)
    theItem = self.content:AddComponent(UILWSeasonMilitaryBenefitCell, goItem.name)
    local preDescInfo = preCell:GetDescInfo(index)
    local fromParam = preDescInfo ~= nil and preDescInfo.Param or 0
    local data = {}
    data.Desc = CS.GameEntry.Localization:GetString(descInfo.DescKey)
    data.FromStr = self.Cell:GetFormatedParam(index, fromParam)
    data.ToStr = descInfo.ParamStr
    data.IsSpecial = checknumber(descInfo.Format) == 3
    data.IsLevelUp = true
    theItem:ReInit(data)
  end
end

function S6MilitaryLevelUpView:Clear()
  self.itemPool:GameObjectRecycleAll()
  self.content:RemoveComponents(UILWSeasonMilitaryBenefitCell)
end

function S6MilitaryLevelUpView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

return S6MilitaryLevelUpView
