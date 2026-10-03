local NewPeakArenaPreRankLevelItem = BaseClass("NewPeakArenaPreRankLevelItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textName = self:AddComponent(UIText, "NameText")
  self.textPower = self:AddComponent(UIText, "PowerText")
  self.btnGift = self:AddComponent(UIButton, "GiftBtn")
  self.btnGift:SetOnClick(function()
    self:OnBtnGiftClick()
  end)
end

local function ComponentDestroy(self)
  self.textName = nil
  self.textPower = nil
  self.btnGift = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.level = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnGiftClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaReward, {anim = true}, self.level, PVPArenaType.NewPeakArena)
end

local function Refresh(self, level)
  local info = DataCenter.NewPeakArenaManager.info
  self.level = level
  local splitChar
  if Localization:GetLanguage() == Language.German then
    splitChar = "\n"
  else
    splitChar = " "
  end
  if self.level == NewPeakArenaLevel.Advanced then
    self.textName:SetLocalText("new_arena_tips_3")
    if info.highMaxRank and info.highMinRank then
      self.textPower:SetActive(true)
      self.textPower:SetText(Localization:GetString("new_arena_tips_5") .. splitChar .. "<color=#fdc389>" .. info.highMinRank .. "-" .. info.highMaxRank .. "</color>")
    else
      self.textPower:SetActive(false)
    end
  elseif self.level == NewPeakArenaLevel.Intermediate then
    self.textName:SetLocalText("new_arena_tips_4")
    if info.lowMaxRank and info.lowMinRank then
      self.textPower:SetActive(true)
      self.textPower:SetText(Localization:GetString("new_arena_tips_5") .. splitChar .. info.lowMinRank .. "-" .. info.lowMaxRank)
    else
      self.textPower:SetActive(false)
    end
  end
end

NewPeakArenaPreRankLevelItem.OnCreate = OnCreate
NewPeakArenaPreRankLevelItem.OnDestroy = OnDestroy
NewPeakArenaPreRankLevelItem.OnEnable = OnEnable
NewPeakArenaPreRankLevelItem.OnDisable = OnDisable
NewPeakArenaPreRankLevelItem.ComponentDefine = ComponentDefine
NewPeakArenaPreRankLevelItem.ComponentDestroy = ComponentDestroy
NewPeakArenaPreRankLevelItem.DataDefine = DataDefine
NewPeakArenaPreRankLevelItem.DataDestroy = DataDestroy
NewPeakArenaPreRankLevelItem.OnAddListener = OnAddListener
NewPeakArenaPreRankLevelItem.OnRemoveListener = OnRemoveListener
NewPeakArenaPreRankLevelItem.OnBtnGiftClick = OnBtnGiftClick
NewPeakArenaPreRankLevelItem.Refresh = Refresh
return NewPeakArenaPreRankLevelItem
