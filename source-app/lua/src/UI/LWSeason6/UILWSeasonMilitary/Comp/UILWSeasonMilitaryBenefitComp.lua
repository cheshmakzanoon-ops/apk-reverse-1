local p_text_benefit_title_path = "title/p_text_benefit_title"
local p_template_benefit_path = "content/scrollView/p_template_benefit"
local content_path = "content/scrollView/Viewport/Content"
local p_btn_reward_box_path = "title/p_btn_reward_box"
local base = UIBaseContainer
local UILWSeasonMilitaryBenefitCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryBenefitCell")
local S6MilitaryRewardTipsView = require("UI.LWSeason6.UILWSeasonMilitary.RewardTips.View.S6MilitaryRewardTipsView")
local UILWSeasonMilitaryBenefitComp = BaseClass("UILWSeasonMilitaryBenefitComp", UIBaseContainer)

function UILWSeasonMilitaryBenefitComp:ComponentDefine()
  self.p_text_benefit_title = self:AddComponent(UITextMeshProUGUIEx, p_text_benefit_title_path)
  self.p_template_benefit = self:AddComponent(UIImage, p_template_benefit_path)
  self.content = self:AddComponent(UIGameObjectPoolRoot, content_path)
  self.p_btn_reward_box = self:AddComponent(UIButton, p_btn_reward_box_path)
  self.p_btn_reward_box:SetOnClick(BindCallback(self, self.OnBoxClicked))
end

function UILWSeasonMilitaryBenefitComp:ComponentDestroy()
  self.content:Clear()
  self.p_text_benefit_title = nil
  self.p_btn_reward_box = nil
  self.p_template_benefit = nil
  self.content = nil
end

function UILWSeasonMilitaryBenefitComp:DataDefine()
end

function UILWSeasonMilitaryBenefitComp:DataDestroy()
end

function UILWSeasonMilitaryBenefitComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryBenefitComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryBenefitComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitaryBenefitComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitaryBenefitComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryBenefitComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.Cell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(self.Data.Level)
    if self.Cell ~= nil then
      self.Rewards = self.Cell:GetLevelUpReward()
      return true
    end
  end
  return false
end

function UILWSeasonMilitaryBenefitComp:InitUi()
  self.content:Init(self.p_template_benefit.gameObject, UILWSeasonMilitaryBenefitCell)
  if self.Data.IsUpgrade then
    self.p_text_benefit_title:SetLocalText("season_military_benefit")
    self:ShowPreviewBenefit()
  elseif self.Data.IsPreview then
    self.p_text_benefit_title:SetLocalText("season_military_benefit_preview")
    self:ShowCurBenefit()
  else
    self.p_text_benefit_title:SetLocalText("season_military_benefit")
    self:ShowCurBenefit()
  end
  self:InitRewardBox(self.Data.IsPreview or self.Data.IsUpgrade)
end

function UILWSeasonMilitaryBenefitComp:InitRewardBox(isUpgrade)
  self.p_btn_reward_box:SetActive(isUpgrade and not table.IsNullOrEmpty(self.Rewards))
end

function UILWSeasonMilitaryBenefitComp:ShowCurBenefit()
  self.content:Clear()
  for index, descInfo in pairs(self.Cell:GetDescInfos()) do
    local data = {}
    data.Desc = CS.GameEntry.Localization:GetString(descInfo.DescKey)
    data.FromStr = descInfo.ParamStr
    data.ToStr = ""
    data.Index = index
    self.content:AddData(data)
  end
end

function UILWSeasonMilitaryBenefitComp:ShowPreviewBenefit()
  self.content:Clear()
  local nextCell = DataCenter.SeasonMilitaryManager:GetLevelCellTmp(checknumber(self.Cell.level) + 1)
  if nextCell == nil then
    self:ShowCurBenefit()
    return
  end
  for index, descInfo in pairs(nextCell:GetDescInfos()) do
    local curDescInfo = self.Cell:GetDescInfo(index)
    local fromParam = curDescInfo ~= nil and curDescInfo.Param or 0
    local data = {}
    data.Desc = CS.GameEntry.Localization:GetString(descInfo.DescKey)
    data.FromStr = nextCell:GetFormatedParam(index, fromParam)
    data.ToStr = descInfo.ParamStr
    data.IsSpecial = checknumber(descInfo.Format) == 3
    data.Index = index
    self.content:AddData(data)
  end
end

function UILWSeasonMilitaryBenefitComp:OnBoxClicked()
  if not table.IsNullOrEmpty(self.Rewards) then
    local param = S6MilitaryRewardTipsView.ParamDataClass.New()
    param.position = self.p_btn_reward_box:GetPosition()
    param.deltaY = 0
    param.rewardList = self.Rewards
    param.title = "season_military_promote_box_desc"
    param.deltaX = -35
    if CommonUtil.IsArabicAutoMirrorOpen() then
      param.dir = S6MilitaryRewardTipsView.Direction.LEFT
    else
      param.dir = S6MilitaryRewardTipsView.Direction.RIGHT
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6MilitaryRewardTipsView, {anim = false}, param)
  end
end

return UILWSeasonMilitaryBenefitComp
