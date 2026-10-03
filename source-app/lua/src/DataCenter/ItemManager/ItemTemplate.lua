local base = require("Common.TemplateBase")
local ItemTemplate = BaseClass("ItemTemplate", base)

function ItemTemplate:OnCreate()
  self.orderCache = nil
  self.orderCacheTime = nil
end

function ItemTemplate:OnDestroy()
  self.orderCache = nil
  self.orderCacheTime = nil
end

function ItemTemplate:InitData(row, seasonIndex)
  if row == nil then
    return
  end
  if row == nil then
    return
  end
  local tbl_index, tbl_data, tbl_ext = row:getMetaData()
  base.SetRowData(self, tbl_index, tbl_data, tbl_ext)
  self.id = tostring(self.id)
  self.type = self:getValue("type")
  local temp = self:getValue("type2")
  if temp ~= nil and temp ~= "" then
    self.type2 = tonumber(temp) or -1
    if self.type2 == 10 or self.type2 == 13 then
      self:UpdateItemSkin(seasonIndex)
    end
  else
    self.type2 = -1
  end
end

function ItemTemplate:UpdateItemSkin(seasonIndex)
  local goodSkin = DataCenter.ItemTemplateManager:GetItemSkin(self.id, seasonIndex)
  if goodSkin then
    if not string.IsNullOrEmpty(goodSkin.icon) then
      self.icon = goodSkin.icon
    end
    if not string.IsNullOrEmpty(goodSkin.description) then
      self.description = goodSkin.description
    end
    if not string.IsNullOrEmpty(goodSkin.name) then
      self.name = goodSkin.name
    end
    if not string.IsNullOrEmpty(goodSkin.name_value) then
      local name, value = string.match(goodSkin.name_value, "([^|]+)|([^|]+)")
      if name and value then
        self.name_value = {
          [name] = value
        }
      end
    end
  end
end

function ItemTemplate.getters:name()
  return self:getValue("name")
end

function ItemTemplate.getters:icon()
  self.icon = self:getValue("icon", "")
  if LuaEntry.Player.JPUser then
    local jpIcon = DataCenter.LWSaveGirlManager:GetJPGoodsIcon(self.id)
    if not string.IsNullOrEmpty(jpIcon) then
      self.icon = jpIcon
    end
  end
  return self.icon
end

function ItemTemplate.getters:description()
  return self:getValue("description")
end

function ItemTemplate.getters:para()
  return self:getValue("c_para")
end

function ItemTemplate.getters:color()
  return self:getValue("color")
end

function ItemTemplate.getters:quality()
  return self:getValue("color")
end

function ItemTemplate.getters:order()
  return self:GetOrder()
end

function ItemTemplate.getters:lv()
  return self:getValue("lv")
end

function ItemTemplate.getters:version()
  return self:getValue("version")
end

function ItemTemplate.getters:page()
  return self:getValue("page")
end

function ItemTemplate.getters:pages()
  return self:getValue("pages")
end

function ItemTemplate.getters:useall()
  return self:getValue("useall")
end

function ItemTemplate.getters:use()
  return self:getValue("use")
end

function ItemTemplate.getters:overdue()
  return self:getValue("overdue")
end

function ItemTemplate.getters:activtiy_around()
  return self:getValue("activtiy_around")
end

function ItemTemplate.getters:para1()
  return self:getValue("c_para1")
end

function ItemTemplate.getters:para2()
  return self:getValue("c_para2")
end

function ItemTemplate.getters:para3()
  return self:getValue("c_para3")
end

function ItemTemplate.getters:para4()
  return self:getValue("c_para4")
end

function ItemTemplate.getters:para5()
  return self:getValue("c_para5")
end

function ItemTemplate.getters:para6()
  return self:getValue("c_para6")
end

function ItemTemplate.getters:name_link()
  return self:getValue("name_link")
end

function ItemTemplate.getters:name_value()
  return self:getValue("name_value")
end

function ItemTemplate.getters:pagehot()
  return self:getValue("pagehot")
end

function ItemTemplate.getters:go_to()
  return self:getValue("go_to")
end

function ItemTemplate.getters:join_method()
  return self:getValue("join_method")
end

function ItemTemplate.getters:icon_join()
  return self:getValue("icon_join")
end

function ItemTemplate.getters:price()
  return self:getValue("price")
end

