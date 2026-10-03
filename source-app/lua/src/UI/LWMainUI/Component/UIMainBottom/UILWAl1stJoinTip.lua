local UILWAl1stJoinTip = BaseClass("UILWAl1stJoinTip", UIAsyncContainer)
local base = UIAsyncContainer
local click_btn_path = "Btn"

function UILWAl1stJoinTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAl1stJoinTip:OnDestroy()
  self.hide = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAl1stJoinTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
  end)
end

function UILWAl1stJoinTip:ComponentDestroy()
  self.clickBtn = nil
end

function UILWAl1stJoinTip:OnEnable()
  base.OnEnable(self)
end

function UILWAl1stJoinTip:OnDisable()
  base.OnDisable(self)
end

function UILWAl1stJoinTip:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceApplySuccess, self.OnRefreshShow)
  self:AddUIListener(EventId.UILWAllianceFirstJoinOpen, self.OnHideTip)
end

function UILWAl1stJoinTip:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceApplySuccess, self.OnRefreshShow)
  self:RemoveUIListener(EventId.UILWAllianceFirstJoinOpen, self.OnHideTip)
  base.OnRemoveListener(self)
end

return UILWAl1stJoinTip
