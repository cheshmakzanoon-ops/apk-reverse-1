local JungleTrialHistoryItem = BaseClass("JungleTrialHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_name_path = "Txt_Title"
local common_button_path = "CommonButton"
local txt_state_path = "Txt_State"

function JungleTrialHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.common_button = self:AddComponent(UIButton, common_button_path)
  self.common_button:SetOnClick(function()
    if self.monsterData then
      GoToUtil.MoveToWorldMarchAndOpen(self.monsterData.pointId, self.monsterData.monsterUuid, self.monsterData.serverId, 0)
      GoToUtil.CloseAllWindows()
    end
  end)
  self.txt_state = self:AddComponent(UITextMeshProUGUIEx, txt_state_path)
end

function JungleTrialHistoryItem:OnDestroy()
  self.monsterData = nil
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_name = nil
  self.common_button = nil
  self.txt_state = nil
end

function JungleTrialHistoryItem:SetData(data)
  self.monsterData = data
  self.txt_des:SetLocalText("season6_piranha_activity_swallow_desc")
  if data.createTime then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.createTime, false))
  else
    self.txt_time:SetText("")
  end
  self.player_head:ParseHeadInfo(data.userInfo)
  self.txt_name:SetText(DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.userInfo.name))
  if data.isAlive then
    self.txt_state:SetActive(false)
    self.common_button:SetActive(true)
  else
    self.txt_state:SetActive(true)
    self.common_button:SetActive(false)
  end
end

function JungleTrialHistoryItem:OnBtnChomperClick()
  if self.monsterData then
    GoToUtil.MoveToWorldMarchAndOpen(self.monsterData.pointId, self.monsterData.monsterUuid, self.monsterData.serverId, 0)
  end
end

return JungleTrialHistoryItem
