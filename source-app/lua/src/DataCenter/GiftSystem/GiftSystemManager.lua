local GiftSystemManager = BaseClass("GiftSystemManager")
require("DataCenter.GiftSystem.GiftSystemConst")
local Localization = CS.GameEntry.Localization
IsGiftSystemOpen = true
local MinGiftLevel = 0
local CAN_PLAY_EFFECT_KEY = "CAN_PLAY_EFFECT_KEY"
local GIFT_EFFECT_HISTORY_LIST = "GIFT_EFFECT_HISTORY_LIST"

local function __init(self)
  self:AddListener()
  self.receivingList = {}
  self.privilegeTemplateList = nil
  self.expList = {}
  self.claimedPrivileges = {}
  self.giftLevel = MinGiftLevel
  self.giftExp = 0
  self.giftGoods = nil
  self.idMap = nil
  self.maxLevel = nil
  self.animQueen = {}
  self.animHistory = {}
  self.canPlayEffect = true
  self.lastSendTime = -1
  self.giftShowUnlockMaxNum = nil
  self.giftShowUnlockCurNum = nil
  self.giftShowUnlockCurShowNum = nil
  self.giftShowTipStateDict = nil
end

local function __delete(self)
  self.receivingList = {}
  self.privilegeTemplateList = nil
  self.expList = {}
  self.claimedPrivileges = {}
  self.giftLevel = MinGiftLevel
  self.giftExp = 0
  self.giftGoods = nil
  self.idMap = nil
  self.maxLevel = nil
  self.animQueen = {}
  self.animHistory = {}
  self.canPlayEffect = true
  self.lastSendTime = -1
  self.giftShowUnlockMaxNum = nil
  self.giftShowUnlockCurNum = nil
  self.giftShowUnlockCurShowNum = nil
  self.giftShowTipStateDict = nil
  self:RemoveListener()
end

local function AddListener(self)
  function self.OnUpdateGiftSystemOpen()
    self:UpdateGiftSystemOpen()
  end
  
  function self.CloseWind()
    self:OnCloseWind()
  end
  
  EventManager:GetInstance():AddListener(EventId.MainLvUp, self.OnUpdateGiftSystemOpen)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.OnUpdateGiftSystemOpen)
end

local function InitData(self, t)
  self:InitAnim()
  local giftObj = t.giftObj or {}
  self.giftLevel = giftObj.level or MinGiftLevel
  self.giftExp = giftObj.exp or 0
  if not string.IsNullOrEmpty(giftObj.privilegeReward) then
    local list = string.split(giftObj.privilegeReward, "|")
    for _, v in pairs(list) do
      self.claimedPrivileges[tonumber(v)] = true
    end
  end
  self:UpdateGiftSystemOpen()
end

function GiftSystemManager:UpdateGiftSystemOpen()
  self.minSendGiftLevel = LuaEntry.DataConfig:TryGetNum("gift_giving", "k1", 10)
  local openServer = LuaEntry.DataConfig:TryGetStr("gift_giving", "k3", "")
  if string.IsNullOrEmpty(openServer) then
    IsGiftSystemOpen = true
  else
    local serverIds = string.split(openServer, "-")
    IsGiftSystemOpen = CommonUtil.IsGrayServer(tonumber(serverIds[1]), tonumber(serverIds[2]))
  end
  IsGiftSystemOpen = IsGiftSystemOpen and (not (LuaEntry.Player.level < self.minSendGiftLevel) or not (DataCenter.BuildManager.MainLv < self.minSendGiftLevel))
end

function GiftSystemManager:GetGiftShopSellDict()
  local showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
  local sellDict = {}
  for _, data in ipairs(showDataList) do
    local goodsId = data.itemId
    local goods = self:GetGiftGoods(goodsId)
    if goods then
      local expired = self:IsGiftExpired(goodsId)
      local show = self:GetShowConditions(goods)
      if goods.show == 1 and not expired and show then
        sellDict[goodsId] = true
      end
    end
  end
  return sellDict
end

function GiftSystemManager:GetGiftList(windowType)
  local list
  local isSend = windowType == GiftSystemConst.WindowType.Send
  if isSend then
    list = DataCenter.ItemTemplateManager:GetTypeListByType(161)
  else
    list = DataCenter.ItemTemplateManager:GetTypeListByType(162)
  end
  local result = {}
  local showDataList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.GiftShop)
  for _, v in pairs(list) do
    local goods = self:GetGiftGoods(v.id)
    local num = self:GetGiftNum(v.id)
    if goods then
      local isShow = false
      if isSend then
        local expired = self:IsGiftExpired(v.id)
        if 0 < num then
          isShow = not expired
        else
          local show = self:GetShowConditions(goods)
          if goods.show == 1 and not expired then
            if goods.pay == 0 then
              isShow = show
            else
              for _, data in ipairs(showDataList) do
                if tostring(data.itemId) == tostring(goods.id) then
                  isShow = show
                  break
                end
              end
            end
          end
        end
      else
        isShow = 0 < num
      end
      if isShow then
        table.insert(result, v)
      end
    end
  end
  table.sort(result, function(a, b)
    local goodsA = self:GetGiftGoods(a.id)
    local goodsB = self:GetGiftGoods(b.id)
    if isSend then
      local actPassA = goodsA.order_by_activity > 0 and DataCenter.ActivityListDataManager:CheckIfActivityOpen(nil, goodsA.order_by_activity)
      local actPassB = goodsB.order_by_activity > 0 and DataCenter.ActivityListDataManager:CheckIfActivityOpen(nil, goodsB.order_by_activity)
      if actPassA ~= actPassB then
        return actPassA
      end
    end
    local numA = self:GetGiftNum(a.id)
    local numB = self:GetGiftNum(b.id)
    if numA == 0 ~= (numB == 0) then
      return numA ~= 0 and numB == 0
    end
    if goodsA.add_exp ~= goodsB.add_exp then
      return goodsA.add_exp > goodsB.add_exp
    end
    return tonumber(a.id) < tonumber(b.id)
  end)
  return result
