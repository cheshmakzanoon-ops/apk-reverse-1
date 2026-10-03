local LuaEntry = {}
local PlayerInfo = require("DataCenter.Global.PlayerInfo")
local GlobalData = require("DataCenter.Global.GlobalData")
local ResourceInfo = require("DataCenter.Global.ResourceInfo")
local DataConfig = require("DataCenter.Global.DataConfig")
local EffectData = require("DataCenter.Global.EffectData")

function LuaEntry:init()
  self.Player = PlayerInfo.New()
  self.Resource = ResourceInfo.New()
  self.GlobalData = GlobalData.New()
  self.Effect = EffectData.New()
  self:LoadDataConfig()
end

function LuaEntry:Uninit()
  self:__UninitCModule()
end

local function AsyncUpdate()
  if LuaEntry.Async then
    LuaEntry.Async.Async_Update()
  end
end

function LuaEntry:__UninitCModule()
  if LuaEntry.Async then
    UpdateManager:GetInstance():RemoveUpdate(AsyncUpdate)
    LuaEntry.Async.Async_Uninit()
  end
  self.Sqlite = nil
  self.WebSocket = nil
  self.Async = nil
end

function LuaEntry:__InitCModule()
  if _G.rg_sqlite ~= nil then
    self.Sqlite = _G.rg_sqlite
  else
    return false
  end
  if _G.rg_async ~= nil then
    self.Async = _G.rg_async
    self.Async.Async_Init()
    UpdateManager:GetInstance():AddUpdate(AsyncUpdate)
  else
    return false
  end
  local luaopen_websocket = package.loadlib("xlua", "luaopen_websocket")
  if _G.rg_websocket ~= nil then
    self.WebSocket = _G.rg_websocket
  else
    return false
  end
  return true
end

function LuaEntry:onMessage(data)
  self.GlobalData:InitFromNet(data)
  self.Player = PlayerInfo.New()
  self.Player:InitFromNet(data)
  self.DataConfig:InitFromNet(data)
  if self.Effect then
    self.Effect:Destroy()
  end
  self.Effect = EffectData.New()
  self.Effect:InitFromNet(data)
  self.Resource = ResourceInfo.New()
  self.Resource:InitFromNet(data)
end

function LuaEntry:LoadDataConfig()
  self.DataConfig = DataConfig.New()
  self.DataConfig:InitFromTable()
end

return LuaEntry
