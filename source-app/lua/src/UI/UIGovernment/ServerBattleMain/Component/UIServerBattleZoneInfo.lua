local UIServerBattleZoneInfo = BaseClass("UIServerBattleZoneInfo", UIBaseContainer)
local base = UIBaseContainer
local home_icon_path = "House/homeIcon"
local server_bg_path = "House/ServerBg"
local server_txt_path = "House/ServerBg/ServerTxt"
local occupy_path = "House/occupy"
local player_path = "head/Player"
local select_go_path = "head/SelectGo"
local name_path = "head/Name"

function UIServerBattleZoneInfo:OnCreate()
  base.OnCreate(self)
  self.occupyInfo = self:AddComponent(UIImage, occupy_path)
  self.server_bg = self:AddComponent(UIImage, server_bg_path)
  self.serverText = self:AddComponent(UIText, server_txt_path)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.playerRoot = self:AddComponent(UIBaseComponent, "head")
  self.SelectGo = self:AddComponent(UIBaseComponent, select_go_path)
  self.nameText = self:AddComponent(UIText, name_path)
  self.KingBtn = self:AddComponent(UIButton, home_icon_path)
  if self.KingBtn ~= nil and self.KingBtn.unity_uibutton and self.KingBtn.unity_image then
    self.KingBtn:SetOnClick(function()
      if self.serverId ~= nil and self.serverId > 0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverId)
      end
    end)
    self.home_icon = self.KingBtn
  else
    self.home_icon = self:AddComponent(UIImage, home_icon_path)
  end
  self.playerUI:SetEnableClickShowInfo(true, true)
  self.server_btn = self:AddComponent(UIButton, server_bg_path)
  self.server_btn:SetOnClick(function()
    if self.serverId ~= nil and self.serverId > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverId)
    end
  end)
  self.playerRoot:SetActive(false)
  self.occupyInfo:SetActive(false)
end

function UIServerBattleZoneInfo:OnDestroy()
  self.player = nil
  self.serverId = nil
  base.OnDestroy(self)
end

function UIServerBattleZoneInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.UpdatePresidentData)
end

function UIServerBattleZoneInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.UpdatePresidentData)
  base.OnRemoveListener(self)
end

function UIServerBattleZoneInfo:UpdatePresidentData(presidentInfo, fakePresidentInfo, serverId)
end

function UIServerBattleZoneInfo:ShowOccupy()
  if self.occupyInfo then
    self.occupyInfo:SetActive(true)
  end
end

function UIServerBattleZoneInfo:SetServerId(serverId, showKing)
  if not serverId or type(serverId) ~= "number" or serverId < 0 then
    return
  end
  local thePresident = DataCenter.GovernmentManager.CrossKingdomKing[serverId]
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
  local cfgId = kingInfo and kingInfo.badges and kingInfo.badges.cfgId or 511001
  local status = 0
  if LuaEntry.Player:GetSourceServerId() == serverId then
    status = 2
  end
  local king = kingInfo and kingInfo.king or thePresident
  self:ReInit(showKing and king, ServerBattleType.None, status, serverId, {cfgId = cfgId})
end

function UIServerBattleZoneInfo:ReInit(player, serverBattleType, status, serverId, serverInfo, serverData_)
  self.player = player
  self.serverBattleType = serverBattleType
  if serverInfo then
    self.cfgId = serverInfo.cfgId or 511001
  else
    self.cfgId = 511001
  end
  if self.cfgId and self.home_icon then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.cfgId)
    if itemCfg ~= nil then
      self.home_icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  self.serverId = toInt(serverId)
  if player == nil or player.allianceAbbr == nil and player.name == nil then
    self.SelectGo:SetActive(false)
    self.playerRoot:SetActive(false)
    DataCenter.ZoneWarManager:SetServerInfo(self.server_bg, self.serverText, serverId, status, serverData_)
    return
  end
  self.playerRoot:SetActive(true)
  if self.serverBattleType == ServerBattleType.VS8 or self.serverBattleType == ServerBattleType.VSCamp then
    self.nameText:SetText(player.allianceAbbr)
  else
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(player.uid, player.name)
    if player.allianceAbbr then
      self.nameText:SetText("[" .. player.allianceAbbr .. "]" .. showName)
    else
      self.nameText:SetText(showName or "")
    end
  end
  self.SelectGo:SetActive(false)
  self.playerUI:ParseHeadInfo(player)
  self.playerUI:SetFlag(player.country)
  DataCenter.ZoneWarManager:SetServerInfo(self.server_bg, self.serverText, serverId, status)
end

return UIServerBattleZoneInfo
