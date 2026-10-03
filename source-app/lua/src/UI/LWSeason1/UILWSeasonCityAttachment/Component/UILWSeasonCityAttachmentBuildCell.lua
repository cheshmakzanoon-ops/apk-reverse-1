local UILWSeasonCityAttachmentBuildCell = BaseClass("UILWSeasonCityAttachmentBuildCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local bg_white_path = "bgWhite"
local building_path = "building"
local level_path = "txtLevel"
local txt_product_path = "Status/title/txtStatus"
local text_path = "Pos/Text"
local pos_path = "Pos"
local status_path = "Status"
local res_icon_path = "Status/title/res_icon"
local icon_path = "building/icon"
local tooltip_path = "tooltip"
local tooltip_txt_path = "tooltip/tooltip_txt"
local close_btn_path = "tooltip/closeBtn"
local title_root_path = "Status/title"
local res_icon2_path = "popup/res_icon2"
local res_count_path = "popup/res_count"
local popup_path = "popup"

function UILWSeasonCityAttachmentBuildCell:OnCreate()
  base.OnCreate(self)
  self.hpBar = self:AddComponent(UISlider, "HPBar")
  self.bg_white = self:AddComponent(UIImage, bg_white_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.icon = self:AddComponent(UIRawImage, icon_path)
  self.status = self:AddComponent(UIImage, status_path)
  self.res_icon = self:AddComponent(UIImage, res_icon_path)
  self.popup = self:AddComponent(UIButton, popup_path)
  self.res_icon2 = self:AddComponent(UIImage, res_icon2_path)
  self.res_count = self:AddComponent(UITextMeshProUGUIEx, res_count_path)
  self.popup:SetOnClick(function()
    if self.cityId and self.slotId then
      self.tryGetReward = true
      SFSNetwork.SendMessage(MsgDefines.GetCityAttachmentRewardByIcon, self.cityId, self.slotId)
    end
  end)
  self.title_root = self:AddComponent(UIBaseContainer, title_root_path)
  self.txtLevel = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.txt_product = self:AddComponent(UITextMeshProUGUIEx, txt_product_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.pos_btn = self:AddComponent(UIButton, pos_path)
  self.pos_btn:SetOnClick(function()
    if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
      local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, LuaEntry.Player:GetSourceServerId())
    end
  end)
  self.building:SetOnClick(function()
    self:OnClick()
  end)
  self.tooltip = self:AddComponent(UICanvasGroup, tooltip_path)
  self.tooltip_txt = self:AddComponent(UIText, tooltip_txt_path)
  self.tooltip_close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tooltip:SetActive(false)
  self.tooltip:SetAlpha(0)
  self.tooltip.transform:Rotate(0, 90, 0)
  self.tooltip_close_btn:SetOnClick(function()
    self:HideTips()
  end)
  self.popup:SetActive(false)
  self.tryGetReward = nil
end

function UILWSeasonCityAttachmentBuildCell:ShowTips()
  if self.tooltip_txt ~= nil then
    self.tooltip:SetAlpha(0)
    self.tooltip:SetActive(true)
    self.tooltip:FadeIn(0.3)
    self.tooltip.transform:DORotate(Vector3.zero, 0.2)
    self.tooltip_tick = 3
  end
end

function UILWSeasonCityAttachmentBuildCell:OnClick()
  self:ShowTips()
end

function UILWSeasonCityAttachmentBuildCell:HideTips()
  if self.tooltip_txt ~= nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(self.tooltip:FadeOut(0.3))
    sequence:Join(self.tooltip.transform:DORotate(Vector3.New(0, 90, 0), 0.2))
    sequence:OnComplete(function()
      self.tooltip:SetActive(false)
    end)
    self.tooltip_tick = 0
  end
end

function UILWSeasonCityAttachmentBuildCell:OnDestroy()
  self.bg_white = nil
  self.building = nil
  self.txtLevel = nil
  self.txt_product = nil
  self.text = nil
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentBuildCell:ReInit(index, dataConfig)
  local cityId = dataConfig.cityId
  local originalData = dataConfig.original
  local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(dataConfig.buildId)
  local isFarmer = DataCenter.SeasonFarmerManager:IsActive()
  if dataConfig.allianceId ~= nil then
    originalData = dataConfig
  end
  self.index = index
  self.dataConfig = dataConfig
  self.cityPos = SceneUtils.IndexToTilePos(dataConfig.pointId, ForceChangeScene.World)
  self.cityId = cityId
  self.slotId = dataConfig.slot
  self.txtLevel:SetLocalText("300665", dataConfig.level)
  self.icon:SetActive(true)
  self.icon:LoadSprite(buildData:GetIconPath())
  self.popup:SetActive(false)
  if buildData.rewardResourceId == 0 then
    self.popup:SetActive(false)
    self.res_icon:SetActive(false)
  else
    local iconPath = DataCenter.ResourceManager:GetResourceIconByType(buildData.rewardResourceId)
    self.res_icon:LoadSprite(iconPath)
    self.res_icon2:LoadSprite(iconPath)
    self.res_icon:SetActive(true)
    local hasCoal = toInt(dataConfig.leftNum)
    self.popup:SetActive(0 < hasCoal)
    if 0 < hasCoal then
      self.res_count:SetText(string.GetFormattedStr(hasCoal * buildData.rewardResourceCount))
    end
  end
  if isFarmer and dataConfig.allianceId and dataConfig.allianceId ~= LuaEntry.Player.allianceId then
    self.icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.bg_white.transform, false, false)
    self.txt_product:SetText("[" .. dataConfig.allianceAbbr .. "]" .. Localization:GetString(buildData.name))
  elseif isFarmer and originalData == nil then
    self.txt_product:SetLocalText(buildData.name)
    self.icon:SetColorRGBA(1, 1, 1, 0.5)
    CS.UIGray.SetGray(self.bg_white.transform, true, false)
  else
    self.icon:SetColorRGBA(1, 1, 1, 1)
    CS.UIGray.SetGray(self.bg_white.transform, false, false)
    if isFarmer and buildData.rewardResourceId ~= 0 then
      self.txt_product:SetText("+" .. string.GetFormattedSeparatorNum(buildData.rewardResourceCount) .. "/h")
    elseif isFarmer then
      self.txt_product:SetLocalText(buildData.name)
    elseif dataConfig.allianceAbbr then
      self.txt_product:SetText("[" .. dataConfig.allianceAbbr .. "]")
    else
      self.txt_product:SetLocalText(buildData.name)
    end
  end
  self.text:SetText("<u>X:" .. self.cityPos.x .. " Y:" .. self.cityPos.y .. "</u>")
  self.tooltip_txt:SetLocalText(buildData.desc_2, buildData.desc_2_para)
  if dataConfig.state == 0 and dataConfig.exp ~= nil then
    local cost = toInt(buildData.cost)
    if 0 < cost then
      self.hpBar:SetActive(true)
      self.hpBar:SetValue(dataConfig.exp / cost)
    else
      self.hpBar:SetActive(false)
    end
  else
    self.hpBar:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.pos_btn.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title_root.rectTransform)
