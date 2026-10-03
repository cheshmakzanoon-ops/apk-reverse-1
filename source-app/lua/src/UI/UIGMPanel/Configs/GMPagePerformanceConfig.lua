local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")
local GMPageConfig = require("UI.UIGMPanel.Configs.GMPageConfig")
local ResourceManager = CS.GameEntry.Resource
local MessageFactory = CS.MessageFactory.Instance

local function ResourceDelayTip()
  local sb = StringBuilder.New()
  sb:AppendLine("\229\143\170\232\174\190\231\189\174\230\151\182\233\151\180\230\137\128\230\156\137prefab\229\138\160\232\189\189\233\131\189\228\188\154delay")
  sb:AppendLine("\232\174\190\231\189\174\231\137\185\229\174\154\232\183\175\229\190\132\229\144\142\229\143\170\230\156\137\232\191\153\228\186\155\232\183\175\229\190\132\231\154\132\229\138\160\232\189\189\228\188\154delay")
  sb:AppendLine("\229\141\149\228\184\170\232\183\175\229\190\132\229\134\133\229\174\185\228\184\186CopyPath\231\154\132\232\183\175\229\190\132,\229\164\154\228\184\170\232\183\175\229\190\132\231\148\168;\229\136\134\229\137\178")
  sb:AppendLine("\228\184\139\233\157\162\230\152\175\231\142\176\229\156\168delay\231\154\132\233\162\132\229\136\182\232\183\175\229\190\132:")
  local asyncDelayPathSet = ResourceManager.asyncDelayPathSet
  if asyncDelayPathSet ~= nil then
    for k, v in pairs(asyncDelayPathSet) do
      sb:AppendLine(v)
    end
  end
  UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
end

local function MsgDelayTip()
  local sb = StringBuilder.New()
  sb:AppendLine("\229\143\170\232\174\190\231\189\174\230\151\182\233\151\180\230\137\128\230\156\137\230\182\136\230\129\175\229\155\158\232\176\131\233\131\189\228\188\154delay")
  sb:AppendLine("\232\174\190\231\189\174\231\137\185\229\174\154\229\141\143\232\174\174\229\144\141\229\144\142\229\143\170\230\156\137\232\191\153\228\186\155\229\141\143\232\174\174\231\154\132\229\155\158\232\176\131\228\188\154delay")
  sb:AppendLine("\229\141\149\228\184\170\229\141\143\232\174\174\229\144\141\228\184\186MsgDefines\231\154\132value,\229\164\154\228\184\170\229\141\143\232\174\174\229\144\141\231\148\168;\229\136\134\229\137\178")
  sb:AppendLine("\228\184\139\233\157\162\230\152\175\231\142\176\229\156\168delay\231\154\132\229\141\143\232\174\174\229\144\141:")
  local asyncDelayCmdSet = MessageFactory.asyncDelayCmdSet
  if asyncDelayCmdSet ~= nil then
    for k, v in pairs(asyncDelayCmdSet) do
      sb:AppendLine(v)
    end
  end
  UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
end

