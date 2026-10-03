local base = UIBaseContainer
local LLDetailSmallCity = BaseClass("LLDetailSmallCity", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLDetailSmallCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailSmallCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailSmallCity:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgTime = self.viewSkin:AddComponent(self, UIImage, 2)
  self.imgBuildingIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnPosText = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPosText:SetOnClick(function()
    self:OnBtnPosTextClick()
  end)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textOccupy = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 8)
  self.imgBuilding = self.viewSkin:AddComponent(self, UIImage, 9)
end

function LLDetailSmallCity:ComponentDestroy()
  self.viewSkin = nil
  self.textTime = nil
  self.imgTime = nil
  self.imgBuildingIcon = nil
  self.textPos = nil
  self.btnPosText = nil
  self.textName = nil
  self.textOccupy = nil
  self.slider = nil
  self.imgBuilding = nil
end

function LLDetailSmallCity:DataDefine()
end

function LLDetailSmallCity:DataDestroy()
  self.data = nil
end

function LLDetailSmallCity:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailSmallCity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailSmallCity:OnBtnPosTextClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.data == nil then
    return
  end
  ActMgr:JumpToCity(self.data.cityId)
end

function LLDetailSmallCity:SetData(data)
  if data == nil then
    return
  end
  self.data = data
  ActMgr:SetDetailCityShow(data, self.imgBuilding, self.imgTime, nil, self.textOccupy, self.textPos)
  local template = ActMgr:GetCityTemplate(data.cityId)
  if template ~= nil then
    local icon = data.state == LLConst.ZWLBuildingState.RUIN and template.ruins_icon or template:GetIconPath()
    self.imgBuildingIcon:LoadSpriteAsyncWithCallback(icon, function()
      self.imgBuildingIcon:SetAspectSize(190)
    end)
    self.textName:SetText(template:GetFullName())
    local cityPos = template.pos
    self.textPos:SetLocalText(300015, cityPos.x, cityPos.y)
  end
  local progress = self.data:GetPercent()
  local max = self.data.progressMax or 0
  local percent = max == 0 and 0 or progress * 1.0 / max
  self.slider:SetValue(percent)
  self.textTime:SetText(string.percentage(progress, max, 1))
end

return LLDetailSmallCity
