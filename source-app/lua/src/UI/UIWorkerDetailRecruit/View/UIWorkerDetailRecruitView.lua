local UIWorkerDetailRecruitView = BaseClass("UIWorkerDetailRecruitView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local effect_txt_path = "BG/effectItem/effectTxt"
local value_text_path = "BG/effectItem/ValueText"
local first_name_text_path = "BG/firstNameText"
local building_name_text_path = "BG/buildingNameText"

function UIWorkerDetailRecruitView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
  DataCenter.LWSoundManager:PlaySound(62259, false)
end

function UIWorkerDetailRecruitView:DataDefine()
  self.workerData = nil
  self.callBack = nil
end

function UIWorkerDetailRecruitView:ComponentDefine()
  self.workerIconImg = self:AddComponent(UIRawImage, "BG/workerIcon")
  self.loadingImg = self:AddComponent(UIImage, "BG/Loading")
  self.workerQualityImg = self:AddComponent(UIRawImage, "BG/QualityBg")
  self.nameText = self:AddComponent(UIText, "BG/nameText")
  self.agreeBtnText = self:AddComponent(UIText, "BG/agreeBtn/Text")
  self.agreeBtn = self:AddComponent(UIButton, "BG/agreeBtn")
  self.planeBtn = self:AddComponent(UIButton, "plane")
  self.agreeBtn:SetOnClick(function()
    if self.callBack then
      self.callBack()
    end
    self.ctrl:CloseSelf()
  end)
  self.planeBtn:SetOnClick(function()
    if self.callBack then
      self.callBack()
    end
    self.ctrl:CloseSelf()
  end)
  self.effect_txt = self:AddComponent(UITextMeshProUGUIEx, effect_txt_path)
  self.value_text = self:AddComponent(UITextMeshProUGUIEx, value_text_path)
  self.first_name_text = self:AddComponent(UITextMeshProUGUIEx, first_name_text_path)
  self.building_name_text = self:AddComponent(UITextMeshProUGUIEx, building_name_text_path)
end

function UIWorkerDetailRecruitView:ReInit()
  self.workerData, self.callBack = self:GetUserData()
  self.nameText:SetLocalText(self.workerData.lastName)
  self.first_name_text:SetLocalText(self.workerData.firstName)
  local workerText = ""
  if self.workerData.workingBuildList then
    if #self.workerData.workingBuildList > 1 then
      for i = 1, #self.workerData.workingBuildList do
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.workerData.workingBuildList[i])
        workerText = workerText .. Localization:GetString(template.name)
        if i ~= #self.workerData.workingBuildList then
          workerText = workerText .. " ; "
        end
      end
    else
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.workerData.workingBuildList[1])
      workerText = Localization:GetString(template.name)
    end
  end
  self.building_name_text:SetText(workerText)
  local imgPath = HeroUtils.GetHeroIconPath(self.workerData.modelId, HeroIconType.pose_icon_path)
  local hasAsset = UIUtil.CheckAssetDownloaded(imgPath)
  self.loadingImg:SetActive(not hasAsset)
  self.workerIconImg:LoadSpriteAuto(imgPath, function(texture)
    if not hasAsset and self and self.loadingImg then
      self.loadingImg:SetActive(false)
    end
    if self and self.workerIconImg then
      self.workerIconImg:SetNativeSize()
    end
  end)
  self.workerQualityImg:LoadSprite(self:GetQualityBgPath(self.workerData.quality))
  local describe, text = WorkerUtil.GetEffectText(tonumber(self.workerData.peculiarity), tonumber(self.workerData.peculiarityVlue), true)
  self.effect_txt:SetText(describe)
  self.value_text:SetText(text)
  self.agreeBtnText:SetLocalText(110021)
end

function UIWorkerDetailRecruitView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorkerDetailRecruitView:DataDestroy()
  self.workerData = nil
  self.callBack = nil
end

function UIWorkerDetailRecruitView:ComponentDestroy()
  self.workerIconImg = nil
  self.workerQualityImg = nil
  self.nameText = nil
  self.nameTextOutline = nil
  self.planeBtn = nil
  self.loadingImg = nil
  self.effect_txt = nil
  self.value_text = nil
  self.first_name_text = nil
  self.building_name_text = nil
end

function UIWorkerDetailRecruitView:GetQualityBgPath(quality)
  local bgName = "Mjc_xcz_new_bg_hui"
  if quality == WorkerQualityType.Legendary then
    bgName = "Mjc_xcz_new_bg_cheng"
  elseif quality == WorkerQualityType.Genius then
    bgName = "Mjc_xcz_new_bg_zi"
  elseif quality == WorkerQualityType.Outstanding then
    bgName = "Mjc_xcz_new_bg_lan"
  elseif quality == WorkerQualityType.Excellent then
    bgName = "Mjc_xcz_new_bg_lv"
  elseif quality == WorkerQualityType.Normal then
    bgName = "Mjc_xcz_new_bg_hui"
  end
  local bgPath = string.format(LoadPath.UIWorkerTexturePath, bgName)
  return bgPath
end

return UIWorkerDetailRecruitView