function ItemTemplate.getters:price_all()
  return self:getValue("price_all")
end

function ItemTemplate.getters:alliance_order()
  return self:getValue("alliance_order")
end

function ItemTemplate.getters:important()
  return self:getValue("important")
end

function ItemTemplate.getters:needCount()
  return self:getIntValue("needCount")
end

function ItemTemplate.getters:rate_show()
  return self:getValue("rate_show")
end

function ItemTemplate.getters:default_useCount()
  return self:getIntValue("default_useCount", 1)
end

function ItemTemplate.getters:drop_info_para()
  return self:getIntValue("drop_info_para")
end

function ItemTemplate.getters:sales()
  local self_sales = {}
  local sales = self:getValue("sales")
  if sales ~= nil and sales ~= "" then
    local spl1 = string.split_ss_array(sales, "|")
    for k, v in ipairs(spl1) do
      local spl2 = string.split_ii_array(v, ";")
      if table.count(spl2) > 1 then
        local vec = {}
        vec.count = spl2[1]
        vec.price = spl2[2]
        table.insert(self_sales, vec)
      end
    end
  end
  self.sales = self_sales
  return self_sales
end

function ItemTemplate.getters:allianceNum()
  local tempAllianceNum = self:getValue("allianceNum")
  if tempAllianceNum ~= nil and tempAllianceNum ~= "" then
    self.allianceNum = tonumber(tempAllianceNum)
  else
    self.allianceNum = -1
  end
  return self.allianceNum
end

local function fetch_linked_item(self)
  if self._linked_item_type == nil then
    local linked_item = self:getValue("linked_item")
    if linked_item ~= nil and linked_item ~= "" then
      local spl1 = string.split_ss_array(linked_item, ";")
      self._linked_item_type = tonumber(spl1[1])
      self._linked_item_id = tonumber(spl1[2])
    else
      self._linked_item_id = 0
      self._linked_item_type = ItemLinkType.None
    end
  end
  return self._linked_item_type
end

function ItemTemplate.getters:linked_item_type()
  fetch_linked_item(self)
  return self._linked_item_type
end

function ItemTemplate.getters:linked_item_id()
  fetch_linked_item(self)
  return self._linked_item_id
end

function ItemTemplate.getters:recycled_item()
  return self:getValue("recycled_item") or ""
end

function ItemTemplate.getters:recovery()
  return self:getValue("recovery") or {}
end

function ItemTemplate.getters:tipsType()
  return self:getIntValue("tips_type")
end

function ItemTemplate.getters:tipsPara1()
  return self:getValue("tips_para1") or ""
end

function ItemTemplate.getters:tipsPara2()
  return self:getValue("tips_para2") or ""
end

function ItemTemplate.getters:tipsPara3()
  return self:getValue("tips_para3") or ""
end

function ItemTemplate.getters:popupType()
  return self:getValue("popup_type") or 0
end

function ItemTemplate.getters:goto_para()
  return self:getValue("goto_para") or ""
end

function ItemTemplate.getters:recruitOrder()
  return self:getValue("recruit_order") or 0
end

function ItemTemplate.getters:serverPara1()
  return self:getValue("para1") or 0
end

function ItemTemplate.getters:serverPara2()
  return self:getValue("para2") or 0
end

function ItemTemplate.getters:serverPara3()
  return self:getValue("para3") or 0
end

function ItemTemplate.getters:show_will_expire()
  return self:getIntValue("show_will_expire")
end

function ItemTemplate.getters:is_single_show()
  return self:getIntValue("is_single_show")
end

function ItemTemplate.getters:special_order()
  return self:getValue("special_order")
end

function ItemTemplate:GetDetailInfo(seasonIndex)
  local icon = self.icon
  local name = self.name
  local desc = self.description
  local name_value = self.name_value
  local goodSkin = DataCenter.ItemTemplateManager:GetItemSkin(self.id, seasonIndex)
  if goodSkin then
    if not string.IsNullOrEmpty(goodSkin.icon) then
      icon = goodSkin.icon
    end
    if not string.IsNullOrEmpty(goodSkin.description) then
      desc = goodSkin.description
    end
    if not string.IsNullOrEmpty(goodSkin.name) then
      name = goodSkin.name
    end
    if not string.IsNullOrEmpty(goodSkin.name_value) then
      local _name, _value = string.match(goodSkin.name_value, "([^|]+)|([^|]+)")
      if _name and _value then
        name_value = {
          [_name] = _value
        }
      end
    end
  end
  return icon, name, desc, name_value
