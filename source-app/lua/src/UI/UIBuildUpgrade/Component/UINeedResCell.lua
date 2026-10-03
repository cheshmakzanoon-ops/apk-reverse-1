local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer
local item_icon_path = "ResourceIcon"
local num_text_path = "ResourceNum"
local this_path = ""

function UINeedResCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UINeedResCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UINeedResCell:OnEnable()
  base.OnEnable(self)
end

function UINeedResCell:OnDisable()
  base.OnDisable(self)
end

function UINeedResCell:ComponentDefine()
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.num_shadow = self:AddComponent(UIShadow, num_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

function UINeedResCell:ComponentDestroy()
  self.item_icon = nil
  self.num_text = nil
  self.num_shadow = nil
end

function UINeedResCell:DataDefine()
  self.param = {}
end

function UINeedResCell:DataDestroy()
  self.param = {}
end

function UINeedResCell:ReInit(param)
  self.param = param
  if param.itemId ~= nil then
    self.item_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(param.itemId))
  elseif param.resItemId ~= nil then
    self.item_icon:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(param.resItemId))
  elseif param.resourceType ~= nil then
    self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.resourceType))
  end
  self.num_text:SetText(string.GetFormattedSpecial(param.count))
  if param.isRed then
    self.num_text:SetColor(Color.New(0.917, 0.26, 0.26, 1))
    self.num_shadow:AllEnable(false)
  else
    self.num_text:SetColor(WhiteColor)
    self.num_shadow:AllEnable(true)
  end
end

function UINeedResCell:OnBtnClick()
  if self.param.isRed and self.param.resourceType ~= nil then
    local data = {}
    table.insert(data, {
      resType = self.param.resourceType,
      need = self.param.count
    })
    LWResourceLackUtil:GotoResLack(data)
    return
  end
end

function UINeedResCell:IsLack()
  return self.param.isRed
end

function UINeedResCell:GetGuideBtn()
  return self.btn.gameObject
end

return UINeedResCell
