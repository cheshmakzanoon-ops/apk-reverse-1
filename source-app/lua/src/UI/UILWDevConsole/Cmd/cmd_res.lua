local cmd = {}
local Localization = CS.GameEntry.Localization

local function tr(key)
  return Localization:GetString(key)
end

local function _CollectWorldPlayerBuilding()
  local _buildings = {}
  local _res_dup = {}
  local tb_player_buildings = DataCenter.DecorationTemplateManager:GetTypeDecorations(1)
  for k, v in pairs(tb_player_buildings) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    local res = template.model_world
    local is_adv = template.is_advanced
    local order = 1
    if is_adv then
      res = template.model_world_advanced
      order = 2
    end
    if res ~= nil and res ~= "" and _res_dup[res] == nil then
      _res_dup[res] = true
      table.insert(_buildings, #_buildings + 1, {
        id = v,
        res = res,
        desc = tr(template.name),
        type_desc = "\228\184\150\231\149\140\228\184\187\229\160\161",
        order = order,
        is_adv = is_adv
      })
    end
  end
  table.sort(_buildings, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    end
    return a.id < b.id
  end)
  return _buildings
end

local function _CollectWorldBuildingEffect()
  local _effects = {}
  local tb_effects = DataCenter.DecorationTemplateManager:GetTypeDecorations(4)
  for k, v in pairs(tb_effects) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    local res = template.model_world
    if res ~= nil and res ~= "" then
      table.insert(_effects, #_effects + 1, {
        id = v,
        res = res,
        desc = tr(template.name),
        type_desc = "\228\184\150\231\149\140\228\184\187\229\160\161\231\137\185\230\149\136"
      })
    end
  end
  return _effects
end

local function _CollectWorldMarchHero()
  local _heroes = {}
  local _res_dup = {}
  DataCenter.HeroTemplateManager:InitAllTemplate()
  local tb_heroes = DataCenter.HeroTemplateManager.templateDict
  for k, v in pairs(tb_heroes) do
    local tb_appearance = DataCenter.AppearanceTemplateManager:GetTemplate(v.appearance)
    if tb_appearance == nil then
      Logger.LogError("HeroTemplateManager GetTemplate lineData is nil id:" .. v.appearance)
    elseif (v.heroData_type == 1 or v.heroData_type == 2) and _res_dup[tb_appearance.world_model_path] == nil then
      _res_dup[tb_appearance.world_model_path] = true
      table.insert(_heroes, #_heroes + 1, {
        id = k,
        res = tb_appearance.world_model_path,
        desc = tr(v.name),
        type = v.heroData_type,
        type_desc = "\228\184\150\231\149\140\232\189\189\229\133\183\229\146\140\230\128\170\231\137\169",
        order = 5 - v.quality
      })
    end
  end
  table.sort(_heroes, function(a, b)
    if a.type ~= b.type then
      return a.type < b.type
    end
    if a.order ~= b.order then
      return a.order < b.order
    end
    return a.id < b.id
  end)
  return _heroes
end

local function _DumpResToCSV(res)
  local utf8_bom = "\239\187\191"
  local csv = "id,res,desc,type\n"
  for _, v in ipairs(res) do
    csv = csv .. v.id .. "," .. v.res .. "," .. v.desc .. "," .. v.type_desc .. "\n"
  end
  local path = CS.UnityEngine.Application.dataPath .. "/../res_dump.csv"
  local file = io.open(path, "w")
  if file then
    file:write(utf8_bom)
    file:write(csv)
    file:close()
    print("CSV exported to: " .. path)
  else
    print("Failed to write CSV file")
  end
end

function cmd.Execute(arr)
  local tag = arr[2]
  if tag == "dump" then
    local res = {}
    if arr[3] == nil or arr[3] == "all" then
      res = table.mergeArray(res, _CollectWorldPlayerBuilding())
      res = table.mergeArray(res, _CollectWorldBuildingEffect())
      res = table.mergeArray(res, _CollectWorldMarchHero())
    elseif arr[3] == "building" then
      res = table.mergeArray(res, _CollectWorldPlayerBuilding())
    elseif arr[3] == "effect" then
      res = table.mergeArray(res, _CollectWorldBuildingEffect())
    elseif arr[3] == "world_hero" then
      res = table.mergeArray(res, _CollectWorldMarchHero())
    end
    _DumpResToCSV(res)
  end
end

function cmd.Help()
  local content = ""
  content = content .. "res dump <tag> \232\181\132\230\186\144\229\145\189\228\187\164\n"
  content = content .. "tag: \232\181\132\230\186\144\231\177\187\229\158\139[all,building,effect,world_hero]\n"
end

return cmd
