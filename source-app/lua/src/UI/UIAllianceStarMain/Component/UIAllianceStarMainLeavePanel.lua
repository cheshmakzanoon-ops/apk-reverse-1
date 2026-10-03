local UIAllianceStarMainLeavePanel = BaseClass("UIAllianceStarMainLeavePanel", UIBaseContainer)
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
  self.textTip = self:AddComponent(UIText, "TipText")
  self.textLeaveBtn = self:AddComponent(UIText, "LeaveBtn/LeaveBtnText")
  self.btnLeave = self:AddComponent(UIButton, "LeaveBtn")
  self.btnLeave:SetOnClick(function()
    local mailId = DataCenter.AllianceStarManager:GetMailId()
    if mailId then
      GoToUtil:CloseAllWindows()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, mailId)
      DataCenter.MailDataManager:ReadMail(mailId)
    else
      self.view.ctrl:CloseSelf()
    end
  end)
  self.btnReward = self:AddComponent(UIButton, "RewardBtn")
  self.btnReward:SetOnClick(function()
    if self.participateReceive then
      UIUtil.ShowTipsId("alliance_weeklyStar_rewardClaimed")
    elseif self.rewardAnimTimer == nil then
      self.boxSimpleAnim:Play("open")
      self.rewardAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:StopRewardAnimTimer()
        SFSNetwork.SendMessage(MsgDefines.AllianceStarCeremonyQuestRewardNew)
      end, 1)
    end
  end)
  self.imgBtnReward = self:AddComponent(UIRawImage, "RewardBtn/node_box/box_open")
  self.boxSimpleAnim = self:AddComponent(UISimpleAnimation, "RewardBtn/node_box")
  self.redPoint = self:AddComponent(UIBaseComponent, "RewardBtn/node_box/box_open/RedPoint")
  self.redPointNum = self:AddComponent(UIText, "RewardBtn/node_box/box_open/RedPoint/Text")
end

local function ComponentDestroy(self)
  self.textTip = nil
  self.btnLeave = nil
  self.textLeaveBtn = nil
  self.btnReward = nil
  self.imgBtnReward = nil
  self.boxSimpleAnim = nil
  self.redPoint = nil
  self.redPointNum = nil
end

local function DataDefine(self)
  local fullData = DataCenter.AllianceStarManager:GetCeremonyFullData()
  self.stageNum = #fullData.ceremonyInfo
end

local function DataDestroy(self)
  self.participateReceive = nil
  self:StopRewardAnimTimer()
  self.stageNum = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, param)
  self.textTip:SetLocalText("alliance_weeklyStar_ceremony_state_over")
  self.textLeaveBtn:SetLocalText("alliance_weeklyStar_ceremony_btn_leave")
  self:RefreshRewardBox()
end

local function RefreshRewardBox(self)
  local fullData = DataCenter.AllianceStarManager:GetCeremonyFullData()
  self.participateReceive = fullData.participateReceive
  if self.participateReceive then
    self.boxSimpleAnim:SampleAnimationAtTime("open", 1)
    self.redPoint:SetActive(false)
  else
    self.boxSimpleAnim:Play("appear")
    self.redPoint:SetActive(true)
    self.redPointNum:SetText(self.stageNum)
  end
end

local function StopRewardAnimTimer(self)
  if self.rewardAnimTimer then
    self.rewardAnimTimer:Stop()
    self.rewardAnimTimer = nil
  end
end

UIAllianceStarMainLeavePanel.OnCreate = OnCreate
UIAllianceStarMainLeavePanel.OnDestroy = OnDestroy
UIAllianceStarMainLeavePanel.OnEnable = OnEnable
UIAllianceStarMainLeavePanel.OnDisable = OnDisable
UIAllianceStarMainLeavePanel.ComponentDefine = ComponentDefine
UIAllianceStarMainLeavePanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainLeavePanel.DataDefine = DataDefine
UIAllianceStarMainLeavePanel.DataDestroy = DataDestroy
UIAllianceStarMainLeavePanel.OnAddListener = OnAddListener
UIAllianceStarMainLeavePanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainLeavePanel.Refresh = Refresh
UIAllianceStarMainLeavePanel.RefreshRewardBox = RefreshRewardBox
UIAllianceStarMainLeavePanel.StopRewardAnimTimer = StopRewardAnimTimer
return UIAllianceStarMainLeavePanel
