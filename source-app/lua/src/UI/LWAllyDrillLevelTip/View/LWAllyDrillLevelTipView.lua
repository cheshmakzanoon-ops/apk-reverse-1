local LWAllyDrillLevelTipView = BaseClass("LWAllyDrillLevelTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local black_path = "black"
local click_tip_path = "envelopeBg/clickTip"
local title_path = "mailBg/title"
local dear_path = "mailBg/dear"
local content_path = "mailBg/content"
local confirm_btn_text_path = "mailBg/ConfirmBtn/ConfirmBtnText"
local confirm_btn_path = "mailBg/ConfirmBtn"

function LWAllyDrillLevelTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function LWAllyDrillLevelTipView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWAllyDrillLevelTipView:OnAddListener()
  base.OnAddListener(self)
end

function LWAllyDrillLevelTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWAllyDrillLevelTipView:ComponentDefine()
  self.black = self:AddComponent(UIButton, black_path)
  self.click_tip = self:AddComponent(UITextMeshProUGUIEx, click_tip_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.dear = self:AddComponent(UITextMeshProUGUIEx, dear_path)
  self.content = self:AddComponent(UITextMeshProUGUIEx, content_path)
  self.confirm_btn_text = self:AddComponent(UITextMeshProUGUIEx, confirm_btn_text_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.animator = self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  self.black:SetOnClick(function()
    self:OnBlackBtnClick()
  end)
  self.confirm_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.click_tip:SetText(Localization:GetString("alliance_boss_tips_010"))
  self.confirm_btn_text:SetText(Localization:GetString("alliance_boss_tips_009"))
  self.title:SetText(Localization:GetString("alliance_boss_tips_011"))
  self.dear:SetText(Localization:GetString("alliance_boss_tips_012"))
  self.content:SetText(Localization:GetString("alliance_boss_tips_008"))
end

function LWAllyDrillLevelTipView:DataDefine()
end

function LWAllyDrillLevelTipView:ComponentDestroy()
  if self.clickDelay then
    self.clickDelay:Stop()
    self.clickDelay = nil
  end
  self.black = nil
  self.click_tip = nil
  self.title = nil
  self.dear = nil
  self.content = nil
  self.confirm_btn_text = nil
  self.confirm_btn = nil
end

function LWAllyDrillLevelTipView:DataDestroy()
end

function LWAllyDrillLevelTipView:ReInit()
  self.canClick = false
  self.clickDelay = TimerManager:GetInstance():DelayInvoke(function()
    self.clickDelay = nil
    self:OnCanClickCallback()
  end, 1)
end

function LWAllyDrillLevelTipView:OnCanClickCallback()
  self.canClick = true
end

function LWAllyDrillLevelTipView:OnBlackBtnClick()
  if self.canClick then
    if self.animator then
      self.animator:Play("LWAllyDrillLevelTipLetterOpen", 0, 0)
    end
    self.canClick = false
  end
end

return LWAllyDrillLevelTipView
