local UITreasureChestView = BaseClass("UITreasureChestView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITreasureChestItem = require("UI.LWTreasureChest.UITreasureChestItem")
local UITreasureChestRewardTip = require("UI.LWTreasureChest.UITreasureChestRewardTip")
local BoxSwitchStatus = {
  ShowBigReward = "ShowBigReward",
  BigRewardInto = "BigRewardInto",
  Switching = "Switching",
  SwitchEnd = "SwitchEnd"
}

function UITreasureChestView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITreasureChestView:OnDestroy()
  if self.cachedTreasureChestDetectEventCompMsg then
    EventManager:GetInstance():Broadcast(EventId.DetectEventComp, self.cachedTreasureChestDetectEventCompMsg)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITreasureChestView:ComponentDefine()
  self.textTxtTitle = self:AddComponent(UITextMeshProUGUIEx, "Main/bg/txtTitle")
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "Main/bg/btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnInfo = self:AddComponent(UIButton, "Main/bg/btnInfo")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compBox1 = self:AddComponent(UITreasureChestItem, "Main/bg/Boxs/Box1")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "Main/bg/Desc")
  self.textTxtStart = self:AddComponent(UITextMeshProUGUIEx, "Main/bg/btnGroup/btnStart/txtStart")
  self.btnStart = self:AddComponent(UIButton, "Main/bg/btnGroup/btnStart")
  self.btnStart:SetOnClick(function()
    self:OnBtnStartClick()
  end)
  self.compBox2 = self:AddComponent(UITreasureChestItem, "Main/bg/Boxs/Box2")
  self.compBox3 = self:AddComponent(UITreasureChestItem, "Main/bg/Boxs/Box3")
  self.btnReceive = self:AddComponent(UIButton, "Main/bg/btnGroup/btnReceive")
  self.btnReceive:SetOnClick(function()
    self:OnBtnReceiveClick()
  end)
  self.textTxtReceive = self:AddComponent(UITextMeshProUGUIEx, "Main/bg/btnGroup/btnReceive/txtReceive")
  self.textTxtTitle:SetLocalText("new_detect_tips_15")
  self.textTxtReceive:SetLocalText("new_detect_tips_22")
  self.textDesc:SetLocalText("new_detect_tips_16")
  self.rewardTips = self:AddComponent(UITreasureChestRewardTip, "UITreasureChestRewardTip")
  self.rewardTips:SetActive(false)
  self.box1DefaultPosition = self.compBox1.transform.position
  self.box2DefaultPosition = self.compBox2.transform.position
  self.box3DefaultPosition = self.compBox3.transform.position
  self.compBox1:SetData(1)
  self.compBox2:SetData(2)
  self.compBox3:SetData(3)
  self.switchEffect = self.transform:Find("Main/bg/EffectSwitch").gameObject
  self.switchEffect:SetActive(false)
end

function UITreasureChestView:ComponentDestroy()
  self.textTxtTitle = nil
  self.btnBlack = nil
  self.btnClose = nil
  self.btnInfo = nil
  self.compBox1 = nil
  self.textDesc = nil
  self.textTxtStart = nil
  self.btnStart = nil
  self.compBox2 = nil
  self.compBox3 = nil
  self.btnReceive = nil
  self.textTxtReceive = nil
end

function UITreasureChestView:DataDefine()
  self.treasureChestId, self.extraInfo = self:GetUserData()
  self.rewardDatas = DataCenter.TreasureChestDataManager:GetBoxRewardDatas(self.treasureChestId)
  self.switchSequence = DataCenter.TreasureChestDataManager:GetSwitchTimeSequence(self.treasureChestId)
  self.bestRewardIndex = self:GetBigRewardBoxIndex()
  self.boxItems = {
    self.compBox1,
    self.compBox2,
    self.compBox3
  }
  self.remainTimeToNextState = 0
  self:ChangeSwitchState(BoxSwitchStatus.ShowBigReward)
end

function UITreasureChestView:GetBigRewardBoxIndex()
  if not self.rewardDatas then
    return 0
  end
  for i, rewardData in ipairs(self.rewardDatas) do
    if rewardData.IsBest then
      return i
    end
  end
  return 0
end

function UITreasureChestView:DataDestroy()
  self:ResetBoxsPosition()
  if self.timerToShowReward then
    self.timerToShowReward:Stop()
  end
  self.timerToShowReward = nil
  self.params = nil
  self.boxItems = nil
  self.rewardDatas = nil
  self.switchSequence = nil
  self.treasureChestId = nil
  self.extraInfo = nil
  self.sequenceIndex = 1
  self.curSwitchBoxOne = nil
  self.curSwitchBoxAnOther = nil
  self.curSelectIndex = nil
  self.bestRewardIndex = nil
  self.switchState = nil
  self.remainTimeToNextState = nil
  self.timerToNextState = nil
  self.cachedTreasureChestDetectEventCompMsg = nil
end

function UITreasureChestView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.TreasureChestStartRequestResult, self.OnTreasureChestStartResult)
  self:AddUIListener(EventId.TreasureChestEndRequestResult, self.OnTreasureChestEndResult)
  self:AddUIListener(EventId.DetectEventComp, self.OnGetDetectEventCompMsg)
