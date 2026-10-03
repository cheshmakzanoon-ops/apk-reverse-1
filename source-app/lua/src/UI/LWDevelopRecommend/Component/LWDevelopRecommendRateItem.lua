local LWDevelopRecommendRateItem = BaseClass("LWDevelopRecommendRateItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWDevelopRecommendRateItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWDevelopRecommendRateItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWDevelopRecommendRateItem:ComponentDefine()
  self.imgIcon = self:AddComponent(UIImage, "TitleBase/TitleIcon")
  self.textName = self:AddComponent(UIText, "TitleBase/Layout/TitleText")
  self.imgSSS = self:AddComponent(UIImage, "TitleBase/Layout/ClassIconSSS")
  self.imgOther = self:AddComponent(UIImage, "TitleBase/Layout/ClassIconOther")
  self.textDes = self:AddComponent(UIText, "RateItemDetail")
  self.slider = self:AddComponent(UISlider, "Slider")
  self.textSlider = self:AddComponent(UIText, "Slider/ProgressText")
end

function LWDevelopRecommendRateItem:ComponentDestroy()
  self.imgIcon = nil
  self.textName = nil
  self.imgSSS = nil
  self.imgOther = nil
  self.textDes = nil
  self.slider = nil
  self.textSlider = nil
end

function LWDevelopRecommendRateItem:DataDefine()
end

function LWDevelopRecommendRateItem:DataDestroy()
  self.sourceType = nil
  self.data = nil
end

function LWDevelopRecommendRateItem:UpdateAllUI(data)
  self.data = data
  if self.data == nil then
    return
  end
  self.imgIcon:LoadSprite(self.data:GetSmallIconPath())
  self.textName:SetLocalText(self.data:GetName())
  local class = DataCenter.LWDevelopRecommendManager:GetClassByPowerSourceType(self.data:GetSourceType())
  self.imgSSS:SetActive(class == DataCenter.LWDevelopRecommendManager.Class.SSS)
  self.imgOther:SetActive(class ~= DataCenter.LWDevelopRecommendManager.Class.SSS)
  if class ~= DataCenter.LWDevelopRecommendManager.Class.SSS then
    self.imgOther:LoadSprite(DataCenter.LWDevelopRecommendManager:GetClassIconPath(class))
  end
  local rankValue = DataCenter.LWDevelopRecommendManager:GetPowerRate(self.data:GetSourceType())
  if 0 < rankValue and 40 <= rankValue then
    local str = " <color=#099B4A>" .. tostring(rankValue) .. "%" .. "</color> "
    self.textDes:SetLocalText("develop_guide_tip2", str)
  else
    self.textDes:SetLocalText("")
  end
  local recommendPower = DataCenter.LWDevelopRecommendManager:GetRecommendPowerValue(self.data:GetSourceType())
  local myPower = DataCenter.PlayerPowerDataManager:GetValByPowerSourceType(self.data:GetSourceType())
  local percent = 0
  if 0 < recommendPower then
    percent = myPower / recommendPower
  end
  self.slider:SetValue(math.min(1, percent))
  self.textSlider:SetText(myPower .. "/" .. recommendPower)
end

return LWDevelopRecommendRateItem
