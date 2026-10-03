local SeasonCampDestroyZoneDetail = BaseClass("SeasonCampDestroyZoneDetail", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonCampDestroyZoneRankItem = require("UI.LWSeason6.SeasonCampDestroy.ZoneDetail.SeasonCampDestroyZoneRankItem")
local IMG_RING_1 = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_S6_ZYDK_fuwuqi_jindu_1.png"
local IMG_RING_2 = "Assets/Main/SeasonRes/S6/Sprites/CampDestroy/mjc_S6_ZYDK_fuwuqi_jindu_2.png"

function SeasonCampDestroyZoneDetail:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SeasonCampDestroyZoneDetail:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyZoneDetail:OnDisable()
  if self.progressTweenSeq then
    self.progressTweenSeq:Kill()
    self.progressTweenSeq = nil
  end
  base.OnDisable(self)
end

function SeasonCampDestroyZoneDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIconCity = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTmpCityRationName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpCityRatio = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnQuit = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnQuit:SetOnClick(function()
    self:OnBtnQuitClick()
  end)
  self.textTmpCityCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgIconRuins = self.viewSkin:AddComponent(self, UIImage, 7)
  self.textTmpRuinsCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compRankRect = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.textTmpEmptyNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 12)
  self.textTmpBottomNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textTmpServerID = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.imgProgress1 = self.viewSkin:AddComponent(self, UIImage, 15)
  self.textTmpTitleRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textTmpTitleAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textTmpTitleAllianceDamage = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.rawImgBgGreen = self.viewSkin:AddComponent(self, UIRawImage, 19)
  self.rawImgBgCamp = self.viewSkin:AddComponent(self, UIRawImage, 20)
  self.rawImgBgBlue = self.viewSkin:AddComponent(self, UIRawImage, 21)
  self.imgIconCamp = self.viewSkin:AddComponent(self, UIImage, 22)
  self.btnShowBuff = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnShowBuff:SetOnClick(function()
    self:OnBtnShowBuffClick()
  end)
  self.imgProgress2 = self.viewSkin:AddComponent(self, UIImage, 24)
  self.textTmpEmptyNotice:SetLocalText("season_builders_alliance_tips_5")
  self.textTmpCityRationName:SetLocalText("season_s6_activity_1200112_desc04")
  self.textTmpBottomNotice:SetLocalText("season_s6_activity_1200112_desc03")
  self.textTmpTitleRank:SetLocalText("458034")
  self.textTmpTitleAllianceName:SetLocalText("390288")
  self.textTmpTitleAllianceDamage:SetLocalText("season_s6_activity_1200112_desc05")
  self:InitItems()
  self.serverInfo = self:GetUserData()
  if self.serverInfo then
    self.serverInfo:RequestServerDetail()
  end
  self:Refresh()
end

function SeasonCampDestroyZoneDetail:ComponentDestroy()
  self.viewSkin = nil
  self.imgIconCity = nil
  self.textTmpCityRationName = nil
  self.textTmpCityRatio = nil
  self.textTmpName = nil
  self.btnQuit = nil
  self.textTmpCityCount = nil
  self.imgIconRuins = nil
  self.textTmpRuinsCount = nil
  self.compRankRect = nil
  self.textTmpEmptyNotice = nil
  self.compContent = nil
  self.gridInfinityScrollViewContent = nil
  self.textTmpBottomNotice = nil
  self.textTmpServerID = nil
  self.imgProgress1 = nil
  self.textTmpTitleRank = nil
  self.textTmpTitleAllianceName = nil
  self.textTmpTitleAllianceDamage = nil
  self.rawImgBgGreen = nil
  self.rawImgBgCamp = nil
  self.rawImgBgBlue = nil
  self.imgIconCamp = nil
  self.btnShowBuff = nil
  self.imgProgress2 = nil
end

function SeasonCampDestroyZoneDetail:DataDefine()
  self.mgr = DataCenter.SeasonCampDestroyManager
  self.currentStatusId = nil
  self.progressTweenSeq = nil
end

function SeasonCampDestroyZoneDetail:DataDestroy()
  if self.progressTweenSeq then
    self.progressTweenSeq:Kill()
    self.progressTweenSeq = nil
  end
  self.mgr = nil
  self.serverInfo = nil
  self.currentStatusId = nil
end

function SeasonCampDestroyZoneDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyGetServerInfoRefresh, self.OnServerInfoRefresh)
end

function SeasonCampDestroyZoneDetail:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyGetServerInfoRefresh, self.OnServerInfoRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyZoneDetail:OnServerInfoRefresh(serverId)
  if self.serverInfo and self.serverInfo.server == serverId then
    self:Refresh(true)
  end
end

function SeasonCampDestroyZoneDetail:InitItems()
  self:ClearItems()
  self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitRankItem), BindCallback(self, self.OnUpdateRankItem), BindCallback(self, self.OnDestroyRankItem))
end

function SeasonCampDestroyZoneDetail:GetRankData()
  return self.serverInfo and self.serverInfo:GetAllianceRank()
end

