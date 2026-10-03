local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local config = GMPageConfig.New("ParkourDebug")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 11
config.label = "\229\128\141\229\162\158\233\151\168"
config.icon = "Assets/Main/Sprites/UI/UIBuildBubble/zyf_zhujiemian_logo_qipao_icon.png"

local function _getImmediateToggle()
  local ret = DataCenter.FunctionOnManager:DumpServerSwitchOn()
  return ret
end

config:Add({
  name = "\230\159\165\231\156\139immediate_toggle\228\191\161\230\129\175",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_common_anniu_jilu.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local str = _getImmediateToggle()
    UIUtil.ShowDetail(str, nil, nil, true, true)
  end,
  onClicked = function()
    UIUtil.ShowTips("\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\232\180\180\230\157\191")
    CommonUtil.CopyTextToClipboard(_getImmediateToggle())
  end,
  btnName = "\229\164\141\229\136\182"
})
config:Add({
  name = "\230\154\130\229\129\156/\230\129\162\229\164\141\230\136\152\230\150\151",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon04.png",
  get = function()
    return DataCenter.LWBattleManager.gamePause
  end,
  set = function(val)
    if not DataCenter.LWBattleManager:IsBattleFinish() then
      DataCenter.LWBattleManager:SetGamePause(val)
    else
      UIUtil.ShowTips("\228\187\133\229\156\168\230\136\152\230\150\151\228\184\173\231\148\159\230\149\136")
    end
  end
})
config:Add({
  name = "\232\174\190\231\189\174\229\176\143\229\133\181\230\149\176\233\135\143",
  icon = "Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_tank.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  get = function()
    local num = 0
    if DataCenter.LWBattleManager.logic and DataCenter.LWBattleManager.logic.team and DataCenter.LWBattleManager.logic.team.teamUnitCount then
      num = DataCenter.LWBattleManager.logic.team.teamUnitCount
    end
    return num
  end,
  set = function(val)
    local logic = DataCenter.LWBattleManager.logic
    if logic and logic.team then
      local nowNum = logic.team.teamUnitCount or 0
      val = tonumber(val)
      if nowNum > val then
        for i = val + 1, nowNum do
          local last = logic.team:GetLastUnit()
          last:Die()
        end
      else
        for i = nowNum + 1, val do
          logic.team:AddMember(10010)
        end
      end
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end
})
config:Add({
  name = "\233\135\141\233\154\143\229\138\168\230\128\129\229\184\131\233\152\181",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengjijie_refresh.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    UIUtil.ShowTips("\233\154\143\229\136\176\230\187\161\230\132\143\231\154\132\228\186\134\228\185\136")
  end,
  onClicked = function()
    local logic = DataCenter.LWBattleManager.logic
    if logic and logic.team then
      local num = #logic.team.teamUnits
      for i = num, 2, -1 do
        logic.team.teamUnits[i]:Die()
      end
      logic.team.formation:ReGenDynamicPos()
      for i = 2, num do
        logic.team:AddMember(10010)
      end
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  btnName = "\233\135\141\231\189\174"
})

local function save_points(tbl, filename)
  local f = assert(io.open(filename, "w"))
  f:write("return {\n")
  for _, arr in ipairs(tbl) do
    f:write("    {")
    for i, v in ipairs(arr) do
      f:write(v)
      if i < #arr then
        f:write(", ")
      end
    end
    f:write("},\n")
  end
  f:write("}\n")
  f:close()
end

