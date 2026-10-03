local SeasonCampDestroyInfluenceDetail = BaseClass("SeasonCampDestroyInfluenceDetail", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonCampDestroyInfluenceDetailIR = require("UI.LWSeason6.SeasonCampDestroy.InfluenceDetail.SeasonCampDestroyInfluenceDetailIR")

function SeasonCampDestroyInfluenceDetail:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyInfluenceDetail:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyInfluenceDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPBlur = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPBlur:SetOnClick(function()
    self:OnBtnPBlurClick()
  end)
  self.textPTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnPClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnPClose:SetOnClick(function()
    self:OnBtnPCloseClick()
  end)
  self.imgAllianceIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textTmpAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpInfluence = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpServerRankVal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTmpSeasonRankVal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textTmpServerRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTmpSeasonRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textTmpTitleName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textTmpTitleLocation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTmpTitleInfluence = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 15)
  self.rawImgIconCamp = self.viewSkin:AddComponent(self, UIRawImage, 16)
  self.textPTitle:SetLocalText("season_s6_activity_1200112_desc05")
  self.textTmpTitleName:SetLocalText("season_alliance_event_name_12002")
  self.textTmpTitleLocation:SetLocalText("season_s6_activity_1200116_desc13")
  self.textTmpTitleInfluence:SetLocalText("season_s6_activity_1200112_desc05")
  local _ = Localization:GetString("season_s2_activity_1000047_description_02") .. ":"
  self.textTmpServerRank:SetText(_)
  local _ = Localization:GetString("season_oasis_UI_20") .. ":"
  self.textTmpSeasonRank:SetText(_)
  local data = self:GetUserData()
  if data then
    self.allianceId = data.allianceId
    self:Refresh(data)
    if data.allianceId then
      DataCenter.SeasonCampDestroyManager:SendGetInfluenceDetail(data.allianceId)
    end
  end
end

function SeasonCampDestroyInfluenceDetail:ComponentDestroy()
  self.viewSkin = nil
  self.btnPBlur = nil
  self.textPTitle = nil
  self.btnPClose = nil
  self.imgAllianceIcon = nil
  self.textTmpAllianceName = nil
  self.textTmpInfluence = nil
  self.textTmpServerRankVal = nil
  self.textTmpSeasonRankVal = nil
  self.textTmpServerRank = nil
  self.textTmpSeasonRank = nil
  self.textTmpTitleName = nil
  self.textTmpTitleLocation = nil
  self.textTmpTitleInfluence = nil
  self.compContent = nil
  self.gridInfinityScrollViewContent = nil
  self.rawImgIconCamp = nil
end

function SeasonCampDestroyInfluenceDetail:DataDefine()
  self.hasInitScroll = false
  self.listGO = {}
  self.showDataList = {}
  self.allianceId = nil
end

function SeasonCampDestroyInfluenceDetail:Refresh(data)
  if not data then
    return
  end
  self.textTmpAllianceName:SetText(UIUtil.FormatAllianceAndName(data.allianceAbbr, data.allianceName))
  self.textTmpInfluence:SetText(string.GetFormattedStr(data.damage))
  if data.allianceIcon then
    self.imgAllianceIcon:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, data.allianceIcon))
  end
  self:SetCampIcon(data.camp)
  self.textTmpServerRankVal:SetText("--")
  self.textTmpSeasonRankVal:SetText("--")
end

function SeasonCampDestroyInfluenceDetail:SetCampIcon(camp)
  local campSprites = {
    [1] = "Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_2.png",
    [2] = "Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_1.png"
  }
  local spritePath = campSprites[camp]
  if spritePath then
    self.rawImgIconCamp:SetActive(true)
    self.rawImgIconCamp:LoadSpriteAuto(spritePath, function()
      self:AfterCampIconReady()
    end)
  else
    self.rawImgIconCamp:SetActive(false)
  end
end

function SeasonCampDestroyInfluenceDetail:AfterCampIconReady()
  if self.rawImgIconCamp then
    self.rawImgIconCamp:SetAlpha(0.3)
  end
end

