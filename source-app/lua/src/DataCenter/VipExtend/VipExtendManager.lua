local VipExtendManager = BaseClass("VipExtendManager")
local VipExtendCitySkinInfo = require("DataCenter.VipExtend.VipExtendCitySkinInfo")
local VipExtendDesignData = require("DataCenter.VipExtend.VipExtendDesignData")
local rapidjson = require("rapidjson")

function VipExtendManager:__init()
  self.designData = VipExtendDesignData.New()
  self.myselfSkinInfo = VipExtendCitySkinInfo.New()
  self.citySkinDicByConfigId = {}
  self.citySkinAllList = {}
  self.citySkinShowList = {}
  self.historyRecords = {}
  self.isLoading = false
  self.hasMoreRecords = true
  self.previousPage = 0
  self.recordIdSet = {}
  local vip18TabData = {
    id = 1,
    name = "vip18_extend_tab",
    assetPath = UIAssets.UIVipExtend18Design,
    cls = "UI.UIVipExtend.Component.Vip18.Vip18DesignPanel"
  }
  local skinTabData = {
    id = 2,
    name = "vip_base_skin_desc11",
    assetPath = UIAssets.UIVipExtend18Panel,
    cls = "UI.UIVipExtend.Component.Vip18.Vip18MainPanel"
  }
  self.vip18TabDataList = {}
  table.insert(self.vip18TabDataList, vip18TabData)
  table.insert(self.vip18TabDataList, skinTabData)
  self.normalTabDataList = {}
  table.insert(self.normalTabDataList, skinTabData)
  self.redK1List = string.split("1.2;1.3;2.2;2.4;3.2;3.4;4.2;4.4;5.2", ";")
  self.redK2List = string.split("1.4;2.3;2.5;2.6;3.3;3.5;3.6;4.3;4.5;4.6;5.3", ";")
  self:AddListeners()
end

function VipExtendManager:__delete()
  self.designData = nil
  self.myselfSkinInfo = nil
  self.citySkinDicByConfigId = nil
  self.citySkinAllList = nil
  self.citySkinShowList = nil
  self.vip18TabDataList = nil
  self.normalTabDataList = nil
  self.redK1List = nil
  self.redK2List = nil
  self:RemoveListeners()
end

function VipExtendManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.GF_item_refreshed, self.OnResOrItemUpdate)
end

function VipExtendManager:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.GF_item_refreshed, self.OnResOrItemUpdate)
end

function VipExtendManager.OnResOrItemUpdate(itemInfo)
  DataCenter.VipExtendManager:OpenUIVip18EnvelopView(itemInfo)
end

function VipExtendManager:OpenUIVip18EnvelopView(item)
  if item == nil then
    return
  end
  local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
  if tostring(envelopItemId) ~= item.itemId then
    return
  end
  if item.otherParam == nil then
    return
  end
  local serverData = rapidjson.decode(item.otherParam)
  if serverData == nil then
    return
  end
  local isExistReward = serverData.state == nil or toInt(serverData.state) == 0
  if isExistReward then
    PostEventLog.Track(PostEventLog.Defines.Vip18InvitationLetterOpen, {source = "auto_popup"})
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip18Envelop, {anim = false}, {
      itemId = item.itemId,
      uuid = item.uuid,
      otherParam = item.otherParam
    })
  end
end

function VipExtendManager:InitData(message)
  if message.vipDisplayType ~= nil then
    self.myselfSkinInfo.displayType = message.vipDisplayType
    if self:IsVip18() then
      SFSNetwork.SendMessage(MsgDefines.Vip18ProductionView)
    end
  end
end

function VipExtendManager:IsVip18SkinDoneAndReceived()
  local skinId = tonumber(self.myselfSkinInfo.displayPara2)
  local skinData = DataCenter.DecorationDataManager:GetSkinDataById(skinId)
  if self.myselfSkinInfo.displayType == 3 and skinData ~= nil then
    return true
  end
  return false
end

function VipExtendManager:IsVip18()
  if self.myselfSkinInfo.displayType ~= 0 then
    return true
  end
  local envelopItemId = LuaEntry.DataConfig:TryGetNum("vip_letter", "k2")
  local item = DataCenter.ItemData:GetItemById(envelopItemId)
  if item ~= nil then
    return true
  end
  return false
end

function VipExtendManager:CanConvertVip18TempSkin()
  return self.myselfSkinInfo.displayType == 3
end

function VipExtendManager:GetVipExtendDesignData()
  return self.designData
end

function VipExtendManager:UpdateVip18ProductionView(message)
  self.designData:UpdateData(message)
  EventManager:GetInstance():Broadcast(EventId.VipExtendDesignRefresh)
end

function VipExtendManager:OnGetCitySkinReward(message)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipExtendCitySkinGetShow)
  EventManager:GetInstance():Broadcast(EventId.VipExtendCitySkinGetReward)
end

function VipExtendManager:GenerateCitySkinRecordId(data)
  local playerId = data.playerInfo.uid == "" and data.playerId or data.playerInfo.uid
  return playerId .. "_" .. data.id
end

function VipExtendManager:FetchHistoryRecords(page)
  if self.isLoading then
    return
  end
  self.isLoading = true
  self.previousPage = page
  SFSNetwork.SendMessage(MsgDefines.VipExtendCitySkinList, page)
end

