local WorldFavoDataManager = BaseClass("WorldFavoDataManager")
local AllianceWorldMark = require("Scene.AllianceWorldMark.AllianceWorldMark")
local WorldBookMarkItem = require("DataCenter.WorldFavoData.WorldBookMarkItem")
local CountryMarkData = require("DataCenter.WorldFavoData.CountryMarkData")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local TranslateManager = require("DataCenter.MailData.MailTranslateManager")
local BookMarkTemplate = require("DataCenter.WorldFavoData.BookMarkTemplate")

local function __init(self)
  self.personalMarkDatas = {}
  self.personalMarkGoDic = {}
  self.allianceMarkDatas = {}
  self.allianceMarkGoDic = {}
  self.allianceMarkReqDic = {}
  self.countryMarkDatas = {}
  self.countryMarkGoDic = {}
  self.countryMarkReqDic = {}
  self.allianceMarkForFriends = {
    dataDict = {},
    requestDict = {},
    luaDict = {}
  }
  self.lastGotoPos = ""
  self.lastTab = 0
  self:AddListener()
  self:InitAllTemplate()
end

local function __delete(self)
  self:ClearAll()
  self.personalMarkDatas = {}
  self.personalMarkGoDic = {}
  self.allianceMarkDatas = {}
  self.allianceMarkGoDic = {}
  self.allianceMarkReqDic = {}
  self.countryMarkDatas = {}
  self.countryMarkGoDic = {}
  self.countryMarkReqDic = {}
  self.allianceMarkForFriends = {
    dataDict = {},
    requestDict = {},
    luaDict = {}
  }
  self.lastGotoPos = nil
  self.lastTab = nil
  self.Translate = nil
  self.templateDic = nil
  self:RemoveListener()
end

local function InitData(self)
  SFSNetwork.SendMessage(MsgDefines.WorldFavoGet, 0)
  SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceMark)
  SFSNetwork.SendMessage(MsgDefines.WorldGetCountryMark)
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnExitWorld)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.OnRefreshMark)
  EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.OnRefreshMark)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnExitWorld)
  EventManager:GetInstance():AddListener(EventId.WorldAllianceMarkTranslateFinish, self.OnWorldTranslateFinish)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.OnRefreshMark)
  EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.OnRefreshMark)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnExitWorld)
  EventManager:GetInstance():RemoveListener(EventId.WorldAllianceMarkTranslateFinish, self.OnWorldTranslateFinish)
end

local function ClearAll(self)
  self:ClearAllAllianceMarksView()
  self:ClearAllCountryMarksView()
  self:ClearAllWorldBookmark()
end

local function InitAllTemplate(self)
  self.templateDic = {}
  LocalController:instance():visitTable(TableName.LW_AllianceMark, function(id, lineData)
    local item = BookMarkTemplate.New()
    item:InitData(lineData)
    self.templateDic[item.type] = item
  end)
end

function WorldFavoDataManager.OnWorldTranslateFinish(markData)
  local self = DataCenter.WorldFavoDataManager
  for markType, v in pairs(self.allianceMarkGoDic) do
    if markType == markData.type then
      self.allianceMarkGoDic[markType]:OnTranslateFinish(markData)
      markData:SetTranslateFinishState(1)
      return
    end
  end
  for markType, v in pairs(self.countryMarkGoDic) do
    if markType == markData.type then
      self.countryMarkGoDic[markType]:OnTranslateFinish(markData)
      markData:SetTranslateFinishState(1)
      return
    end
  end
end

local function InitBookmarkDict(self, message)
  self.personalMarkDatas = {}
  if message.favo ~= nil then
    local favoList = message.favo
    table.walk(favoList, function(k, v)
      local oneData = BookMark.New()
      oneData:ParseData(v)
      if oneData.server > 0 and 0 < oneData.pos then
        local key = oneData.server * 100000000 + oneData.pos
        self.personalMarkDatas[key] = oneData
      end
    end)
  end
end

local function TryAddAllianceMask(self, point, server, markType, name, planTimeStamp, notice, param)
  SFSNetwork.SendMessage(MsgDefines.WorldAddAllianceMark, point, server, markType, name, planTimeStamp, notice, param)
end

local function TryDelAllianceMask(self, markType)
  SFSNetwork.SendMessage(MsgDefines.WorldDelAllianceMark, markType)
end

