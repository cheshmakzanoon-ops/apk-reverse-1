local base = UIBaseContainer
local T11ResearchProgressArrowComponent = BaseClass("T11ResearchProgressArrowComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local NORMAL_ARR_PATH = "Assets/Main/Sprites/UI/UIT11/ljq_t11_jiantou_lv.png"
local GRAY_ARR_PATH = "Assets/Main/Sprites/UI/UIT11/ljq_t11_jiantou.png"

function T11ResearchProgressArrowComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11ResearchProgressArrowComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11ResearchProgressArrowComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgArrow1 = self.viewSkin:AddComponent(self, UIImage, 1)
end

function T11ResearchProgressArrowComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgArrow1 = nil
end

function T11ResearchProgressArrowComponent:DataDefine()
end

function T11ResearchProgressArrowComponent:DataDestroy()
end

function T11ResearchProgressArrowComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11ResearchProgressArrowComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11ResearchProgressArrowComponent:SetGrayState(isGray)
  if not self.imgArrow1 then
    return
  end
  self.imgArrow1:LoadSprite(isGray and GRAY_ARR_PATH or NORMAL_ARR_PATH)
end

return T11ResearchProgressArrowComponent