end

function ItemTemplate:GetName()
  if self.name_value then
    for k, v in pairs(self.name_value) do
      if k and v then
        return CS.GameEntry.Localization:GetString(k, v)
      end
    end
  end
  if not string.IsNullOrEmpty(self.name) then
    return CS.GameEntry.Localization:GetString(self.name)
  end
  return ""
end

function ItemTemplate:IsSelectBox()
  local type = tonumber(self.type)
  return type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_102 or type == GOODS_TYPE.GOODS_TYPE_107
end

function ItemTemplate:IsGuarantBox()
  if self:IsSelectBox() or tonumber(self.type) == GOODS_TYPE.GOODS_TYPE_5 then
    local para3 = string.split(self.para3, ";")
    local guarantId = tonumber(para3[1])
    if not string.IsNullOrEmpty(guarantId) then
      return true
    end
  end
  return false
end

function ItemTemplate:GetTipsDescription()
  if self.tipsType == GOODS_TIPS_TYPE.Box or self.tipsType == GOODS_TIPS_TYPE.BoxWithoutProbability or self.tipsType == GOODS_TIPS_TYPE.BoxTag or self.tipsType == GOODS_TIPS_TYPE.BoxTacticalCard then
    if not string.IsNullOrEmpty(self.tipsPara3) then
      local tabData = LocalController:instance():getLine(TableName.Activity, toInt(self.tipsPara3))
      if tabData ~= nil and not string.IsNullOrEmpty(tabData.name) then
        return CS.GameEntry.Localization:GetString(self.tipsPara1, CS.GameEntry.Localization:GetString(tabData.name))
      end
    end
    return CS.GameEntry.Localization:GetString(self.tipsPara1)
  end
  return ""
end

function ItemTemplate:GetTipsPara2Data()
  if self.tipsType == GOODS_TIPS_TYPE.Box then
    local res = {}
    if not string.IsNullOrEmpty(self.tipsPara2) then
      local strList = string.split(self.tipsPara2, "|")
      if 0 < #strList then
        for i, v in pairs(strList) do
          local strPair = string.split(v, ";")
          if #strPair == 3 then
            table.insert(res, {
              itemId = tonumber(strPair[1]),
              count = tonumber(strPair[2]),
              probability = tonumber(strPair[3])
            })
          end
        end
      end
    end
    return res
  end
  if self.tipsType == GOODS_TIPS_TYPE.BoxWithoutProbability then
    local res = {}
    if not string.IsNullOrEmpty(self.tipsPara2) then
      local strList = string.split(self.tipsPara2, "|")
      if 0 < #strList then
        for i, v in pairs(strList) do
          local strPair = string.split(v, ";")
          if #strPair == 2 then
            table.insert(res, {
              itemId = tonumber(strPair[1]),
              count = tonumber(strPair[2])
            })
          end
        end
      end
    end
    return res
  end
  return nil
end

function ItemTemplate:GetTipsPara2DataWithTag()
  local res = {}
  if self.tipsType == GOODS_TIPS_TYPE.BoxTag then
    if not string.IsNullOrEmpty(self.tipsPara2) then
      local strList = string.split(self.tipsPara2, "|")
      if 0 < #strList then
        for i, v in pairs(strList) do
          local strPair = string.split(v, ";")
          if #strPair == 3 then
            local tagType = tonumber(strPair[1])
            local tagData = {
              itemId = tonumber(strPair[2]),
              count = tonumber(strPair[3])
            }
            if res[tagType] == nil then
              res[tagType] = {}
            end
            table.insert(res[tagType], tagData)
          end
        end
      end
    end
  else
    local tagType = CapacityBoxTagType.default
    local resData = self:GetTipsPara2Data()
    if resData and 0 < #resData then
      res[tagType] = resData
    end
  end
  return res
end

function ItemTemplate:GetGotoParaData()
  if self.goto_para_data == nil then
    self.goto_para_data = {}
    if not string.IsNullOrEmpty(self.goto_para) then
      local strList = string.split(self.goto_para, "|")
      if #strList == 2 then
        self.goto_para_data.type = tonumber(strList[1])
        local gotoData = string.split(strList[2], ";")
        if #gotoData == 2 then
          self.goto_para_data.gotoType = tonumber(gotoData[1])
          self.goto_para_data.gotoPara = tonumber(gotoData[2])
        end
      end
    end
  end
  return self.goto_para_data
