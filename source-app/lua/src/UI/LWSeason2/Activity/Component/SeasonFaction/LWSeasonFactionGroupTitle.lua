local LWSeasonFactionGroupTitle = BaseClass("LWSeasonFactionGroupTitle", UIButton)
local base = UIButton
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function LWSeasonFactionGroupTitle:OnCreate()
  base.OnCreate(self)
  self.my_pos_icon = self:AddComponent(UIImage, "MyPosIcon")
  self.arrow_icon = self:AddComponent(UIImage, "ArrowIcon")
  self.arrow_icon_select = self:AddComponent(UIImage, "ArrowIconSelect")
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, "MemberText")
  self:SetOnClick(function()
    self:SwitchStatus()
  end)
end

function LWSeasonFactionGroupTitle:OnDestroy()
  self.my_pos_icon = nil
  self.arrow_icon = nil
  self.arrow_icon_select = nil
  self.title_text = nil
  base.OnDestroy(self)
end

function LWSeasonFactionGroupTitle:OnEnable()
  base.OnEnable(self)
end

function LWSeasonFactionGroupTitle:OnDisable()
  base.OnDisable(self)
end

function LWSeasonFactionGroupTitle:ReInit(campId, data, view)
  self.campId = campId
  self.data = data
  self.parentView = view
  self.expand = not not data.expand
  self.title_text:SetLocalText("season_s2_faction_war_17", data.group, data.rankMin, data.rankMax)
  self.arrow_icon_select:SetActive(self.expand)
  if data and data.group and view and (view.myGroupIndex == data.group or view.myEnemyIndex == data.group) then
    self.my_pos_icon:SetActive(true)
    if view.myGroupIndex == data.group then
      self.my_pos_icon:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmengchengyuan_dingwei.png")
    else
      self.my_pos_icon:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/zyf_tongmengchengyuan_enemy.png")
    end
  else
    self.my_pos_icon:SetActive(false)
  end
end

function LWSeasonFactionGroupTitle:SwitchStatus()
  self.expand = not self.expand
  self.arrow_icon_select:SetActive(self.expand)
  self.parentView:OnGroupClick(self.data.group, self.expand)
end

return LWSeasonFactionGroupTitle
