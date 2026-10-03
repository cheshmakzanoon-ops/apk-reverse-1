local UIDesertRulesView = BaseClass("UIDesertRulesView", UIBaseView)
local base = UIBaseView
local panel_path = "panel"
local close_btn_path = "PopUpTitle/CloseBtn"
local bg_path = "PopUpTitle/Common_bg_orange2/Bg"
local content_path = "PopUpTitle/Common_bg_orange2/Content"
local toggle_sv_path = "PopUpTitle/Common_bg_orange2/TabListView"
local toggle_path = "PopUpTitle/Common_bg_orange2/TabListView/Viewport/Tab/Toggle%s"
local PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleContent%s.prefab"
local CLS_PATH = "UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.%s"
local DEF_PREFAB_NAME = "Base"
local T_INFOS = {
  {
    "Rule",
    "458129",
    "UIDesertRulesItem1"
  },
  {
    "Build",
    "458130",
    "UIDesertRulesBuildItem"
  },
  {
    "Reward",
    "458131",
    "UIDesertRulesRewardItem",
    "Reward"
  },
  {
    "Other",
    "458132",
    "UIDesertRulesItem1"
  },
  {
    "Skill",
    "150001",
    "UIDesertRulesSkillItem"
  },
  {
    "Role",
    "YiBianJinQu_rules_title_13",
    "UIDesertRulesRoleItem"
  },
  {
    "Score",
    "winter_s0_exp_title",
    "DesertBattleRuleContentScore",
    "Score"
  }
}

function UIDesertRulesView:OnCreate()
  base.OnCreate(self)
  self.toggles = {}
  self.contents = {}
  local param, toggle, subToggle = self:GetUserData()
  self.param = param
  self.targetToggle = toggle
  self.subToggle = subToggle
  self:ComponentDefine()
end

function UIDesertRulesView:OnDestroy()
  self.toggles = {}
  self.contents = {}
  self.param = nil
  self.targetToggle = nil
  self.subToggle = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDesertRulesView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.toggleSV = self:AddComponent(UIScrollRect, toggle_sv_path)
  self.infoGroup = {}
  if self.param == BattleFieldType.EpidemicZone then
    self.infoGroup = {
      BF_GuideTag.Rule,
      BF_GuideTag.Role,
      BF_GuideTag.Build,
      BF_GuideTag.Skill,
      BF_GuideTag.Other
    }
  elseif self.param == BattleFieldType.DsbDuel then
    self.infoGroup = {
      BF_GuideTag.Rule,
      BF_GuideTag.Build,
      BF_GuideTag.Other
    }
  elseif self.param == BattleFieldType.WinterStorm then
    self.infoGroup = {
      BF_GuideTag.Rule,
      BF_GuideTag.Build,
      BF_GuideTag.Score,
      BF_GuideTag.Other
    }
  else
    self.infoGroup = {
      BF_GuideTag.Rule,
      BF_GuideTag.Build,
      BF_GuideTag.Reward,
      BF_GuideTag.Other
    }
  end
  self.toggles = {}
  local targetIdx = self.targetToggle or 1
  local max = 0
  local curIdx = 1
  for i = 1, 5 do
    local realIdx = self.infoGroup[i]
    local toggle = self:AddComponent(UIToggle, string.format(toggle_path, i))
    if realIdx == targetIdx then
      toggle:SetIsOn(true)
      curIdx = i
    end
    toggle:SetOnValueChanged(function(tf)
      if tf then
        self:SetToggleOn(i)
      end
    end)
    self.toggles[i] = toggle
    local info = T_INFOS[realIdx]
    if info ~= nil then
      max = max + 1
      local strKey = info[2]
      local text1 = toggle:AddComponent(UITextMeshProUGUIEx, "text1")
      text1:SetLocalText(strKey)
      local text2 = toggle:AddComponent(UITextMeshProUGUIEx, "Choose/text2")
      text2:SetLocalText(strKey)
    else
      toggle:SetActive(false)
    end
  end
  local toggle = self.toggles[curIdx]
  if not toggle:GetActive() then
    curIdx = 1
    toggle = self.toggles[curIdx]
  end
  local pos = max <= 1 and 0 or (curIdx - 1) / (max - 1)
  self.toggleSV:SetHorizontalNormalizedPosition(pos)
  if toggle then
    self:SetToggleOn(curIdx)
  end
end

function UIDesertRulesView:ComponentDestroy()
  self.btn_back = nil
end

function UIDesertRulesView:RefreshBg()
  local realIdx = self.infoGroup[self.curIdx]
  self.bg:SetOffsetMinXY(0, realIdx == BF_GuideTag.Score and 130 or 0)
end

function UIDesertRulesView:SetToggleOn(idx)
  local lastContent = self.contents[self.curIdx]
  if lastContent ~= nil and lastContent:AsyncLoadDone() then
    lastContent:SetActive(false)
  end
  self.curIdx = idx
  local content = self.contents[self.curIdx]
  if content ~= nil then
    content:SetActive(true)
    self:RefreshBg()
    return
  end
  local realIdx = self.infoGroup[idx]
  local info = T_INFOS[realIdx]
  local cls = string.format(CLS_PATH, info[3])
  local prefab = string.format(PREFAB_PATH, info[4] or DEF_PREFAB_NAME)
  self.contents[idx] = self:LoadComponentAsync(cls, prefab, self.content, function(_, go)
    go.name = info[1]
    content = self.contents[idx]
    local x, y = content:GetOffsetMaxXY()
    content:SetOffsetMaxXY(x, 0)
    x, y = content:GetOffsetMinXY()
    content:SetOffsetMinXY(x, 0)
    content:SetAnchoredPositionXY(0, 0)
    if self.curIdx == idx then
      content:SetActive(true)
      self:RefreshBg()
      content:ReInit(realIdx, self.param, self.subToggle)
    else
      content:SetActive(false)
    end
  end)
end

return UIDesertRulesView