function SeasonCampDestroyZoneDetail:RefreshItems()
  self.rankDataList = self:GetRankData()
  if not self.rankDataList or #self.rankDataList <= 0 then
    self.textTmpEmptyNotice:SetActive(true)
    self.compContent:SetActive(false)
    return
  end
  self.textTmpEmptyNotice:SetActive(false)
  self.compContent:SetActive(true)
  self.gridInfinityScrollViewContent:SetItemCount(#self.rankDataList)
end

function SeasonCampDestroyZoneDetail:RefreshStyle()
  if not self.serverInfo then
    return
  end
  self.imgIconCamp:LoadSpriteAuto(SeasonUtil.GetSeason6CampMidIconPath(self.serverInfo.camp))
  if self.serverInfo.camp == SeasonFactionType.Rebels then
    self.rawImgBgGreen:SetActive(true)
    self.rawImgBgBlue:SetActive(false)
    self.imgProgress1:LoadSpriteAuto(IMG_RING_2)
    self.imgProgress2:LoadSpriteAuto(IMG_RING_1)
  elseif self.serverInfo.camp == SeasonFactionType.Gendarmerie then
    self.rawImgBgGreen:SetActive(false)
    self.rawImgBgBlue:SetActive(true)
    self.imgProgress1:LoadSpriteAuto(IMG_RING_1)
    self.imgProgress2:LoadSpriteAuto(IMG_RING_2)
  else
    self.rawImgBgGreen:SetActive(true)
    self.rawImgBgBlue:SetActive(false)
  end
end

function SeasonCampDestroyZoneDetail:OnInitRankItem(go, index)
  local item = self.compContent:AddComponent(SeasonCampDestroyZoneRankItem, go)
  item:Setup(self)
  item:SetActive(false)
  self.rankItems[go] = item
end

function SeasonCampDestroyZoneDetail:OnUpdateRankItem(go, index)
  local theIndex = index + 1
  local cellItem = self.rankItems[go]
  local data = self.rankDataList and self.rankDataList[theIndex]
  if cellItem and data then
    cellItem:SetActive(true)
    cellItem:ReInit(theIndex, data)
    self.rankItemList[theIndex] = cellItem
  end
end

function SeasonCampDestroyZoneDetail:OnDestroyRankItem(go, index)
end

function SeasonCampDestroyZoneDetail:Refresh(anim)
  if not self.mgr or not self.serverInfo then
    return
  end
  local info = self.serverInfo
  self.textTmpName:SetText(DataCenter.SeasonFactionWarDataManager:GetCampName(info.camp))
  self.textTmpServerID:SetText(string.format("#%s", info.server))
  self.textTmpCityCount:SetText(info.city)
  self.textTmpRuinsCount:SetText(info.ruins)
  local destroyRatio = Mathf.Clamp01(info.ruins * 1.0 / Mathf.Max(info.city, 1))
  local remainRatio = 1.0 - destroyRatio
  if self.progressTweenSeq then
    self.progressTweenSeq:Kill()
    self.progressTweenSeq = nil
  end
  if anim then
    local duration = 0.5
    local ease = CS.DG.Tweening.Ease.InOutQuad
    local seq = DOTween.Sequence()
    seq:Join(self.imgProgress1.unity_image:DOFillAmount(destroyRatio, duration):SetEase(ease))
    seq:Join(self.imgProgress2.unity_image:DOFillAmount(remainRatio, duration):SetEase(ease))
    self.progressTweenSeq = seq
    seq:OnComplete(function()
      if self.progressTweenSeq ~= seq then
        return
      end
      self.imgProgress1:SetFillAmount(destroyRatio)
      self.imgProgress2:SetFillAmount(remainRatio)
      self.progressTweenSeq = nil
    end)
  else
    self.imgProgress1:SetFillAmount(destroyRatio)
    self.imgProgress2:SetFillAmount(remainRatio)
  end
  self.currentIntegrityRatio = remainRatio
  self.textTmpCityRatio:SetText(string.format("%d%%", Mathf.Round(self.currentIntegrityRatio * 100)))
  self:RefreshStyle()
  self:RefreshItems()
  self:RefreshBuff()
end

function SeasonCampDestroyZoneDetail:GetStatusIdByIntegrity(integrityRatio)
  local actConfig = self.mgr and self.mgr.actConfig
  if not actConfig then
    return nil
  end
  local para = actConfig:getValue("para")
  local para1 = actConfig:getValue("para_1")
  if not para or not para1 then
    return nil
  end
  local thresholds = string.split(para, "|")
  local statusIds = string.split(para1, "|")
  if #thresholds ~= #statusIds or #thresholds == 0 then
    return nil
  end
  local statusId
  for i = #thresholds, 1, -1 do
    local threshold = toInt(thresholds[i]) / 100
    if integrityRatio <= threshold then
      statusId = toInt(statusIds[i])
      break
    end
  end
  return statusId
end

function SeasonCampDestroyZoneDetail:RefreshBuff()
  self.currentStatusId = self:GetStatusIdByIntegrity(self.currentIntegrityRatio)
  if not self.currentStatusId then
    self.btnShowBuff:SetButtonNameLocal("")
    self.btnShowBuff:SetActive(false)
    return
  end
  self.btnShowBuff:SetActive(true)
  local statusConfig = LocalController:instance():getLine(TableName.StatusTab, self.currentStatusId)
  if statusConfig then
    local buffName = statusConfig:getValue("name")
    local buffIcon = statusConfig:getValue("icon")
    if buffName then
      self.btnShowBuff:SetButtonNameLocal(buffName)
    end
    if buffIcon then
      self.btnShowBuff:SetIconPath(buffIcon)
    end
  end
end

function SeasonCampDestroyZoneDetail:OnBtnShowBuffClick()
  SeasonUtil.OpenSeasonCampDestroyBuffDetail()
end

function SeasonCampDestroyZoneDetail:ClearItems()
  self.compContent:RemoveComponents(SeasonCampDestroyZoneRankItem)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.rankItems = {}
  self.rankItemList = {}
end

function SeasonCampDestroyZoneDetail:OnBtnQuitClick()
  self.ctrl:CloseSelf()
end

return SeasonCampDestroyZoneDetail
