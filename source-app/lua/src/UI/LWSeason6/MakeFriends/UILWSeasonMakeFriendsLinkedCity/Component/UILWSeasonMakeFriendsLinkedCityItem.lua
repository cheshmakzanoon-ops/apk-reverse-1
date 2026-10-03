local UILWSeasonMakeFriendsLinkedCityItem = BaseClass("UILWSeasonMakeFriendsLinkedCityItem", UIBaseContainer)
local base = UIBaseContainer

function UILWSeasonMakeFriendsLinkedCityItem:OnCreate()
  base.OnCreate(self)
  self.building = self:AddComponent(UIButton, "building")
  self.city_raw = self:AddComponent(UIRawImage, "building/city")
  self.city_spr = self:AddComponent(UIImage, "building/citySpr")
  self.dun = self:AddComponent(UIImage, "building/dun")
  self.txt_level = self:AddComponent(UITextMeshProUGUIEx, "txtLevel")
  self.icon = self:AddComponent(UIImage, "icon")
  self.txt_status = self:AddComponent(UITextMeshProUGUIEx, "txtStatus")
  self.pos_text = self:AddComponent(UITextMeshProUGUIEx, "PosText")
  self.pos_btn = self:AddComponent(UIButton, "PosText/PosBtn")
  self.pos_btn:SetOnClick(function()
    if self.cityMeta then
      self.cityMeta:JumpTo()
    end
  end)
end

function UILWSeasonMakeFriendsLinkedCityItem:OnDestroy()
  self.building = nil
  self.city_raw = nil
  self.city_spr = nil
  self.dun = nil
  self.txt_level = nil
  self.icon = nil
  self.txt_status = nil
  self.pos_text = nil
  self.pos_btn = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsLinkedCityItem:ReInit(index, data, allianceInfo)
  local now = UITimeManager:GetInstance():GetServerTime()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(data.cityId, mySourceServerId)
  self.protectEndTime = nil
  if cityMeta then
    local iconPath = cityMeta:GetIconPath()
    local bigIconPath = cityMeta:GetBigIconPath()
    self.cityMeta = cityMeta
    if iconPath ~= nil and iconPath ~= "" then
      self.city_spr:SetActive(true)
      self.city_raw:SetActive(false)
      self.city_spr:LoadSpriteAuto(iconPath)
    elseif bigIconPath ~= nil and bigIconPath ~= "" then
      self.city_spr:SetActive(false)
      self.city_raw:SetActive(true)
      self.city_raw:LoadSpriteAuto(bigIconPath)
    else
      self.city_spr:SetActive(false)
      self.city_raw:SetActive(true)
    end
    self.txt_level:SetLocalText("310161", "", cityMeta.level)
    self.pos_text:SetText(UIUtil.MakeJumpLink(cityMeta:GetPointId(), cityMeta:GetSourceServerId(), 0))
    if data.inBattle then
      self.dun:SetActive(false)
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_jiaozhan.png")
      self.protectEndTime = nil
      self.txt_status:SetLocalText("120125")
    elseif data.protectEndTime and now < data.protectEndTime then
      self.dun:SetActive(true)
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/AllianceWarTime/mjc_S5_MZ_icon_mianzhan.png")
      self.protectEndTime = data.protectEndTime
      self:Update1000MS()
    else
      local mgr = DataCenter.UILWSeasonAllianceWarTimeManager
      local warTimeIndex = allianceInfo.wartimeindex
      local baseTime = UITimeManager:GetInstance():GetServerTime()
      self.txt_status:SetText("")
      self.dun:SetActive(false)
      self.icon:LoadSpriteAuto(mgr:GetIconPath(warTimeIndex))
      if cityMeta.type == WorldAllianceCityType.Stronghold then
        local startTime, endTime = mgr:GetNextWarTime(baseTime, warTimeIndex, false, true)
        self:ShowWarTime(startTime, endTime)
      elseif cityMeta.type == WorldAllianceCityType.City then
        local startTime, endTime = mgr:GetNextWarTime(baseTime, warTimeIndex, true, true)
        self:ShowWarTime(startTime, endTime)
      end
    end
  end
  self.dun:SetActive(false)
end

function UILWSeasonMakeFriendsLinkedCityItem:ShowWarTime(startTime, endTime)
  local now = UITimeManager:GetInstance():GetServerTime()
  local inWar = startTime <= now and endTime > now
  if inWar then
    self.protectEndTime = endTime
  else
    self.protectEndTime = startTime
  end
  self:Update1000MS()
end

function UILWSeasonMakeFriendsLinkedCityItem:Update1000MS()
  if self.protectEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diff = self.protectEndTime - curTime
    if diff <= 0 then
      self.protectEndTime = nil
      self.txt_status:SetText("")
    else
      self.txt_status:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
    end
  end
end

return UILWSeasonMakeFriendsLinkedCityItem