end

function UILWSeasonCityAttachmentBuildCell:Update1000MS()
  if self.tooltip_txt ~= nil and self.tooltip_tick ~= nil and self.tooltip_tick > 0 then
    self.tooltip_tick = self.tooltip_tick - 1
    if self.tooltip_tick <= 0 then
      self:HideTips()
    end
  end
end

function UILWSeasonCityAttachmentBuildCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityAttachmentOneRewardFinish, self.OnCollectResourceSuccess)
  self:AddUIListener(EventId.CityAttachmentALLRewardFinish, self.OnBatchCollectResourceSuccess)
end

function UILWSeasonCityAttachmentBuildCell:OnRemoveListener()
  self:RemoveUIListener(EventId.CityAttachmentOneRewardFinish, self.OnCollectResourceSuccess)
  self:RemoveUIListener(EventId.CityAttachmentALLRewardFinish, self.OnBatchCollectResourceSuccess)
  base.OnRemoveListener(self)
end

function UILWSeasonCityAttachmentBuildCell:OnCollectResourceSuccess(t)
  if t and t.slotIndex == self.slotId and t.cityId == self.cityId and self.popup then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    self.popup:SetActive(false)
  elseif t and t.errorCode == "season_s2_tips_004" and self.tryGetReward then
    self.popup:SetActive(false)
  end
  self.tryGetReward = nil
end

function UILWSeasonCityAttachmentBuildCell:OnBatchCollectResourceSuccess(t)
  if self.popup then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_Task_Done_Btn)
    self.popup:SetActive(false)
  end
  local allianceBuildInfo = DataCenter.SeasonFarmerManager.allianceBuildInfo
  if allianceBuildInfo and allianceBuildInfo.rewardList then
    allianceBuildInfo.rewardList = {}
  end
end

return UILWSeasonCityAttachmentBuildCell
