local UILWSeasonFactionWarRuleItem = BaseClass("UILWSeasonFactionWarRuleItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonFactionWarRuleItem:OnCreate()
  base.OnCreate(self)
  self.round_time = self:AddComponent(UITextMeshProUGUIEx, "roundTime")
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, "name1")
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, "name2")
  self.icon1 = self:AddComponent(UIImage, "icon1")
  self.icon2 = self:AddComponent(UIImage, "icon2")
  self.icon_arr = self:AddComponent(UIImage, "iconArr")
  self.bg = self:AddComponent(UIImage, "")
end

function UILWSeasonFactionWarRuleItem:OnDestroy()
  self.round_time = nil
  self.name1 = nil
  self.name2 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon_arr = nil
  base.OnDestroy(self)
end

function UILWSeasonFactionWarRuleItem:ReInit(index, roundNow, data)
  self.name1:SetText("")
  self.name2:SetText("")
  if data == nil then
    self.round_time:SetLocalText(312094, index)
    self.bg:SetColorRGBA255(255, 255, 255, 255)
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness then
      local mode = math.fmod(index, 8)
      if mode == 1 or mode == 4 or mode == 6 or mode == 7 then
        self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
        self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
        self.icon_arr:SetFlipX(true)
      else
        self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
        self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
        self.icon_arr:SetFlipX(false)
      end
    else
      local mode = math.fmod(index, 4)
      if mode == 0 or mode == 1 then
        self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
        self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
        self.icon_arr:SetFlipX(true)
      else
        self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
        self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
        self.icon_arr:SetFlipX(false)
      end
    end
  else
    self.round_time:SetText(UITimeManager:GetInstance():GetServerYMDByUTC(data.declareTime))
    if roundNow == data.round then
      self.bg:SetColorRGBA255(230, 255, 190, 255)
    else
      self.bg:SetColorRGBA255(255, 255, 255, 255)
    end
    if data.attackCampId == SeasonFactionType.Rebels then
      self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
      self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
      self.icon_arr:SetFlipX(true)
    else
      self.icon1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/defence.png")
      self.icon2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/attack.png")
      self.icon_arr:SetFlipX(false)
    end
  end
end

return UILWSeasonFactionWarRuleItem
