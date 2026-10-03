local UIParkourTutorialView = BaseClass("UIParkourTutorialView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local tip_path = "Root/tip"

function UIParkourTutorialView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIParkourTutorialView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIParkourTutorialView:OnAddListener()
  base.OnAddListener(self)
end

function UIParkourTutorialView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIParkourTutorialView:ComponentDefine()
  self.tip = self:AddComponent(UITextMeshProUGUIEx, tip_path)
  self.tip:SetText(Localization:GetString("first_guide_des"))
end

function UIParkourTutorialView:DataDefine()
end

function UIParkourTutorialView:ComponentDestroy()
  self.tip = nil
end

function UIParkourTutorialView:DataDestroy()
end

function UIParkourTutorialView:ReInit()
end

return UIParkourTutorialView
