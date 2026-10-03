local UILW3V3BattleResultItem = BaseClass("UILW3V3BattleResultItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local UIGray = CS.UIGray
local UILW3V3BattleResultTeamItem = require("UI.UIArena3V3BattleResult.Component.UILW3V3BattleResultTeamItem")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")

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
  self.playBtn = self:AddComponent(UIButton, "playBtn")
  self.playBtn:SetOnClick(function()
    self:OnPlayBtnClick()
  end)
  self.blueTeam = self:AddComponent(UILW3V3BattleResultTeamItem, "blueTeam")
  self.redTeam = self:AddComponent(UILW3V3BattleResultTeamItem, "redTeam")
end

local function ComponentDestroy(self)
  self.playBtn = nil
  self.blueTeam = nil
  self.redTeam = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, data)
  self.data = data
  self.blueTeam:SetData(self.data.selfData)
  self.redTeam:SetData(self.data.otherData)
end

local function OnPlayBtnClick(self)
  if not self.data then
    return
  end
  local mailUid = self.data.mailUid
  if mailUid then
    if not MailParseHelper.CheckMailBattleReportIntegrity(mailUid, true) then
      UIUtil.ShowTipsId(GameDialogDefine.BATTLE_REPORT_LOADING)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, mailUid, "3V3Record", self.data.recordTime)
    DataCenter.MailDataManager:ReadMail(mailUid)
  end
end

UILW3V3BattleResultItem.OnCreate = OnCreate
UILW3V3BattleResultItem.OnDestroy = OnDestroy
UILW3V3BattleResultItem.ComponentDefine = ComponentDefine
UILW3V3BattleResultItem.ComponentDestroy = ComponentDestroy
UILW3V3BattleResultItem.DataDefine = DataDefine
UILW3V3BattleResultItem.DataDestroy = DataDestroy
UILW3V3BattleResultItem.OnEnable = OnEnable
UILW3V3BattleResultItem.OnDisable = OnDisable
UILW3V3BattleResultItem.SetData = SetData
UILW3V3BattleResultItem.OnPlayBtnClick = OnPlayBtnClick
return UILW3V3BattleResultItem
