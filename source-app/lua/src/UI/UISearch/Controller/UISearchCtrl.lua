local UISearchCtrl = BaseClass("UISearchCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISearch, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function GetCurChangeByTotal(self, curNum, maxNum, isAdd)
  local changeNum = 0
  if isAdd then
    if curNum < maxNum then
      changeNum = curNum + 1
    else
      changeNum = curNum
    end
  elseif 0 < curNum then
    changeNum = curNum - 1
  else
    changeNum = curNum
  end
  return changeNum
end

local function InitData(self)
  self.maxArr = {
    30,
    10,
    10,
    10
  }
  self.curCnt = {}
end

local function OnSearchClick(self, type, ...)
  local pos = LuaEntry.Player:GetMainWorldPos()
  local level = self:GetCurNumBySearchType(type, ...)
  local subType = 0
  if type == UISearchType.Monster then
    local pointId = pos
    subType = select(1, ...)
    SFSNetwork.SendMessage(MsgDefines.FindMonster, pointId, level, false, nil, subType)
  elseif type == UISearchType.Boss then
    subType = select(1, ...)
    SFSNetwork.SendMessage(MsgDefines.FindMonsterBoss, level)
  elseif type == UISearchType.Resource then
    subType = select(1, ...)
    SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, subType, level)
  elseif type == UISearchType.WorldDesert then
    subType = select(1, ...)
    if subType == LWWorldMonsterType.ResObsidian then
      SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.OBSIDIAN, level)
    elseif subType == LWWorldMonsterType.ResFlint then
      SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.FLINT, level)
    end
    GoToUtil.CloseAllWindows()
  end
  DataCenter.SearchPanelDataManager:RecordUserSearch(type, subType, level)
end

local function OnSearchEnd(self, pointId, uuid)
  GoToUtil.MoveToWorldMarchAndOpen(pointId, uuid, LuaEntry.Player:GetSelfServerId(), 0)
  self:CloseSelf()
end

local function GetMaxNumBySearchType(self, type, subType)
  local count = 1
  if type == UISearchType.Monster then
    count = DataCenter.MonsterTemplateManager:GetMonsterMaxLevelbyType(subType)
    count = math.min(self:GetCurMaxCanAttackLevel(type), count)
  elseif type == UISearchType.Boss then
    count = DataCenter.MonsterTemplateManager:GetMonsterMaxLevelbyType(LWWorldMonsterType.Boss)
  elseif type == UISearchType.Resource then
    count = DataCenter.GatherResourceTemplateManager:GetMaxLevelbyType(subType)
  elseif type == UISearchType.WorldDesert then
    count = DataCenter.DesertTemplateManager:GetDesertMaxLevel()
  elseif self.maxArr[type] ~= nil and self.maxArr[type] ~= 0 then
    count = self.maxArr[type]
  end
  return count
end

local function GetCurMaxCanAttackLevel(self, type)
  if type == UISearchType.Monster then
    return DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
  elseif type == UISearchType.Boss then
    return DataCenter.MonsterManager:GetCurCanAttackBossMaxLevel()
  end
end

local function SetCurNumBySearchType(self, type, num, subType)
  DataCenter.SearchPanelDataManager:RecordUserSearch(type, subType, num)
end

local function GetCurNumBySearchType(self, type, subType)
  local value = DataCenter.SearchPanelDataManager:GetUserSearch(type, subType)
  if not value then
    if type == UISearchType.Boss or type == UISearchType.WorldDesert then
      self:SetCurNumBySearchType(type, 1, subType)
      value = 1
    else
      local maxNum = self:GetMaxNumBySearchType(type, subType)
      self:SetCurNumBySearchType(type, maxNum, subType)
      value = maxNum
    end
  end
  if value <= 0 then
    value = 1
  end
  return value
end

local function fmtSettingKey(key1, key2)
  return LuaEntry.Player.uid .. SettingKeys.SEARCH_MONSTER_LEVEL .. tostring(key1) .. tostring(key2)
end

local function SetSearchLevel(self, type, subType)
  Setting:SetInt(fmtSettingKey(type, subType), self:GetCurNumBySearchType(type, subType))
end

local function GetSearchLevel(self, type, subType)
  return Setting:GetInt(fmtSettingKey(type, subType), 1)
end

local function GetCurrentState(self)
  local showData = {}
  showData.serverId = LuaEntry.Player:GetCurServerId()
  local pos = CS.SceneManager.World.CurTarget
  local tile = SceneUtils.WorldToTileIndex(pos)
  local v2 = SceneUtils.IndexToTilePos(tile)
  showData.x = v2.x
  showData.y = v2.y
  return showData
