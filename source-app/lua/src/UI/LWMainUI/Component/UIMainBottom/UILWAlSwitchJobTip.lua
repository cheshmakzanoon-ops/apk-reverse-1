local UILWAlSwitchJobTip = BaseClass("UILWAlSwitchJobTip", UIAsyncContainer)
local base = UIAsyncContainer
local click_btn_path = "Btn"

function UILWAlSwitchJobTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAlSwitchJobTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSwitchJobTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlSwitchJobTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAlSwitchJobTip:OnEnable()
  base.OnEnable(self)
end

function UILWAlSwitchJobTip:OnDisable()
  base.OnDisable(self)
end

function UILWAlSwitchJobTip:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSwitchJobTip:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSwitchJobTip:OnClick()
  DataCenter.AllianceFeatureManager:SendAllianceRecommendInfoForJump()
  DataCenter.AllianceFeatureManager:RefreshAllianceJumpNew(false)
end

return UILWAlSwitchJobTip
