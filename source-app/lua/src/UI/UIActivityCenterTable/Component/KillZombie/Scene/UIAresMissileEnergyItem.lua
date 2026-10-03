local UIAresMissileEnergyItem = BaseClass("UIAresMissileEnergyItem")
local progress_path = "root/Click/Progress"
local timing_text_path = "root/Click/TimingText"
local click_path = "root/Click"

local function __init(self, info, gameObject)
  self.transform = gameObject.transform
  self.gameObject = gameObject
  self:DataDefine()
  self:ComponentDefine()
  self:Refresh(info)
end

local function __delete(self)
  self:DataDestroy()
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.progress = self:AddComponent(UIImage, progress_path)
  self.progress:SetFillAmount(0)
  self.timing_text = self:AddComponent(UITextMeshProUGUIEx, timing_text_path)
  self.click = self:AddComponent(UIButton, click_path)
  self.click:SetOnClick(BindCallback(self, self.OnIconClick))
end

local function ComponentDestroy(self)
  self.progress = nil
  self.timing_text = nil
  self.click = nil
end

local function DataDefine(self)
  self.info = nil
  self.progressValue = nil
end

local function DataDestroy(self)
  self.info = nil
  self.progressValue = nil
end

local function AddComponent(self, component_target, var_arg, ...)
  assert(component_target.__ctype == ClassType.class)
  local component_inst = component_target.New(self, var_arg)
  component_inst:OnCreate(...)
  if component_inst:GetActiveInHierarchy() then
    component_inst:OnEnable()
  end
  return component_inst
end

local function Refresh(self, info)
  self.info = info
  if info then
    local fireTime = toInt(info.aosEndTime or 0) - 10000
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = fireTime - now
    self:RefreshTime(remainTime)
    local energyInfo = info.challangeNewDonate
    if energyInfo then
      local configId = energyInfo.configId
      local maxProgress = GetTableData(TableName.AdvancedChallengePlayerSkill, configId, "progress") or 0
      if 0 < maxProgress then
        local count = energyInfo.count
        local progress = count / maxProgress
        self.progressValue = progress
        self.progress:SetFillAmount(progress)
      else
        self.progress:SetFillAmount(0)
      end
      self.warningTime = tonumber(GetTableData(TableName.AdvancedChallengePlayerSkill, configId, "warning_time")) or 0
    end
  else
    self:SetActive(false)
  end
end

local function RefreshTime(self, remainTime)
  if remainTime and 0 < remainTime then
    if self.timing_text then
      local remainSec = math.floor(remainTime / 1000)
      if self.warningTime and remainSec < self.warningTime then
        if self.mark == nil or self.mark == 1 then
          self.timing_text:SetText(string.format("<color=#f53c3d>%s</color>", remainSec .. "s"))
          self.mark = 2
        else
          self.mark = 1
          self.timing_text:SetText(remainSec .. "s")
        end
      else
        self.timing_text:SetText(remainSec .. "s")
      end
    end
  else
    self:SetActive(false)
  end
end

local function SetActive(self, active)
  if self.gameObject then
    self.gameObject:SetActive(active)
  end
end

local function OnIconClick(self)
  if self.info then
    if self.info.ownerUid == LuaEntry.Player:GetUid() then
      if self.progressValue and self.progressValue >= 1 then
        SFSNetwork.SendMessage(MsgDefines.AllianceMonsterChallengeSkillUse)
      else
        UIUtil.ShowTipsId("challenge_zombie_warlord_energy_tips")
      end
    else
      UIUtil.ShowTipsId("challenge_zombie_warlord_tips")
    end
  end
end

UIAresMissileEnergyItem.__init = __init
UIAresMissileEnergyItem.__delete = __delete
UIAresMissileEnergyItem.ComponentDefine = ComponentDefine
UIAresMissileEnergyItem.ComponentDestroy = ComponentDestroy
UIAresMissileEnergyItem.DataDefine = DataDefine
UIAresMissileEnergyItem.DataDestroy = DataDestroy
UIAresMissileEnergyItem.AddComponent = AddComponent
UIAresMissileEnergyItem.Refresh = Refresh
UIAresMissileEnergyItem.SetActive = SetActive
UIAresMissileEnergyItem.RefreshTime = RefreshTime
UIAresMissileEnergyItem.OnIconClick = OnIconClick
return UIAresMissileEnergyItem