end

function GiftSystemManager:GetCurMustShowGiftDict()
  local result = {}
  local list = self:GetGiftGoodsList()
  local curSeason = SeasonUtil.GetSeason()
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  for _, v in pairs(list) do
    if result[v.id] == nil and v.show == 1 and #v.display_show_condition_season == 0 and string.IsNullOrEmpty(v.display_show_condition_time) then
      result[v.id] = v
    end
    if result[v.id] == nil and v.show == 1 and #v.display_show_condition_season == 2 then
      if curSeason > v.display_show_condition_season[1] then
        result[v.id] = v
      elseif v.display_show_condition_season[1] == curSeason and curSeasonDay >= v.display_show_condition_season[2] then
        result[v.id] = v
      end
    end
    if result[v.id] == nil and v.show == 1 and not string.IsNullOrEmpty(v.display_show_condition_time) then
      local time = UIUtil.GetAbsoluteTimeByStr(v.display_show_condition_time)
      if time and curTime >= time then
        result[v.id] = v
      end
    end
  end
  return result
end

function GiftSystemManager:GetGiftGoods(id)
  local list = self:GetGiftGoodsList()
  local goods = list and list[tonumber(id)]
  if goods == nil then
    local originId = self:GetOriginId(id)
    goods = list and list[tonumber(originId)]
  end
  return goods
end

function GiftSystemManager:GetShowConditions(goods)
  local eaShow = goods.ea == 1 and CommonUtil.IsGrayServer(3, 68) or goods.ea == 0
  local serverShow = true
  if 0 < goods.show_condition_server then
    serverShow = tonumber(LuaEntry.Player.serverId) > goods.show_condition_server
  end
  local condShow = true
  if 0 < #goods.show_condition then
    local condType = tonumber(goods.show_condition[1])
    if condType == 1 then
      local param = tonumber(goods.show_condition[2]) or 0
      local season = SeasonUtil.GetSeason()
      condShow = param <= season
    elseif condType == 2 then
      local param = tonumber(goods.show_condition[2]) or 0
      local day = UITimeManager:GetInstance():GetOpenServerDay()
      condShow = param <= day
    elseif condType == 3 then
      local param2 = tonumber(goods.show_condition[2]) or 0
      condShow = param2 <= SeasonUtil.GetSeasonDay()
    elseif condType == 4 then
      local param2 = tonumber(goods.show_condition[2]) or 0
      local param3 = tonumber(goods.show_condition[3]) or 0
      local season = SeasonUtil.GetSeason()
      condShow = param2 < season or season == param2 and param3 <= SeasonUtil.GetSeasonDay()
    elseif condType == 5 then
      local param2 = tonumber(goods.show_condition[2]) or 0
      local param3 = tonumber(goods.show_condition[3]) or 0
      local param4 = tonumber(goods.show_condition[4]) or 0
      local param5 = tonumber(goods.show_condition[5]) or 0
      local season = SeasonUtil.GetSeason()
      local day = SeasonUtil.GetSeasonDay()
      local cond1 = param2 < season or season == param2 and param3 <= day
      local cond2 = param4 > season or season == param4 and param5 > day
      condShow = cond1 and cond2
    elseif condType == 6 then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local absoluteStartTime = UIUtil.GetAbsoluteTimeByStr(goods.show_condition[2])
      local absoluteEndTime = UIUtil.GetAbsoluteTimeByStr(goods.show_condition[3])
      if absoluteStartTime and absoluteEndTime then
        condShow = curTime >= absoluteStartTime and curTime <= absoluteEndTime
      end
    end
  end
  return eaShow and serverShow and condShow
end

