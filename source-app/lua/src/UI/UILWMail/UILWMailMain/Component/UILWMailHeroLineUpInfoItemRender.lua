local UILWMailHeroLineUpInfoItemRender = BaseClass("UILWMailHeroLineUpInfoItemRender", UIBaseContainer)
local base = UIBaseContainer
local lineup_text_path = "LineUpText"

function UILWMailHeroLineUpInfoItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMailHeroLineUpInfoItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailHeroLineUpInfoItemRender:ComponentDefine()
  self.lineup_text = self:AddComponent(UIText, lineup_text_path)
  self.lineUpItems = {}
  self.lineUpItemIcons = {}
  for i = 1, 5 do
    local path = string.format("Layout/LineUp%s", i)
    local lineUpItem = self:AddComponent(UIImage, path)
    self.lineUpItems[i] = lineUpItem
    local iconPath = string.format("Layout/LineUp%s/LineUpIcon%s", i, i)
    local lineUpIcon = self:AddComponent(UIImage, iconPath)
    self.lineUpItemIcons[i] = lineUpIcon
  end
end

function UILWMailHeroLineUpInfoItemRender:ComponentDestroy()
  self.lineup_text = nil
  self.lineUpItems = nil
  self.lineUpItemIcons = nil
end

function UILWMailHeroLineUpInfoItemRender:ReInit(heroCampList, selfIsAttack, playerData, isShowOldTitle)
  local listCount = #heroCampList
  for i = 1, 5 do
    if i <= listCount then
      self.lineUpItems[i]:SetActive(true)
      self.lineUpItemIcons[i]:LoadSprite(HeroUtils.GetHeroTypeIcon(heroCampList[i]))
    else
      self.lineUpItems[i]:SetActive(false)
    end
  end
  self:ShowCampPowerTitleTextInfo(selfIsAttack, playerData, isShowOldTitle)
end

function UILWMailHeroLineUpInfoItemRender:ShowCampPowerTitleTextInfo(selfIsAttack, playerData, isShowOldTitle)
  if isShowOldTitle then
    if selfIsAttack then
      self.lineup_text:SetLocalText("report_help_13")
    else
      self.lineup_text:SetLocalText("report_help_14")
    end
  else
    local isExistExtraPowerData = BattleReportUtil.IsContainsExtraPowerData(playerData)
    if isExistExtraPowerData then
      local campExtraPower = BattleReportUtil.GetExtraPowerStrAfterFormat(playerData, ExtraPowerInfoType.Camp)
      self.lineup_text:SetLocalText(GameDialogDefine.BATTLE_POWER, campExtraPower)
    else
      self.lineup_text:SetLocalText(GameDialogDefine.BATTLE_POWER, 0)
    end
  end
end

return UILWMailHeroLineUpInfoItemRender
