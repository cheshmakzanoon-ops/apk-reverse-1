local LeagueMatchAllianceItem = BaseClass("LeagueMatchAllianceItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local flag_path = "AllianceFlag"
local alName_path = "alName"
local leaderName_path = "leaderName"
local countryImg_path = "country"
local power_path = "power"
local btn_path = "Button"

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
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, flag_path)
  self.alNameN = self:AddComponent(UIText, alName_path)
  self.leaderNameN = self:AddComponent(UIText, leaderName_path)
  self.countryImgN = self:AddComponent(UIImage, countryImg_path)
  self.powerN = self:AddComponent(UIText, power_path)
  self.btnN = self:AddComponent(UIButton, btn_path)
  self.btnN:SetOnClick(function()
    self:OnClickBtn()
  end)
end

local function ComponentDestroy(self)
  self.allianceFlagN = nil
  self.alNameN = nil
  self.leaderNameN = nil
  self.countryImgN = nil
  self.powerN = nil
  self.btnN = nil
end

local function DataDefine(self)
  self.allianceInfo = nil
end

local function DataDestroy(self)
  self.allianceInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, alInfo)
  self.allianceInfo = alInfo
  self.allianceFlagN:SetData(alInfo.icon)
  self.alNameN:SetText("#" .. alInfo.serverId .. " [" .. alInfo.abbr .. "] ")
  self.leaderNameN:SetLocalText(390082, alInfo.leaderName)
  self.countryImgN:LoadSprite(alInfo:GetCountryFlagPath())
  self.powerN:SetText(string.GetFormattedSeperatorNum(alInfo.fightPower))
end

local function OnClickBtn(self)
end

LeagueMatchAllianceItem.OnCreate = OnCreate
LeagueMatchAllianceItem.OnDestroy = OnDestroy
LeagueMatchAllianceItem.ComponentDefine = ComponentDefine
LeagueMatchAllianceItem.ComponentDestroy = ComponentDestroy
LeagueMatchAllianceItem.DataDefine = DataDefine
LeagueMatchAllianceItem.DataDestroy = DataDestroy
LeagueMatchAllianceItem.OnAddListener = OnAddListener
LeagueMatchAllianceItem.OnRemoveListener = OnRemoveListener
LeagueMatchAllianceItem.SetItem = SetItem
LeagueMatchAllianceItem.OnClickBtn = OnClickBtn
return LeagueMatchAllianceItem