end

function ItemTemplate:CheckCondition(condition)
  if string.IsNullOrEmpty(condition) then
    return false
  end
  local dataList = string.split(condition, "|")
  if #dataList ~= 2 then
    return false
  end
  local result = false
  CommonUtil.ProtectCall(function()
    local condType = dataList[1]
    local condDataStr = dataList[2]
    if condType == "1" then
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local absoluteTime = UIUtil.GetAbsoluteTimeByStr(condDataStr)
      if absoluteTime then
        result = curTime >= absoluteTime
      end
    elseif condType == "2" then
      local openDay = tonumber(condDataStr)
      if openDay then
        local serverOpenDays = UITimeManager:GetInstance():GetServerOpenDays()
        result = openDay <= serverOpenDays
      end
    elseif condType == "3" then
      local condData = string.split(condDataStr, ";")
      if #condData ~= 2 then
        return false
      end
      local needSeason = tonumber(condData[1])
      local needSeasonDay = tonumber(condData[2])
      if needSeason and needSeasonDay then
        local seasonNum = SeasonUtil.GetSeason()
        local seasonDay = SeasonUtil.GetSeasonDay()
        if needSeason < seasonNum then
          result = true
        elseif seasonNum == needSeason then
          result = needSeasonDay <= seasonDay
        end
      end
    elseif condType == "4" then
      local condData = string.split(condDataStr, ";")
      if #condData ~= 2 then
        return false
      end
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local actStartTime = self:GetActStartTime(condData[1])
      if 0 < actStartTime then
        result = curTime >= actStartTime + (tonumber(condData[2]) - 1) * (OneDayTime * 1000)
      end
    end
  end)
  return result
end

function ItemTemplate:GetActStartTime(actId)
  local time = 0
  local tabData = LocalController:instance():tryGetLine(TableName.Activity, toInt(actId))
  local AbsoluteTimeType = "101"
  if tabData and tabData.timeType == AbsoluteTimeType then
    local startTimeStr = tabData.para1
    local absoluteTime = UIUtil.GetAbsoluteTimeByStr(startTimeStr)
    if absoluteTime then
      time = absoluteTime * 1000
    end
  end
  return time
end

function ItemTemplate:GetOrder()
  local now = UITimeManager:GetInstance():GetServerTime()
  if type(self.orderCache) == "number" and self.orderCacheTime then
    local day1 = UITimeManager:GetInstance():GetTodayZeroServerTime(now // 1000)
    local day2 = UITimeManager:GetInstance():GetTodayZeroServerTime(self.orderCacheTime // 1000)
    if day1 == day2 then
      return self.orderCache
    end
  end
  self.orderCacheTime = now
  if string.IsNullOrEmpty(self.special_order) then
    self.orderCache = tonumber(self:getValue("order_num"))
    return tonumber(self:getValue("order_num"))
  end
  if LocalController:instance():hasTable(TableName.GOODS_ORDER_CONFIG) then
    local config = LocalController:instance():tryGetLine(TableName.GOODS_ORDER_CONFIG, self.special_order)
    if self:CheckCondition(config.condition) then
      self.orderCache = tonumber(config.order_number)
      return tonumber(config.order_number)
    end
  end
  self.orderCache = tonumber(self:getValue("order_num"))
  return tonumber(self:getValue("order_num"))
end

function ItemTemplate:IsType59ItemContain(itemId)
  if tonumber(self.type) ~= GOODS_TYPE.GOODS_TYPE_59 then
    return false
  end
  if string.IsNullOrEmpty(self.para1) then
    return false
  end
  if self.para1Dic == nil then
    self.para1Dic = {}
    local para1Strs = string.split(self.para1, "|")
    for _, itemStr in pairs(para1Strs) do
      local itemInfos = string.split(itemStr, ",")
      local targetItemId = 0
      if #itemInfos == 2 then
        targetItemId = itemInfos[1]
      elseif #itemInfos == 3 then
        targetItemId = itemInfos[2]
      end
      if targetItemId ~= 0 then
        self.para1Dic[targetItemId] = true
      end
    end
  end
  local isContain = self.para1Dic[itemId]
  return isContain
end

return ItemTemplate
