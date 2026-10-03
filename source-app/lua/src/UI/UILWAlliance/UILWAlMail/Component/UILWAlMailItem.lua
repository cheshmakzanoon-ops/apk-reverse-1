local UILWAlMailItem = BaseClass("UILWAlMailItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local duigou_icon_path = "GouBg/Gou"
local rank_icon_path = "Icon"
local click_btn_path = "GouBg"

function UILWAlMailItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMailItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMailItem:ComponentDefine()
  self.duiGouGo = self:AddComponent(UIBaseContainer, duigou_icon_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlMailItem:ComponentDestroy()
  self.duiGouGo = nil
  self.rankIcon = nil
  self.clickBtn = nil
end

function UILWAlMailItem:DataDefine()
  self.type = 0
end

function UILWAlMailItem:DataDestroy()
  self.type = nil
end

function UILWAlMailItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMailItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMailItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMailItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMailItem:SetData(type, beSelect)
  self.type = type
  self.rankIcon:LoadSprite(LWAlMemberRankParam[type].Icon)
  self.rankIcon:SetNativeSize()
  self:RefreshSelect(beSelect)
end

function UILWAlMailItem:RefreshSelect(beSelect)
  local isSelect = beSelect
  self.duiGouGo:SetActive(isSelect)
end

function UILWAlMailItem:OnClick()
  self.view:OnClickItem(self.type)
end

return UILWAlMailItem
