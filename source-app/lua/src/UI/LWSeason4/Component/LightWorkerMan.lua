local LightWorkerMan = BaseClass("LightWorkerMan", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local select_it_path = "selectIt"
local work_num_path = "workIcon/workNum"
local power_icon_path = "powerIcon"
local power_num_path = "powerIcon/powerNum"
local desc_path = "Desc"
local info_btn_path = "InfoBtn"
local lock_btn_path = "LockBtn"

function LightWorkerMan:OnCreate()
  base.OnCreate(self)
  self.formationUuid = nil
  self.anim = self:AddComponent(UIAnimator, "")
  self.lock_btn = self:AddComponent(UIButton, lock_btn_path)
  self.selectIt = self:AddComponent(UIToggle, select_it_path)
  self.work_num = self:AddComponent(UITextMeshProUGUIEx, work_num_path)
  self.power_icon = self:AddComponent(UIImage, power_icon_path)
  self.power_num = self:AddComponent(UITextMeshProUGUIEx, power_num_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.lock_btn:SetOnClick(function()
    if self.descStr then
      UIUtil.ShowTips(self.descStr)
    end
  end)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_s4_march_ui_tips03"
    param.alignObject = self.info_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.selectIt:SetOnValueChanged(function(tf)
    if tf then
      LuaEntry.GlobalData.UseLightWorkerMan = 1
      self.anim:Play("on")
    else
      LuaEntry.GlobalData.UseLightWorkerMan = 0
      self.anim:Play("off")
    end
    if not self.startRefresh then
      self.click_uuid = self.formationUuid
    end
    if self.holder then
      self.holder:OnLightWorkerManValueChanged(tf)
    end
  end)
  self.selectIt:SetIsOn(false)
  self:RefreshUI()
end

function LightWorkerMan:OnDestroy()
  self.lock_btn = nil
  self.select_it = nil
  self.work_num = nil
  self.power_icon = nil
  self.power_num = nil
  self.desc = nil
  self.info_btn = nil
  base.OnDestroy(self)
end

function LightWorkerMan:OnAddListener()
  base.OnAddListener(self)
  if not self.AddUIListenerFinish then
    self:AddUIListener(EventId.PowerWorkerUpdated, self.RefreshUI)
    self.AddUIListenerFinish = true
  end
end

function LightWorkerMan:OnRemoveListener()
  if self.AddUIListenerFinish then
    self:RemoveUIListener(EventId.PowerWorkerUpdated, self.RefreshUI)
    self.AddUIListenerFinish = false
  end
  base.OnRemoveListener(self)
end

function LightWorkerMan:RefreshData(formationData, inMarch)
  if formationData and formationData.uuid then
    self.formationUuid = formationData.uuid
    self.ownerLightUuid = formationData.ownerLightUuid
  else
    self.formationUuid = nil
    self.ownerLightUuid = nil
  end
  self.startRefresh = false
  self.click_uuid = nil
  self.inMarch = inMarch
  self:RefreshUI()
end

function LightWorkerMan:GetIsOn()
  if self.selectIt then
    return self.selectIt:GetIsOn()
  end
  return false
end

function LightWorkerMan:RefreshUI()
  if self.lock_btn == nil then
    return
  end
  local powerWorkerDict = DataCenter.SeasonPowerWorkerManager.powerWorkerDict
  local powerWorkerCount = table.count(powerWorkerDict)
  self.startRefresh = true
  if self.inMarch then
    self.descStr = Localization:GetString("season_s3_tips011")
    self.lock_btn:SetActive(true)
    self.desc:SetActive(true)
    self.power_icon:SetActive(false)
    self.desc:SetText(self.descStr)
    self.selectIt:SetInteractable(false)
    if toInt(self.ownerLightUuid) > 0 then
      self.selectIt:SetIsOn(true)
    else
      self.selectIt:SetIsOn(false)
    end
    self.work_num:SetText(powerWorkerCount .. "/1")
    self.click_uuid = nil
    self.startRefresh = false
    return
  end
  if powerWorkerCount == 0 then
    self.descStr = Localization:GetString("season_s4_march_ui_tips01")
    self.lock_btn:SetActive(true)
    self.desc:SetActive(true)
    self.power_icon:SetActive(false)
    self.work_num:SetText("<color=#f53c3d>0</color>/1")
    self.desc:SetText(self.descStr)
    self.selectIt:SetIsOn(false)
    self.selectIt:SetInteractable(false)
    self.click_uuid = nil
  else
    local freeCount = 0
    for k, v in pairs(powerWorkerDict) do
      if v and (v.state == PowerWorkerStatus.WAIT or v.state == PowerWorkerStatus.CHARGE_SELF) then
        freeCount = freeCount + 1
      end
    end
    if 0 < freeCount then
      local workerSpeed = 1
      local cfg = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.LW_BUILD_SEASON4_POWER_STATION1, 1)
      if cfg ~= nil then
        workerSpeed = toInt(cfg.para1)
      end
      self.lock_btn:SetActive(false)
      self.selectIt:SetInteractable(true)
      self.desc:SetActive(false)
      self.power_icon:SetActive(true)
      self.work_num:SetText(freeCount .. "/1")
      self.power_num:SetText("")
      if self.click_uuid == nil then
        local checkIt = false
        if self.formationUuid then
          checkIt = Setting:GetPrivateBool("FL_" .. self.formationUuid, false)
        end
        self.selectIt:SetIsOn(checkIt)
      end
    else
      self.descStr = Localization:GetString("season_s4_march_ui_tips02")
      self.lock_btn:SetActive(true)
      self.selectIt:SetIsOn(false)
      self.selectIt:SetInteractable(false)
      self.desc:SetActive(true)
      self.power_icon:SetActive(false)
      self.work_num:SetText("<color=#f53c3d>0</color>/1")
      self.desc:SetText(self.descStr)
      self.click_uuid = nil
    end
  end
  self.startRefresh = false
end

return LightWorkerMan
