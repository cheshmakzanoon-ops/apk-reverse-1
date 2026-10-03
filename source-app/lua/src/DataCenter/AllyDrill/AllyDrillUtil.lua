local AllyDrillUtil = {}

function AllyDrillUtil.TryOpenDigWindow()
  if not DataCenter.AllyDrillDataManager:HasDigGame() then
    UIUtil.ShowTipsId(370100)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceBossDigGameInfo)
end

function AllyDrillUtil.TryJumpToMyAllyDrillBase()
  local stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  elseif stage == AllyDrillStage.SelectStage then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if alData.curMember < LuaEntry.DataConfig:TryGetNum("alliance_boss", "k2", 20) then
        UIUtil.ShowTipsId(2010358)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillSelect, {anim = true})
      end
    else
      UIUtil.ShowTipsId(2010348)
    end
  elseif stage == AllyDrillStage.PrepareStage then
    DataCenter.AllyDrillDataManager:JumpToDrill()
  elseif stage == AllyDrillStage.AttackStage then
    DataCenter.AllyDrillDataManager:JumpToDrill()
    DataCenter.AllyDrillDataManager:SetHasClickedAttackBtn()
  elseif stage == AllyDrillStage.ReadyStage then
    DataCenter.AllyDrillDataManager:JumpToDrill()
  elseif stage == AllyDrillStage.SettleStage then
    DataCenter.AllyDrillDataManager:JumpToDrill()
  elseif stage == AllyDrillStage.End then
    UIUtil.ShowTipsId(2010333)
  end
end

return ConstClass("AllyDrillUtil", AllyDrillUtil)
