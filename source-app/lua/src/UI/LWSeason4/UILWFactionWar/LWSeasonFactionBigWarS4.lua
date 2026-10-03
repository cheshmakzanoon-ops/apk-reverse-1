local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWSeasonFactionBigWarS4 = BaseClass("LWSeasonFactionBigWarS4", base)
local Localization = CS.GameEntry.Localization
local RuleItem = require("UI.LWSeason4.UILWFactionWar.Component.UILWSeasonFactionWarRuleItemS4")
local btn_rule_path = "Top/BtnRule"
local act_title_path = "Top/act_title"
local title_path = "Top/title"
local time_text_path = "Top/TimeBg/TimeText"
local tips_path = "BottomBar/Tips"
local scroll_view_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local desc_text_path = "ScrollView/Viewport/Content/DescText"
local time_item_path = "ScrollView/Viewport/Content/TimeItem"

function LWSeasonFactionBigWarS4:OnCreate()
  base.OnCreate(self)
  self.btn_rule = self:AddComponent(UIButton, btn_rule_path)
  self.act_title = self:AddComponent(UITextMeshProUGUIEx, act_title_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.btn_rule:SetOnClick(function()
    if self.activityData ~= nil and self.activityData.story ~= nil then
      local msg = Localization:GetString(self.activityData.story)
      UIUtil.ShowDetail(msg, nil, nil, true, true)
    end
  end)
  self.title:SetText("")
  self.tips:SetText("")
  self.time_text:SetText("")
  self.act_title:SetLocalText("season_s2_trends_name23")
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.theItem = self.transform:Find(time_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.scroll_view:SetVerticalNormalizedPosition(1)
end

function LWSeasonFactionBigWarS4:OnDestroy()
  self.content:RemoveComponents(RuleItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_rule = nil
  self.act_title = nil
  self.title = nil
  self.time_text = nil
  self.tips = nil
  self.scroll_view = nil
  self.content = nil
  self.desc_text = nil
  self.time_item = nil
  base.OnDestroy(self)
end

function LWSeasonFactionBigWarS4:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actData then
    self.activityData = actData
    self.act_title:SetLocalText(actData.name)
    self.tips:SetLocalText(actData.desc_info)
    self.tips:SetActive(true)
    self.desc_text:SetLocalText(actData.desc_info)
    self.desc_text:SetActive(false)
  end
  local timeInfos = DataCenter.SeasonFactionWarDataManager.timeInfos
  if timeInfos then
    local roundNow = 0
    local actInfo = DataCenter.SeasonFactionWarDataManager:GetDeclareWarActInfo()
    if actInfo then
      roundNow = actInfo.round
    end
    table.sort(timeInfos, function(a, b)
      return a.round < b.round
    end)
    local goItem, theItem
    for k, v in ipairs(timeInfos) do
      if v.round > 4 then
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = "round_" .. k
        goItem:SetActive(true)
        theItem = self.content:AddComponent(RuleItem, goItem.name)
        theItem:ReInit(k, roundNow, v)
      end
    end
    self.scroll_view:SetActive(true)
  else
    self.scroll_view:SetActive(false)
  end
end

return LWSeasonFactionBigWarS4