config:Add({
  name = "\228\191\157\229\173\152\229\138\168\230\128\129\229\184\131\233\152\181",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengjijie_refresh.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    UIUtil.ShowTips("\233\154\143\229\136\176\230\187\161\230\132\143\231\154\132\228\186\134\228\185\136")
  end,
  onClicked = function()
    local logic = DataCenter.LWBattleManager.logic
    if logic and logic.team and logic.team.formation then
      local genConfig = logic.team.formation.genConfig
      if genConfig then
        save_points(genConfig, "Assets/Main/LuaScripts/Scene/LWBattle/ParkourBattle/Team/ParkourDynamicTeamPos.lua")
      end
    end
    Logger.LogError("\228\191\157\229\173\152\229\136\176\228\186\134Assets/Main/LuaScripts/Scene/LWBattle/ParkourBattle/Team/ParkourDynamicTeamPos.lua")
    UIUtil.ShowTips("\228\191\157\229\173\152\230\136\144\229\138\159")
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  btnName = "\228\191\157\229\173\152"
})
config:Add({
  name = "\230\155\191\230\141\162\229\188\128\231\129\171\231\137\185\230\149\136\232\183\175\229\190\132",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  contentType = 0,
  tips = function()
    local replacedPath = GMUtils.GetString(GMConst.ReplaceWorldShotEffPath, "")
    if replacedPath == "" then
      UIUtil.ShowTips(string.format("\228\187\128\228\185\136\233\131\189\230\178\161\233\133\141\228\189\160\231\130\185\230\136\145\228\189\156\231\148\154\239\188\159\229\134\141\231\130\185\230\136\145\230\136\145\229\176\177\229\143\171\228\186\134\229\149\138\239\188\129"))
      return
    end
    local sb = StringBuilder.New()
    sb:AppendLineFormat("\232\183\175\229\190\132\229\144\142\231\154\132\232\183\175\229\190\132:%s", replacedPath)
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    local replacedPath = GMUtils.GetString(GMConst.ReplaceWorldShotEffPath, "")
    return replacedPath
  end,
  set = function(val)
    if val == "" then
      local replacedPath = GMUtils.SetString(GMConst.ReplaceWorldShotEffPath, "")
      return
    end
    if not CS.GameEntry.Resource:PrefabAssetsDownloaded(val) then
      UIUtil.ShowTips("\232\174\190\231\189\174\229\164\177\232\180\165\239\188\140\230\137\190\228\184\141\229\136\176\232\181\132\230\186\144")
      return
    end
    GMUtils.SetString(GMConst.ReplaceWorldShotEffPath, val)
    UIUtil.ShowTips("\230\155\191\230\141\162\230\136\144\229\138\159\229\150\189")
  end,
  icon = "Assets/Main/Sprites/ItemIcons/lrb_chunjiedafuweng_paodan.png"
})
config:Add({
  name = "\230\160\185\230\141\174id\232\191\155\229\133\165PVE\229\133\179\229\141\161",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 101
  end,
  set = function(val)
  end,
  onClicked = function(val)
    DataCenter.LWBattleManager:JumpLevel(val)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  contentType = 0,
  btnName = "\232\191\155\229\133\165\229\133\179\229\141\161",
  icon = "Assets/Main/Sprites/UI/UIPveLoading/UIPveLoading_img01.png"
})
config:Add({
  name = "\232\176\131\232\175\149\230\181\183\230\176\180\231\154\132\233\162\156\232\137\178\233\165\177\229\146\140\229\186\166",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return -1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local num = tonumber(val)
    if num == nil or num < 0 or 1 < num then
      UIUtil.ShowTips("\229\128\188\229\191\133\233\161\187\229\156\1680-1\228\185\139\233\151\180")
      return
    end
    val = num
    DataCenter.LWBattleManager:TestSetWaterFresnelValue(val)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  contentType = 0,
  btnName = "\232\174\190\231\189\174",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengjijie_refresh.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\231\148\168\230\157\165\228\191\174\230\148\185\229\184\166\230\156\137\230\181\183\230\176\180\229\133\179\229\141\161\231\154\132\230\181\183\230\176\180\233\162\156\232\137\178\233\165\177\229\146\140\229\186\166")
    sb:AppendLine("\229\128\188\231\154\132\232\140\131\229\155\180\230\152\1750-1\239\188\140\229\128\188\232\182\138\229\164\167\230\176\180\232\182\138\230\154\151")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end
})
config:Add({
  name = "\232\176\131\232\175\149\230\137\147\233\163\158\230\156\186\233\149\156\229\164\180\231\188\147\229\138\168\229\143\130\230\149\176",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    local param = string.format("%d:%.4f", DataCenter.LWBattleManager.cameraMoveType, DataCenter.LWBattleManager.cameraMoveFactor)
    return param
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local paramStrs = string.split(val, ":")
    local type = paramStrs[1] and tonumber(paramStrs[1]) or 0
    DataCenter.LWBattleManager:SetTestCameraMoveType(type)
    local factorValue = paramStrs[2] and tonumber(paramStrs[2]) or 1
    DataCenter.LWBattleManager:SetTestCameraMoveFactor(factorValue)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
  end,
  contentType = 0,
  btnName = "\232\174\190\231\189\174",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengjijie_refresh.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\143\130\230\149\176\231\148\168:\229\136\134\229\137\178,\229\143\130\230\149\1761\232\161\168\230\152\142\233\149\156\229\164\180\231\167\187\229\138\168\231\177\187\229\158\139\239\188\1361:\229\188\185\230\128\167\231\188\147\229\138\168,2:\233\157\158\229\188\185\230\128\167\231\188\147\229\138\168\239\188\137")
    sb:AppendLine("\229\143\130\230\149\1762\232\161\168\230\152\142\233\149\156\229\164\180\229\143\130\230\149\176\239\188\136\231\177\187\229\158\139\228\184\1861:\229\128\188\232\182\138\229\176\143\233\149\156\229\164\180\229\147\141\229\186\148\232\182\138\232\191\133\233\128\159(0.5\229\143\130\232\128\131\229\128\188),\231\177\187\229\158\139\228\184\1862:\229\128\188\232\182\138\229\176\143,\233\149\156\229\164\180\229\147\141\229\186\148\232\182\138\230\133\162(0.1\229\143\130\232\128\131\229\128\188)\239\188\137")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end
})
config:Add({
  name = function()
    return string.format("\229\189\147\229\137\141ABTest\231\154\132\229\128\188: %s \230\173\166\232\163\133\229\141\135\231\186\167\230\160\135\229\191\151\229\128\188: %s \229\155\189\229\174\182\228\191\161\230\129\175: %s  \228\191\174\230\148\185\230\149\176\230\141\174\230\160\135\232\174\176: %s", LuaEntry.Player.monopoly_ab, LuaEntry.Player.armed_upgrade_tag, LuaEntry.Player.country, LuaEntry.Player.armed_upgrade_repair)
  end,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_lianmengjijie_refresh.png"
})
config:Add({
  name = "\232\189\172\230\141\162pve\230\136\170\229\155\190",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_shengji_jiantou_3.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  onClicked = function()
    CS.CSUtils.LoadPveShotTex()
  end,
  btnName = "\232\189\172\230\141\162"
})
config:Add({
  name = "\230\137\147\229\188\128/\229\133\179\233\151\173Vector3PoolLog",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon04.png",
  get = function()
    return Vector3.GetOpenPoolLog()
  end,
  set = function(val)
    Vector3.SetOpenPoolLog(val)
  end
})
return config
