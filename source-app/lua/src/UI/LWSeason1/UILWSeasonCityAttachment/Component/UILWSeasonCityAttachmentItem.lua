local UILWSeasonCityAttachmentItem = BaseClass("UILWSeasonCityAttachmentItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonCityAttachmentItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIRawImage, "icon")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.btn_build = self:AddComponent(UIButton, "BtnBuild")
  self.btn_build_txt = self:AddComponent(UITextMeshProUGUIEx, "BtnBuild/txt")
  self.btn_build:SetOnClick(function()
    local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
    if not isFarmer then
      UIUtil.ShowTipsId("season_builders_alliance_UI_2")
      return
    end
    if DataCenter.SeasonFarmerManager:GetCurBuildingInfo() ~= nil then
      UIUtil.ShowTipsId("cit_attachment_tips_15")
      return
    end
    if self.unlockCount == nil or self.unlockCount == 0 then
      UIUtil.ShowTipsId("season_builders_alliance_button_2")
    elseif self.hasCount == self.unlockCount then
      UIUtil.ShowTipsId("season_builders_alliance_tips_10")
    elseif self.buildData and self.buildData.cfgId then
      if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
        UIUtil.ShowTipsId("season_builders_alliance_tips_9")
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
      if LuaEntry.Player:AtHomeNow() then
        SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentFreePoint, self.buildData.cfgId)
      else
        UIUtil.ShowTipsId("season_builders_alliance_tips_53")
      end
    else
      UIUtil.ShowTipsId("E100008")
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
  self.res_icon = self:AddComponent(UIButton, "ResIcon")
  self.mem_icon = self:AddComponent(UIButton, "MemIcon")
  self.info_btn:SetActive(false)
  self.lockTxt = self:AddComponent(UITextMeshProUGUIEx, "lock")
  self.bg = self:AddComponent(UIImage, "bg")
  self.lock_icon = self:AddComponent(UIImage, "icon/lockIcon")
  self.res_icon:SetOnClick(function()
    if self.buildData and self.buildData.cost then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.isLocal = true
      param.desc = Localization:GetString("season_builders_alliance_UI_82", string.GetFormattedSeparatorNum(self.buildData.cost))
      param.alignObject = self.res_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
  self.mem_icon:SetOnClick(function()
    if self.buildData and self.buildData.persons_num then
      local param = {}
      param.type = "desc"
      param.title = ""
      param.isLocal = true
      param.desc = Localization:GetString("season_builders_alliance_UI_78", self.buildData.persons_num)
      param.alignObject = self.mem_icon
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
    end
  end)
end

function UILWSeasonCityAttachmentItem:OnDestroy()
  self.lock = nil
  self.bg = nil
  self.lock_icon = nil
  self.info_btn = nil
  self.res_num = nil
  self.mem_num = nil
  self.icon = nil
  self.title = nil
  self.desc = nil
  self.btn_build = nil
  self.txt = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityAttachmentFreePointInfo, self.OnFreePointInfoUpdate)
end

function UILWSeasonCityAttachmentItem:OnRemoveListener()
  self:RemoveUIListener(EventId.CityAttachmentFreePointInfo, self.OnFreePointInfoUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonCityAttachmentItem:OnFreePointInfoUpdate(t)
  if t and self.buildData and self.buildData.cfgId == t.buildId then
    local pointId = t.pointId
    local buildId = t.buildId
    local serverId = LuaEntry.Player:GetSourceServerId()
    local cityId = SceneUtils.GetZoneIdByPosId(pointId, serverId)
    local slotIndex = CSharpCallLuaInterface.GetInt("CityAttachmentSlotId," .. pointId .. "," .. serverId)
    local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(pos, nil, nil, function()
      BuildingUtils.ShowPutAllianceBuild(buildId, cityId * 1000 + slotIndex, pointId, PlaceBuildType.CityAttachment)
    end)
  end
end

function UILWSeasonCityAttachmentItem:ReInit(index, buildData)
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  self.buildData = buildData
  self.title:SetLocalText(buildData.name)
  self.icon:LoadSprite(buildData.icon)
  self.desc:SetLocalText(buildData.desc_2, buildData.desc_2_para)
  self.res_num:SetText(string.GetFormattedSeparatorNum(buildData.cost))
  self.mem_num:SetText(string.GetFormattedSeparatorNum(buildData.persons_num))
  local allianceBuildInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo
  local unlockCount = 0
  local theBuildId = toInt(buildData.cfgId)
  if isFarmer and allianceBuildInfo.builderExpInfo then
    local myLevel = toInt(allianceBuildInfo.builderExpInfo.level)
    local expList = DataCenter.SeasonFarmerTemplateManager:GetALLExpTemplate()
    if expList then
      for k, v in pairs(expList) do
        if myLevel >= v.level and v.unlockBuildId == theBuildId and v.unlockCount ~= 0 then
          unlockCount = unlockCount + v.unlockCount
        end
      end
    end
  end
  if isFarmer and 0 < unlockCount then
    local hasCount = 0
    if allianceBuildInfo and allianceBuildInfo.ownerList then
      for k, v in pairs(allianceBuildInfo.ownerList) do
        if v and v.buildId == theBuildId then
          hasCount = hasCount + 1
        end
      end
    end
    self.checkCountOK, self.checkPowerOK = DataCenter.AllianceMemberDataManager:CheckPowerAndCount(buildData.persons_num, buildData.persons_power)
    self.hasCount = hasCount
    self.unlockCount = unlockCount
    self.btn_build:SetActive(true)
    self.lock_icon:SetActive(false)
    self.lockTxt:SetActive(false)
    self.btn_build_txt:SetLocalText("season_builders_alliance_button_1", hasCount, unlockCount)
    CS.UIGray.SetGray(self.btn_build.transform, hasCount == unlockCount or not self.checkCountOK or not self.checkPowerOK, true)
    CS.UIGray.SetGray(self.bg.transform, false, false)
    CS.UIGray.SetGray(self.icon.transform, false, false)
    self.icon:SetColorRGBA255(255, 255, 255, 255)
    self.bg:SetColorRGBA255(255, 255, 255, 255)
  else
    self.hasCount = 0
    self.unlockCount = 0
    self.btn_build:SetActive(false)
    self.lock_icon:SetActive(true)
    self.lockTxt:SetActive(true)
    self.lockTxt:SetLocalText("season_builders_alliance_button_2")
    CS.UIGray.SetGray(self.btn_build.transform, true, true)
    CS.UIGray.SetGray(self.bg.transform, true, false)
    CS.UIGray.SetGray(self.icon.transform, true, false)
    self.icon:SetColorRGBA255(150, 150, 150, 255)
    self.bg:SetColorRGBA255(210, 210, 210, 255)
  end
  self.info_btn:SetActive(true)
end

return UILWSeasonCityAttachmentItem