function GiftSystemManager:GetGiftGoodsList()
  if self.giftGoods then
    return self.giftGoods
  end
  self.giftGoods = {}
  LocalController:instance():visitTable(TableName.LW_GIFT_GOODS, function(id, lineData)
    local rowData = {}
    rowData.id = lineData.id
    rowData.cross = lineData.cross
    rowData.add_exp = lineData.add_exp
    rowData.ep_gift = lineData.ep_gift
    rowData.convert_item = lineData.convert_item
    rowData.pay = lineData.pay
    rowData.order_by_activity = tonumber(lineData.order_by_activity) or 0
    rowData.icon_small = lineData.icon_small
    rowData.icon_mid = lineData.icon_mid
    rowData.icon_big = lineData.icon_big
    rowData.show = lineData.show
    rowData.activity_id = lineData.activity_id
    rowData.ea = lineData.ea or 0
    rowData.effect_id = lineData.effect_id
    rowData.privilege_fx = lineData.privilege_fx
    rowData.sound_id = lineData.sound_id
    rowData.model = lineData.model
    rowData.show_param = lineData.show_param
    rowData.default_light = lineData.default_light
    rowData.fade_out_time = tonumber(lineData.fade_out_time) or 0
    rowData.order_by_activity = tonumber(lineData.order_by_activity) or 0
    rowData.group_id = not string.IsNullOrEmpty(lineData.group_id) and string.split(lineData.group_id, "|") or {}
    rowData.group_icon = not string.IsNullOrEmpty(lineData.group_icon) and string.split(lineData.group_icon, "|") or {}
    rowData.group_sound = not string.IsNullOrEmpty(lineData.group_sound) and string.split(lineData.group_sound, "|") or {}
    rowData.group_effect = not string.IsNullOrEmpty(lineData.group_effect) and string.split(lineData.group_effect, "|") or {}
    rowData.group_pic = not string.IsNullOrEmpty(lineData.group_pic) and string.split(lineData.group_pic, "|") or {}
    rowData.group_model = not string.IsNullOrEmpty(lineData.group_model) and string.split(lineData.group_model, "|") or {}
    rowData.gift_bubble = not string.IsNullOrEmpty(lineData.gift_bubble) and string.split(lineData.gift_bubble, "|") or {}
    rowData.num_send_country = toInt(lineData.num_send_country)
    rowData.show_condition = not string.IsNullOrEmpty(lineData.show_condition) and string.split(lineData.show_condition, "|") or {}
    rowData.display_show_condition_season = not string.IsNullOrEmpty(lineData.display_show_condition_season) and string.string2array_i_oneSep(lineData.display_show_condition_season, "|") or {}
    rowData.display_show_condition_time = lineData.display_show_condition_time
    rowData.is_set_message = not string.IsNullOrEmpty(lineData.is_set_message) and string.string2array_i_oneSep(lineData.is_set_message, "|") or {}
    rowData.spine_param = not string.IsNullOrEmpty(lineData.spine_param) and string.string2array_num_oneSep(lineData.spine_param, "|") or {}
    rowData.gift_coupon = not string.IsNullOrEmpty(lineData.gift_coupon) and string.string2array_num_oneSep(lineData.gift_coupon, "|") or {}
    rowData.spine_param2 = lineData.spine_param2
    rowData.default_message = not string.IsNullOrEmpty(lineData.default_message) and string.split(lineData.default_message, "|") or {}
    rowData.show_condition_server = toInt(lineData.show_condition_server)
    rowData.show_fx = not string.IsNullOrEmpty(lineData.show_fx) and string.split(lineData.show_fx, "|") or {}
    rowData.activity_not_dis_msg = lineData.activity_not_dis_msg
    self.giftGoods[lineData.id] = rowData
  end)
  return self.giftGoods
end

function GiftSystemManager:GetGiftNum(id)
  if DataCenter.ItemTemplateManager:GetItemTemplate(id) ~= nil then
    local item = DataCenter.ItemData:GetItemById(id)
    if item ~= nil then
      return item.count or 0
    end
  end
  return 0
end

function GiftSystemManager:CheckServerPass(selfServerId, serverStr)
  local isPass = false
  if serverStr == "all" then
    isPass = true
  elseif serverStr == "close" then
  else
    local serverRange = string.string2array_num(serverStr, "-", ";")
    if serverRange and 0 < #serverRange then
      for _, v in ipairs(serverRange) do
        if #v == 1 then
          if selfServerId == v[1] then
            isPass = true
            break
          end
        elseif #v == 2 and selfServerId >= v[1] and selfServerId <= v[2] then
          isPass = true
          break
        end
      end
    end
  end
  return isPass
end

function GiftSystemManager:GetGiftPrivilegeList()
  self.privilegeList = {}
  table.insert(self.privilegeList, {
    type = GiftSystemConst.PrivilegeUIType.Level
  })
  local templist = self:GetPrivilegeTemplateList()
  local list = {}
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  for k, v in ipairs(templist) do
    if self:CheckServerPass(selfServerId, v.server) then
      table.insert(list, v)
    end
  end
  local unlockList = {}
  local lockList = {}
  for _, template in pairs(list) do
    if self.giftLevel >= tonumber(template.level) then
      table.insert(unlockList, {
        type = GiftSystemConst.PrivilegeUIType.Content,
        Unlock = true,
        template = template
      })
    else
      table.insert(lockList, {
        type = GiftSystemConst.PrivilegeUIType.Content,
        Unlock = false,
        template = template
      })
    end
  end
  table.sort(unlockList, function(a, b)
    if a.template.level ~= b.template.level then
      return tonumber(a.template.level) < tonumber(b.template.level)
    end
    return a.template.id < b.template.id
  end)
  table.sort(lockList, function(a, b)
    if a.template.level ~= b.template.level then
      return tonumber(a.template.level) < tonumber(b.template.level)
    end
    return a.template.id < b.template.id
  end)
  local level = -1
  for i, v in ipairs(lockList) do
    if level < v.template.level then
      v.showLevel = true
      level = v.template.level
    end
  end
  if 0 < #unlockList then
    table.insert(self.privilegeList, {
      type = GiftSystemConst.PrivilegeUIType.Title,
      Unlock = true
    })
    table.insertto(self.privilegeList, unlockList)
  end
  if 0 < #lockList then
    table.insert(self.privilegeList, {
      type = GiftSystemConst.PrivilegeUIType.Title,
      Unlock = false
    })
    table.insertto(self.privilegeList, lockList)
  end
  return self.privilegeList
end