function VipExtendManager:LoadInitialHistory()
  self.historyRecords = {}
  self.recordIdSet = {}
  self.previousPage = 0
  self.hasMoreRecords = true
  self:FetchHistoryRecords(0)
end

function VipExtendManager:LoadMoreHistory()
  if not self.hasMoreRecords or self.isLoading then
    return
  end
  self:FetchHistoryRecords(self.previousPage + 1)
end

function VipExtendManager:OnRefreshCitySkinList(message)
  self.isLoading = false
  local myData = message.myData
  if myData ~= nil then
    self.myselfSkinInfo:UpdateInfo(myData)
  end
  if message.dataArr == nil then
    Logger.Log("dataArr is nil")
    return
  end
  local newRecords = message.dataArr or {}
  if #newRecords == 0 then
    self.hasMoreRecords = false
    return
  end
  local addedCount = 0
  for _, record in ipairs(newRecords) do
    if 0 > record.id then
      record.id = 999999
    end
    local recordId = self:GenerateCitySkinRecordId(record)
    if not self.recordIdSet[recordId] then
      self.recordIdSet[recordId] = true
      local skinInfo = VipExtendCitySkinInfo.New()
      skinInfo:UpdateInfo(record)
      table.insert(self.historyRecords, skinInfo)
      addedCount = addedCount + 1
    end
  end
  self.hasMoreRecords = 0 < addedCount
  EventManager:GetInstance():Broadcast(EventId.VipExtendCitySkinListUpdate)
end

function VipExtendManager:GetTypeDataList()
  if self:IsVip18() then
    return self.vip18TabDataList
  end
  return self.normalTabDataList
end

function VipExtendManager:GetMyselfSkinInfo()
  return self.myselfSkinInfo
end

function VipExtendManager:CheckRedDotByType(id)
  if id == 1 then
    return self:IsRed() or self:IsVip18ContactRed()
  end
  if id == 2 then
    return false
  end
  return false
end

function VipExtendManager:GetLastStageStr()
  local lastStageStr = CommonUtil.PlayerPrefsGetString("Vip18ExtendLastStage", "")
  return lastStageStr
end

function VipExtendManager:GetCurrentStageStr()
  local currentStageStr = self.designData.stage + 1 .. "." .. self.designData.subStage + 1
  return currentStageStr
end

function VipExtendManager:IsInRedK1List(currentStageStr)
  for i, v in ipairs(self.redK1List) do
    if v == currentStageStr then
      return true
    end
  end
  return false
end

function VipExtendManager:IsInRedK2List(currentStageStr)
  for i, v in ipairs(self.redK2List) do
    if v == currentStageStr then
      return true
    end
  end
  return false
end

function VipExtendManager:IsRed()
  if self:IsVip18() == false then
    return false
  end
  local lastStageStr = self:GetLastStageStr()
  local currentStageStr = self:GetCurrentStageStr()
  local isInRedK1List = self:IsInRedK1List(currentStageStr)
  local isInRedK2List = self:IsInRedK2List(currentStageStr)
  if (isInRedK1List or isInRedK2List) and lastStageStr ~= currentStageStr then
    return true
  end
  return false
end

function VipExtendManager:ClearRedPoint()
  local lastStageStr = self:GetLastStageStr()
  local currentStageStr = self:GetCurrentStageStr()
  if lastStageStr ~= currentStageStr then
    CommonUtil.PlayerPrefsSetString("Vip18ExtendLastStage", currentStageStr)
    EventManager:GetInstance():Broadcast(EventId.VipExtendDesignRedPoint)
  end
end

function VipExtendManager:IsVip18ContactRed()
  if self:IsVip18() == false then
    return false
  end
  return DataCenter.LWCustomerServiceManager:GetCustomerServiceRedPointData()
end

function VipExtendManager:SetCacheSkinData(id, skinInfo)
  self.cacheSkinId = id
  self.cacheSkinInfo = skinInfo
end

function VipExtendManager:GetCacheSkinData()
  return self.cacheSkinId, self.cacheSkinInfo
end

function VipExtendManager:GetContactUsUrlByLanguage()
  local map = {}
  local urlMapStr = LuaEntry.DataConfig:TryGetStr("vip_base_skin_model_config", "k2")
  local urlMapPairList = string.split(urlMapStr, "|")
  for i, v in ipairs(urlMapPairList) do
    if not string.IsNullOrEmpty(v) then
      local pair = string.split(v, ";")
      if 2 <= #pair then
        map[pair[1]] = pair[2]
      end
    end
  end
  local language = ChatInterface.getLanguageName()
  if map[language] then
    return map[language]
  else
    return map.Others
  end
end

function VipExtendManager:GetContactUsIcon()
  local url = self:GetContactUsUrlByLanguage()
  if string.find(url, "lin.ee") then
    return "Assets/Main/Sprites/UI/UIVipExtend18/wxy_v18_line.png"
  end
  if string.find(url, "kakao") then
    return "Assets/Main/Sprites/UI/UIVipExtend18/wxy_v18_kakao.png"
  end
  if string.find(url, "wa.me") then
    return "Assets/Main/Sprites/UI/UIVipExtend18/wxy_v18_whatsapp.png"
  end
  return "Assets/Main/Sprites/UI/UIVipExtend18/wxy_v18_whatsapp.png"
end

function VipExtendManager:ContactUsByLanguage()
  CS.SDKManager.OpenURL(self:GetContactUsUrlByLanguage())
end

return VipExtendManager