end

function UITreasureChestView:OnRemoveListener()
  self:RemoveUIListener(EventId.TreasureChestStartRequestResult, self.OnTreasureChestStartResult)
  self:RemoveUIListener(EventId.TreasureChestEndRequestResult, self.OnTreasureChestEndResult)
  self:RemoveUIListener(EventId.DetectEventComp, self.OnGetDetectEventCompMsg)
  base.OnRemoveListener(self)
end

function UITreasureChestView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UITreasureChestView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITreasureChestView:OnBtnInfoClick()
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString("new_detect_tips_31"))
end

function UITreasureChestView:ChangeSwitchState(state)
  if state == BoxSwitchStatus.ShowBigReward then
    self:ResetBoxsPosition()
    for i, v in ipairs(self.boxItems) do
      if i == self.bestRewardIndex then
        v:OpenBoxWithBigReward()
      else
        v:OpenBoxWithNormalReward()
      end
    end
    self.switchState = state
    self.timerToNextState = false
    self.remainTimeToNextState = 0
    self.nextState = nil
    self.curSelectIndex = nil
    CS.UIGray.SetGray(self.btnStart.transform, false, true)
    CS.UIGray.SetGray(self.btnReceive.transform, true, false)
    self.btnReceive:SetActive(false)
    self.textTxtStart:SetLocalText("new_detect_tips_20")
  elseif state == BoxSwitchStatus.BigRewardInto then
    self:ResetBoxsPosition()
    local switchTime = 0
    for i, v in ipairs(self.boxItems) do
      if i == self.bestRewardIndex then
        switchTime = v:CloseBoxBigReward()
      else
        v:CloseBoxNormalReward()
      end
    end
    self.switchState = state
    self.timerToNextState = true
    self.remainTimeToNextState = switchTime
    self.nextState = BoxSwitchStatus.Switching
    self.curSelectIndex = nil
    CS.UIGray.SetGray(self.btnStart.transform, true, false)
    CS.UIGray.SetGray(self.btnReceive.transform, true, false)
    self.btnReceive:SetActive(false)
    self.textTxtStart:SetLocalText("new_detect_tips_20")
  elseif state == BoxSwitchStatus.Switching then
    local success = self:StartSwitch()
    if success then
      self.switchState = state
      self.timerToNextState = false
      self.remainTimeToNextState = 0
      self.nextState = BoxSwitchStatus.SwitchEnd
      self.curSelectIndex = nil
      CS.UIGray.SetGray(self.btnStart.transform, true, false)
      CS.UIGray.SetGray(self.btnReceive.transform, true, false)
    end
    self.textTxtStart:SetLocalText("new_detect_tips_20")
  elseif state == BoxSwitchStatus.SwitchEnd then
    for i, v in ipairs(self.boxItems) do
      v:CloseBox()
    end
    self.switchState = state
    self.timerToNextState = false
    self.remainTimeToNextState = 0
    self.nextState = nil
    self.curSelectIndex = nil
    CS.UIGray.SetGray(self.btnStart.transform, false, true)
    CS.UIGray.SetGray(self.btnReceive.transform, true, false)
    self.btnReceive:SetActive(true)
    self.textTxtStart:SetLocalText("new_detect_tips_21")
  end
