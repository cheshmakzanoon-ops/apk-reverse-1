local base = UIBaseContainer
local SelectItemComponent = BaseClass("SelectItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local textString = {
  "ghost_parkour_record_all",
  "ghost_parkour_record_attack",
  "ghost_parkour_record_defense"
}

function SelectItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SelectItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SelectItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgCheckmark = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgGray = self.viewSkin:AddComponent(self, UIImage, 3)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function SelectItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgCheckmark = nil
  self.textLabel = nil
  self.imgGray = nil
  self.btn = nil
end

function SelectItemComponent:DataDefine()
end

function SelectItemComponent:DataDestroy()
end

function SelectItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SelectItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SelectItemComponent:Refresh(type)
  self.type = type
  self.textLabel:SetLocalText(textString[type])
end

function SelectItemComponent:ExecuteCallback(callback)
  if callback and type(callback) == "function" then
    self.callBack = callback
  else
    print("Invalid function provided")
  end
end

function SelectItemComponent:SetCheckmark(value)
  self.imgGray:SetActive(value)
end

function SelectItemComponent:OnBtnClick()
  if self.callBack then
    self.callBack(self.type)
  end
end

return SelectItemComponent
