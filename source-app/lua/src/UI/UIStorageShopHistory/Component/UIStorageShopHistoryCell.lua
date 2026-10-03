local UIStorageShopHistoryCell = BaseClass("UIStorageShopHistoryCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local player_name_text_path = "PlayerNameText"
local time_text_path = "TimeText"
local playerHead_path = "HeadGo/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "HeadGo/UIPlayerHead/Foreground"
local money_text_path = "MoneyBg/Text_num28"
local item_name_text_path = "ItemNameText"
local item_icon_path = "item_bg/ItemIcon"
local item_count_text_path = "item_bg/NumText"
local player_head_btn_path = "HeadGo/UIPlayerHead"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.player_name_text = self:AddComponent(UIText, player_name_text_path)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg_path)
  self.money_text = self:AddComponent(UIText, money_text_path)
  self.item_name_text = self:AddComponent(UIText, item_name_text_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.item_count_text = self:AddComponent(UIText, item_count_text_path)
  self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
  self.money_text:SetActive(false)
  self.player_head_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnPlayerBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.player_name_text = nil
  self.time_text = nil
  self.playerHead = nil
  self.playerHeadFg = nil
  self.money_text = nil
  self.item_name_text = nil
  self.item_icon = nil
  self.item_count_text = nil
  self.player_head_btn = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local itemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.param.data.itemId)
  if itemTemplate ~= nil then
    self.item_icon:LoadSprite(itemTemplate:GetIconPath())
    if self.param.data.num > 1 then
      self.item_name_text:SetText(Localization:GetString(itemTemplate.name) .. " *" .. self.param.data.num)
    else
      self.item_name_text:SetText(Localization:GetString(itemTemplate.name))
    end
  end
  self.item_count_text:SetText(tostring(self.param.data.num))
  self.playerHead:SetData(self.param.data.soldOutUid, self.param.data.pic, self.param.data.picVer)
  local serverId = ""
  if self.param.data.serverId and self.param.data.serverId ~= LuaEntry.Player.serverId then
    serverId = "#" .. self.param.data.serverId
  end
  local tempAbbr = string.IsNullOrEmpty(self.param.data.alAbbr) and "" or "[" .. self.param.data.alAbbr .. "]"
  self.player_name_text:SetText(serverId .. tempAbbr .. self.param.data.soldName)
  if curTime <= self.param.data.monthCardEndTime then
    self.playerHeadFg:SetActive(true)
  else
    self.playerHeadFg:SetActive(false)
  end
  self.time_text:SetText(self:GetTimeDes(self.param.data.time))
  self.money_text:SetActive(true)
  self.money_text:SetText(string.GetFormattedSeperatorNum(self.param.data.gold))
end

local function OnPlayerBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.param.data.soldOutUid)
end

local function GetTimeDes(self, time)
  local deltaTime = UITimeManager:GetInstance():GetServerTime() - time
  if 86400000 < deltaTime then
    local day = math.floor(deltaTime / 86400000)
    return Localization:GetString(GameDialogDefine.BUY_AT_AGO_DAY, day)
  elseif 3600000 < deltaTime then
    local hour = math.floor(deltaTime / 3600000)
    return Localization:GetString(GameDialogDefine.BUY_AT_AGO_HOUR, hour)
  elseif 60000 < deltaTime then
    local minute = math.floor(deltaTime / 60000)
    return Localization:GetString(GameDialogDefine.BUY_AT_AGO_MIN, minute)
  end
  return Localization:GetString(GameDialogDefine.BUY_AT_AGO_MIN, 1)
end

UIStorageShopHistoryCell.OnCreate = OnCreate
UIStorageShopHistoryCell.OnDestroy = OnDestroy
UIStorageShopHistoryCell.OnEnable = OnEnable
UIStorageShopHistoryCell.OnDisable = OnDisable
UIStorageShopHistoryCell.ComponentDefine = ComponentDefine
UIStorageShopHistoryCell.ComponentDestroy = ComponentDestroy
UIStorageShopHistoryCell.DataDefine = DataDefine
UIStorageShopHistoryCell.DataDestroy = DataDestroy
UIStorageShopHistoryCell.ReInit = ReInit
UIStorageShopHistoryCell.OnPlayerBtnClick = OnPlayerBtnClick
UIStorageShopHistoryCell.GetTimeDes = GetTimeDes
return UIStorageShopHistoryCell
