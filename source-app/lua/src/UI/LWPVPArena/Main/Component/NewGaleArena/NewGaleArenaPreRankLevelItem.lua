local NewGaleArenaPreRankLevelItem = BaseClass("NewGaleArenaPreRankLevelItem", UIBaseContainer)
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
  self.selfIcon = self:AddComponent(UIBaseContainer, "SelfIcon")
  self.select = self:AddComponent(UIBaseContainer, "Select")
  self.btnGift = self:AddComponent(UIButton, "GiftBtn")
  self.btnGift:SetOnClick(function()
    self:OnBtnGiftClick()
  end)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
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
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaReward, {anim = true}, self.level, PVPArenaType.NewGaleArena)
end

local function OnBtnClick(self)
  if self.viewChooseLevel ~= self.level then
    SFSNetwork.SendMessage(MsgDefines.GaleArenaGetTopThreeList, self.level)
  end
end

local function Refresh(self, level, viewChooseLevel, isSelfLevel)
  local info = DataCenter.NewGaleArenaManager.info
  self.level = level
  self.viewChooseLevel = viewChooseLevel
  if self.level == NewGaleArenaLevel.Advanced then
    self.textName:SetLocalText("new_arena_tips_3")
    if info.highMaxRank and info.highMinRank then
      self.textPower:SetActive(true)
      self.textPower:SetText(Localization:GetString("new_arena_tips_5") .. " <color=#fdc389>" .. info.highMinRank .. "-" .. info.highMaxRank .. "</color>")
    else
      self.textPower:SetActive(false)
    end
  elseif self.level == NewGaleArenaLevel.Intermediate then
    self.textName:SetLocalText("new_arena_tips_4")
    if info.lowMaxRank and info.lowMinRank then
      self.textPower:SetActive(true)
      self.textPower:SetText(Localization:GetString("new_arena_tips_5") .. " " .. info.lowMinRank .. "-" .. info.lowMaxRank)
    else
      self.textPower:SetActive(false)
    end
  elseif self.level == NewGaleArenaLevel.Basic then
    self.textName:SetLocalText("gale_arena_tips03")
    if info.baseMinRank and info.baseMaxRank then
      self.textPower:SetActive(true)
      self.textPower:SetText(Localization:GetString("new_arena_tips_5") .. " " .. info.baseMinRank .. "-" .. info.baseMaxRank)
    else
      self.textPower:SetActive(false)
    end
  end
  self.select:SetActive(viewChooseLevel == self.level)
  self.selfIcon:SetActive(isSelfLevel)
end

NewGaleArenaPreRankLevelItem.OnCreate = OnCreate
NewGaleArenaPreRankLevelItem.OnDestroy = OnDestroy
NewGaleArenaPreRankLevelItem.OnEnable = OnEnable
NewGaleArenaPreRankLevelItem.OnDisable = OnDisable
NewGaleArenaPreRankLevelItem.ComponentDefine = ComponentDefine
NewGaleArenaPreRankLevelItem.ComponentDestroy = ComponentDestroy
NewGaleArenaPreRankLevelItem.DataDefine = DataDefine
NewGaleArenaPreRankLevelItem.DataDestroy = DataDestroy
NewGaleArenaPreRankLevelItem.OnAddListener = OnAddListener
NewGaleArenaPreRankLevelItem.OnRemoveListener = OnRemoveListener
NewGaleArenaPreRankLevelItem.OnBtnGiftClick = OnBtnGiftClick
NewGaleArenaPreRankLevelItem.OnBtnClick = OnBtnClick
NewGaleArenaPreRankLevelItem.Refresh = Refresh
return NewGaleArenaPreRankLevelItem