function GiftSystemManager:GetPrivilegeTemplateList()
  if self.privilegeTemplateList ~= nil then
    return self.privilegeTemplateList
  end
  self.privilegeTemplateList = {}
  LocalController:instance():visitTable(TableName.LW_GIFT_PRIVILEGE, function(id, lineData)
    local rowData = {}
    rowData.id = lineData.id
    rowData.level = lineData.level
    rowData.des = lineData.des
    rowData.type = lineData.type
    rowData.icon = lineData.icon
    rowData.para = lineData.para
    rowData.show_goods_id = lineData.show_goods_id
    rowData.server = lineData.server
    table.insert(self.privilegeTemplateList, rowData)
  end)
  table.sort(self.privilegeTemplateList, function(a, b)
    return tonumber(a.level) < tonumber(b.level)
  end)
  return self.privilegeTemplateList
end

function GiftSystemManager:GetNeedExpByLevel(level)
  if self.maxLevel == nil then
    self.maxLevel = LocalController:instance():GetTableLength(TableName.LW_GIFT_LEVEL)
  end
  level = math.min(level, self.maxLevel)
  if self.expList[level] then
    return self.expList[level].exp
  end
  local rowData = LocalController:instance():getLine(TableName.LW_GIFT_LEVEL, level)
  self.expList[level] = rowData
  return rowData.exp
end

function GiftSystemManager:GetGiftLevel()
  return math.max(MinGiftLevel, self.giftLevel)
end

function GiftSystemManager:GetGiftExp()
  return self.giftExp
end

function GiftSystemManager:IsGiftExpired(id)
  local expiredExchangeTemplate = DataCenter.ItemExchangeManager:GetItemExchangeTemplateByItemId(id)
  if expiredExchangeTemplate ~= nil and expiredExchangeTemplate:IsExpiredNow() then
    return true
  end
  return false
end

function GiftSystemManager:GetGiftExpiredTime(id)
  local time = 0
  local exchangeServerData = DataCenter.ItemExchangeManager:GetItemExchangeServerDataById(tonumber(id))
  if exchangeServerData and exchangeServerData.expireTime then
    time = exchangeServerData.expireTime
  end
  return time
end

function GiftSystemManager:GetOriginId(itemId)
  if self.idMap == nil then
    self.idMap = {}
    local list = self:GetGiftGoodsList()
    for _, v in pairs(list) do
      self.idMap[tonumber(v.convert_item)] = tonumber(v.id)
    end
  end
  return self.idMap and self.idMap[tonumber(itemId)]
end

function GiftSystemManager:HasPrivilegeClaimed(id)
  if self.claimedPrivileges == nil then
    return false
  end
  return self.claimedPrivileges[tonumber(id)] == true
end

function GiftSystemManager:CheckPrivilegeHaveRedDot()
  local isHave = false
  local list = self:GetPrivilegeTemplateList()
  for _, template in pairs(list) do
    if self.giftLevel >= tonumber(template.level) and self:HasPrivilegeClaimed(template.id) == false then
      isHave = true
      break
    end
  end
  return isHave
end

function GiftSystemManager:SendGift(itemId, targetUid, isAnonymous, context, num, fromType, isQuick)
  local now = UITimeManager:GetInstance():GetServerTime()
  if not isQuick and self.lastSendTime ~= -1 and now - self.lastSendTime < 1000 then
    return
  end
  self.lastSendTime = now
  if LuaEntry.Player.level < self.minSendGiftLevel and DataCenter.BuildManager.MainLv < self.minSendGiftLevel then
    UIUtil.ShowTips(Localization:GetString("gift_sent_toast3", self.minSendGiftLevel))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SendUserGift, {
    targetUid = targetUid,
    itemId = itemId,
    num = num,
    context = context,
    isAnonymous = isAnonymous,
    fromType = fromType or 0
  })
end

function GiftSystemManager:SendGiftByFollow(itemId, targetUid, isAnonymous, context, num)
  if LuaEntry.Player.level < self.minSendGiftLevel and DataCenter.BuildManager.MainLv < self.minSendGiftLevel then
    UIUtil.ShowTips(Localization:GetString("gift_sent_toast3", self.minSendGiftLevel))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.UserAddFollow, {
    targetUid = targetUid,
    itemId = itemId,
    num = num,
    context = context,
    isAnonymous = isAnonymous
  })
end

function GiftSystemManager:RequestReceivingHistory()
  SFSNetwork.SendMessage(MsgDefines.GiftOwnerReceivingHistory, {
    targetUid = targetUid,
    itemId = itemId
  })
end

function GiftSystemManager:RequestReceivingHistoryById(targetUid, itemId, startIndex, endIndex, filterContent)
  if targetUid then
    SFSNetwork.SendMessage(MsgDefines.GiftOtherReceivingHistory, {
      targetUid = targetUid,
      itemId = itemId,
      startIndex = startIndex,
      endIndex = endIndex
    })
  else
    SFSNetwork.SendMessage(MsgDefines.GiftOwnerReceivingHistory, {
      itemId = itemId or 0,
      startIndex = startIndex,
      endIndex = endIndex
    }, filterContent)
  end
end

function GiftSystemManager:RequestSetGiftShow(arr)
  local list = {}
  local map = {}
  local itemUnlockNum = DataCenter.GiftSystemManager:GetGiftShowUnlockCurNum()
  local itemCount = GiftSystemConst:GetDefaultGiftShowNum() + itemUnlockNum
  for _, v in ipairs(arr) do
    if not map[v.itemId] then
      map[v.itemId] = v
      if itemCount >= v.pos and v.pos > 0 and itemCount > #list and 0 < v.count then
        table.insert(list, v)
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.SetGiftShow, {arr = list})
end

function GiftSystemManager:RequestGetPrivilegeReward(id)
  SFSNetwork.SendMessage(MsgDefines.UserGiftReward, {id = id})
