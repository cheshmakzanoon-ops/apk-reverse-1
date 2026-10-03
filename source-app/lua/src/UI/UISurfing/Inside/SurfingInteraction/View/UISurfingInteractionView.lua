local base = UIBaseView
local UISurfingInteractionView = BaseClass("UISurfingInteractionView", base)
local text_path = "SafeArea/InteractionRoot/Root/Text"
local u_i_player_head_path = "SafeArea/InteractionRoot/Root/UIPlayerHead"
local TIPS_IDS = {
  "parkour_lick_boots_1",
  "parkour_lick_boots_2",
  "parkour_lick_boots_3"
}

function UISurfingInteractionView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UISurfingInteractionView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISurfingInteractionView:ComponentDefine()
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.anim = self:AddComponent(UIAnimator, "")
end

function UISurfingInteractionView:ComponentDestroy()
  self.text = nil
  self.u_i_player_head = nil
  self.anim = nil
end

function UISurfingInteractionView:DataDefine()
  self.delayAnimTimer = nil
end

function UISurfingInteractionView:DataDestroy()
  self:RemoveTimer()
end

function UISurfingInteractionView:ReInit(param)
  param = param or self:GetUserData()
  if param == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.u_i_player_head:SetHeadAndFrame(param.uid, param.headPic, param.headPicVer, false, param.headSkinId, param.headSkinET)
  self:PlayShowAnim()
  local count = #TIPS_IDS
  local i = Mathf.Random(1, count)
  local id = TIPS_IDS[i]
  if string.IsNullOrEmpty(id) then
    return
  end
  self.text:SetLocalText(id)
end

function UISurfingInteractionView:RefreshView(param)
  if param then
    self:ReInit(param)
  end
end

function UISurfingInteractionView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingGotAllyBuff, self.RefreshView)
end

function UISurfingInteractionView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SurfingGotAllyBuff, self.RefreshView)
end

function UISurfingInteractionView:PlayShowAnim()
  self:PlayAnim("V_ui_UISurfingInteraction_in", function()
    self:PlayCloseAnim()
  end, 1)
end

function UISurfingInteractionView:PlayCloseAnim()
  self:PlayAnim("V_ui_UISurfingInteraction_out", function()
    if self.ctrl then
      self.ctrl:CloseSelf()
    end
  end)
end

function UISurfingInteractionView:PlayAnim(animName, callback, duration)
  if string.IsNullOrEmpty(animName) or self.anim == nil then
    return
  end
  local ret, time = self.anim:PlayAnimationReturnTime(animName)
  if ret then
    duration = duration or 0
    self:RemoveTimer()
    self.delayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveTimer()
      if callback then
        callback()
      end
    end, time + duration)
  end
end

function UISurfingInteractionView:RemoveTimer()
  if self.delayAnimTimer then
    self.delayAnimTimer:Stop()
    self.delayAnimTimer = nil
  end
end

return UISurfingInteractionView
