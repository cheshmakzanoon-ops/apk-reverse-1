local MainItem = BaseClass("MainItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local StringUtils = CS.StringUtils

function MainItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.icon = self:AddComponent(UIImage, "Icon")
  self.text = self:AddComponent(UIText, "Text")
  self.red_pot = self:AddComponent(UIImage, "RedPot")
  self.btn:SetOnClick(function()
    self:OnCellClick()
  end)
end

function MainItem:OnDestroy()
  base.OnDestroy(self)
end

function MainItem:ReInit(index, serverId)
  self.index = index
  self.serverId = serverId
  if index == 7 then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local seasonType = SeasonUtil.GetSeasonSubdivisionType(false, ServerEnum.Source)
    self:SetActive(seasonType == SeasonMapType.NineNationRainforest and mySourceServerId == serverId)
  end
end

function MainItem:OnCellClick()
  local sourceServerId = LuaEntry.Player:GetSourceServerId()
  if self.index == 1 then
    local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
    local destroyerKingConfig = SeasonUtil.IsInSeason() and DataCenter.GovernmentTemplateManager:GetDestroyerKingConfig(seasonSubType)
    if destroyerKingConfig then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDestroyerOfficialList, {anim = true}, self.view.serverId, self.view.buildingId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.view.serverId)
    end
  elseif self.index == 2 then
    if self.serverId ~= sourceServerId then
      UIUtil.ShowTipsId("season_s6_zone_government_tips_4")
      return
    end
    UIUtil.ShowTipsId(457061)
  elseif self.index == 3 then
    local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
    local destroyerKingConfig = SeasonUtil.IsInSeason() and DataCenter.GovernmentTemplateManager:GetDestroyerKingConfig(seasonSubType)
    if destroyerKingConfig then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDestroyerOfficialEncourage, {anim = true}, self.view.serverId, self.view.buildingId)
    else
      if self.serverId ~= sourceServerId then
        UIUtil.ShowTipsId("season_s6_zone_government_tips_4")
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEncourage)
    end
  elseif self.index == 4 then
    if self.serverId ~= sourceServerId then
      UIUtil.ShowTipsId("season_s6_zone_government_tips_4")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentPresidentHistory)
  elseif self.index == 5 then
    if self.serverId ~= sourceServerId then
      UIUtil.ShowTipsId("season_s6_zone_government_tips_4")
      return
    end
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
    if not canChat then
      return
    end
    if StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.258") >= 0 and not Config.IsPC() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEmail_v2)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentEmail)
    end
  elseif self.index == 6 then
    if self.serverId ~= sourceServerId then
      UIUtil.ShowTipsId("season_s6_zone_government_tips_4")
      return
    end
    if DataCenter.GovernmentManager:SwitchOpenOrAtHomeNow() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentMedal)
    else
      UIUtil.ShowTipsId(500019)
    end
  elseif self.index == 7 then
    if self.serverId ~= sourceServerId then
      UIUtil.ShowTipsId("season_s6_zone_government_tips_4")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRainforestKingDestroyRank)
  end
end

return MainItem
