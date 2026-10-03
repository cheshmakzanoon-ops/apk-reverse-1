local UISurfingGuildView = BaseClass("UISurfingGuildView", UIBaseView)
local base = UIBaseView
local tips_text_path = "Root/TipsText"

function UISurfingGuildView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UISurfingGuildView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISurfingGuildView:ComponentDefine()
  self.ui_anim = self:AddComponent(UIAnimator, "")
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.tips_text:SetLocalText("parkour_guide_operate")
end

function UISurfingGuildView:ComponentDestroy()
  self.ui_anim = nil
  self.tips_text = nil
end

function UISurfingGuildView:DataDefine()
  self.delayAnimTimer = nil
end

function UISurfingGuildView:DataDestroy()
  if self.delayAnimTimer then
    self.delayAnimTimer:Stop()
    self.delayAnimTimer = nil
  end
end

function UISurfingGuildView:InitView()
  if self.ui_anim then
    local ret, time = self.ui_anim:PlayAnimationReturnTime("UISurfingGuild_move_in")
    if ret then
      self.delayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTimer then
          self.delayAnimTimer:Stop()
          self.delayAnimTimer = nil
        end
        if self.ctrl then
          self.ctrl:CloseSelf()
        end
      end, time)
    end
  end
end

return UISurfingGuildView
