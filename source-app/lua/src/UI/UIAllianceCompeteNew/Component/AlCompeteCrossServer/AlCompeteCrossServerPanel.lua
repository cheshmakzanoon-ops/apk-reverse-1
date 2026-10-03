local base = UIBaseView
local AlCompeteCrossServerPanel = BaseClass("AlCompeteCrossServerPanel", base)
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
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
local infoBtn_path = "rightLayer/infoBtn"

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
  self.titleN:SetText(Localization:GetString("110214"))
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetText(Localization:GetString("372418"))
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
  self.attackTipN = self:AddComponent(UIText, attackTip_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
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
  if self:IsMoveToAttack() then
    self.attackBtnTxtN:SetLocalText(100150)
  else
    self.attackBtnTxtN:SetLocalText(GameDialogDefine.BACK)
  end
end

local function RefreshAll(self)
  self:SetTimeTip()
  local isMoveToAttack = self:IsMoveToAttack()
  local myAllianceId = LuaEntry.Player.allianceId
  local allianceList = self.eventInfo.vsAllianceList
  table.walk(allianceList, function(k, v)
    local name = string.format("#%s [%s] %s", v.serverId, v.abbr, v.alName)
    if k == myAllianceId then
      self.alNameLN:SetText(name)
      self.allianceFlagLN:SetData(v.icon)
      if not isMoveToAttack then
        self.attackTipN:SetText(Localization:GetString("372419", v.serverId, v.abbr))
      end
    else
      self.alNameRN:SetText(name)
      self.allianceFlagRN:SetData(v.icon)
      if isMoveToAttack then
        self.attackTipN:SetText(Localization:GetString("372419", v.serverId, v.abbr))
      end
    end
  end)
end

local function SetTimeTip(self)
  local _, startT, endT = self.eventInfo:CheckIfShowCrossServer()
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
    if self:IsMoveToAttack() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteTips, DataCenter.AllianceCompeteDataManager:GetFightServerId(), 1)
    elseif LuaEntry.Player.crossFightSrcServerId ~= -1 then
      GoToUtil.CloseAllWindows()
      local pointId = LuaEntry.Player:GetMainWorldPos()
      local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      position.x = position.x - 1
      position.y = position.y
      position.z = position.z - 1
      GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
        local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
        if mainBuild ~= nil then
          local city = CS.SceneManager.World:GetWorldBuildingByUuid(mainBuild.uuid)
          if city ~= nil then
            city:SetMoveState(true)
          end
          CS.SceneManager.World:UICreateBuilding(BuildingTypes.FUN_BUILD_MAIN, mainBuild.uuid, pointId, PlaceBuildType.MoveCity)
        end
      end, LuaEntry.Player.crossFightSrcServerId)
    end
  elseif self.curStatus == 1 then
    UIUtil.ShowTips(Localization:GetString("E100172"))
  elseif self.curStatus == 3 then
    UIUtil.ShowTips(Localization:GetString("370100"))
  end
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("110214"), Localization:GetString("110223"), Localization:GetString("110221"))
end

local function OnGotoPoint(self, data)
end

function AlCompeteCrossServerPanel:IsMoveToAttack()
  if LuaEntry.Player.crossFightSrcServerId == -1 or LuaEntry.Player.serverId ~= DataCenter.AllianceCompeteDataManager:GetFightServerId() then
    return true
  end
  return false
end

AlCompeteCrossServerPanel.OnCreate = OnCreate
AlCompeteCrossServerPanel.OnDestroy = OnDestroy
AlCompeteCrossServerPanel.OnAddListener = OnAddListener
AlCompeteCrossServerPanel.OnRemoveListener = OnRemoveListener
AlCompeteCrossServerPanel.ComponentDefine = ComponentDefine
AlCompeteCrossServerPanel.ComponentDestroy = ComponentDestroy
AlCompeteCrossServerPanel.DataDefine = DataDefine
AlCompeteCrossServerPanel.DataDestroy = DataDestroy
AlCompeteCrossServerPanel.ShowPanel = ShowPanel
AlCompeteCrossServerPanel.RefreshAll = RefreshAll
AlCompeteCrossServerPanel.SetTimeTip = SetTimeTip
AlCompeteCrossServerPanel.AddTimer = AddTimer
AlCompeteCrossServerPanel.SetRemainTime = SetRemainTime
AlCompeteCrossServerPanel.DelTimer = DelTimer
AlCompeteCrossServerPanel.OnClickAttackBtn = OnClickAttackBtn
AlCompeteCrossServerPanel.OnClickInfoBtn = OnClickInfoBtn
AlCompeteCrossServerPanel.OnGotoPoint = OnGotoPoint
return AlCompeteCrossServerPanel
