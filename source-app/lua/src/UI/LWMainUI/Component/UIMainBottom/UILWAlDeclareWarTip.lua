local UILWAlDeclareWarTip = BaseClass("UILWAlDeclareWarTip", UIAsyncContainer)
local base = UIAsyncContainer
local click_btn_path = "Btn"

function UILWAlDeclareWarTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAlDeclareWarTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlDeclareWarTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self.holder:OnClick()
  end)
end

function UILWAlDeclareWarTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAlDeclareWarTip:OnEnable()
  base.OnEnable(self)
end

function UILWAlDeclareWarTip:OnDisable()
  base.OnDisable(self)
end

function UILWAlDeclareWarTip:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlDeclareWarTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWAlDeclareWarTip
