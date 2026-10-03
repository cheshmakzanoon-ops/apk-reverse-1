local UILWSeasonCityAttachmentPopListItem = BaseClass("UILWSeasonCityAttachmentPopListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonCityAttachmentPopListItem:OnCreate()
  base.OnCreate(self)
  self.exist_build = false
  self.hpBar = self:AddComponent(UISlider, "HPBar")
  self.icon = self:AddComponent(UIRawImage, "icon")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.btn_build = self:AddComponent(UIButton, "BtnBuild")
  self.btn_build_txt = self:AddComponent(UITextMeshProUGUIEx, "BtnBuild/txt")
  self.btn_build:SetOnClick(function()
    local pointId = self.buildPointId
    if self.exist_build and pointId then
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, 0.02, function()
      end)
    else
      local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
      if isFarmer and (self.unlockCount == nil or self.unlockCount == 0) then
        UIUtil.ShowTipsId("season_builders_alliance_button_2")
      elseif isFarmer and self.hasCount == self.unlockCount then
        UIUtil.ShowTipsId("season_builders_alliance_tips_10")
      elseif isFarmer then
        self:TryBuild()
      else
        UIUtil.ShowTipsId("season_builders_alliance_UI_2")
      end
    end
  end)
  self.res_root = self:AddComponent(UIButton, "ResIcon")
  self.mem_root = self:AddComponent(UIButton, "MemIcon")
  self.res_root:SetOnClick(function()
    if self.buildData and self.buildData.cost then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.isLocal = true
      param.desc = Localization:GetString("season_builders_alliance_UI_82", string.GetFormattedSeparatorNum(self.buildData.cost))
      param.alignObject = self.res_root
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.mem_root:SetOnClick(function()
    if self.buildData and self.buildData.persons_num then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.isLocal = true
      param.desc = Localization:GetString("season_builders_alliance_UI_78", self.buildData.persons_num)
      param.alignObject = self.mem_root
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.info_btn = self:AddComponent(UIButton, "InfoBtn")
  self.res_num = self:AddComponent(UITextMeshProUGUIEx, "ResIcon/ResNum")
  self.mem_num = self:AddComponent(UITextMeshProUGUIEx, "MemIcon/MemNum")
  self.info_btn:SetOnClick(function()
    if self.buildData then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachmentDetail, {anim = true}, self.buildData.cfgId)
    end
  end)
  self.info_btn:SetActive(false)
  self.lockTxt = self:AddComponent(UITextMeshProUGUIEx, "lock")
  self.bg = self:AddComponent(UIImage, "bg")
  self.lock_icon = self:AddComponent(UIImage, "icon/lockIcon")
end

function UILWSeasonCityAttachmentPopListItem:OnDestroy()
  self.icon = nil
  self.title = nil
  self.desc = nil
  self.lock = nil
  self.btn_build = nil
  self.txt = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentPopListItem:ReInit(slotIndex, cityId, cityPointId, buildId, cityMeta)
  local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(buildId)
  self.slotIndex = slotIndex
  self.cityId = cityId
  self.cityPointId = cityPointId
  self.cityMeta = cityMeta
  self.buildPointId = cityMeta:GetBuildPosBySlot(slotIndex)
  self.hpBar:SetActive(false)
  if buildData then
    self.buildData = buildData
    self.title:SetLocalText(buildData.name)
    self.icon:LoadSprite(buildData.icon)
    self.desc:SetLocalText(buildData.desc_2, buildData.desc_2_para)
    self.res_num:SetText(string.GetFormattedSeparatorNum(buildData.cost))
    self.mem_num:SetText(string.GetFormattedSeparatorNum(buildData.persons_num))
    self.res_root:SetActive(true)
    self.mem_root:SetActive(true)
    local unlockCount = 0
    local hasCount = 0
    local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
    local allianceBuildInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo
    if allianceBuildInfo and isFarmer and allianceBuildInfo.builderExpInfo then
      local myLevel = toInt(allianceBuildInfo.builderExpInfo.level)
      local expList = DataCenter.SeasonFarmerTemplateManager:GetALLExpTemplate()
      if expList then
        for k, v in pairs(expList) do
          if myLevel >= v.level and v.unlockBuildId == buildId and v.unlockCount ~= 0 then
            unlockCount = unlockCount + v.unlockCount
          end
        end
      end
      if allianceBuildInfo and allianceBuildInfo.ownerList then
        for k, v in pairs(allianceBuildInfo.ownerList) do
          if v and v.buildId == buildId then
            hasCount = hasCount + 1
          end
        end
      end
    end
    if isFarmer and 0 < unlockCount then
      self.checkCountOK, self.checkPowerOK = DataCenter.AllianceMemberDataManager:CheckPowerAndCount(buildData.persons_num, buildData.persons_power)
      self.hasCount = hasCount
      self.unlockCount = unlockCount
      self.btn_build:SetActive(true)
      self.lock_icon:SetActive(false)
      self.lockTxt:SetActive(false)
      self.btn_build_txt:SetLocalText("110015")
      self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
      CS.UIGray.SetGray(self.btn_build.transform, hasCount == unlockCount or not self.checkCountOK or not self.checkPowerOK, true)
      CS.UIGray.SetGray(self.bg.transform, false, false)
      CS.UIGray.SetGray(self.icon.transform, false, false)
      self.icon:SetColorRGBA255(255, 255, 255, 255)
      self.bg:SetColorRGBA255(255, 255, 255, 255)
    else
      self.btn_build:SetActive(false)
      self.lock_icon:SetActive(true)
      self.lockTxt:SetActive(true)
      self.lockTxt:SetLocalText("season_builders_alliance_button_2")
      CS.UIGray.SetGray(self.bg.transform, true, false)
      CS.UIGray.SetGray(self.icon.transform, true, false)
      self.icon:SetColorRGBA255(150, 150, 150, 255)
      self.bg:SetColorRGBA255(210, 210, 210, 255)
    end
    self.info_btn:SetActive(true)
  else
    self.btn_build:SetActive(false)
  end
end

function UILWSeasonCityAttachmentPopListItem:OnDetailUpdate(slotData)
  if slotData and self.buildData then
    if slotData.state == 0 and slotData.exp ~= nil then
      local cost = toInt(self.buildData.cost)
      if 0 < cost then
        self.hpBar:SetActive(true)
        self.hpBar:SetValue(slotData.exp / cost)
      else
        self.hpBar:SetActive(false)
      end
    else
      self.hpBar:SetActive(false)
    end
    self.exist_build = true
    self.btn_build:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    self.btn_build:SetActive(true)
    self.lock_icon:SetActive(false)
    self.lockTxt:SetActive(false)
    self.res_root:SetActive(false)
    self.mem_root:SetActive(false)
    self.title:SetText("[" .. slotData.allianceAbbr .. "]" .. Localization:GetString(self.buildData.name))
    self.btn_build_txt:SetLocalText("500413")
    self.icon:SetColorRGBA255(255, 255, 255, 255)
    self.bg:SetColorRGBA255(255, 255, 255, 255)
    CS.UIGray.SetGray(self.btn_build.transform, false, true)
    CS.UIGray.SetGray(self.bg.transform, false, false)
    CS.UIGray.SetGray(self.icon.transform, false, false)
  end
end

function UILWSeasonCityAttachmentPopListItem:TryBuild()
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId("season_builders_alliance_tips_9")
    return
  end
  if DataCenter.SeasonFarmerManager:GetCurBuildingInfo() ~= nil then
    UIUtil.ShowTipsId("cit_attachment_tips_15")
    return
  end
  if not self.checkCountOK then
    UIUtil.ShowTipsId("2010358")
    return
  end
  if not self.checkPowerOK then
    UIUtil.ShowTipsId("2010359")
    return
  end
  local cfg = self.buildData
  if cfg == nil then
    return
  end
  if LuaEntry.Player:AtHomeNow() then
    local pointId = self.buildPointId
    local slotIndex = self.slotIndex - 1
    local cityId = self.cityId
    local buildId = cfg.cfgId
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, LuaEntry.Player:GetCurServerId())
    if cityInfo ~= nil and cityInfo.allianceId ~= nil then
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World), nil, 0.02, function()
        BuildingUtils.ShowPutAllianceBuild(buildId, cityId * 1000 + slotIndex, pointId, PlaceBuildType.CityAttachment)
      end, LuaEntry.Player:GetSourceServerId())
    else
      UIUtil.ShowTipsId("cit_attachment_tips_16")
    end
  else
    UIUtil.ShowMessage(Localization:GetString("season_tips142", ""), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      GoToUtil.CloseAllWindows()
      CrossServerUtil.BackToSrcServer()
    end)
  end
end

return UILWSeasonCityAttachmentPopListItem
