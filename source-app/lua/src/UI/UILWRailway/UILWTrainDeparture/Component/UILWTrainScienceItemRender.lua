local UILWTrainScienceItemRender = BaseClass("UILWTrainScienceItemRender", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local btn_path = "Btn"
local science_icon_path = "Btn/ScienceIcon"

function UILWTrainScienceItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWTrainScienceItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainScienceItemRender:ComponentDefine()
  self.science_icon = self:AddComponent(UIImage, science_icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UILWTrainScienceItemRender:ComponentDestroy()
  self.btn = nil
  self.science_icon = nil
end

function UILWTrainScienceItemRender:SetData(scienceId)
  self.scienceId = tonumber(scienceId)
  self.template = DataCenter.ScienceManager:GetScienceTemplate(self.scienceId)
  if self.template ~= nil then
    self.science_icon:LoadSprite(string.format(LoadPath.UILWScience, self.template.icon))
    local scienceLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    local showGray = scienceLevel == 0
    UIGray.SetGrayWithIgnore(self.btn.transform, showGray, "Bg")
  end
end

function UILWTrainScienceItemRender:OnBtnClick()
  local param = {}
  param.position = self:GetPosition()
  param.deltaY = 56
  param.scienceId = self.scienceId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainDepartureScienceTips, {anim = false}, param)
end

return UILWTrainScienceItemRender
