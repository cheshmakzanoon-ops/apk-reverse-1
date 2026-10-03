local base = UIBaseContainer
local T11MiddleUnlockableComponent = BaseClass("T11MiddleUnlockableComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11MiddleUnlockableComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11MiddleUnlockableComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11MiddleUnlockableComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPreView = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPreView:SetOnClick(function()
    self:OnBtnPreViewClick()
  end)
  self.textResearchDuration = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function T11MiddleUnlockableComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnPreView = nil
  self.textResearchDuration = nil
end

function T11MiddleUnlockableComponent:DataDefine()
end

function T11MiddleUnlockableComponent:DataDestroy()
end

function T11MiddleUnlockableComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11MiddleUnlockableComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11MiddleUnlockableComponent:OnBtnPreViewClick()
  UIManager.Instance:OpenWindow(UIWindowNames.T11SoldierPreviewView)
end

function T11MiddleUnlockableComponent:RefreshView()
  self.nextStageTmp = T11Util.GetNextStageTmp()
  if not self.nextStageTmp then
    T11Util.ShowLog("T11UnlockableItemComponent:RefreshView nextStageTmp is nil")
    return
  end
  self:RefreshBreakDuration()
end

function T11MiddleUnlockableComponent:RefreshBreakDuration()
  local breakDuration = self.nextStageTmp.cost_time
  local showDuration = UITimeManager:GetInstance():SecondToFmtString(breakDuration)
  self.textResearchDuration:SetText(showDuration)
end

return T11MiddleUnlockableComponent
