local base = UIAsyncContainer
local KingInfoRoot = BaseClass("KingInfoRoot", base)
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local king_icon_path = "king_icon"
local king_name_text_path = "king_name"
local king_manage_btn_path = "king_btn"

function KingInfoRoot:OnCreate()
  base.OnCreate(self)
  self.king_icon = self:AddComponent(UIImage, king_icon_path)
  self.king_name_text = self:AddComponent(UIText, king_name_text_path)
  self.king_manage_btn = self:AddComponent(UIButton, king_manage_btn_path)
  self.king_manage_btn:SetOnClick(function()
    local cityId = self.view.ctrl.cityId
    local serverId = self.view.ctrl.serverId
    local seasonType = SeasonUtil.GetSeasonType(false, false, ServerEnum.View)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIUtil.DestroyWorldSiegePoint()
    if seasonType == SeasonMapType.NineNation and SeasonUtil.GetCenterCityId(serverId) == cityId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialMain, {anim = true}, GovOfficialType.Center, serverId, cityId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentMain, {anim = true}, serverId, cityId)
    end
  end)
  self:DataDefine()
  self.serverId = self.view.ctrl.serverId or LuaEntry.Player:GetCurServerId()
  if DataCenter.GovernmentManager:GetCurPresident(self.serverId) == nil then
    DataCenter.GovernmentManager:GetKingInfoByServerId(self.serverId)
  end
end

function KingInfoRoot:DataDefine()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionList(self.view.ctrl.serverId, self.view.ctrl.cityId)
end

function KingInfoRoot:OnDestroy()
  base.OnDestroy(self)
end

function KingInfoRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionList, self.UpdateData)
  self:AddUIListener(EventId.KingdomPresidentInfoUpdate, self.UpdateData)
end

function KingInfoRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionList, self.UpdateData)
  self:RemoveUIListener(EventId.KingdomPresidentInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function KingInfoRoot:ReInit()
  self:UpdateData()
end

function KingInfoRoot:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local serverId = self.serverId
  local curPresident
  local seasonType = SeasonUtil.GetSeasonType(false, false, ServerEnum.View)
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, ServerEnum.View)
  if seasonType == SeasonMapType.NineNation and SeasonUtil.GetCenterCityId(serverId) == self.view.ctrl.cityId then
    curPresident = DataCenter.BuildingOfficialManager:GetSurfaceLeader(serverId, self.view.ctrl.cityId)
    self.king_manage_btn:SetActive(SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source))
    local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(GovOfficialType.Center, seasonSubType)
    self.king_icon:LoadSpriteAsync(leaderConfig.icon)
  else
    curPresident = DataCenter.GovernmentManager:GetCurPresident(serverId)
    local sourceServerId = LuaEntry.Player:GetSourceServerId()
    local showBtn = false
    if sourceServerId == serverId then
      showBtn = true
    else
      local isBigMap, isSameGroup = SeasonUtil.InSeasonBigMapMode(serverId, sourceServerId)
      if isBigMap and isSameGroup and SeasonUtil.IsUserInSeason() then
        showBtn = true
      end
    end
    self.king_manage_btn:SetActive(showBtn)
    local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(GovOfficialType.Native, seasonSubType)
    self.king_icon:LoadSpriteAsync(leaderConfig.icon)
  end
  if curPresident == nil then
    if LuaEntry.Player:IsPresident(serverId) then
      self.king_name_text:SetText(LuaEntry.Player:GetName())
    else
      self.king_name_text:SetLocalText("391071")
      local curServerId = self.serverId
      local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
      local pointInfo = CS.SceneManager.World:GetPointInfo(kingCityPosIndex)
      if pointInfo ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
        if allianceCityPointInfo ~= nil then
          local timeOpen = allianceCityPointInfo.openTime
          local timeEnd = allianceCityPointInfo.protectTime
          if curTime > timeOpen and curTime < timeEnd then
            self.king_name_text:SetLocalText("457017")
          end
        end
      end
    end
  else
    self.king_name_text:SetText(UIUtil.FormatAllianceAndName(curPresident.allianceAbbr or curPresident.abbr, curPresident.name))
  end
end

return KingInfoRoot
