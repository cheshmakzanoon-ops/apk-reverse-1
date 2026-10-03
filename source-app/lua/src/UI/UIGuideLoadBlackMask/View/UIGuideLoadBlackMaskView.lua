local UIGuideLoadBlackMaskView = BaseClass("UIGuideLoadBlackMaskView", UIBaseView)
local base = UIBaseView
local des_text_path = "DesText"

function UIGuideLoadBlackMaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIGuideLoadBlackMaskView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGuideLoadBlackMaskView:ComponentDefine()
  self.des_text = self:AddComponent(UIText, des_text_path)
end

function UIGuideLoadBlackMaskView:ComponentDestroy()
  self.des_text = nil
end

function UIGuideLoadBlackMaskView:DataDefine()
  self.param = nil
end

function UIGuideLoadBlackMaskView:DataDestroy()
  self.param = nil
end

function UIGuideLoadBlackMaskView:OnEnable()
  base.OnEnable(self)
end

function UIGuideLoadBlackMaskView:OnDisable()
  base.OnDisable(self)
end

function UIGuideLoadBlackMaskView:ReInit()
  self.param = self:GetUserData()
  self.des_text:SetText(self.param.des)
end

function UIGuideLoadBlackMaskView:OnAddListener()
  base.OnAddListener(self)
end

function UIGuideLoadBlackMaskView:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UIGuideLoadBlackMaskView
