local LWCivilizationSparkTimelineCtrl = {}
local LWCivilizationSparkTimelineBehaviour = require("DataCenter.LWCivilizationSpark.LWCivilizationSparkTimelineBehaviour")
local TimelineConst = {
  [CiSparkTimelineType.EnterGame] = {
    resPath = "Assets/Main/Prefabs/LWCivilizationSpark/Timeline/s0_01_dagouchuxian/s0_01_dagouchuxian_timeline01.prefab",
    blockerExpireTime = 999,
    syncCamera = true,
    beforePlay = function()
      local camTrans = CS.UnityEngine.Camera.main.transform
      camTrans:Set_position(156, 85.5, 43.5)
      DataCenter.LWOpeningStageManager.utils:CivilizationSparkHideBoss()
      DataCenter.LWOpeningStageManager.squadProxy:HideLeader()
    end,
    stoppedPlay = function()
      DataCenter.LWOpeningStageManager.utils:CivilizationSparkShowBoss()
      DataCenter.LWOpeningStageManager.squadProxy:ShowLeader()
      DataCenter.LWOpeningStageManager.squadProxy:PlayAnim("idle")
      DataCenter.LWOpeningStageManager.squadProxy:SampleAnim()
      DataCenter.LWOpeningStageManager.dirtyWorks:ShowNextStageFinger()
    end
  },
  [CiSparkTimelineType.RecueMonica] = {
    resPath = "Assets/Main/Prefabs/LWCivilizationSpark/Timeline/s0_01_dagouchuxian/s0_01_monika_timeline01.prefab",
    blockerExpireTime = 999,
    syncCamera = true,
    beforePlay = function()
      DataCenter.LWOpeningStageManager.utils:CivilizationSparkHideBoss()
      DataCenter.LWOpeningStageManager.squadProxy:HideLeader()
      DataCenter.XiaoFanManager:HideBadOneDoor()
    end,
    stoppedPlay = function()
      DataCenter.LWOpeningStageManager.utils:CivilizationSparkShowBoss()
      DataCenter.LWOpeningStageManager.squadProxy:ShowLeader()
      DataCenter.LWOpeningStageManager.squadProxy:PlayAnim("idle")
      DataCenter.LWOpeningStageManager.squadProxy:SampleAnim()
      DataCenter.LWOpeningStageManager.dirtyWorks:ShowNextStageFinger()
    end
  }
}

function LWCivilizationSparkTimelineCtrl:Clear()
  if self.behaviourDict then
    for k, v in pairs(self.behaviourDict) do
      if v then
        v:OnDestroy()
      end
    end
    self.behaviourDict = nil
  end
end

function LWCivilizationSparkTimelineCtrl:PlayTimeline(timelineType, playedCallback)
  local isPlayed = DataCenter.LWCivilizationSparkManager:GetTimelineIsPlayed(timelineType)
  if isPlayed then
    if playedCallback then
      playedCallback()
    end
    return
  end
  if self.behaviourDict == nil then
    self.behaviourDict = {}
  end
  if self.behaviourDict[timelineType] then
    Logger.LogError("[LWCivilizationSparkTimelineCtrl] PlayTimeline\228\184\141\232\131\189\232\176\131\231\148\168\228\184\164\230\172\161, timelineType:" .. tostring(timelineType))
    return
  end
  local setting = TimelineConst[timelineType]
  if setting == nil then
    Logger.LogError("[LWCivilizationSparkTimelineCtrl] PlayTimeline\230\178\161\230\156\137\232\191\153\228\184\170timelineType\231\154\132\233\133\141\231\189\174, timelineType:" .. tostring(timelineType))
    return
  end
  local behaviour = LWCivilizationSparkTimelineBehaviour.New()
  behaviour:SetData(setting)
  behaviour:Begin()
  self.behaviourDict[timelineType] = behaviour
  DataCenter.LWCivilizationSparkManager:SetTimelineIsPlayed(timelineType, true)
end

return LWCivilizationSparkTimelineCtrl
