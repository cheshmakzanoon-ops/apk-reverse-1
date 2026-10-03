local LevelContent = BaseClass("LevelContent", UIBaseContainer)
local base = UIBaseContainer
local LevelManager = DataCenter.PlayerLevelManager
local UILevelStage = require("UI.UIPlayerLevel.Component.UILevelStage")
local UILevelBoxTip = require("UI.UIPlayerLevel.Component.UILevelBoxTip")
local Localization = CS.GameEntry.Localization
local season_path = "Season"
local desc_path = "Desc"
local time_path = "Time"
local time_desc_path = "TimeDesc"
local intro_path = "Season/Intro"
local scroll_view_path = "Mask/ScrollView"
local tip_path = "Tip"
local TipOffset = Vector2.New(-40, -13.5)
local ItemWidth = 200 * GetStandardScale()

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.season_text = self:AddComponent(UIText, season_path)
  self.season_text:SetLocalText(120988, "")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season_text.rectTransform)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc_text:SetLocalText(120989)
  self.time_text = self:AddComponent(UIText, time_path)
  self.time_text:SetText("00:00:00")
  self.time_desc_text = self:AddComponent(UIText, time_desc_path)
  self.time_desc_text:SetLocalText(120990)
  self.intro_btn = self:AddComponent(UIButton, intro_path)
  self.intro_btn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.tip = self:AddComponent(UILevelBoxTip, tip_path)
  self.tip.father = self
  self.tip:SetActive(false)
end

local function ComponentDestroy(self)
  self.season_text = nil
  self.desc_text = nil
  self.time_text = nil
  self.intro_btn = nil
  self.scroll_view = nil
  self.tip = nil
end

local function DataDefine(self)
  self.itemList = {}
  self.timer = nil
  self.arrowLevel = -1
end

local function DataDestroy(self)
  self.itemList = nil
  self.arrowLevel = nil
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReceiveLevelReward, self.RefreshLevel)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReceiveLevelReward, self.RefreshLevel)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnCellMoveIn(self, itemObj, index)
  local level = index - 1
  itemObj.name = tostring(level)
  local item = self.scroll_view:AddComponent(UILevelStage, itemObj)
  local template = LevelManager:GetTemplate(level)
  item:SetLevel(level)
  if 0 < level then
    function item.onInfoClick(t)
      self:OnItemInfoClick(t)
    end
    
    self.itemList[template.level] = item
  else
    item.onInfoClick = nil
  end
  if template and template.level == self.arrowLevel and not DataCenter.GuideManager:InGuide() then
    local itemTransform = item.box_btn.gameObject.transform
    TimerManager:GetInstance():DelayInvoke(function()
      local param = {
        arrowType = ArrowType.PlayerLevel,
        positionType = PositionType.Screen,
        position = Vector3.New(itemTransform.position.x, itemTransform.position.y, 0) + Vector3.New(0, 100, 0)
      }
      DataCenter.ArrowManager:ShowArrow(param)
    end, 0.5)
  end
end

local function OnCellMoveOut(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UILevelStage)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = LevelManager:GetMaxLevel()
  if 0 < count then
    self.scroll_view:SetTotalCount(count + 1)
    self.scroll_view:RefillCells()
  end
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILevelStage)
end

local function ReInit(self)
  self:ShowCells()
  local level = LevelManager:GetScrollToLevel()
  if level ~= nil then
    self.arrowLevel = level
  else
    self.arrowLevel = -1
    level = LevelManager:GetFirstOpenLevel() or LevelManager:GetLevel()
  end
  LevelManager:SetScrollToLevel(nil)
  self:ScrollToLevel(level)
end

local function OnIntroClick(self)
  local expLimit = LuaEntry.DataConfig:TryGetNum("player_lv_exp", "k1") or 0
  local dailyExp = DataCenter.PlayerLevelManager:GetDailyExp()
  local str = Localization:GetString("395019", expLimit, dailyExp) .. "\n" .. Localization:GetString("395020") .. "\n" .. Localization:GetString("395021")
  UIUtil.ShowIntro(Localization:GetString("120987"), Localization:GetString("302027"), str)
end

local function OnItemInfoClick(self, item)
  self.tip:SetLevel(item.level)
  self.tip:SetActive(true)
  self.tip.rectTransform.position = item.info_btn.rectTransform.position + TipOffset
end

local function RefreshLevel(self, level)
  if self.itemList[level] then
    self.itemList[level]:SetLevel(level)
  end
end

local function ScrollToLevel(self, level)
  local maxLevel = LevelManager:GetMaxLevel()
  local pos
  if level <= 3 then
    pos = 0
  elseif level >= maxLevel - 2 then
    pos = 1
  else
    local x = (level - 3) * ItemWidth
    local maxX = 5 < maxLevel and (maxLevel - 4.875) * ItemWidth or 1
    pos = x / maxX
  end
  self.scroll_view:SetHorizontalNormalizedPosition(pos)
end

LevelContent.OnCreate = OnCreate
LevelContent.OnDestroy = OnDestroy
LevelContent.ComponentDefine = ComponentDefine
LevelContent.ComponentDestroy = ComponentDestroy
LevelContent.DataDefine = DataDefine
LevelContent.DataDestroy = DataDestroy
LevelContent.OnAddListener = OnAddListener
LevelContent.OnRemoveListener = OnRemoveListener
LevelContent.OnEnable = OnEnable
LevelContent.OnDisable = OnDisable
LevelContent.OnCellMoveIn = OnCellMoveIn
LevelContent.OnCellMoveOut = OnCellMoveOut
LevelContent.ShowCells = ShowCells
LevelContent.ClearScroll = ClearScroll
LevelContent.ReInit = ReInit
LevelContent.OnIntroClick = OnIntroClick
LevelContent.OnItemInfoClick = OnItemInfoClick
LevelContent.RefreshLevel = RefreshLevel
LevelContent.ScrollToLevel = ScrollToLevel
return LevelContent