local function OnInitAllianceMarkDic(self, message)
  self:ClearAllAllianceMarksView()
  self.allianceMarkDatas = {}
  if not self.Translate then
    self.Translate = TranslateManager.New()
  end
  if message.markInfoArr then
    for i, v in ipairs(message.markInfoArr) do
      local newOne = AllianceMarkData.New()
      newOne:SetTranslateHandler(self.Translate)
      newOne:ParseData(v)
      if newOne.server > 0 and 0 < newOne.pos then
        local k = newOne.type
        if k == MarkType.Alliance_rally then
          DataCenter.AllianceRallyPointDataManager:OnInitSelfRallyPoint(v)
        elseif k == MarkType.Alliance_OtherServerRally then
          DataCenter.AllianceRallyPointDataManager:OnInitOtherServerRallyPoint(v)
        else
          self.allianceMarkDatas[k] = newOne
          if self:IsShow(newOne) then
            self:CreateAllianceMarkOnMap(newOne.type, self.allianceMarkDatas, self.allianceMarkReqDic, self.allianceMarkGoDic)
          end
        end
      end
    end
  end
  if message.allyAllianceId ~= nil and message.allyAllianceId ~= "" then
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(message.allyAllianceId)
    if data == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, message.allyAllianceId)
    end
  end
  if message.allyMarkInfo then
    self.allianceMarkForFriends.dataDict = {}
    for i, v in ipairs(message.allyMarkInfo) do
      local newOne = AllianceMarkData.New()
      newOne:SetTranslateHandler(self.Translate)
      newOne:ParseData(v)
      if newOne.server > 0 and 0 < newOne.pos then
        local k = newOne.type
        if k == MarkType.Alliance_rally then
        elseif k == MarkType.Alliance_OtherServerRally then
        else
          self.allianceMarkForFriends.dataDict[k] = newOne
          if self:IsShow(newOne) then
            self:CreateAllianceMarkOnMap(newOne.type, self.allianceMarkForFriends.dataDict, self.allianceMarkForFriends.requestDict, self.allianceMarkForFriends.luaDict, true)
          end
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
end

local function HandleAddAllianceMarkMessage(self, msg)
  if msg.markInfo then
    if not self.Translate then
      self.Translate = TranslateManager.New()
    end
    local newOne = AllianceMarkData.New()
    newOne:ParseData(msg.markInfo)
    newOne:SetTranslateHandler(self.Translate)
    if newOne.server > 0 and 0 < newOne.pos then
      local k = newOne.type
      if msg.isAllyMark then
        DataCenter.SeasonAllyFriendManager.friendMarkDirty = true
        if self:IsShow(newOne) then
          self.allianceMarkForFriends.dataDict[k] = newOne
          self:CreateAllianceMarkOnMap(k, self.allianceMarkForFriends.dataDict, self.allianceMarkForFriends.requestDict, self.allianceMarkForFriends.luaDict, true)
        else
          if self.allianceMarkForFriends.dataDict[k] ~= nil then
            self:DelAllianceMarkOnMap(k, self.allianceMarkForFriends.dataDict, self.allianceMarkForFriends.requestDict, self.allianceMarkForFriends.luaDict)
          end
          self.allianceMarkForFriends.dataDict[k] = newOne
        end
        EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
        EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
      elseif AllianceRallyType[k] then
        DataCenter.AllianceRallyPointDataManager:OnAddRallyPoint(msg.markInfo)
        return false
      else
        if self:IsShow(newOne) then
          self.allianceMarkDatas[k] = newOne
          self:CreateAllianceMarkOnMap(k, self.allianceMarkDatas, self.allianceMarkReqDic, self.allianceMarkGoDic)
        else
          if self.allianceMarkDatas[k] ~= nil then
            self:DelAllianceMarkOnMap(k, self.allianceMarkDatas, self.allianceMarkReqDic, self.allianceMarkGoDic)
          end
          self.allianceMarkDatas[k] = newOne
        end
        EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
      end
      return true
    end
  end
end

