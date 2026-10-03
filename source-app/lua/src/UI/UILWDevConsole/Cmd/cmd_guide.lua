local cmd = {}

function cmd.Execute(arr)
  local tag = arr[2]
  if tag == "log" then
    return DataCenter.LWGuideFlowManager:DumpLog()
  elseif tag == "run" then
    local flowId = tonumber(arr[3])
    DataCenter.LWGuideFlowManager.Runner:Run(flowId)
    return nil
  elseif tag == "mask" then
    local maskHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/UI/LWGuideMask/UIGuideMask.prefab")
    maskHandle:completed("+", function()
      maskHandle.gameObject.transform:SetParent(UIManager:GetInstance().layers[UILayer.Guide.Name].transform, false)
    end)
    return nil
  elseif tag == "kill" then
    DataCenter.LWGuideFlowManager:KillRunningFlow()
    return nil
  elseif tag == "status" then
    local runningId = DataCenter.LWGuideFlowManager.Runner.runningFlowId
    local currBehaviour = DataCenter.LWGuideFlowManager.Runner:GetCurrBehaviour()
    return "Running Flow: " .. tostring(runningId) .. "\n" .. "Current Behaviour: " .. (currBehaviour and currBehaviour.name or "nil")
  end
end

function cmd.Help()
  local content = ""
  content = content .. "guide run <flow_id> \230\137\167\232\161\140\230\140\135\229\174\154\229\188\149\229\175\188\230\181\129\231\168\139\n"
  content = content .. "<flow_id> \230\181\129\231\168\139ID\239\188\140\228\189\141\228\186\142lw_guide_flow\232\161\168id\229\173\151\230\174\181\239\188\140\230\179\168\230\132\143\239\188\154\229\145\189\228\187\164\232\161\140\230\137\167\232\161\140\229\188\149\229\175\188\228\185\159\228\188\154\229\156\168\232\180\166\229\143\183\228\184\139\232\174\176\229\189\149\229\183\178\229\174\140\230\136\144\231\138\182\230\128\129\n\n"
  content = content .. "guide kill \229\188\186\229\136\182\231\187\147\230\157\159\229\189\147\229\137\141\230\137\167\232\161\140\228\184\173\231\154\132\230\181\129\231\168\139\239\188\140\229\166\130\230\158\156\229\189\147\229\137\141\230\181\129\231\168\139\230\156\170\230\137\167\232\161\140\229\136\176\229\133\179\233\148\174\230\173\165\233\170\164\239\188\140\229\188\186\229\136\182\231\187\147\230\157\159\229\144\142\228\184\141\228\188\154\232\174\176\229\189\149\229\183\178\229\174\140\230\136\144\231\138\182\230\128\129\n\n"
  content = content .. "guide log \230\137\147\229\141\176\229\188\149\229\175\188\231\179\187\231\187\159\228\184\173\232\174\176\229\189\149\231\154\132\232\191\144\232\161\140\230\151\165\229\191\151\n\n"
  return content
end

return cmd
