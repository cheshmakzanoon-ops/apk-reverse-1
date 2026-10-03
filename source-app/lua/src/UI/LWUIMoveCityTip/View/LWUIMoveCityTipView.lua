local base = UIBaseView
local LWUIMoveCityTipView = BaseClass("LWUIMoveCityTipView", base)
local Localization = CS.GameEntry.Localization
local txt_title_path = "root/txt_title"
local panel_path = "Panel"
local root_path = "root"

function LWUIMoveCityTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ShowBubbleTips()
end

function LWUIMoveCityTipView:OnDestroy()
  self:RemoveSequence()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUIMoveCityTipView:OnEnable()
  base.OnEnable(self)
end

function LWUIMoveCityTipView:OnDisable()
  base.OnDisable(self)
end

function LWUIMoveCityTipView:ComponentDefine()
  self.root = self:AddComponent(UICanvasGroup, root_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.root:SetAlpha(0)
  self.touchTrough = self.panel.rectTransform:GetComponent(typeof(CS.LFTouchThrough))
  self.touchTrough:ToggleThrough(true)
end

function LWUIMoveCityTipView:ComponentDestroy()
  self.root = nil
  self.txt_title = nil
  self.panel = nil
  self.touchTrough = nil
end

function LWUIMoveCityTipView:DataDefine()
  self.tweenSequence = nil
  self.isShow = false
end

function LWUIMoveCityTipView:DataDestroy()
  self.tweenSequence = nil
  self.isShow = nil
  self.clickPanel = nil
end

function LWUIMoveCityTipView:ShowBubbleTips()
  local userData = self:GetUserData()
  self.clickPanel = userData.bg
  self.rectTransform.position = userData.position
  if self.isShow then
    self.root:SetAlpha(0)
  end
  self:RemoveSequence()
  self.isShow = true
  self.tweenSequence = CS.DG.Tweening.DOTween.Sequence()
  self.tweenSequence:Append(self.root:FadeIn(0.3))
  self.txt_title:SetLocalText("world_cross_teleport_tips_1001", LuaEntry.Player:GetCurServerId())
end

function LWUIMoveCityTipView:RemoveSequence()
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
  end
end

return LWUIMoveCityTipView
