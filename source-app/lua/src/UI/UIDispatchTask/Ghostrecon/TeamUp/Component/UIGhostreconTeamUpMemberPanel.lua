local base = UIBaseContainer
local UIGhostreconTeamUpMemberPanel = BaseClass("UIGhostreconTeamUpMemberPanel", base)
local Localization = CS.GameEntry.Localization
local UIGhostreconPlayerItem = require("UI.UIDispatchTask.Ghostrecon.Component.UIGhostreconPlayerItem")
local leaderHead_path = "LeaderPanel/LeaderHead"
local nameText_path = "LeaderPanel/NameTxt"
local timeText_path = "LeaderPanel/TimeTxt"
local deleteBtn_path = "LeaderPanel/DeleteBtn"
local memberListBtn_path = "MemberPanel/MemberListBtn"
local member1_path = "MemberPanel/playerHead/player1"
local member2_path = "MemberPanel/playerHead/player2"
local member3_path = "MemberPanel/playerHead/player3"
local member4_path = "MemberPanel/playerHead/player4"

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
  self.leaderHead = self:AddComponent(UIGhostreconPlayerItem, leaderHead_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.timeText = self:AddComponent(UIText, timeText_path)
  self.deleteBtn = self:AddComponent(UIButton, deleteBtn_path)
  self.memberListBtn = self:AddComponent(UIButton, memberListBtn_path)
  self.member1 = self:AddComponent(UIGhostreconPlayerItem, member1_path)
  self.member2 = self:AddComponent(UIGhostreconPlayerItem, member2_path)
  self.member3 = self:AddComponent(UIGhostreconPlayerItem, member3_path)
  self.member4 = self:AddComponent(UIGhostreconPlayerItem, member4_path)
  self.deleteBtn:SetOnClick(Bind(self, self.OnClickDeleteBtn))
  self.memberListBtn:SetOnClick(Bind(self, self.OnClickMemberListBtn))
end

local function ComponentDestroy(self)
  self.leaderHead = nil
  self.nameText = nil
  self.timeText = nil
  self.deleteBtn = nil
  self.memberListBtn = nil
  self.member1 = nil
  self.member2 = nil
  self.member3 = nil
  self.member4 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.taskInfo = nil
end

local function SetData(self, uuid)
  self.uuid = uuid
  self.taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  self.leaderHead:SetData(self.taskInfo.leaderMemberInfo.memberInfo)
  self.nameText:SetText(DataCenter.ActGhostreconManager:GetTeamName(self.taskInfo.leaderMemberInfo.memberInfo.name))
  self.startTime = UITimeManager:GetInstance():GetServerTime() - self.taskInfo.teamStartTime
  for i = 1, 4 do
    if self.taskInfo.memberList and self.taskInfo.noLeaderMemberList[i] then
      self["member" .. i]:SetData(self.taskInfo.noLeaderMemberList[i].memberInfo)
    else
      self["member" .. i]:SetEmpty()
    end
  end
  self:Update1000MS()
end

local function OnClickDeleteBtn(self)
  if self.taskInfo:OwnIsLeader() then
    UIUtil.ShowMessage(Localization:GetString("ghostrecon_059"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.GhostReconDisbandTeam, self.uuid)
      if self.view and self.view.ctrl then
        self.view.ctrl:CloseSelf()
      end
    end)
  else
    UIUtil.ShowMessage(Localization:GetString("ghostrecon_060"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.GhostReconQuitTeam, self.uuid)
      if self.view and self.view.ctrl then
        self.view.ctrl:CloseSelf()
      end
    end)
  end
end

local function OnClickMemberListBtn(self)
  local param = {}
  param.uuid = self.uuid
  param.width = 550
  param.alignObject = self.memberListBtn
  param.yPosFix = 20
  param.showArrow = true
  if self.taskInfo:OwnIsLeader() then
    param.width = 460
  else
    param.width = 400
  end
  param.formTeamUp = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconMemberListTip, {anim = true}, param)
end

local function Update1000MS(self)
  if self.startTime and self.startTime > 0 then
    self.timeText:SetText(Localization:GetString("ghostrecon_008") .. UITimeManager:GetInstance():MilliSecondToFmtString(self.startTime))
    self.startTime = self.startTime + 1000
  end
end

UIGhostreconTeamUpMemberPanel.OnCreate = OnCreate
UIGhostreconTeamUpMemberPanel.OnDestroy = OnDestroy
UIGhostreconTeamUpMemberPanel.OnEnable = OnEnable
UIGhostreconTeamUpMemberPanel.OnDisable = OnDisable
UIGhostreconTeamUpMemberPanel.ComponentDefine = ComponentDefine
UIGhostreconTeamUpMemberPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTeamUpMemberPanel.DataDefine = DataDefine
UIGhostreconTeamUpMemberPanel.DataDestroy = DataDestroy
UIGhostreconTeamUpMemberPanel.SetData = SetData
UIGhostreconTeamUpMemberPanel.OnClickDeleteBtn = OnClickDeleteBtn
UIGhostreconTeamUpMemberPanel.OnClickMemberListBtn = OnClickMemberListBtn
UIGhostreconTeamUpMemberPanel.Update1000MS = Update1000MS
return UIGhostreconTeamUpMemberPanel
