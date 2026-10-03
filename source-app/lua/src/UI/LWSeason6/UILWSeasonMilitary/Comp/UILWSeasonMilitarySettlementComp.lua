local p_template_settlement_reward_path = "content/content_settlement_reward/p_template_settlement_reward"
local content_path = "content/content_settlement_reward/Viewport/Content"
local p_text_settlement_time_path = "content/content_Time/p_text_settlement_time"
local p_btn_settlement_info_path = "content/p_btn_settlement_info"
local UILWSeasonMilitaryItemCell = require("UI.LWSeason6.UILWSeasonMilitary.Cell.UILWSeasonMilitaryItemCell")
local base = UIBaseContainer
local UILWSeasonMilitarySettlementComp = BaseClass("UILWSeasonMilitarySettlementComp", UIBaseContainer)

function UILWSeasonMilitarySettlementComp:ComponentDefine()
  self.p_template_settlement_reward = self:AddComponent(UIBaseContainer, p_template_settlement_reward_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.p_text_settlement_time = self:AddComponent(UITextMeshProUGUIEx, p_text_settlement_time_path)
  self.p_btn_settlement_info = self:AddComponent(UIButton, p_btn_settlement_info_path)
  self.p_btn_settlement_info:SetOnClick(BindCallback(self, self.OnInfoClicked))
  self.goTemplate = self.p_template_settlement_reward.gameObject
  self.goTemplate:GameObjectCreatePool()
end

function UILWSeasonMilitarySettlementComp:ComponentDestroy()
  self.goTemplate:GameObjectRecycleAll()
  self.content:RemoveComponents(UILWSeasonMilitaryItemCell)
  self.p_template_settlement_reward = nil
  self.content = nil
  self.p_text_settlement_time = nil
  self.p_btn_settlement_info = nil
end

function UILWSeasonMilitarySettlementComp:DataDefine()
  self.Data = nil
  self.TickAct = false
end

function UILWSeasonMilitarySettlementComp:DataDestroy()
  self.Data = nil
  self.TickAct = false
end

function UILWSeasonMilitarySettlementComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitarySettlementComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitarySettlementComp:OnAddListener()
  base.OnAddListener(self)
end

function UILWSeasonMilitarySettlementComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWSeasonMilitarySettlementComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitarySettlementComp:InitData(data)
  self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
  if self.InfoData ~= nil then
    local actData = DataCenter.SeasonMilitaryManager:GetActData()
    if actData ~= nil then
      self.EndTime = actData:GetShowEndTime()
      self.TickAct = true
    end
    return true
  end
  return false
end

function UILWSeasonMilitarySettlementComp:InitUi()
  self.goTemplate:GameObjectRecycleAll()
  self.content:RemoveComponents(UILWSeasonMilitaryItemCell)
  if self.InfoData.Cell ~= nil then
    local rewards = self.InfoData.Cell:GetFinalRewards()
    if not table.IsNullOrEmpty(rewards) then
      for _, reward in pairs(rewards) do
        local go = self.goTemplate:GameObjectSpawn(self.content.transform)
        go.name = UIUtil.GetLoopListItemIndex("s6_military_settlement_item_")
        go:SetActive(true)
        local comp = self.content:AddComponent(UILWSeasonMilitaryItemCell, go.name)
        comp:ReInit(reward)
      end
    end
  end
end

function UILWSeasonMilitarySettlementComp:OnInfoClicked()
  local desc = CS.GameEntry.Localization:GetString("season_military_settlement_desc")
  local position = self.p_btn_settlement_info.transform.position
  local isTop = true
  UIUtil.ShowBubbleTipsAuto(desc, position, 0, 50, 0, nil, nil, {reversal = isTop})
end

function UILWSeasonMilitarySettlementComp:Update1000MS()
  if not self.TickAct then
    return
  end
  local leftTime = Mathf.Max(0, self.EndTime - UITimeManager:GetInstance():GetServerTime())
  self.p_text_settlement_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
end

return UILWSeasonMilitarySettlementComp
