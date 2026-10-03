local base = UIBaseContainer
local cityItemComponent = BaseClass("cityItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local path = "Assets/Main/Sprites/UI/LWAllianceZone/Textures/%s.png"

function cityItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function cityItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function cityItemComponent:ComponentDefine()
  self.btnSelect = self:AddComponent(UIButton, "")
  self.btnSelect:SetOnClick(function()
    self:OnBtnSelectClick()
  end)
  self.imgTabUnSelect = self:AddComponent(UIImage, "tabUnSelect")
  self.imgTabSelect = self:AddComponent(UIImage, "tabSelect")
  self.imgCityIcon = self:AddComponent(UIImage, "cityIcon")
  self.textCityLevel = self:AddComponent(UITextMeshProUGUIEx, "cityLevel")
end

function cityItemComponent:ComponentDestroy()
  self.imgTabUnSelect = nil
  self.imgTabSelect = nil
  self.imgCityIcon = nil
  self.textCityLevel = nil
  self.btnSelect = nil
end

function cityItemComponent:DataDefine()
  self.index = nil
end

function cityItemComponent:DataDestroy()
  self.index = nil
end

function cityItemComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AttackCityS0RewardPopSelect, self.UpdateSelectState)
end

function cityItemComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.AttackCityS0RewardPopSelect, self.UpdateSelectState)
  base.OnRemoveListener(self)
end

function cityItemComponent:ReInit(data, index, curIndex)
  self.index = index
  self.textCityLevel:SetLocalText("140002", data.level)
  self.imgCityIcon:LoadSprite(string.format(path, data.icon))
  self:UpdateSelectState(curIndex)
end

function cityItemComponent:UpdateSelectState(curIndex)
  self.imgTabSelect.gameObject:SetActive(self.index == curIndex)
  self.imgTabUnSelect.gameObject:SetActive(self.index ~= curIndex)
end

function cityItemComponent:OnBtnSelectClick()
  EventManager:GetInstance():Broadcast(EventId.AttackCityS0RewardPopSelect, self.index)
end

return cityItemComponent
