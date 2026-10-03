local UILWAlAuthorityInfoItem = BaseClass("UILWAlAuthorityInfoItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local title_txt_path = "Title/TitleTxt"
local icons_path = "Icons/"
local bg_path = "Bg"

function UILWAlAuthorityInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlAuthorityInfoItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlAuthorityInfoItem:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.iconList = {}
  for i = 1, 6 do
    self.iconList[i] = self:AddComponent(UIBaseContainer, icons_path .. "Icon" .. i)
  end
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
end

function UILWAlAuthorityInfoItem:ComponentDestroy()
  self.titleTxt = nil
  for i = 1, 6 do
    self.iconList[i] = nil
  end
  self.iconList = nil
end

function UILWAlAuthorityInfoItem:DataDefine()
end

function UILWAlAuthorityInfoItem:DataDestroy()
end

function UILWAlAuthorityInfoItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlAuthorityInfoItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlAuthorityInfoItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlAuthorityInfoItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlAuthorityInfoItem:SetData(data, index)
  self.titleTxt:SetLocalText(data.title)
  for i = 1, 6 do
    self.iconList[i]:SetActive(data.icons[i] and tostring(data.icons[i]) == "1")
  end
  if index then
    self.bg:SetActive(index % 2 == 0)
  end
end

return UILWAlAuthorityInfoItem
