local ChatPinAskLeaderGatherItemCell = BaseClass("ChatPinAskLeaderGatherItemCell", UIBaseContainer)
local base = UIBaseContainer
local Setting = CS.GameEntry.Setting

function ChatPinAskLeaderGatherItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatPinAskLeaderGatherItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatPinAskLeaderGatherItemCell:OnAddListener()
  base.OnAddListener(self)
end

function ChatPinAskLeaderGatherItemCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ChatPinAskLeaderGatherItemCell:OnEnable()
  base.OnEnable(self)
end

function ChatPinAskLeaderGatherItemCell:OnDisable()
  base.OnDisable(self)
end

function ChatPinAskLeaderGatherItemCell:ComponentDefine()
  self.title = self:AddComponent(UIText, "Title")
  self.title:SetLocalText(310181)
  self.dontShowBtn = self:AddComponent(UIButton, "DontShowAgain")
  self.dontShowBtnTxt = self:AddComponent(UIText, "DontShowAgain/DontShowAgainText")
  self.dontShowMark = self:AddComponent(UIBaseContainer, "DontShowAgain/Background/Checkmark")
  self.dontShowBtnTxt:SetLocalText(310182)
  self.dontShowBtn:SetOnClick(function()
    self:OnDontShowAgainBtnClick()
  end)
  self.goBtn = self:AddComponent(UIButton, "GoBtn")
  self.goBtnTxt = self:AddComponent(UIText, "GoBtn/GoBtnText")
  self.goBtnTxt:SetLocalText(110003)
  self.goBtn:SetOnClick(function()
    self:OnGoBtnClick()
  end)
end

function ChatPinAskLeaderGatherItemCell:ComponentDestroy()
end

function ChatPinAskLeaderGatherItemCell:DataDefine()
  self.dontShowAgainFlag = false
end

function ChatPinAskLeaderGatherItemCell:DataDestroy()
end

function ChatPinAskLeaderGatherItemCell:ReInit(data)
  self.dontShowMark:SetActive(false)
  self.data = data
end

function ChatPinAskLeaderGatherItemCell:OnDontShowAgainBtnClick()
  self.dontShowAgainFlag = not self.dontShowAgainFlag
  self.dontShowMark:SetActive(self.dontShowAgainFlag)
end

function ChatPinAskLeaderGatherItemCell:OnGoBtnClick()
  if self.dontShowAgainFlag then
    Setting:SetPrivateBool("DONT_SHOW_LEADER_GATHER_PIN", true)
  end
  DataCenter.LWChatPinManager:RemovePinData(self.data.uuid)
  GoToUtil.CloseAllWindows()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMain, {anim = true}, {Guide = "Gather"})
end

return ChatPinAskLeaderGatherItemCell