local function OnDelAllianceMark(self, msg)
  if msg.markInfo then
    local markType = msg.markInfo.markType
    if markType == nil then
      return false
    elseif msg.isAllyMark then
      DataCenter.SeasonAllyFriendManager.friendMarkDirty = true
      self:DelAllianceMarkOnMap(msg.markInfo.markType, self.allianceMarkForFriends.dataDict, self.allianceMarkForFriends.requestDict, self.allianceMarkForFriends.luaDict)
      if self.allianceMarkForFriends.dataDict ~= nil then
        self.allianceMarkForFriends.dataDict[msg.markInfo.markType] = nil
      end
      EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
      EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
    elseif msg.markInfo.markType == MarkType.Alliance_rally or msg.markInfo.markType == MarkType.Alliance_OtherServerRally then
      DataCenter.AllianceRallyPointDataManager:DeleteOneRallyPoint(msg.markInfo.markType)
      return false
    else
      self:DelAllianceMarkOnMap(msg.markInfo.markType, self.allianceMarkDatas, self.allianceMarkReqDic, self.allianceMarkGoDic)
      self.allianceMarkDatas[msg.markInfo.markType] = nil
      EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
      return true
    end
  end
end

local function OnAddAllianceMarkPush(self, msg)
  if msg.isAllyMark then
    self:HandleAddAllianceMarkMessage(msg)
  else
    local isAllianceMark = self:HandleAddAllianceMarkMessage(msg)
    if isAllianceMark == true and msg.userInfo then
      local need_show_tip = true
      if msg.markInfo ~= nil and not self:IsR4R5Visible(msg.markInfo) then
        need_show_tip = false
      end
      if need_show_tip then
        UIUtil.ShowTips(Localization:GetString("390818", msg.userInfo.name))
      end
    end
  end
end

local function OnDelAllianceMarkPush(self, msg)
  if msg.isAllyMark then
    self:OnDelAllianceMark(msg)
  else
    local isAllianceMark = self:OnDelAllianceMark(msg)
    if isAllianceMark and msg.userInfo then
      local need_show_tip = true
      if msg.markInfo ~= nil and not self:IsR4R5Visible(msg.markInfo) then
        need_show_tip = false
      end
      if need_show_tip then
        UIUtil.ShowTips(Localization:GetString("390819", msg.userInfo.name))
      end
    end
  end
end

local function OnInitCountryMarkDic(self, message)
  self:ClearAllCountryMarksView()
  self.countryMarkDatas = {}
  if not self.Translate then
    self.Translate = TranslateManager.New()
  end
  if message.markInfoArr then
    for i, v in ipairs(message.markInfoArr) do
      local newOne = CountryMarkData.New()
      newOne:SetTranslateHandler(self.Translate)
      newOne:ParseData(v)
      if string.IsNullOrEmpty(newOne.name) then
        newOne.name = self:GetBookMarkName(newOne.type, true)
      end
      if newOne.server > 0 and 0 < newOne.pos then
        self.countryMarkDatas[newOne.type] = newOne
        if self:IsShow(newOne) then
          self:CreateAllianceMarkOnMap(newOne.type, self.countryMarkDatas, self.countryMarkReqDic, self.countryMarkGoDic)
        end
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CountryMarkUpdate)
end

local function HandleAddCountryMarkMessage(self, msg, bPush)
  local markInfo = msg.markInfo or msg
  if markInfo then
    if not self.Translate then
      self.Translate = TranslateManager.New()
    end
    local newOne = CountryMarkData.New()
    newOne:ParseData(markInfo)
    if string.IsNullOrEmpty(newOne.name) then
      newOne.name = self:GetBookMarkName(newOne.type, true)
    end
    newOne:SetTranslateHandler(self.Translate)
    if newOne.server > 0 and 0 < newOne.pos then
      local k = newOne.type
      if self:IsShow(newOne) then
        self.countryMarkDatas[k] = newOne
        self:CreateAllianceMarkOnMap(k, self.countryMarkDatas, self.countryMarkReqDic, self.countryMarkGoDic)
      else
        if self.countryMarkDatas[k] ~= nil then
          self:DelAllianceMarkOnMap(k, self.countryMarkDatas, self.countryMarkReqDic, self.countryMarkGoDic)
        end
        self.countryMarkDatas[k] = newOne
      end
      local needPush = bPush
      if needPush then
        local remain = newOne.startTime - UITimeManager:GetInstance():GetServerTime()
        if 0 < remain then
          needPush = false
        end
      end
      if needPush then
        EventManager:GetInstance():Broadcast(EventId.CountryMarkUpdate, newOne.type)
      end
      return true
    end
  end
end

