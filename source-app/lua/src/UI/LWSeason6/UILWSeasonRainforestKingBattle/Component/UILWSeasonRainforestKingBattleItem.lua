local UILWSeasonRainforestKingBattleItem = BaseClass("UILWSeasonRainforestKingBattleItem", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonRainforestKingBattleItem:OnCreate()
  base.OnCreate(self)
  self.occupyName = self:AddComponent(UITextMeshProUGUIEx, "Name")
  self.bg = self:AddComponent(UIImage, "")
  self.home_icon = self:AddComponent(UIButton, "homeIcon")
  self.server_bg = self:AddComponent(UIButton, "ServerBg")
  self.server_txt = self:AddComponent(UITextMeshProUGUIEx, "ServerBg/ServerTxt")
  self.status = self:AddComponent(UIImage, "status")
  self.home_icon:SetOnClick(function()
    self:TryShowDetail()
  end)
  self.server_bg:SetOnClick(function()
    self:TryShowDetail()
  end)
  self.statusAnim = self:AddComponent(UIAnimator, "status")
  self.eff_attack_fight_fire = self:AddComponent(UIBaseContainer, "Eff_ui_S5_OutpostAttack_fight_fire")
  self.eff_attack_idle_d = self:AddComponent(UIBaseContainer, "Eff_ui_S5_OutpostAttack_idle_d")
  self.eff_attack_idle_u = self:AddComponent(UIBaseContainer, "Eff_ui_S5_OutpostAttack_idle_u")
end

function UILWSeasonRainforestKingBattleItem:OnDestroy()
  self.bg = nil
  self.home_icon = nil
  self.server_bg = nil
  self.server_txt = nil
  self.status = nil
  self.occupyName = nil
  self.statusAnim = nil
  self.eff_attack_fight_fire = nil
  self.eff_attack_idle_d = nil
  self.eff_attack_idle_u = nil
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingBattleItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
  self:AddUIListener(EventId.MyAlCityListChanged, self.OnCityStatusChanged)
end

function UILWSeasonRainforestKingBattleItem:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
  self:RemoveUIListener(EventId.MyAlCityListChanged, self.OnCityStatusChanged)
  base.OnRemoveListener(self)
end

function UILWSeasonRainforestKingBattleItem:OnCityStatusChanged()
  if self.kingCityId and self.serverId then
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(self.kingCityId, self.serverId)
    if cityData then
      self.cityData = cityData
      if toInt(cityData.destroyServerId) > 0 then
        self.battleEndTime = nil
        self.status:SetActive(false)
        self:ShowAnim()
      end
    end
  end
end

function UILWSeasonRainforestKingBattleItem:OnSearchAllianceSuccess()
  if self.occupyName and self.data and self.data.ownerAllianceId and self.data.ownerServerId then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.data.ownerAllianceId)
    if allianceInfo ~= nil then
      local colorStr = "<color=" .. (self.fontColor or "#ffffff") .. ">"
      self.occupyName:SetText(colorStr .. UIUtil.FormatServerAllianceName(self.data.ownerServerId, allianceInfo.abbr, nil) .. "</color>")
    end
  end
end

function UILWSeasonRainforestKingBattleItem:SetMapIndex(mapIndex, kingCityId, attackActData, pop_up_panel)
  self.mapIndex = mapIndex
  self.kingCityId = kingCityId
  self.attackActData = attackActData
  self.popupPanel = pop_up_panel
  self.serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(mapIndex, ServerEnum.Source)
  self.cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(kingCityId, self.serverId)
  self.server_txt:SetText("#" .. tostring(self.serverId))
end

