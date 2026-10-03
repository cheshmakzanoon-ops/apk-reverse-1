local base = UIBaseContainer
local ZoneItemSelect = BaseClass("ZoneItemSelect", base)
local Localization = CS.GameEntry.Localization
local btnServer_path = "House/ServerBg"
local btnIcon_path = "House/homeIcon"
local bgServer_path = "House/ServerBg"
local txtServer_path = "House/ServerBg/ServerTxt"
local homeIcon_path = "House/homeIcon"
local menu_path = "menu"
local btnExchange_path = "menu/BtnExchange"
local btnCancel_path = "menu/BtnCancel"
local btnTips_path = "menu/BtnTips"
local occupy_path = "House/occupy"
local playerRoot_path = "House/head"
local player_path = "House/head/Player"
local name_path = "House/head/Name"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnServer = self:AddComponent(UIButton, btnServer_path)
  self.btnIcon = self:AddComponent(UIButton, btnIcon_path)
  self.bgServer = self:AddComponent(UIImage, bgServer_path)
  self.txtServer = self:AddComponent(UIText, txtServer_path)
  self.homeIcon = self:AddComponent(UIImage, homeIcon_path)
  self.menu = self:AddComponent(UIBaseContainer, menu_path)
  self.btnExchange = self:AddComponent(UIButton, btnExchange_path)
  self.btnCancel = self:AddComponent(UIButton, btnCancel_path)
  self.btnTips = self:AddComponent(UIButton, btnTips_path)
  self.occupy = self:AddComponent(UIBaseContainer, occupy_path)
  self.playerRoot = self:AddComponent(UIBaseContainer, playerRoot_path)
  self.player = self:AddComponent(UIBaseContainer, player_path)
  self.name = self:AddComponent(UIText, name_path)
  self.btnServer:SetOnClick(function()
    if self.data and self.data.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.data.serverId)
    end
  end)
  self.btnIcon:SetOnClick(function()
    if self.data and self.data.serverId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.data.serverId)
    end
  end)
  self.btnExchange:SetOnClick(function()
    self:Exchange()
  end)
  self.btnCancel:SetOnClick(function()
    self:Cancel()
  end)
  self.btnTips:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeInfo)
    UIManager:GetInstance():OpenWindow(UIWindowNames.CampSelectList, {anim = true})
  end)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.playerUI:SetEnableClickShowInfo(true, true)
  self.playerRoot:SetActive(false)
end

local function ComponentDestroy(self)
  self.btnServer = nil
  self.btnIcon = nil
  self.bgServer = nil
  self.txtServer = nil
  self.homeIcon = nil
  self.menu = nil
  self.btnExchange = nil
  self.btnCancel = nil
  self.btnTips = nil
  self.occupy = nil
  self.playerRoot = nil
  self.player = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function ZoneItemSelect:ReInit(index, data, player, serverInfo, status, isOver)
  self.index = index
  self.data = data
  self.status = status
  DataCenter.ZoneWarManager:SetServerInfo(self.bgServer, self.txtServer, data.serverId, status)
  self:RefreshMenu(isOver)
  if serverInfo then
    self.cfgId = serverInfo.cfgId or 511001
  else
    self.cfgId = 511001
  end
  if self.cfgId and self.homeIcon then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(self.cfgId)
    if itemCfg then
      self.homeIcon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  if player and player.name then
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(player.uid, player.name)
    if player.allianceAbbr then
      self.name:SetText("[" .. player.allianceAbbr .. "]" .. showName)
    else
      self.name:SetText(showName or "")
    end
    self.playerUI:ParseHeadInfo(player)
    self.playerUI:SetFlag(player.country)
    self.playerRoot:SetActive(true)
  else
    self.playerRoot:SetActive(false)
  end
end

function ZoneItemSelect:RefreshMenu(isOver)
  if isOver or self.index <= 1 or self.status ~= 2 or not DataCenter.CampWarManager:CanOperateAreaOverview() then
    self.menu:SetActive(false)
    return
  end
  self.menu:SetActive(true)
  local exchangeInfo = DataCenter.CampWarManager:GetAreaExchangeInfo(self.data.selectedCityId)
  if self.data.serverId == LuaEntry.Player:GetSourceServerId() then
    self.btnExchange:SetActive(false)
    self.btnCancel:SetActive(false)
    self.btnTips:SetActive(exchangeInfo ~= nil)
    return
  end
  self.btnTips:SetActive(false)
  local selfData = DataCenter.CampWarManager:GetAreaOverview()
  if not selfData or selfData.isLeaderServer then
    self.btnExchange:SetActive(false)
    self.btnCancel:SetActive(false)
    return
  end
  if not exchangeInfo then
    self.btnExchange:SetActive(true)
    self.btnCancel:SetActive(false)
    return
  end
  if exchangeInfo.initiatorServerId == LuaEntry.Player:GetSourceServerId() then
    self.btnExchange:SetActive(false)
    self.btnCancel:SetActive(true)
    return
  end
  self.btnExchange:SetActive(false)
  self.btnCancel:SetActive(false)
end

function ZoneItemSelect:SetOccupy(isLose)
  if self.occupy then
    self.occupy:SetActive(isLose)
  end
end

function ZoneItemSelect:Exchange()
  if not DataCenter.CampWarManager:CanOperateAreaOverview(true) then
    return
  end
  local selfData = DataCenter.CampWarManager:GetAreaOverview()
  if selfData and selfData.exchangeRemain <= 0 then
    UIUtil.ShowTipsId("season_s4_s_cross_throne_swap_tips_8")
    return
  end
  if 0 >= self.data.exchangeRemain then
    UIUtil.ShowTipsId("season_s4_s_cross_throne_swap_tips_9")
    return
  end
  if DataCenter.CampWarManager:HasAreaExchangeRequest() then
    UIUtil.ShowTipsId("season_s4_s_cross_throne_swap_tips_5")
    return
  end
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(toInt(self.data.selectedCityId), self.data.serverId)
  local cityName = meta and Localization:GetString(meta.name) or "-"
  cityName = string.format("<color=#099b4a>%s</color>", cityName)
  local str = string.format("<color=#099b4a>#%s%s</color>", self.data.serverId, cityName)
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("season_s4_camp_battle_20", str),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeInitiate, self.data.serverId, self.data.selectedCityId)
    end
  })
end

function ZoneItemSelect:Cancel()
  local exchangeInfo = DataCenter.CampWarManager:GetAreaExchangeInfo(self.data.selectedCityId)
  if not exchangeInfo or not DataCenter.CampWarManager:CanOperateAreaOverview() then
    return
  end
  UIUtil.ShowSecondMessageByParam({
    tipText = Localization:GetString("season_s4_camp_battle_24"),
    btnNum = 2,
    showToggle = false,
    sureAction = function()
      SFSNetwork.SendMessage(MsgDefines.CrossThroneStrategicAreaExchangeCancel, exchangeInfo.uuid)
    end
  })
end

ZoneItemSelect.OnCreate = OnCreate
ZoneItemSelect.OnDestroy = OnDestroy
ZoneItemSelect.OnEnable = OnEnable
ZoneItemSelect.OnDisable = OnDisable
ZoneItemSelect.ComponentDefine = ComponentDefine
ZoneItemSelect.ComponentDestroy = ComponentDestroy
ZoneItemSelect.DataDefine = DataDefine
ZoneItemSelect.DataDestroy = DataDestroy
return ZoneItemSelect