local function OnDelCountryMark(self, msg, bPush)
  local markType = msg.markType
  if markType == nil and msg.markInfo ~= nil then
    markType = msg.markInfo.markType
  end
  if markType == nil then
    return false
  end
  self:DelAllianceMarkOnMap(markType, self.countryMarkDatas, self.countryMarkReqDic, self.countryMarkGoDic)
  self.countryMarkDatas[markType] = nil
  EventManager:GetInstance():Broadcast(EventId.CountryMarkUpdate)
  return true
end

local function TryAddCountryMask(self, markType, point, worldId, serverId, pointInfo, planTimeStamp, notice)
  SFSNetwork.SendMessage(MsgDefines.WorldAddCountryMark, markType, point, worldId, serverId, pointInfo, planTimeStamp, notice)
end

local function TryDelCountryMask(self, markType)
  SFSNetwork.SendMessage(MsgDefines.WorldDelCountryMark, markType)
end

function WorldFavoDataManager:ClearAllianceMarks()
  self:ClearAllAllianceMarksView()
  self.allianceMarkDatas = {}
  self.allianceMarkForFriends = {
    dataDict = {},
    requestDict = {},
    luaDict = {}
  }
end

local function ClearAllAllianceMarksView(self)
  for i, v in pairs(self.allianceMarkGoDic) do
    v:Destroy()
  end
  self.allianceMarkGoDic = {}
  for i, v in pairs(self.allianceMarkReqDic) do
    v:Destroy()
  end
  self.allianceMarkReqDic = {}
  for i, v in pairs(self.allianceMarkForFriends.luaDict) do
    v:Destroy()
  end
  self.allianceMarkForFriends.luaDict = {}
  for i, v in pairs(self.allianceMarkForFriends.requestDict) do
    v:Destroy()
  end
  self.allianceMarkForFriends.requestDict = {}
end

local function ClearAllCountryMarksView(self)
  for i, v in pairs(self.countryMarkGoDic) do
    v:Destroy()
  end
  self.countryMarkGoDic = {}
  for i, v in pairs(self.countryMarkReqDic) do
    v:Destroy()
  end
  self.countryMarkReqDic = {}
end

local function DelAllianceMarkOnMap(self, tempType, dataDict, requestDict, luaDict)
  if luaDict and luaDict[tempType] then
    luaDict[tempType]:Destroy()
    luaDict[tempType] = nil
  end
  if requestDict and requestDict[tempType] then
    requestDict[tempType]:Destroy()
    requestDict[tempType] = nil
  end
end

local function CreateAllianceMarkOnMap(self, tempType, dataDict, requestDict, luaDict, isFriendAllyMark)
  if not CS.SceneManager:IsInWorld() then
    return
  end
  if dataDict and dataDict[tempType] then
    local markInfo = dataDict[tempType]
    if not requestDict[tempType] then
      local request = ResourceManager:InstantiateAsync(DataCenter.WorldFavoDataManager:GetBookMarkPrefabPath(tempType, isFriendAllyMark))
      requestDict[tempType] = request
      request:completed("+", function()
        if dataDict[tempType] == nil then
          request:Destroy()
        elseif luaDict[tempType] or not CS.SceneManager:IsInWorld() then
          Logger.LogInfo("[FavPoint]Too late... Destroy request")
          request:Destroy()
        else
          luaDict[tempType] = nil
          if request.isError then
            return
          end
          request.gameObject:SetActive(true)
          request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
          request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          request.gameObject.name = "AllianceMark_" .. tempType
          local newAllianceMark = AllianceWorldMark.New()
          newAllianceMark:OnCreate(request)
          luaDict[tempType] = newAllianceMark
          luaDict[tempType]:ShowMark(markInfo)
        end
      end)
    elseif luaDict[tempType] then
      luaDict[tempType]:ShowMark(markInfo)
    end
  end
end

local function CheckIfAllianceMarkInUse(self, tempType)
  return self.allianceMarkDatas and self.allianceMarkDatas[tempType]
end

local function CheckIfCountryMarkInUse(self, tempType)
  return self.countryMarkDatas and self.countryMarkDatas[tempType]
end

local function CheckIfPointInUse(self, pos)
  for i, v in pairs(self.allianceMarkDatas) do
    if v.pos == pos then
      return true
    end
  end
  for i, v in pairs(self.countryMarkDatas) do
    if v.pos == pos then
      return true
    end
  end
  return false
