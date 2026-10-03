local UICommonPropertyCanFoldItemTitle = BaseClass("UICommonPropertyCanFoldItemTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local icon_path = "Content/iconContent/icon"
local empty_content_path = "Content/emptyContent"
local button_content_path = "Content/buttonContent"
local button_img_path = "Content/buttonContent/buttonImg"

function UICommonPropertyCanFoldItemTitle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICommonPropertyCanFoldItemTitle:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonPropertyCanFoldItemTitle:ComponentDefine()
  self.name = self:AddComponent(UILWScienceDetailDesc, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
  self.icon = self:AddComponent(UIImage, icon_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.button_content = self:AddComponent(UIBaseContainer, button_content_path)
  self.button_img = self:AddComponent(UIImage, button_img_path)
end

function UICommonPropertyCanFoldItemTitle:ComponentDestroy()
  self.name = nil
  self.value = nil
  self.icon = nil
  self.empty_content = nil
  self.button_content = nil
  self.button_img = nil
end

function UICommonPropertyCanFoldItemTitle:DataDefine()
end

function UICommonPropertyCanFoldItemTitle:DataDestroy()
end

function UICommonPropertyCanFoldItemTitle:Refresh(data)
  self.data = data
  self.icon.gameObject:SetActive(false)
  
  local function ProcessDesc(desc)
    local modifiedText = string.gsub(desc, "<link=", string.format("<color=%s><u><link=", "#FFAC40"))
    modifiedText = string.gsub(modifiedText, "</link>", "</link></u></color>")
    return modifiedText
  end
  
  local des = data.mainTotalTitle
  des = Localization:GetString(des)
  des = ProcessDesc(des)
  self.name:SetText(des)
  self.value:SetText(data.mainTotalValue)
  if data.hasRows then
    self.empty_content:SetActive(false)
    self.button_content:SetActive(true)
    if self.data.isShowDetail then
      self.button_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png")
    else
      self.button_img:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png")
    end
  else
    self.empty_content:SetActive(true)
    self.button_content:SetActive(false)
  end
end

return UICommonPropertyCanFoldItemTitle
