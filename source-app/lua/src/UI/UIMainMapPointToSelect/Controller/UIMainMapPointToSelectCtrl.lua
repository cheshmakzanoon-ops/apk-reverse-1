local UIMainMapPointToSelectCtrl = BaseClass("UIMainMapPointToSelectCtrl", UIBaseCtrl)

local function CloseSelf(self, shareData)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainMapPointToSelect, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
  DataCenter.WorldPointSelectViewDataManager:EndSelect(shareData)
end

local function GetCityPointDataFast(self, length)
  local oneData = {}
  oneData.list = {}
  oneData.isNew = false
  ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPoint.GetAllMainBaseList")
  local list = CS.SceneManager.World:GetAllMainBaseListByType(CS.PlayerType.PlayerSelf, CS.PlayerType.PlayerAlliance, CS.PlayerType.PlayerAllianceLeader)
  ProfilerUtil.EndSample()
  if list ~= nil then
    ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPoint UpdateList")
    for k, v in pairs(list) do
      local temp = {}
      temp.pType = v:GetPlayerType()
      temp.pos = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
      table.insert(oneData.list, temp)
    end
    ProfilerUtil.EndSample()
    if #oneData.list ~= length then
      oneData.isNew = true
    end
  end
  return oneData
end

local function GetCityPointData(self, length)
  return GetCityPointDataFast(self, length)
end

local function GetMarkListByTab(self, tab)
  local dataList = {}
  local serverList = {}
  local showList = {}
  if tab == -1 then
    dataList = DataCenter.WorldFavoDataManager:GetAllBookList()
  else
    dataList = DataCenter.WorldFavoDataManager:GetBookListByType(tab)
  end
  local total = {}
  table.insert(serverList, -1)
  showList[-1] = total
  if dataList ~= nil then
    for k, v in pairs(dataList) do
      table.insert(total, v)
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

local function SetCurBookMarkType(self, tempType)
  self.curBookMarkType = tempType
end

function UIMainMapPointToSelectCtrl:OnCustomKeyCodeEscape()
end

UIMainMapPointToSelectCtrl.CloseSelf = CloseSelf
UIMainMapPointToSelectCtrl.GetCityPointData = GetCityPointData
UIMainMapPointToSelectCtrl.GetCityPointDataFast = GetCityPointDataFast
UIMainMapPointToSelectCtrl.GetMarkListByTab = GetMarkListByTab
UIMainMapPointToSelectCtrl.SetCurBookMarkType = SetCurBookMarkType
return UIMainMapPointToSelectCtrl
