local LWZoneMobilizationStageTemplate = BaseClass("LWZoneMobilizationStageTemplate")

function LWZoneMobilizationStageTemplate:__init()
  self.id = 0
  self.remark = ""
  self.time = 0
  self.progress = 0
  self.lw_plot = 0
  self.stage_type = 0
  self.reward = 0
  self.reward_show = ""
  self.ui_donate_model_3d = ""
  self.ui_attack_model_3d = ""
  self.ui_defend_model_3d = ""
  self.stage_show = 0
end

function LWZoneMobilizationStageTemplate:__delete()
  self.id = nil
  self.remark = nil
  self.time = nil
  self.progress = nil
  self.lw_plot = nil
  self.ui_donate_model = nil
  self.ui_attack_model = nil
  self.ui_defend_model = nil
  self.stage_type = nil
  self.reward = nil
  self.reward_show = nil
  self.rewardShowDataList = nil
  self.ui_donate_model_3d = nil
  self.ui_attack_model_3d = nil
  self.ui_defend_model_3d = nil
  self.stage_show = nil
end

function LWZoneMobilizationStageTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.remark = rowData:getValue("remark") or ""
  self.time = rowData:getValue("time") or 0
  self.progress = rowData:getValue("progress") or 0
  self.lw_plot = rowData:getValue("lw_plot") or 0
  self.ui_donate_model = rowData:getValue("ui_donate_model") or ""
  self.ui_attack_model = rowData:getValue("ui_attack_model") or ""
  self.ui_defend_model = rowData:getValue("ui_defend_model") or ""
  self.stage_type = rowData:getValue("stage_type") or 0
  self.reward = rowData:getValue("reward") or 0
  self.reward_show = rowData:getValue("reward_show") or ""
  self.ui_donate_model_3d = rowData:getValue("ui_donate_model_3d") or ""
  self.ui_attack_model_3d = rowData:getValue("ui_attack_model_3d") or ""
  self.ui_defend_model_3d = rowData:getValue("ui_defend_model_3d") or ""
  self.stage_show = rowData:getValue("stage_show") or 0
end

function LWZoneMobilizationStageTemplate:GetStageRewardShowData()
  if self.rewardShowDataList == nil then
    self.rewardShowDataList = DataCenter.RewardManager:ParseRewardsStr(self.reward_show)
  end
  return self.rewardShowDataList
end

return LWZoneMobilizationStageTemplate
