local LWPowerOverviewItemTitle = BaseClass("LWPowerOverviewItemTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "Content/iconContent/icon"
local empty_content_path = "Content/emptyContent"
local button_content_path = "Content/buttonContent"
local button_img_path = "Content/buttonContent/buttonImg"

function LWPowerOverviewItemTitle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWPowerOverviewItemTitle:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWPowerOverviewItemTitle:ComponentDefine()
  self.name = self:AddComponent(UIText, "Content/name")
  self.value = self:AddComponent(UIText, "Content/value")
  self.icon = self:AddComponent(UIImage, icon_path)
  self.empty_content = self:AddComponent(UIBaseContainer, empty_content_path)
  self.button_content = self:AddComponent(UIBaseContainer, button_content_path)
  self.button_img = self:AddComponent(UIImage, button_img_path)
end

function LWPowerOverviewItemTitle:ComponentDestroy()
  self.name = nil
  self.value = nil
  self.icon = nil
  self.empty_content = nil
  self.button_content = nil
  self.button_img = nil
end

function LWPowerOverviewItemTitle:DataDefine()
end

function LWPowerOverviewItemTitle:DataDestroy()
end

function LWPowerOverviewItemTitle:Refresh(data)
  self.data = data
  local iconPath, sizeX, sizeY = self.view.ctrl:GetIconPathByPowerType(self.data.powerType)
  self.icon:LoadSprite(iconPath)
  if sizeX and sizeY then
    self.icon:SetSizeDeltaXY(sizeX, sizeY)
  else
    self.icon:SetNativeSize()
  end
  self.name:SetLocalText(self.view.ctrl:GetNameKeyByPowerType(self.data.powerType))
  self.value:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.powerTypeVal)))
  if #self.data.sourceTab > 0 then
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

return LWPowerOverviewItemTitle
