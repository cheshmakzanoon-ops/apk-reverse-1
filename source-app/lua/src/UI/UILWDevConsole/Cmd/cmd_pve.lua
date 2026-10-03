local cmd = {}

function cmd.Execute(arr)
  local tag = arr[2]
  if tag == "jump" then
    local levelId = tonumber(arr[3])
    DataCenter.LWBattleManager:JumpLevel(levelId)
    return nil
  elseif tag == "count" then
    local param = {}
    param.type = PVEType.Count
    param.levelId = tonumber(arr[3])
    DataCenter.LWBattleManager:Enter(param)
  elseif tag == "zombie" then
    local param = {}
    param.type = PVEType.Barrage
    param.enterType = PVEEnterType.GM
    param.levelId = tonumber(arr[3])
    param.levelGroupId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), param.levelId, "group")
    DataCenter.ZombieBattleManager:Enter(param)
  elseif tag == "multiple" then
    DataCenter.MultipleParkourManager:SimulatorSingleMatch()
  elseif tag == "surfing" then
    local param = {}
    param.type = PVEType.Surfing
    param.levelId = tonumber(arr[3])
    param.enterType = PVEEnterType.GM
    DataCenter.LWBattleManager:Enter(param)
  elseif tag == "surfingData" then
    DataCenter.LWBattleManager:SetTestSurfingData(arr[3])
  elseif tag == "surfingIgnoreDec" then
    DataCenter.LWBattleManager:SetTestSurfingDeco(tonumber(arr[3]) == 1)
  elseif tag == "plane" then
    local param = {}
    param.type = PVEType.SkyBattle
    param.enterType = PVEEnterType.GM
    param.levelId = tonumber(arr[3])
    DataCenter.LWBattleManager:Enter(param)
  elseif tag == "surfingPb" then
    local param = {}
    param.type = PVEType.Surfing
    param.enterType = PVEEnterType.SurfingPlayback
    param.fileName = arr[3]
    DataCenter.LWBattleManager:Enter(param)
  elseif tag == "lastStand" then
    local param = {}
    param.type = PVEType.LastStand
    param.enterType = PVEEnterType.GM
    param.levelId = tonumber(arr[3])
    DataCenter.LWBattleManager:Enter(param)
  elseif tag == "ghostGm" then
    local param = {}
    param.type = PVEType.GhostParkour
    param.levelId = tonumber(arr[3])
    param.enterType = PVEEnterType.GM
    if #arr == 4 then
      param.lane = tonumber(arr[4])
    end
    DataCenter.LWBattleManager:Enter(param)
  elseif tag == "ghost" then
    DataCenter.LWGhostParkourDataManager:ReqFightMatch()
  elseif tag == "ghostGuide" then
    local param = {}
    param.type = PVEType.GhostParkour
    param.levelId = 70001
    param.enterType = PVEEnterType.Guide
    DataCenter.LWBattleManager:Enter(param)
  end
end

function cmd.Help()
  local content = ""
  content = content .. "pve jump <stage_id> \232\183\179\229\133\179\232\191\155\229\133\165\229\141\161\231\137\140\230\136\150\232\128\133\232\183\145\233\133\183\229\133\179\229\141\161\n"
  content = content .. "<stage_id> PVE\229\133\179\229\141\161ID\239\188\140\229\166\130\230\158\156id\229\173\152\229\156\168\232\183\145\233\133\183\229\133\179\229\141\161\229\136\153\228\188\152\229\133\136\232\191\155\229\133\165\232\183\145\233\133\183\n"
  content = content .. "pve count <stage_id> \232\191\155\229\133\165Count\229\133\179\229\141\161\n"
  content = content .. "<stage_id> Count\229\133\179\229\141\161ID\n"
  return content
end

return cmd
