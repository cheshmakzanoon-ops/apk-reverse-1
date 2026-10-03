local LWNeedResourceItemRender = BaseClass("LWNeedResourceItemRender", UIBaseContainer)
local base = UIBaseContainer
local resource_icon_path = "ResourceIcon"
local resource_num_path = "ResourceText"

function LWNeedResourceItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWNeedResourceItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWNeedResourceItemRender:ComponentDefine()
  self.resource_icon_image = self:AddComponent(UIImage, resource_icon_path)
  self.resource_num_text = self:AddComponent(UIText, resource_num_path)
end

function LWNeedResourceItemRender:ComponentDestroy()
  self.resource_icon_image = nil
  self.resource_num_text = nil
end

function LWNeedResourceItemRender:ReInit(resType, have, need)
  self.resource_icon_image:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resType))
  local haveStr = string.GetFormattedStr(have)
  local needShowStr = string.format("<color=#736863>/ %s</color>", string.GetFormattedStr(need))
  if need <= have then
    local haveShowStr = string.format("<color=#099b4a> %s</color>", haveStr)
    self.resource_num_text:SetText(haveShowStr .. needShowStr)
  else
    local haveShowStr = string.format("<color=#f53c3d> %s</color>", haveStr)
    self.resource_num_text:SetText(haveShowStr .. needShowStr)
  end
end

return LWNeedResourceItemRender