end

local function AddBookmark(self, point, server, name, type, topFlag, param)
  SFSNetwork.SendMessage(MsgDefines.WorldFavoAdd, name, point, type, server, topFlag, 0, 1, param)
end

function WorldFavoDataManager:AddBookmarkSucceed(message)
  local oneData = BookMark.New()
  oneData.pos = message.point
  oneData.server = message.server
  oneData.name = message.name
  oneData.type = message.type
  oneData.topFlag = message.topFlag
  oneData.pointInfo = message.pointInfo
  if oneData.server > 0 and oneData.pos > 0 then
    local key = oneData.server * 100000000 + oneData.pos
    self.personalMarkDatas[key] = oneData
  end
end

local function UpdateBookmark(self, point, server, createTime)
  local key = server * 100000000 + point
  if self.personalMarkDatas[key] ~= nil then
    self.personalMarkDatas[key].createTime = createTime
    self:CreateWorldBookmark(self.personalMarkDatas[key])
  end
end

local function DelBookmark(self, point, server)
  local key = server * 100000000 + point
  if self.personalMarkDatas[key] ~= nil then
    self.personalMarkDatas[key] = nil
  end
  self:RemoveWorldBookmark(key)
end

local function DelBookmarkBatch(self, points)
  if points and 0 < #points then
    for k, v in ipairs(points) do
      self:DelBookmark(v.point, v.server)
    end
  end
end

local function DelBookmarkByType(self, type)
  local keysToRemove = {}
  for k, v in pairs(self.personalMarkDatas) do
    if v.type == type then
      table.insert(keysToRemove, k)
    end
  end
  for _, k in ipairs(keysToRemove) do
    self.personalMarkDatas[k] = nil
    self:RemoveWorldBookmark(k)
  end
end

local function GetBookmark(self, point, server, onlySelf)
  local targetP = point - point % 10
  local data
  local key = server * 100000000 + targetP
  for i, v in pairs(self.personalMarkDatas) do
    local tempPoint = i - i % 10
    if tempPoint == key then
      data = v
      break
    end
  end
  if onlySelf then
    return data
  end
  if not data and self.allianceMarkDatas then
    for i, v in pairs(self.allianceMarkDatas) do
      if v.pos == point and v.server == server then
        data = v
        break
      end
    end
  end
  if not data and self.countryMarkDatas then
    for i, v in pairs(self.countryMarkDatas) do
      if v.pos == point and v.server == server then
        data = v
        break
      end
    end
  end
  return data
end

local function GetAllianceBookmark(self, point, server)
  local data
  if self.allianceMarkDatas then
    for i, v in pairs(self.allianceMarkDatas) do
      if v.pos == point and v.server == server then
        data = v
        break
      end
    end
  end
  return data
end

local function GetCountryBookmark(self, point, server)
  local data
  if self.countryMarkDatas then
    for i, v in pairs(self.countryMarkDatas) do
      if v.pos == point and v.server == server then
        data = v
        break
      end
    end
  end
  return data
end

local function GetAllianceBookmarkByType(self, type, server)
  local data
  if self.allianceMarkDatas then
    data = self.allianceMarkDatas[type]
    if data and data.server == server then
      return data
    end
  end
  return data
end

local function GetCountryBookmarkByType(self, type, server)
  local data
  if self.countryMarkDatas then
    data = self.countryMarkDatas[type]
    if data and data.server == server then
      return data
    end
  end
  return data
end

local function GetBookListByType(self, type)
  local showList = {}
  if type == MarkType.Special or type == MarkType.Friend or type == MarkType.Enemy then
    table.walk(self.personalMarkDatas, function(k, v)
      if v.type == type then
        showList[k] = v
      end
    end)
  elseif type == MarkType.Country_A then
    showList = self.countryMarkDatas
  else
    showList = self.allianceMarkDatas
    if DataCenter.SeasonAllyFriendManager:HasFriend() then
      showList = table.mergeArray(table.values(self.allianceMarkDatas), table.values(self.allianceMarkForFriends.dataDict))
    end
  end
  return showList
end

local function GetAllianceBookmarkUnusedType(self)
  if self.allianceMarkDatas then
    for i = MarkType.Alliance_Attack, MarkType.Alliance_END do
      if not self.allianceMarkDatas[i] then
        return i
      end
    end
  end
  return MarkType.Alliance_Attack
