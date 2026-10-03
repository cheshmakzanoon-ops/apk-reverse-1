local base = UIAsyncContainer
local UIBFBaseSelectUserTitle = BaseClass("UIBFBaseSelectUserTitle", base)
local rank_icon_path = "RankIcon"
local icon0_path = "Icon0"
local icon_text0_path = "IconText0"
local icon_text1_path = "IconText1"
local icon_text2_path = "IconText2"
local arrow_icon_path = "ArrowIcon"
local arrow_icon_select_path = "ArrowIcon/ArrowIconSelect"
local member_text_path = "MemberText"

function UIBFBaseSelectUserTitle:OnCreate()
  base.OnCreate(self)
  self.isCommanderModuleEnable = self.view.ctrl:IsCommanderModuleEnable()
  self.rank_icon = self:AddComponent(UIImage, rank_icon_path)
  self.icon_text1 = self:AddComponent(UIText, icon_text1_path)
  self.icon_text2 = self:AddComponent(UIText, icon_text2_path)
  self.arrow_icon = self:AddComponent(UIImage, arrow_icon_path)
  self.arrow_icon_select = self:AddComponent(UIImage, arrow_icon_select_path)
  self.member_text = self:AddComponent(UIText, member_text_path)
  self.title_content = self:AddComponent(UIButton, "")
  self.arrow_icon_select:SetActive(false)
  self.title_content:SetOnClick(function()
    if self.data and self.data.rankId then
      self.view:SetRankGroupShowMember(self.data.rankId, false)
    end
  end)
  if self.isCommanderModuleEnable then
    self.icon0 = self:TryAddComponent(UIBaseComponent, icon0_path)
    self.icon0:SetActive(true)
    self.icon_text0 = self:TryAddComponent(UIText, icon_text0_path)
    self.icon_text0:SetActive(true)
  end
end

function UIBFBaseSelectUserTitle:OnDestroy()
  base.OnDestroy(self)
end

function UIBFBaseSelectUserTitle:SetData(data)
  self.data = data
  self:Refresh()
end

function UIBFBaseSelectUserTitle:Refresh()
  local data = self.data
  if data then
    self.rank_icon:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r" .. data.rankId .. ".png")
    local expand = data.showMember == true
    self.arrow_icon_select:SetActive(expand)
    self.icon_text1:SetText(tostring(data.mainCount or 0))
    self.icon_text2:SetText(tostring(data.subCount or 0))
    self.member_text:SetLocalText(455062, data.onlineNum or 0, data.allNum or 0)
    if self.isCommanderModuleEnable then
      self.icon_text0:SetText(tostring(data.comCount or 0))
    end
  end
end

function UIBFBaseSelectUserTitle:Update100MS()
  if self.data then
    self:Refresh()
  end
end

return UIBFBaseSelectUserTitle