end

function UITreasureChestView:OnTreasureChestEndResult(t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local showRewardTime = 0
    local title = ""
    if self.curSelectIndex then
      local box = self:GetBoxItem(self.curSelectIndex)
      if box then
        if self.curSelectIndex == self.bestRewardIndex then
          showRewardTime = box:OpenBigRewardBox()
        else
          showRewardTime = box:OpenNormalRewardBox()
        end
      end
      self.received = true
      if self.curSelectIndex == self.bestRewardIndex then
        title = Localization:GetString("new_detect_tips_23")
      else
        title = Localization:GetString("new_detect_tips_24")
      end
      self.textDesc:SetText(title)
      CS.UIGray.SetGray(self.btnStart.transform, true, false)
      CS.UIGray.SetGray(self.btnReceive.transform, true, false)
    end
    if self.timerToShowReward then
      self.timerToShowReward:Stop()
    end
    self.timerToShowReward = TimerManager:GetInstance():DelayInvoke(function()
      t.treasureChestReward = true
      DataCenter.RewardManager:ShowCommonReward(t, title)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end, showRewardTime)
  end
end

function UITreasureChestView:OnBtnStartClick()
  if self.switchState == BoxSwitchStatus.SwitchEnd then
    self:ChangeSwitchState(BoxSwitchStatus.BigRewardInto)
  else
    SFSNetwork.SendMessage(MsgDefines.TreasureChestPickOneStartRequest, self.treasureChestId, self.extraInfo)
  end
end

function UITreasureChestView:OnTreasureChestStartResult(success)
  if success then
    self:ChangeSwitchState(BoxSwitchStatus.BigRewardInto)
  end
end

function UITreasureChestView:StartSwitch()
  if self.switchState == BoxSwitchStatus.Switching then
    return false
  end
  for i, v in ipairs(self.boxItems) do
    v:CloseBox()
  end
  if not self.switchSequence or not self.switchSequence[1] then
    return true
  end
  local sequenceOne = self.switchSequence[1]
  self.sequenceIndex = 1
  self.curSwitchBoxOne, self.curSwitchBoxAnOther = self:SwitchBoxs(sequenceOne[1], sequenceOne[2], sequenceOne[3])
  return true
end

function UITreasureChestView:OnBtnReceiveClick()
  if self.switchState == BoxSwitchStatus.SwitchEnd and self.curSelectIndex then
    SFSNetwork.SendMessage(MsgDefines.TreasureChestPickOneEndRequest, self.treasureChestId, self.curSelectIndex, self.extraInfo)
  end
end

function UITreasureChestView:Update()
  local deltaTime = Time.deltaTime
  if self.switchState and self.timerToNextState then
    self.remainTimeToNextState = self.remainTimeToNextState - deltaTime
    if self.remainTimeToNextState <= 0 then
      self.timerToNextState = false
      if self.nextState then
        self:ChangeSwitchState(self.nextState)
      end
    end
  end
  if self.switchState == BoxSwitchStatus.Switching and self.curSwitchBoxOne:IsMoving() == false and self.curSwitchBoxAnOther:IsMoving() == false then
    local nextSwitchSequenceIndex = math.min(self.sequenceIndex + 1, #self.switchSequence)
    if nextSwitchSequenceIndex > self.sequenceIndex then
      local sequenceNext = self.switchSequence[nextSwitchSequenceIndex]
      self.curSwitchBoxOne, self.curSwitchBoxAnOther = self:SwitchBoxs(sequenceNext[1], sequenceNext[2], sequenceNext[3])
      self.sequenceIndex = nextSwitchSequenceIndex
    elseif self.nextState then
      self:ChangeSwitchState(self.nextState)
    end
  end
end

function UITreasureChestView:ResetBoxsPosition()
  self.compBox1.transform:Set_position(self.box1DefaultPosition.x, self.box1DefaultPosition.y, self.box1DefaultPosition.z)
  self.compBox2.transform:Set_position(self.box2DefaultPosition.x, self.box2DefaultPosition.y, self.box2DefaultPosition.z)
  self.compBox3.transform:Set_position(self.box3DefaultPosition.x, self.box3DefaultPosition.y, self.box3DefaultPosition.z)
end

function UITreasureChestView:SwitchBoxs(index1, index2, time)
  local oneBox = self:GetBoxItem(index1)
  local anOtherBox = self:GetBoxItem(index2)
  if oneBox and anOtherBox then
    local oneBoxPos = oneBox:GetCurPosition()
    local anOtherPos = anOtherBox:GetCurPosition()
    oneBox:AnimToMoveTargetPosition(anOtherPos, time, 1)
    anOtherBox:AnimToMoveTargetPosition(oneBoxPos, time, -1)
    return oneBox, anOtherBox
  end
end

function UITreasureChestView:GetBoxItem(index)
  return self.boxItems[index]
end

function UITreasureChestView:ShowSwitchEffect(x, y, z)
  self.switchEffect:SetActive(true)
  self.switchEffect.transform:Set_position(x, y, z)
end

function UITreasureChestView:HideSwitchEffect()
  self.switchEffect:SetActive(false)
end

function UITreasureChestView:OnClickBox(index)
  if self.received then
    return
  end
  if self.switchState == BoxSwitchStatus.SwitchEnd then
    CS.UIGray.SetGray(self.btnReceive.transform, false, true)
    if self.curSelectIndex then
      local oldBox = self:GetBoxItem(self.curSelectIndex)
      if oldBox then
        oldBox:CloseBox()
      end
    end
    self.curSelectIndex = index
    local newBox = self:GetBoxItem(self.curSelectIndex)
    if newBox then
      newBox:ClickBox()
    end
  elseif self.switchState == BoxSwitchStatus.ShowBigReward then
    if not self.params then
      self.params = {}
    end
    if not self.params[index] then
      local param = UITreasureChestRewardTip.ParamDataClass.New()
      param.dir = index or UITreasureChestRewardTip.Direction.MIDDLE
      local boxData = self.rewardDatas[index]
      if boxData then
        if boxData.rewardId and boxData.rewardId ~= 0 then
          param.rewardList = DataCenter.RewardTemplateManager:GetList(boxData.rewardId) or {}
        end
        if boxData.extraRewardId and boxData.extraRewardId ~= 0 then
          param.extraRewardList = DataCenter.RewardTemplateManager:GetList(boxData.extraRewardId) or {}
        end
        if boxData.diamondValue and 0 < boxData.diamondValue then
          param.totalVal = boxData.diamondValue
        end
      end
      self.params[index] = param
    end
    self.rewardTips:SetData(self.params[index])
    self.rewardTips:Show()
  end
end

function UITreasureChestView:OnGetDetectEventCompMsg(info)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local uuid = info.uuid
  local event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if event and event.template and (event.template.type == DetectEventType.TreasureChest or event.template.type == DetectEventType.OFF_SEASON_TreasureChest) then
    self.cachedTreasureChestDetectEventCompMsg = info
  end
end

return UITreasureChestView