end

local function GetCountryBookmarkUnusedType(self)
  if self.countryMarkDatas then
    for i = MarkType.Country_A, MarkType.COUNTRY_END do
      if not self.countryMarkDatas[i] then
        return i
      end
    end
  end
  return MarkType.Country_A
end

local function GetAllBookList(self)
  return self.personalMarkDatas
end

local function GetLastGotoPos(self)
  return self.lastGotoPos
end

local function SetLastGotoPos(self, posStr)
  self.lastGotoPos = posStr
end

local function SetLastTab(self, tab)
  self.lastTab = tab
end

local function GetLastTab(self)
  return self.lastTab
end

local function OnExitWorld()
  DataCenter.WorldFavoDataManager:ClearAll()
end

local function OnEnterWorld()
  if BattleFieldUtil.InBattleField() then
    return
  end
  if not CS.SceneManager:IsInWorld() then
    return
  end
  local self = DataCenter.WorldFavoDataManager
  self.curServerId = LuaEntry.Player:GetCurServerId()
  self:CreateAllAllianceMark()
  self:CreateAllCountryMark()
  self:CreateAllWorldBookmark()
end

local function OnRefreshMark()
  local self = DataCenter.WorldFavoDataManager
  if self.curServerId and SeasonUtil.IsInSameMap(self.curServerId, ServerEnum.View) then
    return
  end
  self.curServerId = LuaEntry.Player:GetCurServerId()
  self:ClearAll()
  if CS.SceneManager:IsInWorld() and not BattleFieldUtil.InBattleField() then
    self:CreateAllAllianceMark()
    self:CreateAllCountryMark()
    self:CreateAllWorldBookmark()
  end
end

function WorldFavoDataManager:IsShow(markData)
  if markData.server <= 0 or 0 >= markData.pos then
    return false
  end
  if not markData.isCountryMark and not self:IsR4R5Visible(markData) then
    return false
  end
  return SeasonUtil.IsInSameMap(markData.server, ServerEnum.View)
end

function WorldFavoDataManager:CreateAllAllianceMark()
  for k, v in pairs(self.allianceMarkDatas) do
    if self:IsShow(v) then
      self:CreateAllianceMarkOnMap(k, self.allianceMarkDatas, self.allianceMarkReqDic, self.allianceMarkGoDic)
    end
  end
  for k, v in pairs(self.allianceMarkForFriends.dataDict) do
    if self:IsShow(v) then
      self:CreateAllianceMarkOnMap(k, self.allianceMarkForFriends.dataDict, self.allianceMarkForFriends.requestDict, self.allianceMarkForFriends.luaDict, true)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
end

function WorldFavoDataManager:CreateAllCountryMark()
  for k, v in pairs(self.countryMarkDatas) do
    if self:IsShow(v) then
      self:CreateAllianceMarkOnMap(k, self.countryMarkDatas, self.countryMarkReqDic, self.countryMarkGoDic)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CountryMarkUpdate)
end

local function CreateAllWorldBookmark(self)
  for i, v in pairs(self.personalMarkDatas) do
    if self:IsShow(v) then
      self:CreateWorldBookmark(v)
    end
  end
end

local function CreateWorldBookmark(self, bookMark)
  if bookMark then
    local key = bookMark.server * 100000000 + bookMark.pos
    local item = self.personalMarkGoDic[key]
    if not item then
      item = WorldBookMarkItem.New()
      self.personalMarkGoDic[key] = item
    end
    item:Load(bookMark)
  end
end

local function RemoveWorldBookmark(self, key)
  local item = self.personalMarkGoDic[key]
  if item then
    item:Unload()
    self.personalMarkGoDic[key] = nil
  end
end

local function ClearAllWorldBookmark(self)
  local allBookMark = self.personalMarkGoDic
  for i, v in pairs(allBookMark) do
    v:Unload()
  end
  self.personalMarkGoDic = {}
end

local function GetBookMarkName(self, markType, isTranslate)
  local name
  if self.templateDic then
    name = self.templateDic[markType] and self.templateDic[markType].name
    if name then
      if name == "" then
        return name
      end
      return isTranslate and Localization:GetString(name) or name
    end
  end
  name = AllianceMarkName[markType] or ""
  if name == "" then
    return name
  end
  return isTranslate and Localization:GetString(name) or name
end

