local base = UIBaseContainer
local UIActMonopolyRulesManualItem = BaseClass("UIActMonopolyRulesManualItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local img_content_path = "ImgContent"
local img_path = "ImgContent/Img"
local text_path = "Text"
local line_content_path = "lineContent"

function UIActMonopolyRulesManualItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActMonopolyRulesManualItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyRulesManualItem:ComponentDefine()
  self.img_content = self:AddComponent(UILayoutElement, img_content_path)
  self.img = self:AddComponent(UIRawImage, img_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.line_content = self:AddComponent(UIBaseContainer, line_content_path)
end

function UIActMonopolyRulesManualItem:ComponentDestroy()
  self.img_content = nil
  self.img = nil
  self.text = nil
  self.line_content = nil
end

function UIActMonopolyRulesManualItem:DataDefine()
end

function UIActMonopolyRulesManualItem:DataDestroy()
end

function UIActMonopolyRulesManualItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActMonopolyRulesManualItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActMonopolyRulesManualItem:ReInit(activityId, id, index, totalNum)
  self.id = id
  self.index = index
  self.totalNum = totalNum
  local line = LocalController:instance():getLine(TableName.ACTIVITY_PIC_GUIDE, self.id)
  if not line then
    return
  end
  local pic = line.pic
  local texturePath = ""
  if pic and pic ~= "" and type(pic) == "string" and string.startswith(pic, "Assets/Main/") then
    texturePath = pic
  else
    texturePath = string.format(LoadPath.ActMonopolyRuleTexturePath, line.pic)
  end
  self.img:LoadSprite(texturePath)
  self.img:SetNativeSize()
  local imgSize = self.img:GetSizeDelta()
  local imgH = imgSize.y
  self.img_content:SetPreferredHeight(imgH)
  self.img_content:SetMinHeight(imgH)
  self.text:SetLocalText(line.key)
  self.line_content:SetActive(self.index ~= self.totalNum)
end

return UIActMonopolyRulesManualItem