local config = GMPageConfig.New("PerformanceConfig")
config.style = GMPageStyle.PageTemplate.Vertical
config.order = 200
config.label = "\230\128\167\232\131\189\230\181\139\232\175\149"
config.icon = "Assets/Main/Sprites/UI/GMPanel/gmPerformanceIcon.png"
config:Add({
  name = "\230\140\175\229\178\179\230\168\161\229\188\143",
  icon = "Assets/Main/Sprites/ItemIcons/soldier_01.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\240\159\142\181\240\159\142\181\227\128\138\229\134\141\232\167\129\227\128\139-Zhenyue")
    sb:AppendLine("\230\136\145\230\128\149\230\136\145\230\178\161\230\156\137\230\156\186\228\188\154\n\232\183\159\228\189\160\232\175\180\228\184\128\229\163\176\229\134\141\232\167\129\n\229\155\160\228\184\186\228\185\159\232\174\184(\229\176\177)\229\134\141\228\185\159\232\167\129\228\184\141\229\136\176\228\189\160\n\230\152\142\229\164\169\230\136\145\232\166\129\231\166\187\229\188\128\n\231\134\159\230\130\137\231\154\132\229\156\176\230\150\185\231\154\132\228\189\160\n\232\166\129\229\136\134\231\166\187\n\230\136\145\231\156\188\230\179\170\229\176\177\230\142\137\228\184\139\229\142\187\n\230\136\145\228\188\154\231\137\162\231\137\162\232\174\176\228\189\143\228\189\160\231\154\132\232\132\184\n\230\136\145\228\188\154\231\143\141\230\131\156\228\189\160\231\187\153\231\154\132\230\128\157\229\191\181\n\232\191\153\228\186\155\230\151\165\229\173\144\229\156\168\230\136\145\229\191\131\228\184\173\230\176\184\232\191\156\233\131\189\228\184\141\228\188\154\230\138\185\229\142\187\n\230\136\145\228\184\141\232\131\189\231\173\148\229\186\148\228\189\160\n\230\136\145\230\152\175\229\144\166\228\188\154\229\134\141\229\155\158\230\157\165\n\228\184\141\229\155\158\229\164\180\n\228\184\141\229\155\158\229\164\180\231\154\132\232\181\176\228\184\139\229\142\187\n\230\136\145\230\128\149\230\136\145\230\178\161\230\156\137\230\156\186\228\188\154\n\232\183\159\228\189\160\232\175\180\228\184\128\229\163\176\229\134\141\232\167\129\n\229\155\160\228\184\186\228\185\159\232\174\184(\229\176\177)\229\134\141\228\185\159\232\167\129\228\184\141\229\136\176\228\189\160\n\230\152\142\229\164\169\230\136\145\232\166\129\231\166\187\229\188\128\n\231\134\159\230\130\137\231\154\132\229\156\176\230\150\185\231\154\132\228\189\160\n\232\166\129\229\136\134\231\166\187\n\230\136\145\231\156\188\230\179\170\229\176\177\230\142\137\228\184\139\229\142\187\n\230\136\145\228\188\154\231\137\162\231\137\162\232\174\176\228\189\143\228\189\160\231\154\132\232\132\184\n\230\136\145\228\188\154\231\143\141\230\131\156\228\189\160\231\187\153\231\154\132\230\128\157\229\191\181\n\232\191\153\228\186\155\230\151\165\229\173\144\229\156\168\230\136\145\229\191\131\228\184\173\230\176\184\232\191\156\233\131\189\228\184\141\228\188\154\230\138\185\229\142\187\n\230\136\145\228\184\141\232\131\189\231\173\148\229\186\148\228\189\160\n\230\136\145\230\152\175\229\144\166\228\188\154\229\134\141\229\155\158\230\157\165\n\228\184\141\229\155\158\229\164\180\n\228\184\141\229\155\158\229\164\180\231\154\132\232\181\176\228\184\139\229\142\187\n\230\136\145\228\188\154\231\137\162\231\137\162\232\174\176\228\189\143\228\189\160\231\154\132\232\132\184\n\230\136\145\228\188\154\231\143\141\230\131\156\228\189\160\231\187\153\231\154\132\230\128\157\229\191\181\n\232\191\153\228\186\155\230\151\165\229\173\144\229\156\168\230\136\145\229\191\131\228\184\173\230\176\184\232\191\156\233\131\189\228\184\141\228\188\154\230\138\185\229\142\187\n\230\136\145\228\184\141\232\131\189\231\173\148\229\186\148\228\189\160\n\230\136\145\230\152\175\229\144\166\228\188\154\229\134\141\229\155\158\230\157\165\n\228\184\141\229\155\158\229\164\180\n\228\184\141\229\155\158\229\164\180\231\154\132\232\181\176\228\184\139\229\142\187\n\228\184\141\229\155\158\229\164\180\n\228\184\141\229\155\158\229\164\180\231\154\132\232\181\176\228\184\139\229\142\187")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.ZhenYueMode, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.ZhenYueMode, val)
    UIUtil.ShowTips(val and "\232\191\155\229\133\165\230\140\175\229\178\179\230\168\161\229\188\143" or "\233\128\128\229\135\186\230\140\175\229\178\179\230\168\161\229\188\143")
  end
})
config:Add({
  name = function()
    return "\232\174\190\229\164\135[" .. GameQualitySettings.GetDeviceLevel() .. "] \233\128\130\233\133\141\229\134\133\233\131\168\231\173\137\231\186\167[" .. GameQualitySettings.GetQualityByConfigLevel() .. "]"
  end,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\134\133\233\131\168\230\128\167\232\131\189\233\128\130\233\133\141\231\173\137\231\186\1671-7]")
    sb:AppendLine("[\231\148\168\230\136\183\230\128\167\232\131\189\233\128\130\233\133\141\231\173\137\231\186\1671-3]")
    sb:AppendLine("\229\134\133\233\131\168\231\173\137\231\186\167:" .. GameQualitySettings.GetQualityByConfigLevel())
    sb:AppendLine("\231\148\168\230\136\183\231\173\137\231\186\167:" .. GameQualitySettings.GetQuality())
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    local level = GameQualitySettings.GetQualityByConfigLevel() + 1
    if 7 < level then
      level = 1
    end
    GameQualitySettings.SetQualityByConfigLevel(level)
  end,
  btnName = "\229\136\135\230\141\162\231\173\137\231\186\167"
})
config:Add({
  name = function()
    return "\232\174\190\229\164\135[" .. GameQualitySettings.GetDeviceLevel() .. "] \233\128\130\233\133\141\231\173\137\231\186\167[" .. GameQualitySettings.GetQuality() .. "]"
  end,
  icon = "Assets/Main/Sprites/ItemIcons/mjc_icon_yiminjuan.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\134\133\233\131\168\230\128\167\232\131\189\233\128\130\233\133\141\231\173\137\231\186\1671-7]")
    sb:AppendLine("[\231\148\168\230\136\183\230\128\167\232\131\189\233\128\130\233\133\141\231\173\137\231\186\1671-3]")
    sb:AppendLine("\229\134\133\233\131\168\231\173\137\231\186\167:" .. GameQualitySettings.GetQualityByConfigLevel())
    sb:AppendLine("\231\148\168\230\136\183\231\173\137\231\186\167:" .. GameQualitySettings.GetQuality())
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    local level = GameQualitySettings.GetQuality() + 1
    if 3 < level then
      level = 1
    end
    GameQualitySettings.SetQuality(level)
  end,
  btnName = "\229\136\135\230\141\162\231\173\137\231\186\167"
})
config:Add({
  name = "\228\184\150\231\149\140\228\184\147\231\148\168\231\188\147\229\173\152\230\177\160",
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142\239\188\140\228\189\191\231\148\168\228\184\150\231\149\140\228\184\147\231\148\168\231\154\132\230\177\160\239\188\140\229\143\175\228\187\165\232\167\132\233\129\191active\229\146\140setparent\230\182\136\232\128\151")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    local a = CS.ClientSwitch.ENABLE_WORLD_DYNAMIC_POOL
    return CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_WORLD_DYNAMIC_POOL)
  end,
  set = function(val)
    CS.ClientSwitch.ForceSetSwitch(CS.ClientSwitch.ENABLE_WORLD_DYNAMIC_POOL, val)
    UIUtil.ShowTips(val and "\228\189\191\231\148\168\228\184\147\231\148\168\231\188\147\229\173\152\230\177\160" or "\228\189\191\231\148\168\228\188\160\231\187\159\231\188\147\229\173\152\230\177\160")
  end
})
config:Add({
  name = "\232\181\132\230\186\144\229\138\160\232\189\189delay",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_tubiao_daojishi.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = ResourceDelayTip,
  get = function()
    return ResourceManager.asyncDelayTime
  end,
  set = function(val)
    ResourceManager.asyncDelayTime = val
    UIUtil.ShowTips(string.format("\232\181\132\230\186\144\229\138\160\232\189\189delay\230\151\182\233\151\180\228\184\186:%s", val))
  end,
  contentType = 3
})
config:Add({
  name = "\232\181\132\230\186\144\229\138\160\232\189\189delay\233\162\132\229\136\182\232\183\175\229\190\132",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_tubiao_daojishi.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = ResourceDelayTip,
  get = function()
    return ResourceManager.asyncDelayPath
  end,
  set = function(val)
    ResourceManager.asyncDelayPath = val
    UIUtil.ShowTips(string.format("\232\181\132\230\186\144\229\138\160\232\189\189delay\233\162\132\229\136\182\232\183\175\229\190\132:%s", val))
  end,
  contentType = 0
})
config:Add({
  name = "\230\182\136\230\129\175\229\155\158\232\176\131delay",
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_tubiao_daojishi.png",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  tips = MsgDelayTip,
  get = function()
    return MessageFactory.asyncDelayTime
  end,
  set = function(val)
    MessageFactory.asyncDelayTime = val
    UIUtil.ShowTips(string.format("\230\182\136\230\129\175\229\155\158\232\176\131delay\230\151\182\233\151\180\228\184\186:%s", val))
  end,
  contentType = 3
})
config:Add({
  name = "\230\182\136\230\129\175\229\155\158\232\176\131delay\229\141\143\232\174\174\229\144\141",
  style = GMPageStyle.ItemTemplate.InputRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/zxl_tongyong_tubiao_daojishi.png",
  tips = MsgDelayTip,
  get = function()
    return MessageFactory.asyncDelayCmd
  end,
  set = function(val)
    MessageFactory.asyncDelayCmd = val
    UIUtil.ShowTips(string.format("\230\182\136\230\129\175\229\155\158\232\176\131delay\229\141\143\232\174\174\229\144\141:%s", val))
  end,
  contentType = 0
})
config:Add({
  name = "\230\152\175\229\144\166\229\144\175\231\148\168AudioMixer\230\168\161\229\188\143",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_zuo_5.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\136\135\230\141\162\233\159\179\233\162\145\231\174\161\231\144\134\229\153\168\230\168\161\229\188\143")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return DataCenter.LWSoundManager.useAudioMixer
  end,
  set = function(val)
    if DataCenter.LWSoundManager.useAudioMixer ~= val then
      DataCenter.LWSoundManager.useAudioMixer = val
      local lastMusic = CS.GameEntry.Sound:GetLastMusicPath()
      DataCenter.LWSoundManager:SetAudioMixerUsable(val, function()
        TimerManager:GetInstance():DelayInvoke(function()
          if lastMusic and not string.IsNullOrEmpty(lastMusic) then
            CS.GameEntry.Sound:PlayLastMusic(lastMusic)
          end
        end, 0.2)
        UIUtil.ShowTips(val and "\229\144\175\231\148\168AudioMixer\230\168\161\229\188\143" or "\229\133\179\233\151\173AudioMixer\230\168\161\229\188\143")
      end)
    end
  end,
  contentType = 0
})
config:Add({
  name = "\233\159\179\233\162\145\229\136\134\230\156\141\232\161\168\232\175\187\229\143\150\229\164\150\231\189\145\233\133\141\231\189\174",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\229\139\190\233\128\137\229\144\142lw_sound_server\232\161\168\228\184\141\228\188\154\232\175\187\229\143\150K1\231\154\132\229\134\133\231\189\145\233\133\141\231\189\174,\232\128\140\230\152\175\232\175\187\229\143\150\229\164\150\231\189\145\233\133\141\231\189\174")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return GMUtils.GetBool(GMConst.DebugUseServerSound, false)
  end,
  set = function(val)
    GMUtils.SetBool(GMConst.DebugUseServerSound, val)
    UIUtil.ShowTips(val and "\233\159\179\233\162\145\229\136\134\230\156\141\232\175\187\229\143\150\229\164\150\231\189\145\230\156\141\229\138\161\229\153\168\232\140\131\229\155\180" or "\233\159\179\233\162\145\229\136\134\230\156\141\232\175\187\229\143\150\229\134\133\231\189\145\233\133\141\231\189\174\232\140\131\229\155\180")
  end,
  contentType = 0
})
config:Add({
  name = function()
    return string.format("\229\188\128\229\133\179GPUDamageNum\229\183\178\229\188\128\229\144\175\239\188\159 : %s \232\174\190\229\164\135\230\152\175\229\144\166\230\148\175\230\140\129Instance\239\188\159: %s", DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.GPUDamageNum) and "\230\152\175" or "\229\144\166", CS.UnityEngine.SystemInfo.supportsInstancing and "\230\152\175" or "\229\144\166")
  end,
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png"
})
config:Add({
  name = "PVE\230\136\152\230\150\151\228\188\164\229\174\179\233\163\152\229\173\151",
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("[\229\137\141\231\171\175\230\181\139\232\175\149\231\148\168]")
    sb:AppendLine("\229\139\190\233\128\137\229\144\142,\230\136\152\230\150\151\229\176\134\228\189\191\231\148\1682D\231\162\176\230\146\158\230\163\128\230\181\139")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  get = function()
    return CS.BattleColliderUtils.IsCollider2D()
  end,
  set = function(val)
    CS.BattleColliderUtils.EnableCollider2D(val)
    UIUtil.ShowTips(val and "\230\136\152\230\150\151\229\176\134\228\189\191\231\148\1682D\231\162\176\230\146\158\230\163\128\230\181\139" or "\230\136\152\230\150\151\228\184\141\228\189\191\231\148\1682D\231\162\176\230\146\158\230\163\128\230\181\139")
  end
})
config:Add({
  name = "\230\163\128\230\159\165\229\189\147\229\137\141\233\159\179\233\162\145\230\177\160\228\184\173\231\138\182\230\128\129",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_zuo_5.png",
  tips = function()
  end,
  onClicked = function()
    CS.GameEntry.Sound:GetAudioSourceObjs(function(list)
      local sb = StringBuilder.New()
      for i = 0, list.Count - 1 do
        local a = list[i]
        sb:AppendLine(string.format((a.activeSelf and "<color=#000000>" or "<color=#888888>") .. "%s", a.name))
      end
      UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
    end)
  end,
  btnName = "\230\163\128\230\159\165"
})
config:Add({
  name = "\230\160\185\230\141\174\233\159\179\233\162\145\232\161\168audiosource\229\173\151\230\174\181\230\159\165\233\159\179\233\162\145",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_zuo_5.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\230\160\185\230\141\174\233\159\179\233\162\145\232\161\168audiosource\232\183\175\229\190\132\230\159\165\233\159\179\233\162\145\233\162\132\229\136\182\230\152\175\229\144\166\229\173\152\229\156\168")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    LocalController:instance():visitTable(TableName.LW_Sound, function(id, line)
      local assetName = ""
      local audioStr = line:getValue("audiosource")
      local sb = StringBuilder.New()
      sb:AppendLine("\233\148\153\232\175\175\229\166\130\228\184\139\239\188\154")
      if not string.IsNullOrEmpty(audioStr) then
        local pathArr = string.split(audioStr, ";")
        for i = 1, #pathArr do
          assetName = pathArr[i]
          if not CS.GameEntry.Resource:HasAsset(assetName) then
            local log = string.format("\230\156\170\230\137\190\229\136\176\230\150\135\228\187\182\239\188\154%s", assetName)
            sb:AppendLine(log)
            Logger.LogError(log)
          end
        end
      end
      UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
    end)
  end,
  btnName = "\230\163\128\230\159\165"
})
config:Add({
  name = "\230\160\185\230\141\174\233\159\179\233\162\145\233\162\132\229\136\182\230\159\165\232\161\168\231\154\132audiosource\229\173\151\230\174\181",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_anniu_zuo_5.png",
  tips = function()
    local sb = StringBuilder.New()
    sb:AppendLine("\230\160\185\230\141\174\233\159\179\233\162\145\233\162\132\229\136\182\228\189\147\230\159\165\232\161\168\231\154\132audiosource\232\183\175\229\190\132\230\152\175\229\144\166\229\140\133\229\144\171")
    UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
  end,
  onClicked = function()
    CS.GameEntry.Sound:GetAudioSourcePaths(function(paths)
      local sb = StringBuilder.New()
      local map = {}
      LocalController:instance():visitTable(TableName.LW_Sound, function(id, line)
        local assetName = ""
        local audioStr = line:getValue("audiosource")
        if not string.IsNullOrEmpty(audioStr) then
          local pathArr = string.split(audioStr, ";")
          for i = 1, #pathArr do
            assetName = pathArr[i]
            map[assetName] = id
          end
        end
      end)
      for i = 0, paths.Count - 1 do
        local path = paths[i]
        if not string.startswith(path, "Assets/Main/Sound/Dub/") and not string.startswith(path, "Assets/Main/Sound/Hero/") and map[path] == nil then
          local log = string.format("\233\159\179\233\162\145%s\230\156\170\229\156\168\232\161\168\228\184\173\231\154\132audiosource\229\173\151\230\174\181\230\137\190\229\136\176", path)
          Logger.LogError(log)
          sb:AppendLine(log)
        end
      end
      CS.UnityEngine.GUIUtility.systemCopyBuffer = sb:ToString()
      UIUtil.ShowDetail(sb:ToString(), nil, nil, true, true)
    end)
  end,
  btnName = "\230\163\128\230\159\165"
})
config:Add({
  name = "\230\146\173\230\148\190\230\140\135\229\174\154ID\233\159\179\230\149\1361",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local newValue = tonumber(val) or 0
    if 0 < newValue then
      DataCenter.LWSoundManager:PlaySound(newValue)
    end
  end,
  contentType = 0,
  btnName = "\230\146\173\230\148\190",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png"
})
config:Add({
  name = "\230\146\173\230\148\190\230\140\135\229\174\154ID\233\159\179\230\149\1362",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local newValue = tonumber(val) or 0
    if 0 < newValue then
      DataCenter.LWSoundManager:PlaySound(newValue)
    end
  end,
  contentType = 0,
  btnName = "\230\146\173\230\148\190",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png"
})
config:Add({
  name = "\230\146\173\230\148\190\230\140\135\229\174\154ID\233\159\179\230\149\1363",
  style = GMPageStyle.ItemTemplate.InputButtonRenderer,
  get = function()
    return 1
  end,
  set = function(val)
  end,
  onClicked = function(val)
    local newValue = tonumber(val) or 0
    if 0 < newValue then
      DataCenter.LWSoundManager:PlaySound(newValue)
    end
  end,
  contentType = 0,
  btnName = "\230\146\173\230\148\190",
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png"
})
config:Add({
  name = "\229\129\156\230\173\162\230\137\128\230\156\137\229\163\176\233\159\179",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  icon = "Assets/Main/Sprites/UI/UIMain/LWMainUINew/cfm_zhujiemian_anniu_zuo_5.png",
  tips = function()
  end,
  onClicked = function()
    DataCenter.LWSoundManager:StopAllSounds()
  end,
  btnName = "\229\129\156\230\173\162"
})
config:Add({
  name = "\230\137\167\232\161\140GC",
  icon = "Assets/Main/Sprites/UI/UISet/New/zyf_shezhi_icon_6.png",
  style = GMPageStyle.ItemTemplate.ButtonRenderer,
  tips = nil,
  onClicked = function()
    CS.GameEntry.Lua.Env:FullGc()
    CS.GameEntry.Resource:CollectGarbage()
    CS.System.GC.Collect()
    UIUtil.ShowTips("\230\137\167\232\161\140\228\184\128\230\172\161GC")
  end,
  btnName = "GC"
})
config:Add({
  name = "\229\144\175\231\148\168RawImageVideoPlayer",
  style = GMPageStyle.ItemTemplate.ToggleRenderer,
  icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/UICommon_play_icon.png",
  get = function()
    return GMUtils.GetBool(GMConst.RawImageVideoPlayer, true)
  end,
  set = function(val)
    if not val then
      UIUtil.ShowTips("\229\133\179\233\151\173RawImageVideoPlayer")
    else
      UIUtil.ShowTips("\229\144\175\231\148\168RawImageVideoPlayer")
    end
    GMUtils.SetBool(GMConst.RawImageVideoPlayer, val)
  end
})
return config
