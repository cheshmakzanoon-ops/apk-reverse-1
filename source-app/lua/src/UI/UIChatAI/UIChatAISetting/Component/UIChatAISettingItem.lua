local base = UIBaseContainer
local UIChatAISettingItem = BaseClass("UIChatAISettingItem", base)
local tooltip_fadeOut_time = 0.3
local Setting = CS.GameEntry.Setting

function UIChatAISettingItem:OnCreate(param, parentView)
  base.OnCreate(self)
  self.setting = param
  self.parentView = parentView
  self._iconSprite = self:AddComponent(UIImage, "Item/icon")
  self._nameText = self:AddComponent(UIText, "Item/name")
  self._nameText:SetText(param.text)
  self._helpBtn = self:AddComponent(UIButton, "Item/help")
  self._helpBtn:SetOnClick(function()
    self.parentView:ShowTooltips(self._helpBtn, self.setting.detail)
  end)
  self._switchSliderSprite = self:AddComponent(UIImage, "Item/switchBtn/slider")
  self._switchActiveBgSprite = self:AddComponent(UICanvasGroup, "Item/switchBtn/bgActive")
  self._switchBtn = self:AddComponent(UIButton, "Item/switchBtn")
  self._switchBtn:SetOnClick(function()
    self:SetStatus(not self.pushStatus, true)
    self.parentView:OnSettingChanged()
  end)
  self:SetStatus(Setting:GetBool("ai.chat.push." .. param.id, true), false)
end

function UIChatAISettingItem:SetStatus(status, anim)
  self.pushStatus = status
  if anim then
    self._switchActiveBgSprite.unity_canvas_group:DOFade(status and 1 or 0, tooltip_fadeOut_time)
    self._switchSliderSprite.transform:DOLocalMoveX(status and 20 or -20, tooltip_fadeOut_time):SetEase(CS.DG.Tweening.Ease.InOutCubic)
    Setting:SetBool("ai.chat.push." .. self.setting.id, status)
  else
    self._switchActiveBgSprite:SetAlpha(status and 1 or 0)
    self._switchSliderSprite:SetLocalPositionXYZ(status and 20 or -20, 0, 0)
  end
end

function UIChatAISettingItem:OnDestroy()
  self._iconSprite = nil
  self._nameText = nil
  self._helpBtn = nil
  base.OnDestroy(self)
end

return UIChatAISettingItem
