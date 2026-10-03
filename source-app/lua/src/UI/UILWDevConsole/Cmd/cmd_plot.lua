local cmd = {}

function cmd.Execute(arr)
  local plot_group_id = arr[2]
  local hide_main_ui = arr[3] == "true"
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plot_group_id, hideMainUI = hide_main_ui})
  return nil
end

function cmd.Help()
  local content = ""
  content = content .. "plot <plot_group_id> <hide_main_ui> \230\146\173\230\148\190\229\137\167\230\131\133\229\175\185\232\175\157\n"
  content = content .. "<plot_group_id> \229\137\167\230\131\133\231\187\132ID\239\188\140\228\189\141\228\186\142lw_plot\232\161\168id\229\173\151\230\174\181\231\154\132\229\137\141\229\155\155\228\189\141\n"
  content = content .. "<hide_main_ui> \230\152\175\229\144\166\233\154\144\232\151\143\228\184\187\231\149\140\233\157\162\239\188\140true or false\n"
  return content
end

return cmd