function SeasonCampDestroyInfluenceDetail:DataDestroy()
  self.listGO = nil
  self.showDataList = nil
  self.allianceId = nil
end

function SeasonCampDestroyInfluenceDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyInfluenceDetailRefresh, self.OnInfluenceDetailRefresh)
end

function SeasonCampDestroyInfluenceDetail:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyInfluenceDetailRefresh, self.OnInfluenceDetailRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyInfluenceDetail:OnBtnPBlurClick()
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyInfluenceDetail:OnBtnPCloseClick()
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyInfluenceDetail:RefreshPage(dataList)
  self.showDataList = dataList or {}
  local dataCount = #self.showDataList
  if not self.hasInitScroll then
    self.hasInitScroll = true
    self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitScroll), BindCallback(self, self.OnUpdateScroll), BindCallback(self, self.OnDestroyScrollItem))
  end
  self.gridInfinityScrollViewContent:SetItemCount(dataCount)
  self.gridInfinityScrollViewContent:ForceUpdate()
end

function SeasonCampDestroyInfluenceDetail:OnInitScroll(go, index)
  local item = self.compContent:AddComponent(SeasonCampDestroyInfluenceDetailIR, go)
  self.listGO[go] = item
end

function SeasonCampDestroyInfluenceDetail:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    cellItem:SetActive(true)
    cellItem:SetData(index, self.showDataList[index + 1])
  end
end

function SeasonCampDestroyInfluenceDetail:OnDestroyScrollItem(go, index)
end

function SeasonCampDestroyInfluenceDetail:ClearScroll()
  if self.compContent then
    self.compContent:RemoveComponents(SeasonCampDestroyInfluenceDetailIR)
  end
  if self.gridInfinityScrollViewContent then
    self.gridInfinityScrollViewContent:DestroyChildNode()
  end
end

function SeasonCampDestroyInfluenceDetail:OnInfluenceDetailRefresh(msg)
  if not msg then
    return
  end
  if msg.targetAllianceId ~= self.allianceId then
    return
  end
  if msg.forceValue then
    self.textTmpInfluence:SetText(string.GetFormattedStr(tonumber(msg.forceValue)))
  end
  if msg.serverRank and msg.serverRank > 0 then
    self.textTmpServerRankVal:SetText(tostring(msg.serverRank))
  else
    self.textTmpServerRankVal:SetText("--")
  end
  if msg.globalRank and 0 < msg.globalRank then
    self.textTmpSeasonRankVal:SetText(tostring(msg.globalRank))
  else
    self.textTmpSeasonRankVal:SetText("--")
  end
  local dataList = {}
  
  local function GetCityInfo(cityId, isDestroyed)
    local cityName = GetTableData(TableName.WorldCity, cityId, "name")
    local cityLevel = tonumber(GetTableData(TableName.WorldCity, cityId, "level", 0))
    if cityName then
      cityName = Localization:GetString(cityName)
    else
      cityName = "City_" .. cityId
    end
    local locationStr = ""
    local location = GetTableData(TableName.WorldCity, cityId, "location")
    if location then
      local tabPos = string.split(location, "|")
      if #tabPos == 2 then
        locationStr = string.format("X:%s Y:%s", tabPos[1], tabPos[2])
      end
    end
    local key = isDestroyed and "destroy_force" or "force"
    local force = tonumber(GetTableData(TableName.WorldCity, cityId, key, 0))
    if force <= 0 then
      return nil
    end
    return {
      cityId = cityId,
      name = cityName,
      location = locationStr,
      influence = force,
      isDestroyed = isDestroyed,
      cityLevel = cityLevel
    }
  end
  
  if msg.occupiedCities then
    for _, cityId in ipairs(msg.occupiedCities) do
      local info = GetCityInfo(cityId, false)
      if info then
        table.insert(dataList, info)
      end
    end
  end
  if msg.destroyedCities then
    for _, cityId in ipairs(msg.destroyedCities) do
      local info = GetCityInfo(cityId, true)
      if info then
        table.insert(dataList, info)
      end
    end
  end
  self:RefreshPage(dataList)
end

return SeasonCampDestroyInfluenceDetail
