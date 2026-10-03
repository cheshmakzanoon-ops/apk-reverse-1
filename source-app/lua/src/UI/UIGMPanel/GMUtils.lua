local GMUtils = {}
local CSGMSwitch = CS.GMSwitch
GMUtils.GMManager = nil

function GMUtils.Log(fmt, ...)
  if not CommonUtil.IsDebug() then
    return
  end
  local _ = string.format(fmt, ...)
  _ = string.format("<color=#FFFF00>[GM][Log]%s</color>", _)
  Logger.Log(_)
end

function GMUtils.LogError(fmt, ...)
  local _ = string.format(fmt, ...)
  _ = "[GM][Error]" .. _
  Logger.LogError(_)
end

function GMUtils.GetBarItemByName(name)
  local _ = GMConfig.Bars[name]
  if not _ then
    Logger.LogError(string.format("\232\142\183\229\143\150GmBarItem:%s\229\164\177\232\180\165\229\150\189~", name))
  else
    _.name = name
  end
  return _
end

local _pages

function GMUtils.GetPages()
  if not _pages then
    _pages = {}
    for k, v in pairs(GMConfig.Pages) do
      v.pageName = k
      table.insert(_pages, v)
    end
    table.sort(_pages, function(a, b)
      local sortA = a and a.order or 0
      local sortB = b and b.order or 0
      return sortA > sortB
    end)
  end
  return _pages
end

local GMPageStyle = require("UI.UIGMPanel.Configs.GMPageStyle")

function GMUtils.GetPageStyles()
  return GMPageStyle.PageTemplate
end

function GMUtils.GetPageItem(pageName, itemName)
  local page = GMConfig.Pages[pageName]
  if not page then
    return
  end
  return page:Get(itemName)
end

function GMUtils.GetPageItems(pageData)
  local items = {}
  if not GMUtils.GMManager then
    return items
  end
  if pageData.isFavorite then
    local favs = GMUtils.GMManager:GetFavorites()
    for k, v in ipairs(favs) do
      if v and v.page and v.name then
        local item = GMUtils.GetPageItem(v.page, v.name)
        if item then
          if item.isVisible ~= nil and type(item.isVisible) == "function" then
            if item.isVisible() then
              table.insert(items, item)
            end
          else
            table.insert(items, item)
          end
        end
      end
    end
  elseif pageData and pageData.items then
    for k, v in ipairs(pageData.items) do
      if v then
        if not v.pageName then
          v.pageName = pageData.pageName
        end
        if v.isVisible ~= nil then
          if v.isVisible() then
            table.insert(items, v)
          end
        else
          table.insert(items, v)
        end
      end
    end
  end
  return items
end

function GMUtils.Close()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMPanel)
end

function GMUtils.Open(defaultPage)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGMPanel, {anim = true}, {default = defaultPage})
end

function GMUtils.IsGM()
  if GMUtils.GMManager then
    return GMUtils.GMManager:IsGM()
  end
  return false
end

function GMUtils.GetBool(name, default)
  if GMUtils.GMManager then
    return GMUtils.GMManager:GetBool(name, default)
  end
  return default
end

function GMUtils.SetBool(name, val)
  if GMUtils.GMManager then
    GMUtils.GMManager:SetBool(name, val)
  end
end

function GMUtils.GetInt(name, default)
  if GMUtils.GMManager then
    return GMUtils.GMManager:GetInt(name, default)
  end
  return default
end

function GMUtils.SetInt(name, val)
  if GMUtils.GMManager then
    GMUtils.GMManager:SetInt(name, val)
  end
end

function GMUtils.GetString(name, default)
  if GMUtils.GMManager then
    return GMUtils.GMManager:GetString(name, default)
  end
  return default
end

function GMUtils.SetString(name, val)
  if GMUtils.GMManager then
    GMUtils.GMManager:SetString(name, val)
  end
end

function GMUtils.SetBoolToCS(name, val)
  CSGMSwitch.LuaSetBool(name, val)
end

function GMUtils.SetIntToCS(name, val)
  CSGMSwitch.LuaSetInt(name, val)
end

function GMUtils.GetLogCount()
  if GMUtils.GMManager then
    return GMUtils.GMManager.warningCount, GMUtils.GMManager.errorCount
  end
  return 0, 0
end

function GMUtils.ClearDebugLog()
  CSGMSwitch.ClearDebugLog()
  if GMUtils.GMManager then
    GMUtils.GMManager:UpdateLogCount(0, 0)
  end
end

function GMUtils.GetDebugLogQueue()
  return CSGMSwitch.DebugLogQueue
end

local worldInfo = {}
worldInfo.init = false

function GMUtils.GetWorldInfo()
  return worldInfo
end

function GMUtils.UpdateLogCount(warning, error)
  if GMUtils.GMManager then
    GMUtils.GMManager:UpdateLogCount(warning, error)
  end
end

local _randomSkinIds

function GMUtils.SetRandomBuildSkins()
  if not _randomSkinIds then
    local templates = DataCenter.DecorationTemplateManager:GetTypeDecorations(DecorationType.DecorationType_Main_City)
    if templates then
      _randomSkinIds = true
      local list = CS.System.Collections.Generic.List(CS.System.Int32)()
      for _, v in pairs(templates) do
        list:Add(v)
      end
      CSGMSwitch.LuaSetObject("RandomSkinIds", list)
    end
  end
end

function GMUtils.CheckLogin()
  local uid = LuaEntry.Player:GetUid()
  return not string.IsNullOrEmpty(uid)
end

function GMUtils.AddHappy(happyGetter)
  if not GMUtils.IsGM() then
    return
  end
  if not GMUtils.GetBool(GMConst.ShowHappyWatcher, false) then
    return
  end
  if type(happyGetter) ~= "function" then
    return
  end
  return GMUtils.GMManager:AddHappy(happyGetter)
end

function GMUtils.DelHappy(key)
  if not GMUtils.IsGM() then
    return
  end
  if not key then
    return
  end
  GMUtils.GMManager:DelHappy(key)
end

local normalSkin = {}
normalSkin.icon = "Assets/Main/Sprites/UI/LWCommon/Sprite/dl_zhujiemian_chuzheng_yingxiong.png"
normalSkin.panelBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/ljq_tongyong_erjiyeqian_anniu.png"
normalSkin.panelBtnBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_jindutiao_lan.png"
normalSkin.barBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_5.png"
normalSkin.btnBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png"
local girlSkin = {}
girlSkin.icon = "Assets/Main/Sprites/UI/GMPanel/gmIcon1.png"
girlSkin.panelBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"
girlSkin.panelBtnBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"
girlSkin.barBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_tongyong_jindutiao_hong.png"
girlSkin.btnBg = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png"

function GMUtils.GetSkinPath()
  local skinChanged = GMUtils.GetBool(GMConst.GirlMode, false)
  if skinChanged then
    return girlSkin
  end
  return normalSkin
end

return GMUtils
