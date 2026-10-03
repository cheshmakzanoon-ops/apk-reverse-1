local T11SoldierSelectCtrl = BaseClass("T11SoldierSelectCtrl", UIBaseCtrl)

function T11SoldierSelectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11SoldierSelect)
end

function T11SoldierSelectCtrl:GetAllSkillsInfo(soldierType)
  local stageList = DataCenter.T11DataManager.curT11LevelData.stageData:GetStageList()
  local initStage = T11Util.GetT11InitialStage()
  local otherStage = {}
  for _, v in pairs(stageList) do
    if v ~= initStage then
      table.insert(otherStage, v)
    end
  end
  local initSkillInfo = T11Util.GetSkillInfoByStage(initStage, soldierType)
  local otherSkillInoList = {}
  for _, v in pairs(otherStage) do
    local skillInfo = T11Util.GetSkillInfoByStage(v, soldierType)
    if skillInfo then
      table.insert(otherSkillInoList, skillInfo)
    end
  end
  return {initSkillInfo = initSkillInfo, otherSkillInoList = otherSkillInoList}
end

return T11SoldierSelectCtrl
