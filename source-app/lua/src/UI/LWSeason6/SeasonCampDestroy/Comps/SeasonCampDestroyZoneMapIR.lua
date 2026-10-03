local base = UIBaseContainer
local SeasonCampDestroyZoneMapIR = BaseClass("SeasonCampDestroyZoneMapIR", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local MID_IDNEX = 5

function SeasonCampDestroyZoneMapIR:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyZoneMapIR:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyZoneMapIR:OnDisable()
  if self.modeTweenSeq then
    self.modeTweenSeq:Kill()
    self.modeTweenSeq = nil
  end
  base.OnDisable(self)
end

function SeasonCampDestroyZoneMapIR:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compZoneMap = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.btnSeasonCampDestroyZoneMapIR = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSeasonCampDestroyZoneMapIR:SetOnClick(function()
    self:OnBtnSeasonCampDestroyZoneMapIRClick()
  end)
  self.compMapNode = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compServerNode = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textTmpServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.imgMyServer = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgServerGb = self.viewSkin:AddComponent(self, UIImage, 9)
  self.canvasGroupMapNode = self.viewSkin:AddComponent(self, UICanvasGroup, 10)
  self.canvasGroupServerNode = self.viewSkin:AddComponent(self, UICanvasGroup, 11)
  self.worldMapZoneImage = self.compZoneMap.transform:GetComponent(typeof(CS.LS.UnityEngine.UI.WorldMapZoneImage))
end

function SeasonCampDestroyZoneMapIR:ComponentDestroy()
  self.viewSkin = nil
  self.compZoneMap = nil
  self.btnSeasonCampDestroyZoneMapIR = nil
  self.compMapNode = nil
  self.compServerNode = nil
  self.textTmpServer = nil
  self.imgIcon = nil
  self.imgMyServer = nil
  self.imgBg = nil
  self.imgServerGb = nil
  self.canvasGroupMapNode = nil
  self.canvasGroupServerNode = nil
  self.vfxIn = nil
  self.vfxLoop = nil
end

function SeasonCampDestroyZoneMapIR:TryFindVfx()
  local _ = self.transform:Find("vs/VfxLoop")
  if IsNotNull(_) then
    self.vfxLoop = _.gameObject
    self.vfxLoop:SetActive(false)
  end
  local _ = self.transform:Find("vs/VfxIn")
  if IsNotNull(_) then
    self.vfxIn = _.gameObject
    self.vfxIn:SetActive(false)
  end
end

function SeasonCampDestroyZoneMapIR:DataDefine()
  self.serverMode = nil
  self.worldMapZoneImage = nil
  self.modeTweenSeq = nil
  self.vfxTweenSeq = nil
  self.hasInitModeShow = false
end

function SeasonCampDestroyZoneMapIR:DataDestroy()
  if self.modeTweenSeq then
    self.modeTweenSeq:Kill()
    self.modeTweenSeq = nil
  end
  if self.vfxTweenSeq then
    self.vfxTweenSeq:Kill()
    self.vfxTweenSeq = nil
  end
  self.serverInfo = nil
  self.worldMapZoneImage = nil
  self.vfxIn = nil
  self.vfxLoop = nil
end

function SeasonCampDestroyZoneMapIR:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyZoneMapIR:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyZoneMapIR:OnBtnSeasonCampDestroyZoneMapIRClick()
  if not self.serverInfo then
    return
  end
  if self.midMap then
    return
  end
  if self.parent and self.parent.OnZoneClick then
    self.parent:OnZoneClick(self.serverInfo.index)
  end
end

function SeasonCampDestroyZoneMapIR:ChangeMode(serverMode)
  if self.serverMode == serverMode and self.hasInitModeShow and not self.midMap then
    return
  end
  self.serverMode = serverMode
  if self.midMap then
    self.compServerNode:SetActive(false)
    self.compMapNode:SetActive(false)
    return
  end
  local showServerNode = serverMode == true
  local showMapNode = not showServerNode
  if not self.hasInitModeShow then
    self.hasInitModeShow = true
    if self.canvasGroupServerNode then
      self.canvasGroupServerNode:SetShow(showServerNode)
    end
    if self.canvasGroupMapNode then
      self.canvasGroupMapNode:SetShow(showMapNode)
    end
    self.compServerNode:SetActive(showServerNode)
    self.compMapNode:SetActive(showMapNode)
    return
  end
  if self.modeTweenSeq then
    self.modeTweenSeq:Kill()
    self.modeTweenSeq = nil
  end
  local duration = 0.2
  self.compServerNode:SetActive(true)
  self.compMapNode:SetActive(true)
  local seq = DOTween.Sequence()
  if showServerNode then
    seq:Join(self.canvasGroupServerNode:FadeIn(duration))
    seq:Join(self.canvasGroupMapNode:FadeOut(duration))
  else
    seq:Join(self.canvasGroupServerNode:FadeOut(duration))
    seq:Join(self.canvasGroupMapNode:FadeIn(duration))
  end
  self.modeTweenSeq = seq
  seq:OnComplete(function()
    if self.modeTweenSeq ~= seq then
      return
    end
    if self.canvasGroupServerNode then
      self.canvasGroupServerNode:SetShow(showServerNode)
    end
    if self.canvasGroupMapNode then
      self.canvasGroupMapNode:SetShow(showMapNode)
    end
    self.compServerNode:SetActive(showServerNode)
    self.compMapNode:SetActive(showMapNode)
    self.modeTweenSeq = nil
  end)
end

function SeasonCampDestroyZoneMapIR:Init(parent, index)
  self.parent = parent
  if index == MID_IDNEX then
    self:TryFindVfx()
    if self.vfxIn then
      self.vfxIn:SetActive(true)
    end
    if self.vfxLoop then
      self.vfxLoop:SetActive(false)
    end
    if self.vfxTweenSeq then
      self.vfxTweenSeq:Kill()
      self.vfxTweenSeq = nil
    end
    self.vfxTweenSeq = DOTween.Sequence()
    self.vfxTweenSeq:AppendInterval(1.2)
    self.vfxTweenSeq:AppendCallback(function()
      if self.vfxIn then
        self.vfxIn:SetActive(false)
      end
      if self.vfxLoop then
        self.vfxLoop:SetActive(true)
      end
    end)
    self.vfxTweenSeq:OnComplete(function()
      self.vfxTweenSeq = nil
    end)
    self.hasPlayedVfxIn = true
  end
end

function SeasonCampDestroyZoneMapIR:Refresh(serverInfo)
  self.serverInfo = serverInfo
  self.textTmpServer:SetText(string.format("#%s", self.serverInfo.server))
  self.midMap = serverInfo.index == MID_IDNEX
  if self.hasInitModeShow then
    self:ChangeMode(self.serverMode)
  end
  if self.imgMyServer then
    self.imgMyServer:SetActive(self.serverInfo.isMyServer or false)
  end
  self:RefreshCastleIcon(serverInfo)
  if self.midMap then
    self.imgBg:SetActive(false)
  else
    self.imgBg:SetActive(true)
    self.imgBg:SetColor(SeasonUtil.GetSeason6CampColor(self.serverInfo.camp))
    self.imgServerGb:LoadSpriteAuto(SeasonUtil.GetSeason6CampNameBgPath(self.serverInfo.camp))
    local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    self.textTmpServer:SetColorHex(myCampId == self.serverInfo.camp and "FFFFFF" or "F97077")
    self:RefreshZoneColors(serverInfo)
  end
end

function SeasonCampDestroyZoneMapIR:RefreshCastleIcon(serverInfo)
  if not (serverInfo and serverInfo.server) or serverInfo.server == 0 then
    self.imgIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi00.png")
    return
  end
  local serverId = serverInfo.server
  if self.midMap then
    local kingCfg = DataCenter.AllianceCityTemplateManager:GetKingCityData(serverId)
    if kingCfg and kingCfg.lod_icon ~= nil and kingCfg.lod_icon ~= "" then
      self.imgIcon:LoadSprite(kingCfg.lod_icon)
    else
      self.imgIcon:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png")
    end
  else
    local badgesIconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(serverId)
    self.imgIcon:LoadSprite(badgesIconPath)
  end
end

function SeasonCampDestroyZoneMapIR:RefreshZoneColors(serverInfo)
  if not serverInfo then
    return
  end
  if self.midMap then
    return
  end
  if not self.worldMapZoneImage and self.compZoneMap and self.compZoneMap.transform then
    self.worldMapZoneImage = self.compZoneMap.transform:GetComponent(typeof(CS.LS.UnityEngine.UI.WorldMapZoneImage))
    if IsNotNull(self.worldMapZoneImage) and self.parent then
      self.worldMapZoneImage.CampColors = self.parent.zoneColors
    end
  end
  if not self.worldMapZoneImage then
    return
  end
  local cityIds = self.parent and self.parent:GetCityIdsArray(serverInfo.index)
  if not cityIds then
    return
  end
  local campIdArray = CS.System.Array.CreateInstance(typeof(CS.System.Int32), #cityIds)
  local myId = DataCenter.SeasonFactionWarDataManager.myCampId
  for i, cityId in ipairs(cityIds) do
    local campId = SeasonUtil.GetCityOccupyCampId(cityId, serverInfo.server)
    if campId == SeasonFactionType.None then
      campIdArray[i - 1] = 0
    else
      campIdArray[i - 1] = myId == campId and 1 or 2
    end
  end
  self.worldMapZoneImage:SetZoneCampIds(campIdArray)
end

return SeasonCampDestroyZoneMapIR
