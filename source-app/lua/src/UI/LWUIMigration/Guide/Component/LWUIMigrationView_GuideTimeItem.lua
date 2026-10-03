local LWUIMigrationView_GuideTimeItem = BaseClass("LWUIMigrationView_GuideTimeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local text_time_path = "TimeText"
local text_state_path = "State/StateText"
local btn_info_path = "State"
local info_path = "State/Icon"

function LWUIMigrationView_GuideTimeItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.text_time = self:AddComponent(UIText, text_time_path)
  self.text_state = self:AddComponent(UIText, text_state_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(BindCallback(self, self.OnClickInfo))
  self.info = self:AddComponent(UIBaseComponent, info_path)
end

function LWUIMigrationView_GuideTimeItem:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationView_GuideTimeItem:OnClickInfo()
  if self.infoState == 1 then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local strTip = Localization:GetString("migration_activity_tips_20035")
    UIUtil.ShowBubbleTips(strTip, self.info.transform.position, 0, -30, 0, nil, nil)
  elseif self.infoState == 2 then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local strTip = Localization:GetString("migration_activity_tips_20036")
    UIUtil.ShowBubbleTips(strTip, self.info.transform.position, 0, -30, 0, nil, nil)
  end
end

function LWUIMigrationView_GuideTimeItem:SetData(info, isLocalTime, idx, curIdx)
  local bMy = idx == curIdx
  self.bg:SetActive(bMy)
  local mgr = UITimeManager:GetInstance()
  local sDate, eDate
  if isLocalTime then
    sDate = mgr:TimeStampToLocalDate(info.sTime)
    eDate = mgr:TimeStampToLocalDate(info.eTime)
  else
    sDate = mgr:TimeStampToServerDate(info.sTime)
    eDate = mgr:TimeStampToServerDate(info.eTime)
  end
  self.text_time:SetText(string.format("%0d/%0d %0d:%02d:%02d ~ %0d/%0d %0d:%02d:%02d", sDate.month, sDate.day, sDate.hour, sDate.min, sDate.sec, eDate.month, eDate.day, eDate.hour, eDate.min, eDate.sec))
  local str = DataCenter.ActMigrationManager:GetStageText(info.state)
  self.text_state:SetText(str)
  local r, g, b = 35, 34, 42
  if info.state == ActMigrationState.Apply or info.state == ActMigrationState.Migrate then
    r, g, b = 9, 155, 74
  end
  self.text_state:SetColorRGBA255(r, g, b, 255)
  local infoState = 0
  if info.state == ActMigrationState.Apply then
    infoState = 1
  elseif info.state == ActMigrationState.Migrate then
    infoState = 2
  end
  self.infoState = infoState
  self.info:SetActive(infoState ~= 0)
end

return LWUIMigrationView_GuideTimeItem
