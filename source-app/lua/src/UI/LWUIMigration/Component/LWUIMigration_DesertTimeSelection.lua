local base = UIBaseContainer
local LWUIMigration_DesertTimeSelection = BaseClass("LWUIMigration_DesertTimeSelection", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshProUGUI)

function LWUIMigration_DesertTimeSelection:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigration_DesertTimeSelection:OnDestroy()
  self.onClickedCallback = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_DesertTimeSelection:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnTime0 = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnTime0:SetOnClick(function()
    self:OnBtnTime0Click()
  end)
  self.btnTime1 = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnTime1:SetOnClick(function()
    self:OnBtnTime1Click()
  end)
  self.btnTime2 = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnTime2:SetOnClick(function()
    self:OnBtnTime2Click()
  end)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textTmpTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnUtc = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnUtc:SetOnClick(function()
    self:OnBtnUtcClick()
  end)
  self.isUtcTime = false
  self:InitSelections()
end

function LWUIMigration_DesertTimeSelection:ComponentDestroy()
  self.viewSkin = nil
  self.btnTime0 = nil
  self.btnTime1 = nil
  self.btnTime2 = nil
  self.btnDetail = nil
  self.textTmpTime = nil
  self.btnUtc = nil
end

function LWUIMigration_DesertTimeSelection:DataDefine()
end

function LWUIMigration_DesertTimeSelection:DataDestroy()
end

function LWUIMigration_DesertTimeSelection:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_DesertTimeSelection:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIMigration_DesertTimeSelection:Init(args)
  self.daddySelections = args.defaultDesertTime or 7
  self.onClickedCallback = args.onClickedCallback
  self.isUtcTime = args.showServerTime
  self:RefreshSelections()
end

function LWUIMigration_DesertTimeSelection:Refresh(desertTime)
  self.daddySelections = desertTime
  self:RefreshSelections()
end

function LWUIMigration_DesertTimeSelection:InitSelections()
  self.selections = {}
  local times = BattleFieldUtil.GetDesertOpenTime()
  local btn = {
    self.btnTime0,
    self.btnTime1,
    self.btnTime2
  }
  for i = 1, 3 do
    local time = times[i] or {0, 0}
    local utcStart = UITimeManager:GetInstance():GetTimeFromServerToHHMMSS(time[1])
    local utcEnd = UITimeManager:GetInstance():GetTimeFromServerToHHMMSS(time[2])
    local localStart = UITimeManager:GetInstance():GetTimeFromServerToHHMMSS(time[1], true)
    local localEnd = UITimeManager:GetInstance():GetTimeFromServerToHHMMSS(time[2], true)
    table.insert(self.selections, {
      index = i,
      utcMs = string.format("%s-%s", utcStart, utcEnd),
      localMs = string.format("%s-%s", localStart, localEnd),
      icon = btn[i].transform:Find("ImgSelection").gameObject,
      tmp = btn[i].transform:Find("TmpTime"):GetComponent(UnityTextMeshPro)
    })
  end
  self.daddySelections = 0
end

function LWUIMigration_DesertTimeSelection:ClickedTime(index)
  local selection = self.selections and self.selections[index]
  if not selection then
    return
  end
  local tempSelection = self.daddySelections
  if tempSelection & 1 << index - 1 ~= 0 then
    tempSelection = tempSelection & ~(1 << index - 1)
  else
    tempSelection = tempSelection | 1 << index - 1
  end
  if self.onClickedCallback then
    self.onClickedCallback(tempSelection)
  else
    self.daddySelections = tempSelection
    self:RefreshSelections()
  end
end

function LWUIMigration_DesertTimeSelection:OnBtnTime0Click()
  self:ClickedTime(1)
end

function LWUIMigration_DesertTimeSelection:OnBtnTime1Click()
  self:ClickedTime(2)
end

function LWUIMigration_DesertTimeSelection:OnBtnTime2Click()
  self:ClickedTime(3)
end

function LWUIMigration_DesertTimeSelection:OnBtnDetailClick()
  UIUtil.ShowTipsId("migration_activity_recommend_desc_1009")
end

function LWUIMigration_DesertTimeSelection:OnBtnUtcClick()
  self.isUtcTime = not self.isUtcTime
  self:RefreshSelections()
end

function LWUIMigration_DesertTimeSelection:RefreshSelections()
  for k, v in ipairs(self.selections) do
    local index = v.index
    local icon = v.icon
    local tmp = v.tmp
    icon:SetActive(self.daddySelections & 1 << index - 1 ~= 0)
    tmp:SetText(self.isUtcTime and v.utcMs or v.localMs)
  end
  local lb = Localization:GetString("migration_activity_recommend_limit10_1004")
  local sv = Localization:GetString(self.isUtcTime and "activity_clock_serverTime" or "activity_clock_localTime")
  self.textTmpTime:SetText(string.format("%s(%s)", lb, sv))
end

function LWUIMigration_DesertTimeSelection:ShowServerTime()
  return self.isUtcTime
end

return LWUIMigration_DesertTimeSelection
