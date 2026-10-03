local UIUpgradeTreasureBoxCtrl = BaseClass("UIUpgradeTreasureBoxCtrl", UIBaseCtrl)

function UIUpgradeTreasureBoxCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUpgradeTreasureBoxView)
end

function UIUpgradeTreasureBoxCtrl:__init()
  self.curProgressIndex = 0
end

function UIUpgradeTreasureBoxCtrl:__delete()
  self.curProgressIndex = nil
end

function UIUpgradeTreasureBoxCtrl:OnClick()
  self.curProgressIndex = self.curProgressIndex + 1
end

function UIUpgradeTreasureBoxCtrl:GetCurProgressIndex()
  return self.curProgressIndex
end

function UIUpgradeTreasureBoxCtrl:ResetProgress()
  self.curProgressIndex = 0
end

function UIUpgradeTreasureBoxCtrl:GetRemainUpgradeTimes(uuid, isAuto)
  local maxTimes = DataCenter.UpgradeTreasureBoxManager:GetMaxUpgradeTimes(uuid, isAuto)
  return maxTimes - self.curProgressIndex
end

function UIUpgradeTreasureBoxCtrl:RequestGetReward(uuid)
  SFSNetwork.SendMessage(MsgDefines.ClickUpgradeBoxReward, uuid)
end

function UIUpgradeTreasureBoxCtrl:JumpToLast(uuid, isAuto)
  self.curProgressIndex = DataCenter.UpgradeTreasureBoxManager:GetMaxUpgradeTimes(uuid, isAuto)
end

function UIUpgradeTreasureBoxCtrl:OnCustomKeyCodeEscape()
end

function UIUpgradeTreasureBoxCtrl:GetViewSKinConfig(group)
  if not group then
    Logger.LogError("UIUpgradeTreasureBoxView:InitViewByConfig group is nil")
    return {}
  end
  local config = DataCenter.UpgradeTreasureBoxManager:GetAllBoxInfo(group)
  if not (config and table.count(config) ~= 0 and config[1]) or string.IsNullOrEmpty(config[1].upgradeBoxShowPara) then
    Logger.LogError("UIUpgradeTreasureBoxView:InitViewByConfig config 1 is nil or empty")
    return {}
  end
  local skinConfig = {}
  local showPara = config[1].upgradeBoxShowPara
  local paraArr = string.split(showPara, "|")
  skinConfig.Bg = paraArr[1] or ""
  skinConfig.BgMove = paraArr[2] or ""
  skinConfig.itemQuestionMask = paraArr[3] or ""
  skinConfig.success = paraArr[4] or ""
  skinConfig.fail = paraArr[5] or ""
  skinConfig.scenePath = config[1].box_effect
  return skinConfig
end

return UIUpgradeTreasureBoxCtrl
