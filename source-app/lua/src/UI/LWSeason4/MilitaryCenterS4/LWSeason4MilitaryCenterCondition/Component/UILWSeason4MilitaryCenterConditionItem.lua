local UILWSeason4MilitaryCenterConditionItem = BaseClass("UILWSeason4MilitaryCenterConditionItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local tick_path = "Image/tick"
local title_path = "Image/title"
local desc_path = "desc"
local image_path = "Image"

function UILWSeason4MilitaryCenterConditionItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.tick = self:AddComponent(UIImage, tick_path)
  self.titleBg = self:AddComponent(UIImage, image_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

function UILWSeason4MilitaryCenterConditionItem:OnDestroy()
  self.bg = nil
  self.tick = nil
  self.title = nil
  self.desc = nil
  self.titleBg = nil
  base.OnDestroy(self)
end

function UILWSeason4MilitaryCenterConditionItem:ReInit(index, conditionType, template)
  local desc = ""
  local ok = false
  self.conditionType = conditionType
  self.template = template
  if conditionType == AlMineConditionType.MemberCount then
    self.title:SetText(Localization:GetString("season_s2_alliance_building_ui006"))
    local limit = template.limitMember
    if limit ~= nil and 0 < limit then
      local curMember = 0
      local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceInfo then
        curMember = toInt(allianceInfo.curMember)
      end
      ok = limit <= curMember
      desc = Localization:GetString("season_s2_alliance_building_ui009", curMember, limit)
    else
      ok = true
    end
  elseif conditionType == AlMineConditionType.Power then
    self.title:SetText(Localization:GetString("season_s2_alliance_building_ui007"))
    local limit = template.limitPower
    if limit ~= nil and 0 < limit then
      local fightPower = 0
      local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceInfo then
        fightPower = tonumber(allianceInfo.fightPower)
      end
      ok = limit <= fightPower
      desc = Localization:GetString("season_s2_alliance_building_ui010", string.GetFormattedStr(fightPower), string.GetFormattedStr(limit))
    else
      ok = true
    end
  elseif conditionType == AlMineConditionType.Resource then
    self.title:SetText(Localization:GetString("2010819"))
    local limit = template:GetBuildCost(ResourceType.AllianceStone)
    if limit ~= nil and 0 < limit then
      local hasCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
      local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.AllianceStone)
      ok = limit <= hasCoal
      desc = name .. ": " .. string.GetFormattedSeparatorNum(hasCoal) .. "/" .. string.GetFormattedSeparatorNum(limit)
    else
      ok = true
    end
  end
  if ok then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_fuhetiaojianbg.png")
    self.titleBg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_fuhetiaojian_title.png")
    self.tick:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_fuhetiaojian.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_bufuhetiaojianbg.png")
    self.titleBg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_bufuhetiaojian_title.png")
    self.tick:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_bufuhetiaojian.png")
  end
  self.desc:SetText(desc)
  self.ok = ok
  return ok
end

function UILWSeason4MilitaryCenterConditionItem:Update1000MS()
  if self.template and self.conditionType == AlMineConditionType.Resource then
    local limit = self.template:GetBuildCost(ResourceType.AllianceCoal)
    if limit ~= nil and 0 < limit then
      local hasCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
      local name = DataCenter.ResourceManager:GetResourceNameByType(ResourceType.AllianceCoal)
      local ok = limit <= hasCoal
      local desc = name .. ": " .. string.GetFormattedSeparatorNum(hasCoal) .. "/" .. string.GetFormattedSeparatorNum(limit)
      self.desc:SetText(desc)
      if self.ok ~= ok then
        if ok then
          self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_fuhetiaojianbg.png")
          self.titleBg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_fuhetiaojian_title.png")
          self.tick:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_fuhetiaojian.png")
        else
          self.bg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_bufuhetiaojianbg.png")
          self.titleBg:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_bufuhetiaojian_title.png")
          self.tick:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/lrb_xuanzhanjiemian_bufuhetiaojian.png")
        end
        self.ok = ok
        if not ok and self.view and self.view.btn_build then
          CS.UIGray.SetGray(self.view.btn_build.transform, true, false)
        end
      end
    end
  end
end

return UILWSeason4MilitaryCenterConditionItem
