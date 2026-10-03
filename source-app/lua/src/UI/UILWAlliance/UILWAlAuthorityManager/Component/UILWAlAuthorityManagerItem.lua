local UILWAlAuthorityManagerItem = BaseClass("UILWAlAuthorityManagerItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local duigou_icon_path = "GouBg/Gou"
local rank_icon_path = "Icon"
local click_btn_path = "GouBg"

function UILWAlAuthorityManagerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlAuthorityManagerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlAuthorityManagerItem:ComponentDefine()
  self.duiGouGo = self:AddComponent(UIBaseContainer, duigou_icon_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlAuthorityManagerItem:ComponentDestroy()
  self.duiGouGo = nil
  self.rankIcon = nil
  self.clickBtn = nil
end

function UILWAlAuthorityManagerItem:DataDefine()
  self.type = 0
end

function UILWAlAuthorityManagerItem:DataDestroy()
  self.type = nil
end

function UILWAlAuthorityManagerItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlAuthorityManagerItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlAuthorityManagerItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlAuthorityManagerItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlAuthorityManagerItem:SetData(type, curSelectType)
  self.type = type
  self.rankIcon:LoadSprite(LWAlMemberAuthorityParam[type].Icon)
  self.rankIcon:SetNativeSize()
  self:RefreshSelect(curSelectType)
end

function UILWAlAuthorityManagerItem:RefreshSelect(curSelectType)
  local isSelect = false
  if curSelectType == self.type then
    isSelect = true
  end
  if self.type == LWAlMemberAuthorityType.Rank_4 and self:IsOfficial(curSelectType) then
    isSelect = true
  end
  self.duiGouGo:SetActive(isSelect)
end

function UILWAlAuthorityManagerItem:OnClick()
  self.view:OnClickItem(self.type)
end

function UILWAlAuthorityManagerItem:IsOfficial(type)
  return type == LWAlMemberAuthorityType.Official_1 or type == LWAlMemberAuthorityType.Official_2 or type == LWAlMemberAuthorityType.Official_3 or type == LWAlMemberAuthorityType.Official_4
end

return UILWAlAuthorityManagerItem