end

local function SetCurBookMarkType(self, tempType)
  self.curBookMarkType = tempType
end

local function GetCurBookMarkType(self)
  return self.curBookMarkType
end

local function CheckCanGo(self, server, x, y)
  local canJump = false
  if server ~= nil and x ~= nil and y ~= nil and 0 <= x and 0 <= y and x <= CS.SceneManager.World.TileCount.x - 1 and y <= CS.SceneManager.World.TileCount.y - 1 then
    local data = CS.UnityEngine.Vector2Int(x, y)
    if CS.SceneManager.World:IsInMap(data) then
      canJump = true
    end
  end
  return canJump
end

local function OnJumpClick(self, server, x, y)
  local v2 = {}
  v2.x = x
  v2.y = y
  GoToUtil.GotoPos(SceneUtils.TileToWorld(v2), CS.SceneManager.World.InitZoom, nil, nil, server)
  self:CloseSelf()
end

local function _Match(text, keyword)
  if not text or not keyword then
    return false
  end
  return string.find(text, keyword, 1, true) ~= nil
end

local function GetMarkListByTab(self, tab, keyword)
  local dataList = {}
  local serverList = {}
  local showList = {}
  if tab == -1 then
    dataList = DataCenter.WorldFavoDataManager:GetAllBookList()
  else
    dataList = DataCenter.WorldFavoDataManager:GetBookListByType(tab)
  end
  if tab == MarkType.Alliance_Attack then
    local tempList = {}
    for _, v in pairs(dataList) do
      if DataCenter.WorldFavoDataManager:IsR4R5Visible(v) then
        table.insert(tempList, v)
      end
    end
    dataList = tempList
  end
  local total = {}
  table.insert(serverList, -1)
  showList[-1] = total
  local normalizedKeyword
  if not string.IsNullOrEmpty(keyword) then
    normalizedKeyword = string.lower(keyword)
  end
  local isNum = tonumber(keyword)
  if dataList ~= nil then
    for k, v in pairs(dataList) do
      if not normalizedKeyword then
        table.insert(total, v)
      else
        local normalizedName = string.lower(v.name)
        if _Match(normalizedName, normalizedKeyword) then
          table.insert(total, v)
        elseif isNum then
          local pointId = (v.pos - v.pos % 10) / 10
          local pos = SceneUtils.IndexToTilePos(pointId)
          local str = string.format("%s|%s|%s", v.server, pos.x, pos.y)
          if _Match(str, normalizedKeyword) then
            table.insert(total, v)
          end
        end
      end
    end
  end
  local currentServer = LuaEntry.Player:GetCurServerId()
  table.sort(total, function(a, b)
    if (a.server == currentServer or b.server == currentServer) and a.server ~= b.server then
      return a.server == currentServer
    end
    return (a.createTime or 0) > (b.createTime or 0)
  end)
  for k, v in ipairs(total) do
    local server = v.server
    if not showList[server] then
      showList[server] = {}
      table.insert(serverList, server)
    end
    table.insert(showList[server], v)
  end
  table.sort(serverList, function(a, b)
    if (a == -1 or b == -1) and a ~= b then
      return a == -1
    end
    if (a == currentServer or b == currentServer) and a ~= b then
      return a == currentServer
    end
    return b < a
  end)
  return serverList, showList
end

local function DelBookMark(self, selectItem)
  if not self.curBookMarkType then
    self:CloseSelf()
    return
  end
  if self.curBookMarkType == MarkType.Alliance_Attack then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390820)
      return
    elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(390822)
      return
    end
    DataCenter.WorldFavoDataManager:TryDelAllianceMask(selectItem.type)
  elseif self.curBookMarkType == MarkType.Country_A then
    DataCenter.WorldFavoDataManager:TryDelCountryMask(selectItem.type)
  else
    SFSNetwork.SendMessage(MsgDefines.WorldFavoDel, selectItem.pos, selectItem.type, selectItem.server, selectItem.worldId)
  end
end

function UISearchCtrl:DelBookMarkBatch(selections)
  if not selections or #selections <= 0 then
    return
  end
  if self.curBookMarkType ~= MarkType.Alliance_Attack and self.curBookMarkType ~= MarkType.Country_A then
    SFSNetwork.SendMessage(MsgDefines.WorldFavoDelBatch, selections)
  end
end

