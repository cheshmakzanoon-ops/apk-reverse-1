local UILWAlScienceRecommend = BaseClass("UILWAlScienceRecommend", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local click_btn_path = "Btn"

function UILWAlScienceRecommend:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAlScienceRecommend:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlScienceRecommend:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self.holder:OnClick()
  end)
end

function UILWAlScienceRecommend:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAlScienceRecommend:OnEnable()
  base.OnEnable(self)
end

function UILWAlScienceRecommend:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlScienceRecommend:OnRemoveListener()
  base.OnRemoveListener(self)
end

return UILWAlScienceRecommend
