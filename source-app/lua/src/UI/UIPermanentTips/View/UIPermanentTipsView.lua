local UIPermanentTipsView = BaseClass("UIPermanentTipsView", UIBaseView)
local base = UIBaseView

function UIPermanentTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

function UIPermanentTipsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPermanentTipsView:ComponentDefine()
  self.txt = self:AddComponent(UIText, "ImgBg/Text")
end

function UIPermanentTipsView:ComponentDestroy()
  self.txt = nil
end

function UIPermanentTipsView:OnEnable()
  base.OnEnable(self)
end

function UIPermanentTipsView:OnDisable()
  base.OnDisable(self)
end

function UIPermanentTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UIPermanentTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPermanentTipsView:RefreshView()
  local content = self:GetUserData()
  self.txt:SetText(content)
end

return UIPermanentTipsView
