local base = UIBaseContainer
local UIGhostreconTeamUpBtnPanel = BaseClass("UIGhostreconTeamUpBtnPanel", base)
local Localization = CS.GameEntry.Localization
local giftBtn_path = "GiftBtn"
local remindBtn_path = "RemindBtn"
local remindBtnText_path = "RemindBtn/RemindBtnText"
local startBtn_path = "StartBtn"
local startBtnText_path = "StartBtn/StartBtnText"
local shareBtn_path = "ShareBtn"

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
  self.giftBtn = self:AddComponent(UIButton, giftBtn_path)
  self.remindBtn = self:AddComponent(UIButton, remindBtn_path)
  self.remindBtnText = self:AddComponent(UIText, remindBtnText_path)
  self.startBtn = self:AddComponent(UIButton, startBtn_path)
  self.startBtnText = self:AddComponent(UIText, startBtnText_path)
  self.shareBtn = self:AddComponent(UIButton, shareBtn_path)
  self.startBtn:SetOnClick(Bind(self, self.OnClickStartBtn))
  self.remindBtn:SetOnClick(Bind(self, self.OnClickRemindBtn))
  self.shareBtn:SetOnClick(Bind(self, self.OnClickShareBtn))
  self.giftBtn:SetOnClick(Bind(self, self.OnClickGiftBtn))
  self.startBtnText:SetLocalText("ghostrecon_btn03")
  self.remindBtnText:SetLocalText("ghostrecon_btn02")
end

local function ComponentDestroy(self)
  self.giftBtn = nil
  self.remindBtn = nil
  self.remindBtnText = nil
  self.startBtn = nil
  self.startBtnText = nil
  self.shareBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.taskInfo = nil
  self.remindCdCfg = nil
  self.remindIsGray = false
  self.shareIsGray = false
end

local function SetData(self, uuid)
  self.uuid = uuid
  self.taskInfo = DataCenter.ActGhostreconManager:GetTaskInfoByUUid(uuid)
  if self.taskInfo:OwnIsLeader() then
    self.startBtn:SetActive(true)
    self.remindBtn:SetActive(false)
    self.shareBtn:SetActive(true)
  else
    self.startBtn:SetActive(false)
    self.remindBtn:SetActive(true)
    self.shareBtn:SetActive(false)
  end
  self.remindCdCfg = LuaEntry.DataConfig:TryGetNum("ghostrecon_config", "k2", 5) * 1000
  self.shareCdCfg = LuaEntry.DataConfig:TryGetNum("ghostrecon_config", "k1", 5) * 1000
  self.remindIsGray = false
  self.shareIsGray = false
  CS.UIGray.SetGray(self.remindBtn.transform, self.remindIsGray, true)
  CS.UIGray.SetGray(self.shareBtn.transform, self.shareIsGray, true)
  self:Update1000MS()
end

local function SendGhostReconStartTeam(self)
  SFSNetwork.SendMessage(MsgDefines.GhostReconStartTeam, self.uuid)
  self.view.ctrl:CloseSelf()
end

local function OnClickStartBtn(self)
  if self.view.IsMeet and not self.view:IsMeet() then
    UIUtil.ShowSecondMessage("", Localization:GetString("ghostrecon_079"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:SendGhostReconStartTeam()
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  elseif not self.taskInfo:MemberIsFull() then
    UIUtil.ShowSecondMessage("", Localization:GetString("ghostrecon_049"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:SendGhostReconStartTeam()
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  else
    self:SendGhostReconStartTeam()
  end
end

local function OnClickRemindBtn(self)
  local cdTime = self.remindCdCfg - (UITimeManager:GetInstance():GetServerTime() - self.taskInfo.remindTime)
  if 0 < cdTime then
    UIUtil.ShowTips(Localization:GetString("ghostrecon_056", UITimeManager:GetInstance():MilliSecondToFmtString(cdTime)))
  else
    SFSNetwork.SendMessage(MsgDefines.GhostReconRemindStartTeam, self.uuid)
  end
end

local function OnClickShareBtn(self)
  local cdTime = self.shareCdCfg - (UITimeManager:GetInstance():GetServerTime() - self.taskInfo.sendChatTime)
  if 0 < cdTime then
    UIUtil.ShowTips(Localization:GetString("ghostrecon_057", UITimeManager:GetInstance():MilliSecondToFmtString(cdTime)))
  else
    DataCenter.ActGhostreconManager:ShareOwnGhostreconTask(self.taskInfo.uuid)
  end
end

local function OnClickGiftBtn(self)
  local param = {}
  param.cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(self.taskInfo.cfgId)
  param.width = 480
  param.alignObject = self.giftBtn
  param.yPosFix = 40
  param.showArrow = true
  param.meetNums = param.cfg:GetSuperCondionNumsByMemberList(self.taskInfo.memberList)
  if not IsNull(self.giftBtn) and not IsNull(self.giftBtn.transform) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconGiftTip, {anim = true}, param)
  end
end

local function Update1000MS(self)
  if self.remindBtn:GetActive() and self.taskInfo.remindTime ~= 0 then
    local cdTime = self.remindCdCfg - (UITimeManager:GetInstance():GetServerTime() - self.taskInfo.remindTime)
    if 0 < cdTime then
      if not self.remindIsGray then
        self.remindIsGray = true
        CS.UIGray.SetGray(self.remindBtn.transform, self.remindIsGray, true)
      end
      self.remindBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(cdTime))
    elseif self.remindIsGray then
      self.remindIsGray = false
      CS.UIGray.SetGray(self.remindBtn.transform, self.remindIsGray, true)
      self.remindBtnText:SetLocalText("ghostrecon_btn02")
    end
  end
  if self.shareBtn:GetActive() and self.taskInfo.sendChatTime ~= 0 then
    local cdTime = self.shareCdCfg - (UITimeManager:GetInstance():GetServerTime() - self.taskInfo.sendChatTime)
    if 0 < cdTime then
      if not self.shareIsGray then
        self.shareIsGray = true
        CS.UIGray.SetGray(self.shareBtn.transform, self.shareIsGray, true)
      end
    elseif self.shareIsGray then
      self.shareIsGray = false
      CS.UIGray.SetGray(self.shareBtn.transform, self.shareIsGray, true)
    end
  end
end

UIGhostreconTeamUpBtnPanel.OnCreate = OnCreate
UIGhostreconTeamUpBtnPanel.OnDestroy = OnDestroy
UIGhostreconTeamUpBtnPanel.OnEnable = OnEnable
UIGhostreconTeamUpBtnPanel.OnDisable = OnDisable
UIGhostreconTeamUpBtnPanel.ComponentDefine = ComponentDefine
UIGhostreconTeamUpBtnPanel.ComponentDestroy = ComponentDestroy
UIGhostreconTeamUpBtnPanel.DataDefine = DataDefine
UIGhostreconTeamUpBtnPanel.DataDestroy = DataDestroy
UIGhostreconTeamUpBtnPanel.SetData = SetData
UIGhostreconTeamUpBtnPanel.OnClickStartBtn = OnClickStartBtn
UIGhostreconTeamUpBtnPanel.OnClickRemindBtn = OnClickRemindBtn
UIGhostreconTeamUpBtnPanel.OnClickShareBtn = OnClickShareBtn
UIGhostreconTeamUpBtnPanel.OnClickGiftBtn = OnClickGiftBtn
UIGhostreconTeamUpBtnPanel.Update1000MS = Update1000MS
UIGhostreconTeamUpBtnPanel.SendGhostReconStartTeam = SendGhostReconStartTeam
return UIGhostreconTeamUpBtnPanel
