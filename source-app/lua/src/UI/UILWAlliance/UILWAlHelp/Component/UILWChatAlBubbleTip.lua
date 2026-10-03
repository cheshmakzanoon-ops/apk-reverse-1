local UILWChatAlBubbleTip = BaseClass("UILWChatAlBubbleTip", UIBaseContainer)
local base = UIBaseContainer
local click_btn_path = "Btn"

function UILWChatAlBubbleTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatAlBubbleTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWChatAlBubbleTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWChatAlBubbleTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWChatAlBubbleTip:OnClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  SFSNetwork.SendMessage(MsgDefines.AlHelpAll, math.floor(curTime), self.clickBtn.transform.position, nil, true, true)
end

return UILWChatAlBubbleTip
