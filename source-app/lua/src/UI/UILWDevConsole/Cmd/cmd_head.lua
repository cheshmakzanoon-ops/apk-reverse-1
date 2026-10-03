local cmd = {}

function cmd.Execute(arr)
  local tag = arr[2]
  if tag == "cache" then
    local sub = arr[3]
    if sub == "dump" then
      return CS.UIPlayerHead.DumpCache()
    end
  elseif tag == "dynamic" then
    local sub = arr[3]
    if sub == "dump" then
      return CS.UIPlayerHead.DumpDynamicAssets()
    end
  elseif tag == "collect" then
    local sub = arr[3]
    if sub == "on" then
      CS.UIPlayerHead.CollectOnlineHeadsSwitch = true
      return CS.UIPlayerHead.DumpCollections()
    elseif sub == "off" then
      CS.UIPlayerHead.CollectOnlineHeadsSwitch = false
      return CS.UIPlayerHead.DumpCollections()
    elseif sub == "dump" then
      return CS.UIPlayerHead.DumpCollections()
    end
  end
end

function cmd.Help()
  local content = ""
  content = content .. "head cache dump \230\142\167\229\136\182\229\143\176\232\190\147\229\135\186\229\189\147\229\137\141\231\188\147\229\173\152\230\149\176\230\141\174\n\n"
  content = content .. "head dynamic dump \230\142\167\229\136\182\229\143\176\232\190\147\229\135\186\229\189\147\229\137\141\229\138\168\230\128\129\232\181\132\230\186\144\231\188\147\229\173\152\230\149\176\230\141\174\n\n"
  content = content .. "head collect on \229\188\128\229\144\175\230\138\147\229\143\150\231\148\168\230\136\183\232\135\170\229\174\154\228\185\137\229\164\180\229\131\143url\229\188\128\229\133\179\239\188\136\228\187\133\233\153\144Editor\230\168\161\229\188\143\239\188\140\231\148\168\228\186\142\230\138\147\229\143\150\231\186\191\228\184\138\231\148\168\230\136\183\229\164\180\229\131\143\230\149\176\230\141\174\228\189\156\228\184\186\230\181\139\232\175\149\230\149\176\230\141\174\239\188\137\n"
  content = content .. "head collect off \229\133\179\233\151\173\230\138\147\229\143\150\231\148\168\230\136\183\232\135\170\229\174\154\228\185\137\229\164\180\229\131\143url\229\188\128\229\133\179\239\188\140\229\185\182\228\191\157\229\173\152\229\136\176Assets/playerHeadsCollection.txt\228\184\173\239\188\136\228\187\133\233\153\144Editor\230\168\161\229\188\143\239\188\140\231\148\168\228\186\142\230\138\147\229\143\150\231\186\191\228\184\138\231\148\168\230\136\183\229\164\180\229\131\143\230\149\176\230\141\174\228\189\156\228\184\186\230\181\139\232\175\149\230\149\176\230\141\174\239\188\137\n"
  content = content .. "head collect dump \230\142\167\229\136\182\229\143\176\232\190\147\229\135\186\229\189\147\229\137\141\230\138\147\229\135\186\230\149\176\230\141\174\n\n"
  return content
end

return cmd
