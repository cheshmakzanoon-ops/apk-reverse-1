local UIAlR4RecommendTip = BaseClass("UIAlR4RecommendTip", UIAsyncContainer)
local base = UIAsyncContainer

function UIAlR4RecommendTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAlR4RecommendTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAlR4RecommendTip:ComponentDefine()
  self.clickBtn = self:AddComponent(UIButton, "Btn")
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self:SetAnchoredPosition(Vector2.zero)
end

function UIAlR4RecommendTip:ComponentDestroy()
  self.clickBtn = nil
end

function UIAlR4RecommendTip:OnClick()
  SFSNetwork.SendMessage(MsgDefines.AllianceRecommendR4CandidateInfo)
end

return UIAlR4RecommendTip