end

function GiftSystemManager:HandleGiftReceiving(list)
  EventManager:GetInstance():Broadcast(EventId.GiftSystemReceivingHistory, list)
end

function GiftSystemManager:HandleAddGift(data)
end

function GiftSystemManager:HandleGiftLevelExpChange(data)
  self.giftLevel = tonumber(data.level) or MinGiftLevel
  self.giftExp = tonumber(data.exp) or 0
end

function GiftSystemManager:HandleSendGift(data)
  self.giftLevel = tonumber(data.level) or MinGiftLevel
  self.giftExp = tonumber(data.exp) or 0
  local goods = self:GetGiftGoods(data.itemId)
  local senderInfo = {
    uid = LuaEntry.Player:GetUid(),
    name = LuaEntry.Player:GetName(),
    pic = LuaEntry.Player:GetPic(),
    picVer = LuaEntry.Player:GetPicVer(),
    frameBg = LuaEntry.Player:GetHeadBgImg(),
    isActiveAnonymity = data.isAnonymous == 1
  }
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  senderInfo.abbr = allianceData and allianceData.abbr or ""
  local targetInfo = data.otherPlayerInfo
  local playAlone = true
  if goods.ep_gift == 1 then
    local id = data.chatGiftUuid
    playAlone = false
    DataCenter.GiftSystemManager:TryPlayAnim(id, goods.id, nil, senderInfo, targetInfo, data.giftExtraItemNum)
  else
    if next(goods.group_id) then
      local index = 0
      for i, v in ipairs(goods.group_id) do
        if data.num >= tonumber(v) then
          index = i
        end
      end
      local effect = goods.group_effect[index]
      if not string.IsNullOrEmpty(effect) then
        local id = data.chatGiftUuid
        playAlone = false
        DataCenter.GiftSystemManager:TryPlayAnim(id, goods.id, index, senderInfo, targetInfo, data.giftExtraItemNum)
      else
      end
    else
    end
  end
  if not self.giftAnimList then
    self.giftAnimList = {}
  end
  if playAlone then
    self:PlaySendGiftAnim(goods.id, nil, senderInfo, targetInfo, data.giftExtraItemNum)
  end
end

function GiftSystemManager:PlaySendGiftAnim(giftId, groupId, senderInfo, targetInfo, giftExtraItemNum)
  if not senderInfo or not targetInfo then
    return
  end
  if not self.giftAnimList then
    self.giftAnimList = {}
  end
  local param = {
    giftId = giftId,
    groupId = groupId,
    senderInfo = senderInfo,
    targetInfo = targetInfo,
    giftExtraItemNum = giftExtraItemNum,
    callBack = function()
      self.sendGiftAnimPlaying = false
      return self:QueenPlayGiftAnim()
    end
  }
  table.insert(self.giftAnimList, param)
  self:QueenPlayGiftAnim()
end

function GiftSystemManager:ExitSendGiftAnim(forceCloseUI)
  self.sendGiftAnimPlaying = false
  self.giftAnimList = {}
  if forceCloseUI then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftAnimPanel)
  end
end

function GiftSystemManager:QueenPlayGiftAnim()
  if self.sendGiftAnimPlaying then
    return
  end
  if not self.giftAnimList or #self.giftAnimList < 1 then
    return
  end
  self.sendGiftAnimPlaying = true
  local info = table.remove(self.giftAnimList, 1)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIGiftAnimPanel) then
    EventManager:GetInstance():Broadcast(EventId.GiftSystemSendGiftAnim, info)
    return true
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftAnimPanel, {anim = true}, info)
  end
end

function GiftSystemManager:ShowToast(data)
  local name = data.otherPlayerInfo and data.otherPlayerInfo.name or ""
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
  local tip = data.isAnonymous == 1 and "gift_sent_toast2" or "gift_sent_toast1"
  local giftName = Localization:GetString(template.name)
  if data.giftExtraItemId and data.giftExtraItemNum then
    tip = data.isAnonymous == 1 and "gift_sent_toast6" or "gift_sent_toast5"
    local goodsId = data.giftExtraItemId
    local goodsTemp = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
    if goodsTemp then
      local iconPath = string.format(LoadPath.ItemPath, goodsTemp.icon)
      UIUtil.ShowTipsWithImage(Localization:GetString(tip, name .. " ", data.num, giftName), iconPath, "\195\151" .. data.giftExtraItemNum)
    end
  else
    UIUtil.ShowTips(Localization:GetString(tip, name .. " ", data.num, giftName))
  end
end

function GiftSystemManager:HandleGiftReceivingHistory(list, params)
  if params and params.filterContent and params.filterContent > 0 then
    EventManager:GetInstance():Broadcast(EventId.GiftReceivingFilterMsgHistory, list)
  else
    EventManager:GetInstance():Broadcast(EventId.GiftSystemReceivingHistory, list)
  end
end

function GiftSystemManager:HandleGetPrivilegeReward(data)
  if data.reward then
    DataCenter.RewardManager:ShowCommonReward(data)
    DataCenter.RewardManager:AddRewardsAndRes(data)
  elseif data.unlock then
    local dataArr = string.string2array_num_oneSep(data.unlock, ";")
    if #dataArr == 2 then
      local goodsId = dataArr[1]
      local shopType = dataArr[2]
      DataCenter.CommonShopManager:SetShopDataDirty(shopType)
      local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(goodsId)
      if goodsTemplate then
        local goodsName = Localization:GetString(goodsTemplate.name)
        UIUtil.ShowTips(Localization:GetString("gift_unlock_tips", goodsName))
      end
    end
  end
  self.claimedPrivileges[tonumber(data.id)] = true
  EventManager:GetInstance():Broadcast(EventId.GiftSystemReceivingPrivilege)
