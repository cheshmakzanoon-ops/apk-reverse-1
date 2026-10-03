local WorldSearchItemCell = BaseClass("WorldSearchItemCell", UIBaseContainer)
local base = UIBaseContainer
local BLOODY_NIGHT_CELL_BG = "Assets/Main/Sprites/UI/UISearch/mjc_s4_shijiesouguai_xueye_box01.png"
local NORMAL_NIGHT_CELL_BG = "Assets/Main/Sprites/UI/UISearch/zyf_shijiesouguai_guaiwudikuang.png"

function WorldSearchItemCell:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "Icon")
  self.iconType = self:AddComponent(UIImage, "IconType")
  self.bg = self:AddComponent(UIImage, "")
  self.selectBg = self:AddComponent(UIImage, "selectBg")
  self.text = self:AddComponent(UIText, "txt")
  self.flag = self:AddComponent(UIImage, "flag")
  self.act = self:AddComponent(UIText, "flag/act")
  self.redPoint = self:AddComponent(UIBaseContainer, "RedPoint")
  self.redPoint:SetActive(false)
  self.act:SetLocalText("2010117")
  self.flag:SetActive(false)
  self.iconType:SetActive(false)
  if DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetSelfServerId()) then
    self.bg:LoadSprite(BLOODY_NIGHT_CELL_BG)
    self.selectBg:SetEnable(false)
  else
    self.bg:LoadSprite(NORMAL_NIGHT_CELL_BG)
    self.selectBg:SetEnable(true)
  end
end

function WorldSearchItemCell:Refresh(cfg, v, isMonster)
  self.meta = cfg
  self.icon:LoadSpriteAsyncWithCallback(cfg.icon, function()
    if self and self.icon then
      self.icon:SetNativeSize()
    end
  end)
  self.flag:SetActive(v ~= nil and v.activityType ~= nil)
  if isMonster and SeasonUtil.IsInSeason() then
    self.text:SetText("")
    self.iconType:SetActive(true)
  else
    self.text:SetLocalText(cfg.name)
    self.iconType:SetActive(false)
  end
end

function WorldSearchItemCell:SetGray(gray)
  CS.UIGray.SetGray(self.transform, gray, true)
  CS.UIGray.SetGray(self.redPoint.transform, false, true)
end

return WorldSearchItemCell
