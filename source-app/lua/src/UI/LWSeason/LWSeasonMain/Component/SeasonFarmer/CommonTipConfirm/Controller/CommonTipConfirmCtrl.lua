local CommonTipConfirmCtrl = BaseClass("CommonTipConfirmCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function CommonTipConfirmCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.CommonTipConfirm)
end

function CommonTipConfirmCtrl:GetPanelData(panelType)
  local result
  if panelType == CommonTipConfirmType.SeasonFarmerRewardTip then
    result = {}
    result.title = Localization:GetString("season_builders_alliance_UI_43")
    result.btnText = Localization:GetString("season_builders_alliance_UI_21")
    result.tipDataList = {}
    local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    local ele = string.split(mainCfg.warning_personal_dec, "|")
    for i, v in ipairs(ele) do
      table.insert(result.tipDataList, Localization:GetString(v))
    end
  end
  return result
end

return CommonTipConfirmCtrl
