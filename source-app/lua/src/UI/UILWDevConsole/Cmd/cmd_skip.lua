local cmd = {}

function cmd.Execute(arr)
  local tag = arr[2]
  if tag == "op" then
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuide, GuideState.CityCopter)
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuideStep, 1000)
    SFSNetwork.SendMessage(MsgDefines.LWSaveGuideStep, 1001)
    SFSNetwork.SendMessage(MsgDefines.GMUpdatePlayer)
  end
end

function cmd.Help()
  local content = ""
  content = content .. "skip op \232\183\179\232\191\135\230\150\176\230\137\139\229\133\179\229\141\161\233\152\182\230\174\181\n"
  return content
end

return cmd
