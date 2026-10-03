local base = UIBaseContainer
local LWActMeteoriteShow = BaseClass("LWActMeteoriteShow", base)
local Localization = CS.GameEntry.Localization
local LWActMeteoriteZoneItem = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteZoneItem")
local LWActMeteoriteZoneInfo = require("UI.LWActMeteorite.Component.Schedule.LWActMeteoriteZoneInfo")
local center_path = "Center"
local zone_base_path = "Center/Zone"
local alliance_text_path = "Center/AllianceText"
local alliance_icon_path = "Center/AllianceText/AllianceIcon"
local person_text_path = "Center/PersonText"
local person_icon_path = "Center/PersonText/Head/UIPlayerHead"

function LWActMeteoriteShow:OnCreate()
  base.OnCreate(self)
  self.center = self:AddComponent(UIBaseComponent, center_path)
  self.zoneItems = {}
  self.zoneInfos = {}
  self.zoneTimes = {}
  for i = 1, 4 do
    local zonePath = zone_base_path .. i
    local zone = self:AddComponent(UIBaseContainer, zonePath)
    self.zoneItems[i] = zone:AddComponent(LWActMeteoriteZoneItem, "Zone")
    self.zoneItems[i]:SetCb(i, BindCallback(self, self.OnZoneClick))
    self.zoneInfos[i] = zone:AddComponent(LWActMeteoriteZoneInfo, "ZoneInfo")
    self.zoneTimes[i] = zone:AddComponent(UITextMeshProUGUIEx, "TimeText")
  end
  self.alliance_icon = self:AddComponent(UIImage, alliance_icon_path)
  self.alliance_text = self:AddComponent(UITextMeshProUGUIEx, alliance_text_path)
  self.person_icon = self:AddComponent(UICommonHead, person_icon_path)
  self.person_text = self:AddComponent(UITextMeshProUGUIEx, person_text_path)
end

function LWActMeteoriteShow:OnDestroy()
  self.center = nil
  self.zoneItems = {}
  self.zoneInfos = {}
  self.zoneTimes = {}
  self.alliance_icon = nil
  self.alliance_text = nil
  self.person_icon = nil
  self.person_text = nil
  base.OnDestroy(self)
end

function LWActMeteoriteShow:OnZoneClick(idx)
  EventManager:GetInstance():Broadcast(EventId.MeteoriteActMainToggleSet, {
    idx = 3,
    preValue = idx - 1
  })
end

function LWActMeteoriteShow:SetData()
  local timeMgr = UITimeManager:GetInstance()
  local actInfo = DataCenter.ActMeteoriteBattleManager:GetActInfo()
  local meteorites = actInfo ~= nil and actInfo.meteorites or {}
  local aRankSId = actInfo ~= nil and actInfo.highestAllianceRankServer or 0
  local pRankSId = actInfo ~= nil and actInfo.highestPersonRankServer or 0
  self.alliance_text:SetActive(false)
  self.person_text:SetActive(false)
  local fixA, fixP
  local haveAl = not string.IsNullOrEmpty(LuaEntry.Player.allianceId)
  for i = 1, 4 do
    local zone = self.zoneItems[i]
    local meteorite = meteorites[i]
    if meteorite ~= nil then
      zone.transform.parent.gameObject:SetActive(true)
      zone:SetData(meteorite)
      self.zoneInfos[i]:SetData(meteorite, i)
      local format = timeMgr:TimeSecToServerDate(meteorite.time or 0)
      local time = string.format("%d-%d-%d %02d:%02d:%02d", format.year, format.month, format.day, format.hour, format.min, format.sec)
      self.zoneTimes[i]:SetText(time)
      local tmpHaveOne = false
      if not fixA and meteorite.serverId == aRankSId and haveAl then
        self.alliance_text:SetLocalText(801106, actInfo.highestAllianceRank or 0)
        local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        self.alliance_icon:LoadSpriteAsyncWithCallback(string.format(AL_FLAG_SPRITE_PATH, tostring(baseData.icon)), function()
          if self.alliance_icon then
            self.alliance_icon:SetNativeSize()
          end
        end)
        self:FixedPos(self.zoneInfos[i], self.alliance_text, false, i)
        fixA = true
        tmpHaveOne = true
      end
      if not fixP and meteorite.serverId == pRankSId then
        self.person_text:SetLocalText(801106, actInfo.highestPersonRank or 0)
        local uid = LuaEntry.Player:GetUid()
        local pic = LuaEntry.Player:GetPic()
        local picVer = LuaEntry.Player.picVer
        local headSkinPath = LuaEntry.Player:GetHeadBgImg()
        self.person_icon:SetData(uid, pic, picVer, nil, headSkinPath)
        self:FixedPos(self.zoneInfos[i], self.person_text, tmpHaveOne, i)
        fixP = true
      end
    else
      zone.transform.parent.gameObject:SetActive(false)
    end
  end
  if not fixA then
    self.alliance_text:SetActive(false)
  end
  if not fixP then
    self.person_text:SetActive(false)
  end
end

function LWActMeteoriteShow:FixedPos(from, target, moreAdd, idx)
  local x, y, z = from:GetLocalPositionXYZ()
  local w, h = from:GetSizeDeltaXY()
  y = y - h * 0.5
  if moreAdd then
    y = y - 50
  end
  if idx % 2 == 0 then
    x = x + w * 0.5 + 10
  else
    x = x - w * 0.5 + 25
  end
  target:SetLocalPositionXYZ(x, y, z)
  target:SetActive(true)
end

return LWActMeteoriteShow