local function GetBookMarkSeason(self, markType)
  if self.templateDic then
    local season = self.templateDic[markType] and self.templateDic[markType].season or 0
    return season
  end
  return 0
end

local function GetBookMarkSort(self, markType)
  if self.templateDic then
    local sort = self.templateDic[markType] and self.templateDic[markType].sort or 0
    return sort
  end
  return 0
end

local function GetBookMarkDynamicIcon(self, markType)
  if self.templateDic then
    local dynamicIcon = self.templateDic[markType] and self.templateDic[markType].dynamicIcon
    if dynamicIcon then
      return dynamicIcon
    end
  end
  return nil
end

local function GetBookMarkIconName(self, markType)
  if self.templateDic then
    local icon = self.templateDic[markType] and self.templateDic[markType].icon
    if icon then
      return icon
    end
  end
  return AllianceMarkIconName[markType] or ""
end

local function GetBookMapMarkIconName(self, markType)
  if self.templateDic then
    local icon = self.templateDic[markType] and self.templateDic[markType].mail_icon
    if icon then
      return icon
    end
  end
  return AllianceMapMarkIconName[markType] or ""
end

local function GetBookMarkPrefabPath(self, markType, isFriendAllyMark)
  if self.templateDic then
    local data = self.templateDic[markType]
    if data then
      if isFriendAllyMark then
        local prefabPath = data.friend_prefab
        if prefabPath ~= nil and prefabPath ~= "" then
          return prefabPath
        end
      else
        local prefabPath = data.prefab
        if prefabPath ~= nil and prefabPath ~= "" then
          return prefabPath
        end
      end
    end
  end
  if isFriendAllyMark then
    local prefabPath = AllianceMarkPrefabPathFriends[markType]
    if prefabPath ~= nil and prefabPath ~= "" then
      return prefabPath
    end
  end
  return AllianceMarkPrefabPath[markType] or ""
end

local function GetBookMarkDefaultName(self, markType)
  if self.templateDic then
    local defaultName = self.templateDic[markType] and self.templateDic[markType].text
    if not string.IsNullOrEmpty(defaultName) then
      return defaultName
    end
  end
end

local function GetBookMarkNameLength(self)
  local maxLength = LuaEntry.DataConfig:TryGetStr("alliance_mark", "k1", 50)
  maxLength = maxLength and tonumber(maxLength)
  return maxLength
end

local function CheckBookMarkNameLength(self, name)
  if string.IsNullOrEmpty(name) then
    return true
  end
  local maxLength = self:GetBookMarkNameLength()
  if maxLength < string.len(name) then
    UIUtil.ShowTips(Localization:GetString("alliance_tag_opt_UI_6", maxLength))
    return false
  end
  return true
end

function WorldFavoDataManager:GetFriendBookMarkList()
  return self.allianceMarkForFriends.dataDict
end

function WorldFavoDataManager:IsR4R5Visible(markData)
  if markData.viewRank ~= nil and DataCenter.AllianceBaseDataManager:GetSelfRank() < markData.viewRank then
    return false
  end
  return true
end

function WorldFavoDataManager:DropFriendsAllianceMark()
  for i, v in pairs(self.allianceMarkForFriends.luaDict) do
    v:Destroy()
  end
  self.allianceMarkForFriends.luaDict = {}
  for i, v in pairs(self.allianceMarkForFriends.requestDict) do
    v:Destroy()
  end
  self.allianceMarkForFriends.requestDict = {}
  self.allianceMarkForFriends.dataDict = {}
  EventManager:GetInstance():Broadcast(EventId.AllianceMarkUpdate)
end

