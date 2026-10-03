local UILWSeasonOutpostAttackS5Item = BaseClass("UILWSeasonOutpostAttackS5Item", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonOutpostAttackS5Item:OnCreate()
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

function UILWSeasonOutpostAttackS5Item:OnDestroy()
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

function UILWSeasonOutpostAttackS5Item:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
end

function UILWSeasonOutpostAttackS5Item:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnSearchAllianceSuccess)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostAttackS5Item:OnSearchAllianceSuccess()
  if self.occupyName and self.data and self.data.ownerAllianceId and self.data.ownerServerId then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.data.ownerAllianceId)
    if allianceInfo ~= nil then
      local colorStr = "<color=" .. (self.fontColor or "#ffffff") .. ">"
      self.occupyName:SetText(colorStr .. UIUtil.FormatServerAllianceName(self.data.ownerServerId, allianceInfo.abbr, nil) .. "</color>")
    end
  end
end

function UILWSeasonOutpostAttackS5Item:SetMapIndex(mapIndex, outpostId, attackActData, pop_up_panel)
  self.mapIndex = mapIndex
  self.outpostId = outpostId
  self.attackActData = attackActData
  self.popupPanel = pop_up_panel
  self.serverId = DataCenter.SeasonDataManager:GetNinePalacesServer(mapIndex, ServerEnum.Source)
  self.server_txt:SetText("#" .. tostring(self.serverId))
end

function UILWSeasonOutpostAttackS5Item:ReInit(outpostInfoList, now, battleEndTime)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local data = outpostInfoList[tostring(self.outpostId)]
  local ownerServerId = 0
  self.data = data
  self.battleEndTime = battleEndTime
  if data then
    local fontColor = "#ffffff"
    local battleStartTime = toInt(data.battleStartTime)
    ownerServerId = toInt(data.ownerServerId)
    if ownerServerId == mySourceServerId then
      fontColor = "#5fef87"
      self.home_icon:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_qizi01.png")
    else
      self.home_icon:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_qizi02.png")
    end
    self.fontColor = fontColor
    self.battleStartTime = battleStartTime
    local hasConnectCity = false
    local canAttack = false
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.outpostId, self.serverId)
    if cityTemplate then
      local nearBy = cityTemplate.nearBy
      if nearBy then
        local mgr = DataCenter.WorldAllianceCityDataManager
        for i, cityId in ipairs(nearBy) do
          local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(cityId))
          if cityInfo ~= nil and cityInfo.occupyServerId ~= 0 and cityInfo.occupyServerId ~= ownerServerId then
            hasConnectCity = true
            if ownerServerId ~= mySourceServerId and cityInfo.occupyServerId == mySourceServerId then
              canAttack = true
            end
          end
        end
      end
    end
    if ownerServerId ~= mySourceServerId then
      local _cityId, _serverId = SeasonUtil.GetOutpostId(mySourceServerId)
      if self.outpostId == _cityId then
        canAttack = true
        hasConnectCity = true
      end
    end
    self.canAttack = canAttack
    self.hasConnectCity = hasConnectCity
    self.status:SetActive(hasConnectCity)
    if hasConnectCity then
      if ownerServerId == mySourceServerId then
        self.status:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_jinggong.png")
      elseif canAttack then
        self.status:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_jinggong.png")
      else
        self.status:SetActive(false)
      end
    else
      self.status:SetActive(false)
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
    self.occupyName:SetText("")
  end
  self:ShowAnim()
end

function UILWSeasonOutpostAttackS5Item:ShowAnim()
  if self.hasConnectCity and self.status:GetActive() then
    if self.battleEndTime then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime > self.battleStartTime and curTime < self.battleEndTime then
        self.statusAnim:Enable(true)
        self.eff_attack_fight_fire:SetActive(true)
        self.eff_attack_idle_d:SetActive(false)
        self.eff_attack_idle_u:SetActive(false)
        self.statusAnim:Play("V_ui_S5_OutpostAttack_fight_status_idle")
        return
      end
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

function UILWSeasonOutpostAttackS5Item:Update1000MS()
  if self.battleEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.battleEndTime then
      self.battleEndTime = nil
      self:ShowAnim()
    end
  end
end

function UILWSeasonOutpostAttackS5Item:TryShowDetail()
  if self.mapIndex == nil or self.mapIndex == 5 then
    return
  end
  if self.popupPanel then
    self.popupPanel:ShowIt(self, self.mapIndex, self.outpostId, self.attackActData, self.data)
  end
end

return UILWSeasonOutpostAttackS5Item
