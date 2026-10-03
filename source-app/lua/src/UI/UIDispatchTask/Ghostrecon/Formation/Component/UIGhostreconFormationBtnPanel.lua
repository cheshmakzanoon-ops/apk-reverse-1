local base = UIBaseContainer
local UIGhostreconFormationBtnPanel = BaseClass("UIGhostreconFormationBtnPanel", base)
local Localization = CS.GameEntry.Localization
local giftBtn_path = "GiftBtn"
local sendBtn_path = "SendPanel/SendBtn"
local sendBtnText_path = "SendPanel/SendBtn/SendBtnText"
local noRewardBtn_path = "SendPanel/NoRewardBtn"
local noRewardBtnText_path = "SendPanel/NoRewardBtn/NoRewardBtnText"
local oneKeyBtn_path = "OneKeyBtn"
local oneKeyBtnText_path = "OneKeyBtn/OneKeyBtnText"
local sendPanel_path = "SendPanel"

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
  self.sendBtn = self:AddComponent(UIButton, sendBtn_path)
  self.sendBtnText = self:AddComponent(UIText, sendBtnText_path)
  self.noRewardBtn = self:AddComponent(UIButton, noRewardBtn_path)
  self.noRewardBtnText = self:AddComponent(UIText, noRewardBtnText_path)
  self.oneKeyBtn = self:AddComponent(UIButton, oneKeyBtn_path)
  self.oneKeyBtnText = self:AddComponent(UIText, oneKeyBtnText_path)
  self.sendPanel = self:AddComponent(UIBaseContainer, sendPanel_path)
  self.giftBtn:SetOnClick(Bind(self, self.OnClickGiftBtn))
  self.sendBtn:SetOnClick(Bind(self, self.OnClickSendBtn))
  self.noRewardBtn:SetOnClick(Bind(self, self.OnClickNoRewardBtn))
  self.oneKeyBtn:SetOnClick(Bind(self, self.OnClickOneKeyBtn))
  self.noRewardBtnText:SetLocalText("ghostrecon_btn09")
  self.oneKeyBtnText:SetLocalText(456218)
end

local function ComponentDestroy(self)
  self.giftBtn = nil
  self.sendBtn = nil
  self.sendBtnText = nil
  self.noRewardBtn = nil
  self.noRewardBtnText = nil
  self.oneKeyBtn = nil
  self.oneKeyBtnText = nil
  self.sendPanel = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.uuid = nil
  self.cfg = nil
  self.isJoin = nil
end

local function SetData(self, uuid, cfg, isJoin)
  self.uuid = uuid
  self.cfg = cfg
  self.isJoin = isJoin
  if self.isJoin then
    self.noRewardBtn:SetActive(true)
    if DataCenter.ActGhostreconManager:GetTeamworkRewardTimesFull() then
      self.sendBtn:SetActive(false)
      self.noRewardBtn:SetAnchoredPositionXY(0, self.sendBtn:GetAnchoredPositionY())
    else
      self.sendBtn:SetActive(true)
      self.sendBtn:SetAnchoredPositionXY(-79, self.sendBtn:GetAnchoredPositionY())
      self.noRewardBtn:SetAnchoredPositionXY(229, self.noRewardBtn:GetAnchoredPositionY())
    end
    self.sendBtnText:SetLocalText("ghostrecon_btn08")
  else
    self.sendBtn:SetActive(true)
    self.sendBtn:SetAnchoredPositionXY(0, self.sendBtn:GetAnchoredPositionY())
    self.noRewardBtn:SetActive(false)
    self.sendBtnText:SetLocalText("ghostrecon_btn07")
  end
end

local function Refresh(self, isMeet)
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_FASTJOIN_FUNCTION_OPEN)
  if isOpen < 1 then
    CS.UIGray.SetGray(self.oneKeyBtn.transform, true, true)
  else
    CS.UIGray.SetGray(self.oneKeyBtn.transform, false, true)
  end
  self.sendPanel:SetActive(isMeet)
  self.oneKeyBtn:SetActive(not isMeet)
end

local function OnClickGiftBtn(self)
  local param = {}
  param.cfg = self.cfg
  param.width = 480
  param.alignObject = self.giftBtn
  param.yPosFix = 40
  param.showArrow = true
  param.meetNums = self.view.teamMeetSuperCondionNums
  if not IsNull(self.giftBtn) and not IsNull(self.giftBtn.transform) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostreconGiftTip, {anim = true}, param)
  end
end

local function OnClickSendBtn(self)
  if self.view.meetAllCondition then
    if self.isJoin then
      local allianceTaskInfo = DataCenter.ActGhostreconAllianceManager:GetAllianceTaskInfoByUUid(self.uuid)
      if allianceTaskInfo and table.length(allianceTaskInfo.memberList) >= DataCenter.ActGhostreconManager:GetTeamMaxMemberNum() then
        UIUtil.ShowTipsId("ghostrecon_051")
        return
      end
    end
    SFSNetwork.SendMessage(MsgDefines.GhostReconJoinTeam, self.uuid, self.view.selectedUUID, self.isJoin and 2 or 1)
    self.view.ctrl:CloseSelf()
  else
    UIUtil.ShowTipsId("ghostrecon_055")
  end
end

local function OnClickNoRewardBtn(self)
  UIUtil.ShowSecondMessage("", Localization:GetString("ghostrecon_089", self.cfg.imgSet.AccPointNum), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    if self.view and self.view.meetAllCondition then
      SFSNetwork.SendMessage(MsgDefines.GhostReconJoinTeam, self.uuid, self.view.selectedUUID, 3)
      self.view.ctrl:CloseSelf()
    else
      UIUtil.ShowTipsId("ghostrecon_055")
    end
  end, nil, nil, nil, nil, nil, nil, nil, nil, false)
end

local function OnClickOneKeyBtn(self)
  local isOpen = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_DISPATCH_TASK_FASTJOIN_FUNCTION_OPEN)
  if isOpen < 1 then
    UIUtil.ShowTipsId("456233")
  else
    self.view:OnFastJoinClick()
  end
end

UIGhostreconFormationBtnPanel.OnCreate = OnCreate
UIGhostreconFormationBtnPanel.OnDestroy = OnDestroy
UIGhostreconFormationBtnPanel.OnEnable = OnEnable
UIGhostreconFormationBtnPanel.OnDisable = OnDisable
UIGhostreconFormationBtnPanel.ComponentDefine = ComponentDefine
UIGhostreconFormationBtnPanel.ComponentDestroy = ComponentDestroy
UIGhostreconFormationBtnPanel.DataDefine = DataDefine
UIGhostreconFormationBtnPanel.DataDestroy = DataDestroy
UIGhostreconFormationBtnPanel.SetData = SetData
UIGhostreconFormationBtnPanel.Refresh = Refresh
UIGhostreconFormationBtnPanel.OnClickGiftBtn = OnClickGiftBtn
UIGhostreconFormationBtnPanel.OnClickSendBtn = OnClickSendBtn
UIGhostreconFormationBtnPanel.OnClickNoRewardBtn = OnClickNoRewardBtn
UIGhostreconFormationBtnPanel.OnClickOneKeyBtn = OnClickOneKeyBtn
return UIGhostreconFormationBtnPanel
