local LeagueMatchResultVsItem = BaseClass("LeagueMatchResultVsItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local alNameL_path = "allianceL/nameL"
local resultWinL_path = "allianceL/resultWinL"
local resultLoseL_path = "allianceL/resultLoseL"
local allianceFlagL_path = "allianceL/AllianceFlagL"
local alNameR_path = "allianceR/nameR"
local resultWinR_path = "allianceR/resultWinR"
local resultLoseR_path = "allianceR/resultLoseR"
local allianceFlagR_path = "allianceR/AllianceFlagR"
local vs_path = "VS"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.alNameLN = self:AddComponent(UIText, alNameL_path)
  self.resultWinLN = self:AddComponent(UIText, resultWinL_path)
  self.resultWinLN:SetLocalText(390186)
  self.resultLoseLN = self:AddComponent(UIText, resultLoseL_path)
  self.resultLoseLN:SetLocalText(390187)
  self.allianceFlagLN = self:AddComponent(AllianceFlagItem, allianceFlagL_path)
  self.alNameRN = self:AddComponent(UIText, alNameR_path)
  self.resultWinRN = self:AddComponent(UIText, resultWinR_path)
  self.resultWinRN:SetLocalText(390186)
  self.resultLoseRN = self:AddComponent(UIText, resultLoseR_path)
  self.resultLoseRN:SetLocalText(390187)
  self.allianceFlagRN = self:AddComponent(AllianceFlagItem, allianceFlagR_path)
  self.vsN = self:AddComponent(UIText, vs_path)
  self.vsN:SetText("vs")
end

local function ComponentDestroy(self)
  self.alNameLN = nil
  self.alNameRN = nil
  self.vsN = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, alL, alR, weekIndex)
  self.alNameLN:SetText("#" .. alL.serverId .. " [" .. alL.abbr .. "] ")
  self.alNameRN:SetText("#" .. alR.serverId .. " [" .. alR.abbr .. "] ")
  self.allianceFlagLN:SetData(alL.icon)
  self.allianceFlagRN:SetData(alR.icon)
  self.vsN:SetText("vs")
  local resultL = string.split(alL.roundResult, ";")
  local isLWin = weekIndex <= #resultL and resultL[weekIndex] or "1"
  isLWin = isLWin == "1"
  self.resultWinLN:SetActive(isLWin)
  self.resultLoseLN:SetActive(not isLWin)
  self.resultWinRN:SetActive(not isLWin)
  self.resultLoseRN:SetActive(isLWin)
end

LeagueMatchResultVsItem.OnCreate = OnCreate
LeagueMatchResultVsItem.OnDestroy = OnDestroy
LeagueMatchResultVsItem.ComponentDefine = ComponentDefine
LeagueMatchResultVsItem.ComponentDestroy = ComponentDestroy
LeagueMatchResultVsItem.DataDefine = DataDefine
LeagueMatchResultVsItem.DataDestroy = DataDestroy
LeagueMatchResultVsItem.OnAddListener = OnAddListener
LeagueMatchResultVsItem.OnRemoveListener = OnRemoveListener
LeagueMatchResultVsItem.SetItem = SetItem
return LeagueMatchResultVsItem