end

function GiftSystemManager:InitAnim()
  self.canPlayEffect = CommonUtil.PlayerPrefsGetBool(CAN_PLAY_EFFECT_KEY, true)
  self.animHistory = CommonUtil.PlayerPrefsGetTable(GIFT_EFFECT_HISTORY_LIST, {})
  local now = UITimeManager:GetInstance():GetServerTime()
  local list = {}
  for _, v in pairs(self.animHistory) do
    if 8640000 < now - v then
      table.insert(list, v)
    end
  end
  if 0 < #list then
    for _, v in ipairs(list) do
      self.animHistory[v] = nil
    end
    CommonUtil.PlayerPrefsSetTable(GIFT_EFFECT_HISTORY_LIST, self.animHistory)
  end
end

function GiftSystemManager:TryPlayAnim(seqId, giftId, groupId, senderInfo, targetInfo, giftExtraItemNum)
  if not self.canPlayEffect then
    return
  end
  if self.animHistory[tostring(seqId)] then
    return
  end
  if not senderInfo or not targetInfo then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  self.animHistory[tostring(seqId)] = now
  local anim = self.animQueen[#self.animQueen]
  if anim and anim.giftId == giftId then
    return
  end
  if self.animPlaying and giftId == self.animPlayingId then
    return
  end
  table.insert(self.animQueen, {
    seqId = seqId,
    giftId = giftId,
    groupId = groupId,
    senderInfo = senderInfo,
    targetInfo = targetInfo,
    giftExtraItemNum = giftExtraItemNum
  })
  self:QueenPlayAnim()
end

function GiftSystemManager:QueenPlayAnim()
  if self.animPlaying then
    return
  end
  if #self.animQueen <= 0 then
    return
  end
  self.animPlaying = true
  local info = table.remove(self.animQueen, 1)
  self.animPlayingId = info.giftId
  local data = {
    giftId = info.giftId,
    groupId = info.groupId,
    senderInfo = info.senderInfo,
    targetInfo = info.targetInfo,
    giftExtraItemNum = info.giftExtraItemNum,
    callback = function()
      self.animPlaying = false
      self.animPlayingId = nil
      if #self.animQueen <= 0 then
      else
        self:QueenPlayAnim()
      end
    end
  }
  self:ExitSendGiftAnim(true)
  CommonUtil.PlayerPrefsSetTable(GIFT_EFFECT_HISTORY_LIST, self.animHistory)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIGiftSpecialAnimShow) then
    EventManager:GetInstance():Broadcast(EventId.GiftSystemPlayEffect, data)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftSpecialAnimShow, {anim = true}, data)
  end
end

function GiftSystemManager:GetGiftEffectState()
  return self.canPlayEffect
end

function GiftSystemManager:SwitchGiftEffectState()
  self.canPlayEffect = not self.canPlayEffect
  CommonUtil.PlayerPrefsSetBool(CAN_PLAY_EFFECT_KEY, self.canPlayEffect)
end

function GiftSystemManager:OpenOperationView(data)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftOperation_v2, {anim = true}, data)
end

function GiftSystemManager:OpenDetailView(param, isNewUI)
  local template = param.template
  local goods = self:GetGiftGoods(template.id)
  if goods.group_id and next(goods.group_id) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGroupGiftDetail, {anim = true}, param)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftDetail_v2, {anim = true}, param)
end

function GiftSystemManager.GetGiftIconParam(temp)
  local hOffset = 0
  local minScale = 0.3
  local midScale = 0.6
  local maxScale = 1
  if temp and #temp.spine_param == 4 then
    hOffset = temp.spine_param[1]
    minScale = temp.spine_param[2]
    midScale = temp.spine_param[3]
    maxScale = temp.spine_param[4]
  end
  return hOffset, minScale, midScale, maxScale
end

function GiftSystemManager:GetDefaultMsgKey(goodsId, num)
  if num == nil then
    num = 1
  end
  local msgKey = "gift_msg_default_des"
  local curCanEditor = 1
  local temp = self:GetGiftGoods(goodsId)
  if temp then
    local groupIndex = 1
    if #temp.group_id > 0 then
      for i, v in ipairs(temp.group_id) do
        if num >= tonumber(v) then
          groupIndex = i
        else
          break
        end
      end
    end
    for i, v in ipairs(temp.default_message) do
      if i <= groupIndex then
        msgKey = v
      else
        break
      end
    end
    for i, v in ipairs(temp.is_set_message) do
      if i <= groupIndex then
        curCanEditor = v
      else
        break
      end
    end
  end
  return msgKey, curCanEditor
end

function GiftSystemManager:GetSelfReceiveGiftTypeNum()
  local typeNum = 0
  local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_162)
  if items and 0 < #items then
    typeNum = #items
  end
  return typeNum
end

function GiftSystemManager:GetGiftShowUnlockMaxNum()
  if self.giftShowUnlockMaxNum == nil then
    self.giftShowUnlockMaxNum = DataCenter.GiftUnlockTemplateManager:GetAllNum()
  end
  return self.giftShowUnlockMaxNum
end

