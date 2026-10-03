local FormationDetailGroupItem = BaseClass("FormationDetailGroupItem", UIBaseContainer)
local base = UIBaseContainer

function FormationDetailGroupItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FormationDetailGroupItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FormationDetailGroupItem:DataDefine()
end

function FormationDetailGroupItem:DataDestroy()
  self.type = nil
  self.callback = nil
end

function FormationDetailGroupItem:OnEnable()
  base.OnEnable(self)
end

function FormationDetailGroupItem:OnDisable()
  base.OnDisable(self)
end

function FormationDetailGroupItem:OnAddListener()
  base.OnAddListener(self)
end

function FormationDetailGroupItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FormationDetailGroupItem:ComponentDefine()
  self.name_txt = self:AddComponent(UIText, "groupName_txt")
  self.power_txt = self:AddComponent(UIText, "power_info/RealPower")
  self.bg = self:AddComponent(UIImage, "bg")
  self.icon = self:AddComponent(UIImage, "bg/icon")
  self.btn = self:AddComponent(UIButton, "groupDetail_btn")
  self.btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.MailScoutFormationDetail, {anim = true}, self.formationData, self.type, self.isDisturbed)
  end)
end

function FormationDetailGroupItem:ComponentDestroy()
  self.name_txt = nil
  self.power_txt = nil
  self.bg = nil
end

function FormationDetailGroupItem:SetData(name, icon, power, formationData, type, isDisturbed)
  self.name_txt:SetLocalText(name)
  self.icon:LoadSprite(icon)
  self.power_txt:SetText(string.GetFormattedStr2(power))
  self.formationData = formationData
  self.type = type
  self.isDisturbed = isDisturbed
end

return FormationDetailGroupItem
