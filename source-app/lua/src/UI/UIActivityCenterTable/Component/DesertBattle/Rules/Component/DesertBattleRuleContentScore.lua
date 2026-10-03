local base = UIAsyncContainer
local DesertBattleRuleContentScore = BaseClass("DesertBattleRuleContentScore", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleScoreCell.prefab"
local CLS = "UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.DesertBattleRuleScoreCell"

function DesertBattleRuleContentScore:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DesertBattleRuleContentScore:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DesertBattleRuleContentScore:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleTab1 = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.toggleTab2 = self.viewSkin:AddComponent(self, UIToggle, 2)
  self.toggleTab3 = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.textText11 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textText12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textText31 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textText22 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textText21 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textText32 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 10)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.btnAward = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnAward:SetOnClick(function()
    self:OnBtnAwardClick()
  end)
end

function DesertBattleRuleContentScore:ComponentDestroy()
  self.viewSkin = nil
  self.toggleTab1 = nil
  self.toggleTab2 = nil
  self.toggleTab3 = nil
  self.textText11 = nil
  self.textText12 = nil
  self.textText31 = nil
  self.textText22 = nil
  self.textText21 = nil
  self.textText32 = nil
  self.scrollRect = nil
  self.compContent = nil
  self.btnAward = nil
end

function DesertBattleRuleContentScore:DataDefine()
  self.curIdx = 0
  self.items = {}
  self.toggleTab1:SetIsOn(true)
  self.togs = {
    self.toggleTab1,
    self.toggleTab2,
    self.toggleTab3
  }
  self.texts1 = {
    self.textText11,
    self.textText21,
    self.textText31
  }
  self.texts2 = {
    self.textText12,
    self.textText22,
    self.textText32
  }
  for i, toggle in ipairs(self.togs) do
    toggle:SetOnValueChanged(function(isOn)
      if isOn then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnValueChanged(i)
      end
    end)
  end
end

function DesertBattleRuleContentScore:DataDestroy()
  self.curIdx = 0
  self.items = nil
end

function DesertBattleRuleContentScore:OnAddListener()
  base.OnAddListener(self)
end

function DesertBattleRuleContentScore:OnRemoveListener()
  base.OnRemoveListener(self)
end

function DesertBattleRuleContentScore:OnBtnAwardClick()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertRules)
  if BattleFieldUtil.InBattleField() then
    SFSNetwork.SendMessage(MsgDefines.WinterStormBattleRewardScoreInfo)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWinterStormTaskS0)
  end
end

function DesertBattleRuleContentScore:ReInit(theType, battleType, subType)
  self.bfType = battleType
  local rules = BattleFieldUtil.GetRuleList(battleType, theType)
  self.rules = rules
  local max = 0
  local subToggle
  for i, toggle in ipairs(self.togs) do
    local rule = rules[i]
    toggle:SetActive(rule ~= nil)
    if rule ~= nil then
      max = max + 1
      local title = Localization:GetString(rule.new_tag)
      local text1 = self.texts1[i]
      text1:SetText(title)
      local text2 = self.texts2[i]
      text2:SetText(title)
      if subToggle == nil then
        local type = LocalController:instance():getIntValue(TableName.LW_BattleField_RewardPointShow, rule.reward_point, "reward_point_type")
        if type == subType then
          subToggle = i
        end
      end
    end
  end
  local targetToggle = Mathf.Clamp(subToggle or 1, 1, max)
  self.togs[targetToggle]:SetIsOn(true)
  self:OnValueChanged(targetToggle, true)
end

function DesertBattleRuleContentScore:OnValueChanged(idx, bForce)
  if idx == self.curIdx and not bForce then
    return
  end
  self.curIdx = idx
  local rule = self.rules[idx]
  local lineData = LocalController:instance():getLine(TableName.LW_BattleField_RewardPointShow, rule.reward_point)
  self.type = lineData:getValue("reward_point_type") or 0
  self.typeIds = lineData:getValue("type_id_list") or {}
  self.scoreIds = lineData:getValue("score") or {}
  local max = math.max(#self.items, #self.scoreIds)
  for i = 1, max do
    local curI = i
    local item = self.items[i]
    if self.scoreIds[i] ~= nil then
      if item == nil then
        item = self:LoadComponentAsync(CLS, PREFAB, self.compContent, function()
          self:RefreshCell(curI)
        end)
        item:SetSizeDeltaXY(700, 135)
        self.items[i] = item
      else
        item:SetActive(true)
        self:RefreshCell(curI)
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
end

function DesertBattleRuleContentScore:RefreshCell(i)
  local item = self.items[i]
  if item == nil or not item:GetActive() then
    return
  end
  local info = self:GetInfo(i)
  item:SetData(info)
end

function DesertBattleRuleContentScore:GetInfo(i)
  local scoreId = self.scoreIds[i]
  local scoreCfg = LocalController:instance():getLine(TableName.Score, scoreId)
  local typeId = self.typeIds[i]
  local info = {
    value = 0,
    type = self.type,
    score = scoreCfg:getIntValue("points")
  }
  if self.type == BF_RewardPointType.MVP then
    local tbName = BattleFieldUtil.GetBattleFieldCfgValue(self.bfType, BattleFieldTableKey.STAR)
    local lineData = LocalController:instance():getLine(tbName, typeId)
    local icon = lineData:getValue("icon")
    if not string.IsNullOrEmpty(icon) then
      info.icon = string.format(LoadPath.LWBattleFieldMvpPath, icon)
    end
    info.name = Localization:GetString(lineData:getValue("name"))
    info.desc = Localization:GetString(lineData:getValue("desc"), lineData:getValue("score"))
  elseif self.type == BF_RewardPointType.ACHIEVEMENT then
    local lineData = LocalController:instance():getLine(TableName.LW_BattleField_Achievement, typeId)
    if lineData ~= nil then
      local icon = lineData:getValue("icon")
      if not string.IsNullOrEmpty(icon) then
        info.icon = string.format(LoadPath.LWBattleFieldWinterAchievementPath, icon)
      end
      info.name = Localization:GetString(lineData:getValue("name"))
      info.desc = Localization:GetString(lineData:getValue("desc"), lineData:getValue("value"))
    end
  elseif self.type == BF_RewardPointType.RANK then
    local values = string.string2array_i_oneSep(scoreCfg:getValue("value"), "|")
    info.value = values[1]
    info.name = Localization:GetString("winter_s0_rule_1", values[1])
    info.desc = Localization:GetString("winter_s0_final_tips_ranking", values[1], values[2])
  end
  return info
end

return DesertBattleRuleContentScore
