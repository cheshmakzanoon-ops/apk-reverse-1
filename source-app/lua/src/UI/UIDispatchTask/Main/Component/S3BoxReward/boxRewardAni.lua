local base = UIBaseContainer
local boxRewardAni = BaseClass("boxRewardAni", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function boxRewardAni:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function boxRewardAni:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function boxRewardAni:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.ani = self:AddComponent(UIAnimator, "")
  self.compText1 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function boxRewardAni:ComponentDestroy()
  self.viewSkin = nil
  self.compText1 = nil
  self.textText1 = nil
  self.compText2 = nil
  self.ani = nil
  self.textText2 = nil
end

function boxRewardAni:DataDefine()
end

function boxRewardAni:DataDestroy()
end

function boxRewardAni:OnAddListener()
  base.OnAddListener(self)
end

function boxRewardAni:OnRemoveListener()
  base.OnRemoveListener(self)
end

function boxRewardAni:PlayTextAni(data)
  self.textText1:SetText(data.pointNum)
  if data.isCrit == 1 then
    self.ani:Play("V_ui_cangbaotu_text_in2")
  else
    self.ani:Play("V_ui_cangbaotu_text_in1")
  end
end

return boxRewardAni
