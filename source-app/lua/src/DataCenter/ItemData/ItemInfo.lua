local ItemInfo = BaseClass("ItemInfo")
local PlayerPrefs = CS.UnityEngine.PlayerPrefs
local rapidjson = require("rapidjson")

local function __init(self)
  self.itemId = ""
  self.use = ""
  self.count = 0
  self.preCount = 0
  self.newCount = 0
  self.para1 = ""
  self.para2 = ""
  self.para3 = ""
  self.para4 = ""
  self.uuid = ""
  self.cbitem = ""
  self.cbpart = ""
  self.cbnum = ""
  self.rightseffect = ""
end

local function __delete(self)
  self.itemId = nil
  self.use = nil
  self.count = nil
  self.preCount = nil
  self.para1 = nil
  self.para2 = nil
  self.para3 = nil
  self.para4 = nil
  self.uuid = nil
  self.cbitem = nil
  self.cbpart = nil
  self.cbnum = nil
  self.rightseffect = nil
end

local function UpdateInfo(self, message, isInit)
  if message == nil then
    return
  end
  local lastCount = self.count
  if message.itemId ~= nil then
    self.itemId = message.itemId
  end
  if message.goodsId ~= nil then
    self.itemId = message.goodsId
  end
  if message.use ~= nil then
    self.use = message.use
  end
  if message.count ~= nil then
    self.preCount = self.count
    self.count = message.count
  end
  if message.addNum ~= nil then
    self.preCount = self.count
    self.count = self.count + message.addNum
  end
  if message.num ~= nil then
    self.preCount = self.count
    self.count = message.num
  end
  if message.itemLeftCnt ~= nil then
    self.preCount = self.count
    self.count = message.itemLeftCnt
  end
  if message.para1 ~= nil then
    self.para1 = message.para1
  end
  if message.para2 ~= nil then
    self.para2 = message.para2
  end
  if message.para3 ~= nil then
    self.para3 = message.para3
  end
  if message.para4 ~= nil then
    self.para4 = message.para4
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.cbitem ~= nil then
    self.cbitem = message.cbitem
  end
  if message.cbnum ~= nil then
    self.cbnum = message.cbnum
  end
  if message.cbpart ~= nil then
    self.cbpart = message.cbpart
  end
  if message.rightseffect ~= nil then
    self.rightseffect = message.rightseffect
  end
  if not self.goods then
    self.goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  end
  if message.otherPara ~= nil and not string.IsNullOrEmpty(message.otherPara) then
    self.otherParam = message.otherPara
    self.otherParamTab = nil
  end
  if not self.goods then
    Logger.LogError("Goods not found:" .. self.itemId)
  elseif self.goods.important == 2 then
    if lastCount ~= self.count then
      EventManager:GetInstance():DelayBroadcast(0.1, EventId.RefreshBagRedDot)
    end
  elseif self.goods.important == 1 then
    if lastCount ~= self.count and not isInit then
      local count = CommonUtil.PlayerPrefsGetInt(self.uuid, 0)
      if self.count == 0 then
        self.newCount = self.count
      else
        self.newCount = count + (self.count - lastCount)
      end
      CommonUtil.PlayerPrefsSetInt(self.uuid, self.newCount)
      self:HandleSpecialItem()
      EventManager:GetInstance():DelayBroadcast(0.1, EventId.RefreshBagRedDot)
    elseif isInit then
      self.newCount = CommonUtil.PlayerPrefsGetInt(self.uuid, 0)
    end
  end
end

local function HandleSpecialItem(self)
  if tonumber(self.itemId) == 653052 then
    CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAT_BOTTOM_FUNC_RED_DOT_BY_RED_PACKET, self.newCount)
  end
end

local function SetNewCount(self)
  CommonUtil.PlayerPrefsSetInt(self.uuid, 0)
  self.newCount = 0
  EventManager:GetInstance():DelayBroadcast(0.1, EventId.RefreshBagRedDot)
end

local function GetComposeInfo(self, vec1, vec2, vec3)
  local para1, para2, para3
  if haveEff and LuaEntry.DataConfig:CheckSwitch("combination") and self.cbitem ~= nil and self.cbitem ~= "" and self.cbnum ~= nil and self.cbnum ~= "" and self.cbpart ~= nil and self.cbpart ~= "" then
    para1 = string.split(self.cbitem, "\\")
    para2 = string.split(self.cbpart, "\\")
    para3 = string.split(self.cbnum, "\\")
  else
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if template ~= nil then
      if template.type == GOODS_TYPE.GOODS_TYPE_23 then
        para1 = string.split(self.para3, "\\")
        para2 = string.split(self.itemId, "\\")
        para3 = string.split(self.para4, "\\")
      else
        para1 = string.split(self.para1, "\\")
        para2 = string.split(self.para2, "\\")
        para3 = string.split(self.para2, "\\")
      end
    end
  end
  if #para1 <= 0 or #para1 ~= #para2 or #para2 ~= #para3 then
    return false
  end
  for i = 1, #para1 do
    local temp2 = string.split(para2[i], ";")
    local temp3 = string.split(para3[i], ";")
    if 0 < #temp2 and #temp2 == #para3 then
      for j = 1, #temp2 do
        table.insert(vec1, para1[i])
        table.insert(vec2, temp2[j])
        table.insert(vec3, temp3[j])
      end
    end
  end
  return true
end

local function GetOtherParamTab(self)
  if self.otherParamTab == nil then
    if not string.IsNullOrEmpty(self.otherParam) then
      self.otherParamTab = rapidjson.decode(self.otherParam)
    else
      self.otherParamTab = {}
    end
  end
  return self.otherParamTab
end

local function CheckIsExpireInOtherParamData(self)
  local isExpire = false
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local otherParamTab = self:GetOtherParamTab()
  if otherParamTab and otherParamTab.expireTime and curTime >= otherParamTab.expireTime then
    isExpire = true
  end
  return isExpire
end

ItemInfo.__init = __init
ItemInfo.__delete = __delete
ItemInfo.UpdateInfo = UpdateInfo
ItemInfo.GetNewCount = GetNewCount
ItemInfo.GetComposeInfo = GetComposeInfo
ItemInfo.SetNewCount = SetNewCount
ItemInfo.HandleSpecialItem = HandleSpecialItem
ItemInfo.GetOtherParamTab = GetOtherParamTab
ItemInfo.CheckIsExpireInOtherParamData = CheckIsExpireInOtherParamData
return ItemInfo
