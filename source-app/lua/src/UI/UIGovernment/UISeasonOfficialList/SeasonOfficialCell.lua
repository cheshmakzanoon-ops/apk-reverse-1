local SeasonOfficialCell = BaseClass("SeasonOfficialCell", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local title_path = "title"
local player_path = "player"
local name_path = "Name"
local icon_path = "icon"
local unset_path = "unset"
local holdTime_path = "holdTime"

function SeasonOfficialCell:OnCreate()
  base.OnCreate(self)
  self.cellBtn = self:AddComponent(UIButton, "")
  self.title = self:AddComponent(UIText, title_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerName = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.unset = self:AddComponent(UIText, unset_path)
  self.unset:SetLocalText(457027)
  self.holdTime = self:AddComponent(UIText, holdTime_path)
  self.cellBtn:SetOnClick(function()
    self:OnItemClick()
  end)
  self.player:SetEnableClickShowInfo(false, false)
end

function SeasonOfficialCell:OnDestroy()
  self.config = nil
  self.info = nil
  self.serverId = nil
  self.buildingId = nil
  base.OnDestroy(self)
end

function SeasonOfficialCell:SetData(config, info, serverId, buildingId)
  self.config = config
  self.info = info
  self.serverId = serverId
  self.buildingId = buildingId
  if IsNotNull(self.gameObject) then
    self:UpdateData()
  end
end

function SeasonOfficialCell:UpdateData()
  self.title:SetLocalText(self.config.name)
  local positionInfo = self.info
  if positionInfo and positionInfo.uid and positionInfo.uid ~= "" then
    self.holdTime:SetActive(true)
    self.unset:SetActive(false)
    self.icon:SetActive(false)
    self.player:SetActive(true)
    self.player:SetHead(positionInfo.uid, positionInfo.pic, positionInfo.picVer, nil, positionInfo:GetHeadBgImg())
    self.playerName:SetActive(true)
    self.playerName:SetText(positionInfo:GetFullName(false, positionInfo.uid))
  else
    self.holdTime:SetActive(false)
    self.unset:SetActive(true)
    self.icon:SetActive(true)
    self.icon:LoadSprite(self.config.icon)
    self.icon:SetNativeSize()
    self.player:SetActive(false)
    self.playerName:SetActive(false)
  end
  self:Update1000MS()
end

function SeasonOfficialCell:OnItemClick()
  if SeasonUtil.IsUserInSeason() and LuaEntry.Player:IsBuildingLeader(self.serverId, self.buildingId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialApply, {anim = true}, self.serverId, self.buildingId, self.config)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialBuff, {anim = true}, self.serverId, self.buildingId, self.config, self.info)
  end
end

function SeasonOfficialCell:Update1000MS()
  if self.info then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local appointDeltaTime = curTime - self.info.appointTime
    self.holdTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(appointDeltaTime))
  end
end

return SeasonOfficialCell
