local UILWDominatorCockatriceUnlockCtrl = BaseClass("UILWDominatorCockatriceUnlockCtrl", UIBaseCtrl)

function UILWDominatorCockatriceUnlockCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorCockatriceUnlock)
end

function UILWDominatorCockatriceUnlockCtrl:GotoDetectEvent(uuid)
  local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
  if data ~= nil then
    if not DataCenter.GuideManager:InGuide() then
      EventManager:GetInstance():Broadcast(EventId.ShowWorldMarchByType, NewMarchType.EXPLORE)
    end
    if data.state == DetectEventState.DETECT_EVENT_STATE_NOT_IN_WORLD then
      SFSNetwork.SendMessage(MsgDefines.DetectEventPutPointInWorld, data.uuid)
      return false
    else
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
      if template ~= nil and template.type == DetectEventType.DetectEventTypeBoss then
        local level = 1
        if not string.IsNullOrEmpty(template.c_para) then
          level = toInt(template.c_para)
        else
          local maxLevel = DataCenter.MonsterTemplateManager:GetMonsterMaxLevelbyType(LWWorldMonsterType.Boss) or 30
          level = DataCenter.SearchPanelDataManager:GetUserSearch(UISearchType.Boss, LWWorldMonsterType.Boss) or 1
          level = math.min(level, maxLevel)
        end
        DataCenter.RadarCenterDataManager:FindMonsterBoss(level)
        DataCenter.RadarCenterDataManager:TryDetectFirstGotoPlot(uuid)
        return false
      elseif template ~= nil and template.type == DetectEventType.PARKOUR_BATTLE then
        SFSNetwork.SendMessage(MsgDefines.DetectEventPveFeatureStart, uuid)
        return false
      elseif template ~= nil and template.type == DetectEventType.WANDERING_BOSS then
        SFSNetwork.SendMessage(MsgDefines.DetectEventFindRunningBoss, uuid)
        return false
      end
      DataCenter.WorldPointWaitOpenManager.byDetect = 1
      GoToUtil.MoveToWorldPointAndOpen(data.pointId, data.type, uuid)
      EventManager:GetInstance():Broadcast(EventId.GF_detect_event_goto_clicked, data.eventId)
      DataCenter.RadarCenterDataManager:TryDetectFirstGotoPlot(uuid)
      return true
    end
  else
    return true
  end
end

return UILWDominatorCockatriceUnlockCtrl