function GiftSystemManager:GetGiftShowUnlockCurNum()
  if self.giftShowUnlockCurNum == nil then
    self.giftShowUnlockCurNum = 0
  end
  local maxNum = self:GetGiftShowUnlockMaxNum()
  if maxNum > self.giftShowUnlockCurNum then
    local getTypeNum = self:GetSelfReceiveGiftTypeNum()
    for i = self.giftShowUnlockCurNum + 1, maxNum do
      local temp = DataCenter.GiftUnlockTemplateManager:GetTemplate(i)
      if temp and temp.unlock_condition_arr and #temp.unlock_condition_arr == 2 and temp.unlock_condition_arr[1] == GiftShowUnlockType.GetGiftTypeNum then
        if getTypeNum >= temp.unlock_condition_arr[2] then
          self.giftShowUnlockCurNum = i
        else
          break
        end
      else
      end
    end
  end
  return self.giftShowUnlockCurNum
end

function GiftSystemManager:GetGiftShowCurNum()
  if self.giftShowUnlockCurShowNum == nil then
    local curNum = self:GetGiftShowUnlockCurNum()
    self.giftShowUnlockCurShowNum = curNum
  end
  local maxNum = self:GetGiftShowUnlockMaxNum()
  if maxNum > self.giftShowUnlockCurShowNum then
    local getTypeNum = self:GetSelfReceiveGiftTypeNum()
    for i = self.giftShowUnlockCurShowNum + 1, maxNum do
      local temp = DataCenter.GiftUnlockTemplateManager:GetTemplate(i)
      if temp and temp.show_condition_arr and #temp.show_condition_arr == 2 and temp.show_condition_arr[1] == GiftShowUnlockType.GetGiftTypeNum then
        if getTypeNum >= temp.show_condition_arr[2] then
          self.giftShowUnlockCurShowNum = i
        else
          break
        end
      else
      end
    end
  end
  return self.giftShowUnlockCurShowNum
end

function GiftSystemManager:GetGiftShowIndexTipStr(tempId)
  local tipStr = ""
  local temp = DataCenter.GiftUnlockTemplateManager:GetTemplate(tempId)
  if temp and temp.unlock_condition_arr and #temp.unlock_condition_arr == 2 and temp.unlock_condition_arr[1] == GiftShowUnlockType.GetGiftTypeNum then
    tipStr = Localization:GetString("gift_unlock_tips2", temp.unlock_condition_arr[2])
  else
  end
  return tipStr
end

function GiftSystemManager:TrySetGiftShowTipStateDict()
  if self.giftShowTipStateDict == nil then
    self.giftShowTipStateDict = {}
    local dataStr = DataCenter.GuideRecordDataManager:GetRecordTabData(GuidServerRecordType.GiftShowIndexTipState)
    if not string.IsNullOrEmpty(dataStr) then
      self.giftShowTipStateDict = string.string2table_ii(dataStr, ";", "|")
    end
  end
end

function GiftSystemManager:GetGiftShowTipStateType(index)
  self:TrySetGiftShowTipStateDict()
  local state = GiftShowIndexTipStateType.None
  if self.giftShowTipStateDict[index] then
    state = self.giftShowTipStateDict[index]
  end
  return state
end

function GiftSystemManager:SetGiftShowTipStateType(index, state)
  self:TrySetGiftShowTipStateDict()
  self.giftShowTipStateDict[index] = state
  local recordStr = ""
  local haveAddNum = 0
  for k, v in pairs(self.giftShowTipStateDict) do
    if 0 < haveAddNum then
      recordStr = recordStr .. "|"
    end
    recordStr = recordStr .. k .. ";" .. v
    haveAddNum = haveAddNum + 1
  end
  if not string.IsNullOrEmpty(recordStr) then
    DataCenter.GuideRecordDataManager:SetRecordTabDataByMsg(GuidServerRecordType.GiftShowIndexTipState, recordStr)
  end
end

function GiftSystemManager:GetIsGiftShowAutoAni(val)
  local isPlay = false
  if val == GiftShowAutoAniVal.Play or string.IsNullOrEmpty(val) then
    isPlay = true
  end
  return isPlay
end

function GiftSystemManager:SetIsGiftShowAutoAni(val)
  local recordVal = GiftShowAutoAniVal.Play
  if val then
    recordVal = GiftShowAutoAniVal.Play
  else
    recordVal = GiftShowAutoAniVal.Stop
  end
  return recordVal
end

function GiftSystemManager:GetSelfIsGiftShowAutoAni()
  local selfVal = DataCenter.GuideRecordDataManager:GetRecordTabData(GuidServerRecordType.GiftShowAutoAni)
  return self:GetIsGiftShowAutoAni(selfVal)
end

function GiftSystemManager:SetSelfIsGiftShowAutoAni(val)
  local setVal = self:SetIsGiftShowAutoAni(val)
  DataCenter.GuideRecordDataManager:SetRecordTabDataByMsg(GuidServerRecordType.GiftShowAutoAni, setVal)
end

function GiftSystemManager:CheckGiftOrderActPass(giftTemp)
  local isPass = false
  if giftTemp and giftTemp.order_by_activity > 0 and DataCenter.ActivityListDataManager:CheckIfActivityOpen(nil, giftTemp.order_by_activity) then
    isPass = true
  end
  return isPass
end

function GiftSystemManager:GetIsPartner(panelType, uid, serverId)
  local playerInfo
  local EnumPanelType = GiftSystemConst.GiftSendPanelType
  if panelType == EnumPanelType.Desert then
    local info = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(uid)
    return info ~= nil
  elseif panelType == EnumPanelType.WarZone then
    return DataCenter.ZoneWarManager:IsAlly(serverId)
  elseif panelType == EnumPanelType.Canyon then
    return true
  elseif panelType == EnumPanelType.Winter then
    local camp = DataCenter.ActWinterStormManager:GetWorldCampInWinterStorm(uid)
    return camp == WorldCamp.WsTeammate
  end
