local base = UIBaseView
local AlCompeteCrossDesertServerPanel = BaseClass("AlCompeteCrossDesertServerPanel", base)
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local AllianceFlag = require("UI.UIAllianceCompeteNew.Component.AlCompeteCrossServer.AllianceFlag")
local title_path = "startGo/middleGo/titleTxt"
local subTitle_path = "startGo/middleGo/desTxt"
local actTime_path = "startGo/middleGo/timeTxt"
local cdTip_path = "startGo/middleGo/timeTxt/cdTip"
local cdTime_path = "startGo/middleGo/timeTxt/cdTxt"
local allianceFlagL_path = "startGo/redGo/redAllianceIcon/AllianceFlagRed"
local allianceFlagR_path = "startGo/blueGo/blueAllianceIcon/AllianceFlagBlue"
local alNameL_path = "startGo/redGo/redAllianceGo/redAllianceNameTxt"
local alNameR_path = "startGo/blueGo/blueAllianceGo/blueAllianceNameTxt"
local attackBtn_path = "startGo/attackBtn"
local attackBtnTxt_path = "startGo/attackBtn/attackTxt"
local attackTip_path = "startGo/attackTip"
local allianceFlag_path = "startGo/allianceFlag"
local infoBtn_path = "startGo/middleGo/titleTxt/infoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DelTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  if SeasonUtil.IsInSeason() then
    self.titleN:SetText(Localization:GetString("110559"))
  else
    self.titleN:SetText(Localization:GetString("110214"))
  end
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  if SeasonUtil.IsInSeason() then
    self.subTitleN:SetText(Localization:GetString("110560"))
  else
    self.subTitleN:SetText(Localization:GetString("372418"))
  end
  self.actTimeN = self:AddComponent(UIBaseContainer, actTime_path)
  self.cdTipN = self:AddComponent(UIText, cdTip_path)
  self.cdTimeN = self:AddComponent(UIText, cdTime_path)
  self.allianceFlagLN = self:AddComponent(AllianceFlagItem, allianceFlagL_path)
  self.allianceFlagRN = self:AddComponent(AllianceFlagItem, allianceFlagR_path)
  self.alNameLN = self:AddComponent(UIText, alNameL_path)
  self.alNameRN = self:AddComponent(UIText, alNameR_path)
  self.attackBtnN = self:AddComponent(UIButton, attackBtn_path)
  self.attackBtnN:SetOnClick(function()
    self:OnClickAttackBtn()
  end)
  self.attackBtnTxtN = self:AddComponent(UIText, attackBtnTxt_path)
  self.attackBtnTxtS = self:AddComponent(UIShadow, attackBtnTxt_path)
  self.attackBtnTxtN:SetLocalText(100150)
  self.attackTipN = self:AddComponent(UIText, attackTip_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.allianceFlagObj = self:AddComponent(AllianceFlag, allianceFlag_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.subTitleN = nil
  self.cdTipN = nil
  self.cdTimeN = nil
  self.allianceFlagLN = nil
  self.allianceFlagRN = nil
  self.alNameLN = nil
  self.alNameRN = nil
  self.attackBtnN = nil
  self.attackBtnTxtN = nil
  self.attackTipN = nil
  self.infoBtnN = nil
end

local function DataDefine(self)
  self.activityInfo = nil
  self.eventInfo = nil
  self.isCrossServerOpen = nil
  self.curStatus = nil
end

local function DataDestroy(self)
  self.activityInfo = nil
  self.eventInfo = nil
  self.isCrossServerOpen = nil
  self.curStatus = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ShowPanel(self)
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
  if not self.activityInfo then
    return
  end
  self.eventInfo = self.activityInfo:GetEventInfo()
  if not self.eventInfo then
    return
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  self:SetTimeTip()
  local myAllianceId = LuaEntry.Player.allianceId
  local allianceList = self.eventInfo.vsAllianceList
  table.walk(allianceList, function(k, v)
    local name = string.format("#%s [%s] %s", v.serverId, v.abbr, v.alName)
    if k == myAllianceId then
      self.alNameLN:SetText(name)
      self.allianceFlagLN:SetData(v.icon)
    else
      self.alNameRN:SetText(name)
      self.allianceFlagRN:SetData(v.icon)
      self.attackTipN:SetText(Localization:GetString("372419", v.serverId, v.abbr))
    end
  end)
end

local function SetTimeTip(self)
  local _, startT, endT = self.eventInfo:CheckIfShowCrossDesert()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if startT > serverTime then
    self.cdTipN:SetText(Localization:GetString("372114"))
    self.endTime = startT
    self.cdTimeN:SetActive(true)
    self:AddTimer()
    CS.UIGray.SetGray(self.attackBtnN.transform, true, true)
    self.attackBtnTxtS:SetAllColor(YellowBtnShadowGrayColor)
    self.isCrossServerOpen = false
    self.curStatus = 1
  elseif endT > serverTime then
    self.cdTipN:SetText(Localization:GetString("372420"))
    self.endTime = endT
    self.cdTimeN:SetActive(true)
    self:AddTimer()
    CS.UIGray.SetGray(self.attackBtnN.transform, false, true)
    self.attackBtnTxtS:SetAllColor(GreenBtnShadowLightColor)
    self.isCrossServerOpen = true
    self.curStatus = 2
  else
    self.endTime = nil
    self.cdTipN:SetText(Localization:GetString("370100"))
    self.cdTimeN:SetActive(false)
    self:DelTimer()
    CS.UIGray.SetGray(self.attackBtnN.transform, true, true)
    self.attackBtnTxtS:SetAllColor(YellowBtnShadowGrayColor)
    self.isCrossServerOpen = false
    self.curStatus = 3
  end
end

local function AddTimer(self)
  function self.TimerAction()
    self:SetRemainTime()
  end
  
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
  self:SetRemainTime()
end

local function SetRemainTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.endTime then
    local remainT = self.endTime - curTime
    if 0 < remainT then
      self.cdTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainT))
    else
      self:DelTimer()
      self:SetTimeTip()
    end
  else
    self:SetTimeTip()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickAttackBtn(self)
  if self.curStatus == 2 then
    if CrossServerUtil.GetCrossServerIsInSameSeason() == false then
      UIUtil.ShowTips(Localization:GetString("372604"))
    else
      local fightServerId = DataCenter.AllianceCompeteDataManager:GetFightServerId()
      if 0 < fightServerId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteTips, fightServerId, 2)
      end
    end
  elseif self.curStatus == 1 then
    UIUtil.ShowTips(Localization:GetString("E100172"))
  elseif self.curStatus == 3 then
    UIUtil.ShowTips(Localization:GetString("370100"))
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("110214"), Localization:GetString("110223"), Localization:GetString("110550"))
end

