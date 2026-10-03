local base = UIBaseView
local LWUIActBountyHunterRefreshMonsterTipView = BaseClass("LWUIActBountyHunterRefreshMonsterTipView", UIBaseView)
local Localization = CS.GameEntry.Localization

function LWUIActBountyHunterRefreshMonsterTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self:OnOpen()
end

function LWUIActBountyHunterRefreshMonsterTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActBountyHunterRefreshMonsterTipView:DataDefine()
end

function LWUIActBountyHunterRefreshMonsterTipView:DataDestroy()
end

function LWUIActBountyHunterRefreshMonsterTipView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, "Panel")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.root = self:AddComponent(UIBaseComponent, "Root/ImgBg")
  self.text = self:AddComponent(UIText, "Root/ImgBg/Text")
end

function LWUIActBountyHunterRefreshMonsterTipView:ComponentDestroy()
  self.close_btn = nil
  self.text = nil
  self.root = nil
end

function LWUIActBountyHunterRefreshMonsterTipView:OnOpen()
  if self.param and self.param.activityData then
    self.text:SetLocalText("activity_hunter_useitem_tips1", self.param.activityData:GetRefreshItemName(), self.param.activityData:GetRefreshItemEverydayAddCount())
  end
  self.root.transform:Set_position(self.param.target.transform.position.x, self.param.target.transform.position.y, self.param.target.transform.position.z)
end

return LWUIActBountyHunterRefreshMonsterTipView
