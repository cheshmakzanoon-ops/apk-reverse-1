local base = UIBaseContainer
local CampScienceCell = BaseClass("CampScienceCell", base)
local img_ScienceIcon_path = "ScienceBg/ScienceIcon"
local txt_ScienceName_path = "ScienceBg/ScienceName"
local btn_ScienceBg_path = "ScienceBg"
local go_Lock_path = "ScienceBg/Lock"
local txt_LevelText_path = "ScienceBg/LevelText"
local img_leaderRecommend_path = "ScienceBg/leaderRecommend"
local img_upgrade_path = "ScienceBg/upgrade"
local go_TimeLock_path = "ScienceBg/Lock/TimeLock"
local txt_UITime_path = "ScienceBg/Lock/TimeLock/UITime"
local img_maxText_path = "ScienceBg/maxText"
local img_specialBgFront_path = "ScienceBg/specialBgFront"
local go_vfxNode_path = "ScienceBg/vfxNode"

function CampScienceCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CampScienceCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CampScienceCell:ComponentDefine()
  self.img_ScienceIcon = self:AddComponent(UIImage, img_ScienceIcon_path)
  self.txt_ScienceName = self:AddComponent(UIText, txt_ScienceName_path)
  self.btn_ScienceBg = self:AddComponent(UIButton, btn_ScienceBg_path)
  self.go_Lock = self:AddComponent(UIBaseContainer, go_Lock_path)
  self.txt_LevelText = self:AddComponent(UIText, txt_LevelText_path)
  self.img_leaderRecommend = self:AddComponent(UIImage, img_leaderRecommend_path)
  self.img_upgrade = self:AddComponent(UIImage, img_upgrade_path)
  self.go_TimeLock = self:AddComponent(UIBaseContainer, go_TimeLock_path)
  self.txt_UITime = self:AddComponent(UIText, txt_UITime_path)
  self.img_maxText = self:AddComponent(UIImage, img_maxText_path)
  self.img_specialBgFront = self:AddComponent(UIImage, img_specialBgFront_path)
  self.go_vfxNode = self:AddComponent(UIBaseContainer, go_vfxNode_path)
  self.btn_ScienceBg:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

function CampScienceCell:ComponentDestroy()
  self.img_ScienceIcon = nil
  self.txt_ScienceName = nil
  self.btn_ScienceBg = nil
  self.go_Lock = nil
  self.txt_LevelText = nil
  self.img_leaderRecommend = nil
  self.img_upgrade = nil
  self.go_TimeLock = nil
  self.txt_UITime = nil
  self.img_maxText = nil
  self.img_specialBgFront = nil
  self.go_vfxNode = nil
end

function CampScienceCell:OnAddListener()
  self:AddUIListener(EventId.UpdateCampRecommendScience, self.UpdateCampRecommendScienceHandle)
end

function CampScienceCell:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateCampRecommendScience, self.UpdateCampRecommendScienceHandle)
end

function CampScienceCell:RefreshData(data)
  self.img_upgrade:SetActive(false)
  self.img_maxText:SetActive(false)
  self.scienceData = data
  if self.scienceData ~= nil then
    self.img_ScienceIcon:LoadSprite(self.scienceData.icon)
    self.txt_ScienceName:SetLocalText(self.scienceData.name)
    local isLock = self.scienceData.isLock
    if isLock then
      self.txt_LevelText:SetText("")
      self.go_Lock:SetActive(true)
      CS.UIGray.SetGray(self.img_ScienceIcon.transform, true, true)
      CS.UIGray.SetGray(self.btn_ScienceBg.transform, true, true)
    else
      CS.UIGray.SetGray(self.img_ScienceIcon.transform, false, true)
      CS.UIGray.SetGray(self.btn_ScienceBg.transform, false, true)
      self.go_Lock:SetActive(false)
      if self.scienceData.curLevel >= self.scienceData.maxLevel then
        self.txt_LevelText:SetText("")
      else
        self.txt_LevelText:SetColor(Color.New(1, 1, 1, 1))
        self.txt_LevelText:SetText(self.scienceData.curLevel .. "/" .. self.scienceData.maxLevel)
      end
    end
    self.go_TimeLock:SetActive(self.scienceData.isTimeLock)
    self:UpdateCampRecommendScienceHandle(DataCenter.CampScienceDataManager:GetRecommendScienceId())
    self.img_maxText:SetActive(self.scienceData.curLevel >= self.scienceData.maxLevel)
  end
  self:Update1000MS()
end

function CampScienceCell:UpdateCampRecommendScienceHandle(scienceId)
  self.img_leaderRecommend:SetActive(scienceId and self.scienceData.scienceId == scienceId)
end

function CampScienceCell:CheckIfShowRedPoint()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime < self.scienceData.finishTime then
    return false
  end
  if self.scienceData.isLock then
    return false
  end
  local userNum = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
  local maxNum = DataCenter.AllianceScienceDataManager:GetResDonateMaxCount()
  if userNum >= maxNum / 2 then
    if self.scienceData.curLevel >= self.scienceData.maxLevel then
      return false
    end
    local redScienceTb = DataCenter.AllianceScienceDataManager:GetShowRedScienceId(self.view.tab)
    if redScienceTb and table.hasvalue(redScienceTb, self.scienceData.scienceId) then
      return true
    else
      return false
    end
  end
end

function CampScienceCell:OnBtnClick()
  if self.scienceData.isTimeLock then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_camp_science_tips_8"))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICampScienceInfo, {anim = true}, self.scienceData)
end

function CampScienceCell:Update1000MS()
  if self.scienceData.isTimeLock then
    local timeStr, time = self.scienceData.config:GetTimeToLock()
    self.txt_UITime:SetText(timeStr)
    if time < 0 then
      self.scienceData.isTimeLock = false
      self:RefreshData(self.scienceData)
      if self.view ~= nil then
        self.view:RefreshView()
      end
    end
  end
end

return CampScienceCell
