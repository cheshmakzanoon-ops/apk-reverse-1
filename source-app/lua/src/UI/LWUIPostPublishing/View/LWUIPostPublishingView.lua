local LWUIPostPublishingView = BaseClass("LWUIPostPublishingView", UIBaseView)
local base = UIBaseView
local record_content_path = "recordContent"

function LWUIPostPublishingView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIPostPublishingView:ComponentDefine()
  self.planelBtn = self:AddComponent(UIButton, "curtain")
  self.planelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, "panel/btnClose")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.noticeBtn = self:AddComponent(UIButton, "optionsLayout/noticeBtn")
  self.noticeBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPostAllianceNotice, {anim = true})
    self.ctrl:CloseSelf()
  end)
  self.voteBtn = self:AddComponent(UIButton, "optionsLayout/voteBtn")
  self.voteBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIPublishPoll, {anim = true})
    self.ctrl:CloseSelf()
  end)
  self.record_content = self:AddComponent(UIButton, record_content_path)
  self.record_content:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UINoticeRecord, {anim = true})
    self.ctrl:CloseSelf()
  end)
end

function LWUIPostPublishingView:ComponentDestroy()
  self.planelBtn = nil
  self.closeBtn = nil
  self.noticeBtn = nil
  self.voteBtn = nil
  self.record_content = nil
end

function LWUIPostPublishingView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

return LWUIPostPublishingView