local function DelBookMarkByType(self)
  if not self.curBookMarkType then
    self:CloseSelf()
    return
  end
  if self.curBookMarkType == MarkType.Alliance_Attack or self.curBookMarkType == MarkType.Country_A then
    return
  else
    local param = {
      type = self.curBookMarkType
    }
    SFSNetwork.SendMessage(MsgDefines.WorldFavoClearAll, param)
  end
end

local rapidjson = require("rapidjson")

local function ShareBookMark(self, selectItem)
  if self.curBookMarkType and self.curBookMarkType == MarkType.Alliance_Attack and not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390820)
    return
  end
  local share_param = {}
  share_param.sid = selectItem.server
  share_param.pos = (selectItem.pos - selectItem.pos % 10) / 10
  share_param.uname = ""
  if selectItem.pointInfo and not string.IsNullOrEmpty(selectItem.pointInfo) then
    local info = rapidjson.decode(selectItem.pointInfo)
    if info then
      if info.uname then
        share_param.uname = info.uname
      else
        share_param.uname = ""
      end
      if info.abbr then
        share_param.abbr = info.abbr
      end
      if info.oname then
        share_param.oname = info.oname
      end
      if info.olv then
        share_param.olv = info.olv
      end
      share_param.uid = info.uid
      if not string.IsNullOrEmpty(info.posType) then
        share_param.posType = toInt(info.posType)
      end
    end
  end
  GoToUtil.GotoOpenView(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

local function OnClickPosBtn(self, selectItem)
  if self.curBookMarkType and self.curBookMarkType == MarkType.Alliance_Attack and not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390820)
    return
  end
  local point = (selectItem.pos - selectItem.pos % 10) / 10
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(point), CS.SceneManager.World.InitZoom, nil, nil, selectItem.server)
  self:CloseSelf()
end

local function GetLastRecordXAndY(self)
  local x = Setting:GetInt(LuaEntry.Player.uid .. SettingKeys.GOTO_POSITION_X, -1)
  local y = Setting:GetInt(LuaEntry.Player.uid .. SettingKeys.GOTO_POSITION_Y, -1)
  return x, y
end

local function SaveLastInputXAndY(self, serverId, x, y)
  if self:CheckCanGo(serverId, x, y) == true then
    Setting:SetInt(LuaEntry.Player.uid .. SettingKeys.GOTO_POSITION_X, x)
    Setting:SetInt(LuaEntry.Player.uid .. SettingKeys.GOTO_POSITION_Y, y)
  end
end