function UILWSeasonRainforestKingBattleItem:ReInit(battleStartTime, battleEndTime)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local data = self.cityData
  local isMyCampServer = DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(mySourceServerId, self.serverId)
  self.data = data
  self.battleStartTime = battleStartTime
  self.battleEndTime = battleEndTime
  if data then
    local fontColor = "#ffffff"
    local ownerServerId = toInt(data.ownerServerId)
    if ownerServerId == 0 then
      ownerServerId = self.serverId
    end
    self.status:SetActive(false)
    if 0 >= toInt(data.destroyServerId) then
      local mgr = DataCenter.WorldAllianceCityDataManager
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.kingCityId, self.serverId)
      if cityTemplate then
        local nearBy = cityTemplate.nearBy
        if isMyCampServer then
          if mySourceServerId == self.serverId then
            self.status:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_jinggong.png")
            self.status:SetActive(true)
          elseif nearBy then
            for _, _cityId in ipairs(nearBy) do
              local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(_cityId), self.serverId)
              if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 and cityInfo.occupyServerId == mySourceServerId then
                self.status:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_jinggong.png")
                self.status:SetActive(true)
                break
              end
            end
          end
        elseif nearBy then
          for _, _cityId in ipairs(nearBy) do
            local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(_cityId), self.serverId)
            if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 and cityInfo.occupyServerId == mySourceServerId then
              self.status:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_jinggong.png")
              self.status:SetActive(true)
              break
            end
          end
        end
      end
      if ownerServerId == mySourceServerId then
        fontColor = "#5fef87"
      end
      self.fontColor = fontColor
    end
    local colorStr = "<color=" .. fontColor .. ">"
    if string.IsNullOrEmpty(data.ownerAllianceId) then
      self.occupyName:SetText(colorStr .. UIUtil.FormatServerAllianceName(ownerServerId, nil, nil) .. "</color>")
    else
      local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(data.ownerAllianceId)
      if allianceInfo == nil then
        SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, data.ownerAllianceId)
        self.occupyName:SetText(colorStr .. UIUtil.FormatServerAllianceName(ownerServerId, nil, nil) .. "</color>")
      else
        self.occupyName:SetText(colorStr .. UIUtil.FormatServerAllianceName(ownerServerId, allianceInfo.abbr, nil) .. "</color>")
      end
    end
  else
    self.status:SetActive(false)
    self.occupyName:SetText("#" .. self.serverId)
    self.occupyName:SetSizeDeltaXY(150, 55)
  end
  self.occupyName:SetText("")
  self:ShowAnim()
end

function UILWSeasonRainforestKingBattleItem:ShowAnim()
  if self.status and self.status:GetActive() then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local protectTime = DataCenter.AllianceCityTipManager:GetProtectedTime(self.serverId, self.kingCityId)
    if protectTime ~= nil and protectTime ~= 0 and curTime < protectTime then
      self.statusAnim:Enable(false)
      self.status:SetActive(false)
      self.eff_attack_fight_fire:SetActive(false)
      self.eff_attack_idle_d:SetActive(false)
      self.eff_attack_idle_u:SetActive(false)
      return
    end
    if self.battleEndTime and curTime > self.battleStartTime and curTime < self.battleEndTime then
      self.statusAnim:Enable(true)
      self.eff_attack_fight_fire:SetActive(true)
      self.eff_attack_idle_d:SetActive(false)
      self.eff_attack_idle_u:SetActive(false)
      self.statusAnim:Play("V_ui_S5_OutpostAttack_fight_status_idle")
      return
    end
    self.statusAnim:Enable(false)
    self.eff_attack_fight_fire:SetActive(false)
    self.eff_attack_idle_d:SetActive(true)
    self.eff_attack_idle_u:SetActive(true)
  else
    self.statusAnim:Enable(false)
    self.eff_attack_fight_fire:SetActive(false)
    self.eff_attack_idle_d:SetActive(false)
    self.eff_attack_idle_u:SetActive(false)
  end
end

function UILWSeasonRainforestKingBattleItem:Update1000MS()
  if self.battleEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.battleEndTime then
      self.battleEndTime = nil
      self:ShowAnim()
    end
  end
end

function UILWSeasonRainforestKingBattleItem:TryShowDetail()
  if self.kingCityId and self.serverId then
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(self.kingCityId, self.serverId)
    if cityData then
      self.cityData = cityData
      if toInt(cityData.destroyServerId) > 0 then
        UIUtil.ShowTipsId("season_s6_activity_1200116_desc06")
        return
      end
    end
  end
  if self.mapIndex == nil or self.mapIndex == 5 then
    return
  end
  if self.popupPanel then
    self.popupPanel:ShowIt(self, self.mapIndex, self.kingCityId, self.attackActData, self.data)
  end
end

return UILWSeasonRainforestKingBattleItem
