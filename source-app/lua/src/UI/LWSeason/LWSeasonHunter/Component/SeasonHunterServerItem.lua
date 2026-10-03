local base = UIBaseContainer
local SeasonHunterServerItem = BaseClass("SeasonHunterServerItem", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local house_path = "root/House"
local serverIcon_path = "root/House/homeIcon"
local serverBtn_path = "root/House/homeIcon"
local serverBg_path = "root/House/ServerBg"
local serverTxt_path = "root/House/ServerBg/ServerTxt"
local txtCount_path = "Info/TxtCount"
local txtInfo_path = "Info/TxtInfo"
local txtTime_path = "root/Time/TxtTime"
local time_path = "root/Time"
local iconSelf_path = "root/House/ServerBg/IconSelf"
local iconBan_path = "root/iconBan"
local root_path = "root"

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
  self.house = self:AddComponent(UIImage, house_path)
  self.serverIcon = self:AddComponent(UIImage, serverIcon_path)
  self.serverBtn = self:AddComponent(UIButton, serverBtn_path)
  self.serverBg = self:AddComponent(UIImage, serverBg_path)
  self.serverTxt = self:AddComponent(UIText, serverTxt_path)
  self.txtCount = self:AddComponent(UIText, txtCount_path)
  self.txtInfo = self:AddComponent(UIText, txtInfo_path)
  self.txtTime = self:AddComponent(UIText, txtTime_path)
  self.time = self:AddComponent(UIBaseContainer, time_path)
  self.iconSelf = self:AddComponent(UIBaseContainer, iconSelf_path)
  self.iconBan = self:AddComponent(UIBaseContainer, iconBan_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.serverBtn:SetOnClick(BindCallback(self, self.Goto))
  self.anim = self:AddComponent(UISimpleAnimation, root_path)
end

local function ComponentDestroy(self)
  self.house = nil
  self.serverIcon = nil
  self.serverBtn = nil
  self.serverBg = nil
  self.serverTxt = nil
  self.txtCount = nil
  self.txtInfo = nil
  self.txtTime = nil
  self.time = nil
  self.iconSelf = nil
  self.iconBan = nil
  self.root = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonHunterServerItem:ReInit(index, data)
  self.serverId = toInt(data.sid)
  self.serverTxt:SetText(string.format("#%s", data.sid))
  local badgesIconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(self.serverId)
  self.serverIcon:LoadSprite(badgesIconPath)
  self.iconSelf:SetActive(self.serverId == LuaEntry.Player:GetSelfServerId())
  if not data.lastWolfNum then
    self:Ban()
    return
  end
  local value = string.GetFormattedSeperatorNum(math.floor(data.lastWolfNum or 0))
  self.txtCount:SetText(value)
  self.EndTime = data.banTime
  if self.EndTime and UITimeManager:GetInstance():GetServerTime() < self.EndTime then
    self:BeforeBan()
    return
  end
  UIGray.SetGray(self.house.transform, false, true)
  UIGray.SetGray(self.serverIcon.transform, false, true)
  UIGray.SetGray(self.serverBg.transform, false, true)
  self.serverIcon:SetColorRGBA(1, 1, 1, 1)
  self.time:SetActive(false)
  self.txtInfo:SetActive(false)
  self.txtCount:SetActive(true)
  self.iconBan:SetActive(false)
  self.anim:SampleAnimationAtTime("Default", 0)
end

function SeasonHunterServerItem:Update1000MS()
  if not self.EndTime then
    return
  end
  local cur = UITimeManager:GetInstance():GetServerTime()
  if cur >= self.EndTime then
    self:Ban()
    return
  end
  self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.EndTime - cur))
end

function SeasonHunterServerItem:BeforeBan()
  UIGray.SetGray(self.house.transform, false, true)
  UIGray.SetGray(self.serverIcon.transform, false, true)
  UIGray.SetGray(self.serverBg.transform, false, true)
  self.serverIcon:SetColorRGBA(0.9622642, 0.6672304, 0.689201, 1)
  self.time:SetActive(true)
  self.txtInfo:SetActive(false)
  self.txtCount:SetActive(true)
  self.iconBan:SetActive(true)
  self.anim:Play("Default")
  self:Update1000MS()
end

function SeasonHunterServerItem:Ban()
  self.EndTime = nil
  UIGray.SetGray(self.house.transform, true, true)
  UIGray.SetGray(self.serverIcon.transform, true, true)
  UIGray.SetGray(self.serverBg.transform, true, true)
  self.serverIcon:SetColorRGBA(1, 1, 1, 1)
  self.time:SetActive(false)
  self.txtInfo:SetActive(true)
  self.txtCount:SetActive(false)
  self.iconBan:SetActive(true)
  self.anim:SampleAnimationAtTime("Default", 0)
end

function SeasonHunterServerItem:Goto()
  local gotoPointIndex = LuaEntry.Player:GetMainWorldPos()
  if gotoPointIndex == nil or gotoPointIndex == 0 or gotoPointIndex < 0 then
    local markInfo = DataCenter.AllianceRallyPointDataManager:GetMyAllianceRallyPoint()
    if markInfo then
      gotoPointIndex = markInfo:GetPointIndex()
    end
  end
  if gotoPointIndex == nil or gotoPointIndex == 0 or gotoPointIndex < 0 then
    gotoPointIndex = 200200
  end
  local position = SceneUtils.TileIndexToWorld(gotoPointIndex, ForceChangeScene.World)
  GoToUtil.CloseAllWindows()
  if LuaEntry.Player:GetSelfServerId() == self.serverId then
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
    end, self.serverId)
  elseif LuaEntry.Player:GetSourceServerId() == self.serverId then
    CrossServerUtil.BackToSrcServer()
  else
    GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
    end, self.serverId)
  end
end

SeasonHunterServerItem.OnCreate = OnCreate
SeasonHunterServerItem.OnDestroy = OnDestroy
SeasonHunterServerItem.OnEnable = OnEnable
SeasonHunterServerItem.OnDisable = OnDisable
SeasonHunterServerItem.ComponentDefine = ComponentDefine
SeasonHunterServerItem.ComponentDestroy = ComponentDestroy
SeasonHunterServerItem.DataDefine = DataDefine
SeasonHunterServerItem.DataDestroy = DataDestroy
return SeasonHunterServerItem
