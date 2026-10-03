local UILWSeasonFactionWarRuleItemS4 = BaseClass("UILWSeasonFactionWarRuleItemS4", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonFactionWarRuleItemS4:OnCreate()
  base.OnCreate(self)
  self.round_time = self:AddComponent(UITextMeshProUGUIEx, "roundTime")
  self.name1 = self:AddComponent(UITextMeshProUGUIEx, "name1")
  self.name2 = self:AddComponent(UITextMeshProUGUIEx, "name2")
  self.icon1 = self:AddComponent(UIImage, "icon1")
  self.icon2 = self:AddComponent(UIImage, "icon2")
  self.icon_arr = self:AddComponent(UIImage, "iconArr")
  self.bg = self:AddComponent(UIImage, "")
end

function UILWSeasonFactionWarRuleItemS4:OnDestroy()
  self.round_time = nil
  self.name1 = nil
  self.name2 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon_arr = nil
  base.OnDestroy(self)
end

function UILWSeasonFactionWarRuleItemS4:ReInit(index, roundNow, data)
  self.name1:SetText("")
  self.name2:SetText("")
  if data == nil then
    self.round_time:SetLocalText(312094, index)
    self.bg:SetColorRGBA255(255, 255, 255, 255)
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

return UILWSeasonFactionWarRuleItemS4
