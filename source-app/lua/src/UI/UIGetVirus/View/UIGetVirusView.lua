local UIGetVirusView = BaseClass("UIGetVirusView", UIBaseView)
local base = UIBaseView
local title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/Title"
local count_path = "UICommonRewardPopUp/Panel/Count"
local desc_path = "UICommonRewardPopUp/Panel/Desc"

function UIGetVirusView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Init()
end

function UIGetVirusView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGetVirusView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "UICommonRewardPopUp/Panel")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("season_mastery_tips_26")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.desc:SetLocalText("season_mastery_tips_31")
  self.count = self:AddComponent(UITextMeshProUGUIEx, count_path)
end

function UIGetVirusView:ComponentDestroy()
  self.title = nil
  self.count = nil
end

function UIGetVirusView:Init()
  local num = self:GetUserData()
  self.count:SetText("+" .. num)
end

return UIGetVirusView