end

function GiftSystemManager:GetGiftListByType(playerUid, panelType, serverId)
  local template = DataCenter.GiftQuickSendTemplateManager:GetTemplate(panelType)
  if template then
    if self:GetIsPartner(panelType, playerUid, serverId) then
      return template.show_gift_friend
    else
      return template.show_gift_enemy
    end
  end
end

function GiftSystemManager:GetHasGiftList(playerUid, panelType, serverId)
  local gifts = self:GetGiftListByType(playerUid, panelType, serverId)
  local goodsList = {}
  local goods
  for i = 1, #gifts do
    goods = gifts[i]
    local count = self:GetGiftNum(goods)
    if count and 0 < count then
      table.insert(goodsList, goods)
    end
  end
  return goodsList
end

function GiftSystemManager:GetPanelGift(playerUid, panelType)
  if not playerUid or not panelType then
    return
  end
  local battleId, groupId
  if panelType == GiftSystemConst.GiftSendPanelType.Desert then
    groupId = DataCenter.ActDragonManager:GetCurGroupIdx()
    local battleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
    if battleInfo then
      battleId = ChatInterface.getAllianceId() .. "_" .. battleInfo.battleEndTime .. "_" .. groupId
    end
  elseif panelType == GiftSystemConst.GiftSendPanelType.WarZone then
    local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
    if roundInfo then
      local curVsRound = roundInfo.curVsRound[1]
      battleId = curVsRound and curVsRound.ownerId
    end
  end
  if battleId then
    SFSNetwork.SendMessage(MsgDefines.GetUserReceiveGift, playerUid, panelType, battleId, groupId)
  end
end

function GiftSystemManager:SendReceiveGift(giftId, playerUid, panelType)
  if not (playerUid and panelType) or not giftId then
    return
  end
  if panelType == GiftSystemConst.GiftSendPanelType.Desert then
    local groupIndex = DataCenter.ActDragonManager:GetCurGroupIdx()
    local battleInfo = DataCenter.ActDragonManager:GetCurBattleInfo()
    if battleInfo then
      local battleId = ChatInterface.getAllianceId() .. "_" .. battleInfo.battleEndTime .. "_" .. groupIndex
      SFSNetwork.SendMessage(MsgDefines.SendUserReceiveGift, giftId, playerUid, panelType, battleId, groupIndex)
    end
  elseif panelType == GiftSystemConst.GiftSendPanelType.WarZone then
    local roundInfo = DataCenter.ZoneWarManager:GetCrossKingRoundInfoNow()
    if roundInfo then
      local curVsRound = roundInfo.curVsRound[1]
      SFSNetwork.SendMessage(MsgDefines.SendUserReceiveGift, giftId, playerUid, panelType, curVsRound.ownerId)
    end
  else
    self:SendGift(giftId, playerUid, false, "", 1, 0, true)
  end
end

function GiftSystemManager:HandleReceiveGift(message)
  if not message.giveInfo then
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OnReceiveGiftList, message)
end

function GiftSystemManager:GetGiftIconByGroup(itemId, itemCount)
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(itemId)
  itemCount = itemCount or 0
  if goods then
    local iconName = goods.icon_big
    if 0 < #goods.group_id and 0 < itemCount then
      local groupIndex = 1
      for i, v in ipairs(goods.group_id) do
        if itemCount >= tonumber(v) then
          groupIndex = i
        else
          break
        end
      end
      iconName = goods.group_pic[groupIndex]
    end
    return GiftSystemConst.GetIconPathNew(iconName)
  end
end

function GiftSystemManager:QualityIcon(itemId)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if template then
    return GiftSystemConst.GetPlayerInfoQualityIcon(template.color)
  end
end

function GiftSystemManager:IsCanShowQuickBtn(panelType)
  local temp = DataCenter.GiftQuickSendTemplateManager:GetTemplate(panelType)
  local isQuickView = temp ~= nil
  return IsGiftSystemOpen and isQuickView
end

function GiftSystemManager:ShowQuick(param)
  if not param.playerUid or not param.openType then
    return
  end
  if param.playerUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("fastsendgift_tips1")
  elseif #self:GetHasGiftList(param.playerUid, param.openType, param.serverId) == 0 then
    UIUtil.ShowTipsId("fastsendgift_tips2")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIQuickGift, {anim = false}, param)
  end
end

function GiftSystemManager:CanShowGiftBubble(itemId, itemCount)
  local goods = DataCenter.GiftSystemManager:GetGiftGoods(itemId)
  itemCount = itemCount or 1
  local isCanShow = goods
  local showTag
  if #goods.group_id > 0 then
    local groupIndex = 1
    for i, v in ipairs(goods.group_id) do
      if itemCount >= tonumber(v) then
        groupIndex = i
      else
        break
      end
    end
    showTag = goods.gift_bubble[groupIndex]
    return showTag and showTag == "1"
  else
    showTag = goods.gift_bubble[1]
    return showTag and showTag == "1"
  end
end

GiftSystemManager.__init = __init
GiftSystemManager.__delete = __delete
GiftSystemManager.AddListener = AddListener
GiftSystemManager.RemoveListener = RemoveListener
GiftSystemManager.InitData = InitData
return GiftSystemManager
