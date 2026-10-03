local Config = Config or {}
Config.Debug = false
Config.UseAssetBundle = false

local function IsPC()
  return CS.SDKManager.IS_UNITY_STANDALONE() and not CS.SDKManager.IS_UNITY_EDITOR()
end

Config.IsPC = IsPC
return Config
