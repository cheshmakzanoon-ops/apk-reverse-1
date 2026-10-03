local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorAllianceInviteMoveCity = BaseClass("VisitorAllianceInviteMoveCity", CallerUnit)
local Const = require("Scene.CityVisitor.Const")

function VisitorAllianceInviteMoveCity:FinishVisitor(operate)
  self:SetFinishTargetPos()
  self.isFinish = true
  self:PlayAni(Const.animation.Walk)
  self.questionIcon.gameObject:SetActive(false)
  if operate == 1 then
    self.smilingFaceIcon.gameObject:SetActive(true)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
    end, Const.showEmojiTime)
  else
    self.tipRoot.gameObject:SetActive(false)
  end
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  local _chatRoomManager = ChatInterface.getRoomMgr()
  if _chatRoomManager:HasAllianceRoom() then
    local allianceRoomData = _chatRoomManager:GetAllianceRoomData()
    local pinDatas = DataCenter.LWChatPinManager:GetAllPinData(allianceRoomData)
    for k, v in pairs(pinDatas) do
      if v.type == ChatPinMessageType.AllianceGatherMember or v.type == ChatPinMessageType.AllianceGatherLeader then
        DataCenter.LWChatPinManager:RecordRejectAllianceGatherMember(v.uuid)
      end
    end
  end
  DataCenter.CityVisitorManager:DeleteVisitor(self.visitorData.uid, self.visitorData.type)
  EventManager:GetInstance():Broadcast(EventId.RefreshVisitorBtnState)
end

function VisitorAllianceInviteMoveCity:OnTriggerClick()
  if not self.param then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlAssemblyInfo, {anim = true})
  local info = {
    uid = self.visitorData.uid,
    visitorType = self.visitorData.type,
    operate = 1
  }
  DataCenter.CityVisitorManager:FinishVisitor(info)
end

function VisitorAllianceInviteMoveCity:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorAllianceInviteMoveCity:ClearData()
  base.ClearData(self)
end

return VisitorAllianceInviteMoveCity