AlCompeteCrossDesertServerPanel.OnCreate = OnCreate
AlCompeteCrossDesertServerPanel.OnDestroy = OnDestroy
AlCompeteCrossDesertServerPanel.OnAddListener = OnAddListener
AlCompeteCrossDesertServerPanel.OnRemoveListener = OnRemoveListener
AlCompeteCrossDesertServerPanel.ComponentDefine = ComponentDefine
AlCompeteCrossDesertServerPanel.ComponentDestroy = ComponentDestroy
AlCompeteCrossDesertServerPanel.DataDefine = DataDefine
AlCompeteCrossDesertServerPanel.DataDestroy = DataDestroy
AlCompeteCrossDesertServerPanel.ShowPanel = ShowPanel
AlCompeteCrossDesertServerPanel.RefreshAll = RefreshAll
AlCompeteCrossDesertServerPanel.SetTimeTip = SetTimeTip
AlCompeteCrossDesertServerPanel.AddTimer = AddTimer
AlCompeteCrossDesertServerPanel.SetRemainTime = SetRemainTime
AlCompeteCrossDesertServerPanel.DelTimer = DelTimer
AlCompeteCrossDesertServerPanel.OnClickAttackBtn = OnClickAttackBtn
AlCompeteCrossDesertServerPanel.OnClickInfoBtn = OnClickInfoBtn
return AlCompeteCrossDesertServerPanel