WorldFavoDataManager.__init = __init
WorldFavoDataManager.InitData = InitData
WorldFavoDataManager.__delete = __delete
WorldFavoDataManager.AddListener = AddListener
WorldFavoDataManager.RemoveListener = RemoveListener
WorldFavoDataManager.InitBookmarkDict = InitBookmarkDict
WorldFavoDataManager.AddBookmark = AddBookmark
WorldFavoDataManager.UpdateBookmark = UpdateBookmark
WorldFavoDataManager.DelBookmark = DelBookmark
WorldFavoDataManager.DelBookmarkByType = DelBookmarkByType
WorldFavoDataManager.GetBookmark = GetBookmark
WorldFavoDataManager.GetBookListByType = GetBookListByType
WorldFavoDataManager.GetLastGotoPos = GetLastGotoPos
WorldFavoDataManager.SetLastGotoPos = SetLastGotoPos
WorldFavoDataManager.GetAllBookList = GetAllBookList
WorldFavoDataManager.OnInitAllianceMarkDic = OnInitAllianceMarkDic
WorldFavoDataManager.TryAddAllianceMask = TryAddAllianceMask
WorldFavoDataManager.TryDelAllianceMask = TryDelAllianceMask
WorldFavoDataManager.HandleAddAllianceMarkMessage = HandleAddAllianceMarkMessage
WorldFavoDataManager.OnDelAllianceMark = OnDelAllianceMark
WorldFavoDataManager.OnAddAllianceMarkPush = OnAddAllianceMarkPush
WorldFavoDataManager.OnDelAllianceMarkPush = OnDelAllianceMarkPush
WorldFavoDataManager.OnInitCountryMarkDic = OnInitCountryMarkDic
WorldFavoDataManager.TryAddCountryMask = TryAddCountryMask
WorldFavoDataManager.TryDelCountryMask = TryDelCountryMask
WorldFavoDataManager.HandleAddCountryMarkMessage = HandleAddCountryMarkMessage
WorldFavoDataManager.OnDelCountryMark = OnDelCountryMark
WorldFavoDataManager.CreateAllianceMarkOnMap = CreateAllianceMarkOnMap
WorldFavoDataManager.DelAllianceMarkOnMap = DelAllianceMarkOnMap
WorldFavoDataManager.CheckIfAllianceMarkInUse = CheckIfAllianceMarkInUse
WorldFavoDataManager.CheckIfCountryMarkInUse = CheckIfCountryMarkInUse
WorldFavoDataManager.CheckIfPointInUse = CheckIfPointInUse
WorldFavoDataManager.ClearAllAllianceMarksView = ClearAllAllianceMarksView
WorldFavoDataManager.ClearAllCountryMarksView = ClearAllCountryMarksView
WorldFavoDataManager.SetLastTab = SetLastTab
WorldFavoDataManager.GetLastTab = GetLastTab
WorldFavoDataManager.OnExitWorld = OnExitWorld
WorldFavoDataManager.OnEnterWorld = OnEnterWorld
WorldFavoDataManager.OnRefreshMark = OnRefreshMark
WorldFavoDataManager.CreateAllWorldBookmark = CreateAllWorldBookmark
WorldFavoDataManager.CreateWorldBookmark = CreateWorldBookmark
WorldFavoDataManager.RemoveWorldBookmark = RemoveWorldBookmark
WorldFavoDataManager.GetAllianceBookmark = GetAllianceBookmark
WorldFavoDataManager.GetCountryBookmark = GetCountryBookmark
WorldFavoDataManager.ClearAllWorldBookmark = ClearAllWorldBookmark
WorldFavoDataManager.ClearAll = ClearAll
WorldFavoDataManager.InitAllTemplate = InitAllTemplate
WorldFavoDataManager.GetBookMarkName = GetBookMarkName
WorldFavoDataManager.GetBookMarkSeason = GetBookMarkSeason
WorldFavoDataManager.GetBookMarkSort = GetBookMarkSort
WorldFavoDataManager.GetBookMarkDynamicIcon = GetBookMarkDynamicIcon
WorldFavoDataManager.GetBookMarkIconName = GetBookMarkIconName
WorldFavoDataManager.GetBookMapMarkIconName = GetBookMapMarkIconName
WorldFavoDataManager.GetBookMarkPrefabPath = GetBookMarkPrefabPath
WorldFavoDataManager.GetBookMarkDefaultName = GetBookMarkDefaultName
WorldFavoDataManager.GetAllianceBookmarkByType = GetAllianceBookmarkByType
WorldFavoDataManager.GetCountryBookmarkByType = GetCountryBookmarkByType
WorldFavoDataManager.GetAllianceBookmarkUnusedType = GetAllianceBookmarkUnusedType
WorldFavoDataManager.GetCountryBookmarkUnusedType = GetCountryBookmarkUnusedType
WorldFavoDataManager.GetBookMarkNameLength = GetBookMarkNameLength
WorldFavoDataManager.CheckBookMarkNameLength = CheckBookMarkNameLength
WorldFavoDataManager.DelBookmarkBatch = DelBookmarkBatch
return WorldFavoDataManager
