local UILWSeasonMapDetailV6Item = BaseClass("UILWSeasonMapDetailV6Item", UIToggle)
local base = UIToggle

function UILWSeasonMapDetailV6Item:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "")
  self.infoRoot = self:AddComponent(UIButton, "info")
  self.king_badges = self:AddComponent(UIImage, "info/icon")
  self.nameBg = self:AddComponent(UIImage, "info/bg")
  self.selectRed = self:AddComponent(UIImage, "selectBig")
  self.select = self:AddComponent(UIImage, "select")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "info/name")
  self.selectRed:SetActive(false)
  self.infoRoot:SetOnClick(function()
    if self.theMapIndex and self.serverId then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      if self.theMapIndex == 5 then
        if self.serverZoneCamp == nil then
          do
            local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
            local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(GovOfficialType.Center, seasonSubType)
            if 0 < #templates then
              local cityId = SeasonUtil.GetCenterCityId(self.serverId)
              UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialMain, {anim = true}, GovOfficialType.Center, self.serverId, cityId)
            else
            end
          end
        end
      else
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGovernmentOfficial) then
          UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentOfficial)
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentOfficial, {anim = true}, self.serverId)
      end
    end
  end)
end

function UILWSeasonMapDetailV6Item:OnDestroy()
  self.nameBg = nil
  base.OnDestroy(self)
end

function UILWSeasonMapDetailV6Item:ReInit(theMapIndex, serverId, info, mySourceServerId, serverZoneCamp, myCampId)
  self.theMapIndex = theMapIndex
  self.serverId = serverId
  self.info = info
  self.serverZoneCamp = serverZoneCamp
  self.mySourceServerId = mySourceServerId
  if serverId == nil or serverId == 0 then
    self.name:SetText("#???")
    self.king_badges:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi00.png")
  else
    local theCampId = 0
    if info then
      theCampId = info:GetCampIdByServerId(serverId)
    end
    if myCampId == nil then
      myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    end
    if serverZoneCamp then
      theCampId = serverZoneCamp.campId
    end
    self.theCampId = theCampId
    self.myCampId = myCampId
    self.theCampId = theCampId
    self.name:SetText("#" .. serverId)
    if serverId == mySourceServerId then
      self.name:SetColorHex("#5fef87")
    elseif theMapIndex == 5 then
      self.name:SetColorHex("#FFFFFF")
    elseif myCampId == theCampId then
      self.name:SetColorHex("#FFFFFF")
    else
      self.name:SetColorHex("#f97077")
    end
    if theMapIndex == 5 then
      local kingCityId = 1103
      local lineData = LocalController:instance():tryGetLine("season_city_s6", toInt(kingCityId))
      if lineData and lineData.lod_icon ~= nil and lineData.lod_icon ~= "" then
        self.king_badges:LoadSprite(lineData.lod_icon)
      else
        local kingCfg = DataCenter.AllianceCityTemplateManager:GetTemplate(kingCityId, serverId)
        if kingCfg and kingCfg.lod_icon ~= nil and kingCfg.lod_icon ~= "" then
          self.king_badges:LoadSprite(kingCfg.lod_icon)
        else
          self.king_badges:LoadSprite("Assets/Main/Sprites/ItemIcons/lrb_zhanqvduijue_tubiao_fuwuqi02.png")
        end
      end
    else
      local badgesIconPath = DataCenter.ZoneWarManager:GetKingdomBadgesIconPath(serverId)
      self.king_badges:LoadSprite(badgesIconPath)
      if theCampId == 1 then
        self.nameBg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_fuwuqibg01.png")
      elseif theCampId == 2 then
        self.nameBg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_fuwuqibg02.png")
      end
    end
    if theCampId == SeasonFactionType.Rebels then
      self.bg:SetColorHex("4B855D")
    elseif theCampId == SeasonFactionType.Gendarmerie then
      self.bg:SetColorHex("30778B")
    elseif theCampId == SeasonFactionType.Central then
      self.bg:SetColorHex("FFFFFF00")
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.infoRoot.rectTransform)
end

function UILWSeasonMapDetailV6Item:SetSelectMode(mode)
  if mode == 1 then
    if self.serverZoneCamp then
      self:SetIsOn(self.theMapIndex ~= 5 and self.theCampId == self.myCampId and self.myCampId ~= 0)
    elseif self.info and self.info:IsInBattleServerGroupInt_IgnoreSplitServer(self.mySourceServerId) then
      self:SetIsOn(self.theMapIndex ~= 5 and self.theCampId == self.myCampId)
    else
      self:SetIsOn(self.theMapIndex ~= 5)
    end
    self.selectRed:SetActive(false)
  elseif mode == 4 then
    self:SetIsOn(false)
    self.selectRed:SetActive(self.theMapIndex ~= 5 and self.theCampId ~= self.myCampId)
  elseif mode == 3 then
    self:SetIsOn(self.theMapIndex == 5)
    self.selectRed:SetActive(false)
  elseif mode == 2 then
    self:SetIsOn(false)
    self.selectRed:SetActive(self.theMapIndex == 5)
  end
end

return UILWSeasonMapDetailV6Item
