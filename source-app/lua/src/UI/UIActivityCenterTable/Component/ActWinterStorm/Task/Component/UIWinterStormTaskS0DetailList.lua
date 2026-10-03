local base = UIAsyncContainer
local UIWinterStormTaskS0DetailList = BaseClass("UIWinterStormTaskS0DetailList", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local PREFAB = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/RulesCells/DesertBattleRuleScoreCell.prefab"
local CLS = "UI.UIActivityCenterTable.Component.DesertBattle.Rules.Component.DesertBattleRuleScoreCell"

function UIWinterStormTaskS0DetailList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIWinterStormTaskS0DetailList:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWinterStormTaskS0DetailList:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.btnTop = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnTop:SetOnClick(function()
    self:OnBtnTopClick()
  end)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 4)
end

function UIWinterStormTaskS0DetailList:ComponentDestroy()
  self.viewSkin = nil
  self.compContent = nil
  self.btnTop = nil
  self.textDesc = nil
  self.scrollRect = nil
end

function UIWinterStormTaskS0DetailList:DataDefine()
  self.items = {}
end

function UIWinterStormTaskS0DetailList:DataDestroy()
  self.pointType = nil
  self.items = nil
end

function UIWinterStormTaskS0DetailList:OnAddListener()
  base.OnAddListener(self)
end

function UIWinterStormTaskS0DetailList:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIWinterStormTaskS0DetailList:OnBtnTopClick()
  EventManager:GetInstance():Broadcast(EventId.WinterStormTaskDetailShow, BF_RewardPointType.None)
end

function UIWinterStormTaskS0DetailList:ShowDetail(pointType)
  self.pointType = pointType
  self:RefreshView()
end

function UIWinterStormTaskS0DetailList:UpdateData()
  if self.pointType == nil then
    return
  end
  self:SetActive(true)
  self.bfType = BattleFieldType.WinterStorm
  local rules = BattleFieldUtil.GetRuleList(self.bfType, BF_GuideTag.Score)
  local lineData
  for _, rule in ipairs(rules) do
    local line = LocalController:instance():getLine(TableName.LW_BattleField_RewardPointShow, rule.reward_point)
    local type = line:getIntValue("reward_point_type")
    if type == self.pointType then
      lineData = line
      self.textDesc:SetLocalText(line:getValue("reward_desc"))
      break
    end
  end
  if lineData == nil then
    return
  end
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
        item:SetSizeDeltaXY(670, 135)
        self.items[i] = item
      else
        item:SetActive(true)
        self:RefreshCell(curI)
      end
    elseif item ~= nil then
      item:SetActive(false)
    end
  end
  self.scrollRect:SetVerticalNormalizedPosition(1)
end

function UIWinterStormTaskS0DetailList:RefreshCell(i)
  local item = self.items[i]
  if item == nil or not item:GetActive() then
    return
  end
  local info = self:GetInfo(i)
  item:SetData(info)
end

function UIWinterStormTaskS0DetailList:GetInfo(i)
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

return UIWinterStormTaskS0DetailList