local function GetSearchItemConfig(self, cfgTable, level, searchType, v)
  local cfg = {
    icon = "",
    name = "",
    reward = {},
    desc = "",
    firstReward = false,
    firstRewardDes = nil
  }
  local subtype = v.type
  if cfgTable == TableName.Monster then
    if v.activityType ~= nil then
      local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(v.activityType)
      if #dataList <= 0 then
        return nil
      end
      local template = DataCenter.MonsterTemplateManager:GetMonsterTemplateBySpecialLevel(level, 3, v.special, true)
      if template then
        cfg.icon = UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, template.pic)
        cfg.name = template.name
        if DataCenter.LWActivityLockhartManager:IsLockHartFirstKill(level) then
          local first_reward = template:GetProcessedFirstRewardShow()
          if not table.IsNullOrEmpty(first_reward) then
            cfg.firstReward = true
            cfg.reward = first_reward
            if template.first_reward_condition == 1 then
              cfg.firstRewardDes = Localization:GetString("season_tips211")
            end
          else
            cfg.reward = table.mergeArray(template:GetProcessedShowReward(), template:GetProcessedShowPossibleReward())
          end
        else
          cfg.reward = table.mergeArray(template:GetProcessedShowReward(), template:GetProcessedShowPossibleReward())
        end
        return cfg
      end
    end
    local template = DataCenter.MonsterTemplateManager:GetMonsterTemplatebyLevelType(level, subtype)
    if template then
      cfg.icon = UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, template.pic)
      cfg.name = template.name
      local fisrtRewardFlag = false
      if template.first_reward_type == 1 then
        fisrtRewardFlag = not LuaEntry.Player:IsKillMonster(template.id)
      else
        fisrtRewardFlag = level > LuaEntry.Player.pveLevel
      end
      if fisrtRewardFlag then
        local firstReward = template:GetProcessedFirstRewardShow()
        if firstReward and 0 < #firstReward then
          cfg.reward = firstReward
          cfg.firstReward = true
          if template.first_reward_condition == 1 then
            cfg.firstRewardDes = Localization:GetString("season_tips211")
          end
        else
          cfg.reward = table.mergeArray(template:GetProcessedShowReward(), template:GetProcessedShowPossibleReward())
        end
      else
        cfg.reward = table.mergeArray(template:GetProcessedShowReward(), template:GetProcessedShowPossibleReward())
      end
    end
  elseif cfgTable == TableName.GatherResource then
    local template = DataCenter.GatherResourceTemplateManager:GetTemplatebyLevelType(level, subtype, GatherResourceSpecialType.Common)
    if template then
      cfg.icon = template.pic
      cfg.name = template.name
      cfg.reward = template:GetProcessedShowReward()
    end
  elseif cfgTable == TableName.Desert then
    local template
    if LWWorldMonsterType.ResObsidian == subtype then
      template = DataCenter.DesertTemplateManager:GetTemplateByLevelAndType(level, 2)
      cfg.icon = "Assets/Main/Sprites/SeasonDesert/xianrenzhang_4.png"
      cfg.name = "season_resource_place_name002"
    elseif LWWorldMonsterType.ResFlint == subtype then
      template = DataCenter.DesertTemplateManager:GetTemplateByLevelAndType(level, 1)
      cfg.icon = "Assets/Main/Sprites/SeasonDesert/taiyangkuang_4.png"
      cfg.name = "season_resource_place_name001"
    end
    if template then
      local mgr = DataCenter.RewardManager
      local strList
      local attackMaxLevel = DataCenter.SeasonDataManager:GetDesertMaxLevel()
      if level and level > attackMaxLevel then
        cfg.firstReward = true
        strList = mgr:ConcatRewardList({
          template.firstRewardStr
        }, nil)
      else
        strList = mgr:ConcatRewardList({
          template.showRewardStr
        }, nil)
      end
      if strList ~= nil and 0 < #strList then
        local item
        for _, vv in ipairs(strList) do
          if vv ~= nil and vv ~= "" then
            item = mgr:ParseOneRewardStr(vv)
            if item ~= nil then
              table.insert(cfg.reward, item)
            end
          end
        end
      end
      table.sort(cfg.reward, function(a, b)
        if a.rewardType and b.rewardType then
          return a.rewardType < b.rewardType
        end
        if a.itemId and b.itemId then
          return a.itemId < b.itemId
        end
        return a.count < b.count
      end)
    end
  end
  return cfg
end

local function RecordSelectPage(self)
  DataCenter.SearchPanelDataManager:RecordSelectPage(self.pageIndex, self.cellIndex)
end

function UISearchCtrl:RecordSelectPageForS5(group)
  DataCenter.SearchPanelDataManager:RecordSelectPageForS5(self.pageIndex, self.cellIndex, group)
end

UISearchCtrl.CloseSelf = CloseSelf
UISearchCtrl.Close = Close
UISearchCtrl.GetCurChangeByTotal = GetCurChangeByTotal
UISearchCtrl.InitData = InitData
UISearchCtrl.GetCurMaxCanAttackLevel = GetCurMaxCanAttackLevel
UISearchCtrl.GetMaxNumBySearchType = GetMaxNumBySearchType
UISearchCtrl.SetCurNumBySearchType = SetCurNumBySearchType
UISearchCtrl.GetCurNumBySearchType = GetCurNumBySearchType
UISearchCtrl.OnSearchEnd = OnSearchEnd
UISearchCtrl.OnSearchClick = OnSearchClick
UISearchCtrl.SetSearchLevel = SetSearchLevel
UISearchCtrl.GetSearchLevel = GetSearchLevel
UISearchCtrl.GetCurrentState = GetCurrentState
UISearchCtrl.CheckCanGo = CheckCanGo
UISearchCtrl.OnJumpClick = OnJumpClick
UISearchCtrl.GetMarkListByTab = GetMarkListByTab
UISearchCtrl.DelBookMark = DelBookMark
UISearchCtrl.DelBookMarkByType = DelBookMarkByType
UISearchCtrl.ShareBookMark = ShareBookMark
UISearchCtrl.OnClickPosBtn = OnClickPosBtn
UISearchCtrl.SetCurBookMarkType = SetCurBookMarkType
UISearchCtrl.GetCurBookMarkType = GetCurBookMarkType
UISearchCtrl.GetLastRecordXAndY = GetLastRecordXAndY
UISearchCtrl.SaveLastInputXAndY = SaveLastInputXAndY
UISearchCtrl.GetSearchItemConfig = GetSearchItemConfig
UISearchCtrl.RecordSelectPage = RecordSelectPage
return UISearchCtrl
