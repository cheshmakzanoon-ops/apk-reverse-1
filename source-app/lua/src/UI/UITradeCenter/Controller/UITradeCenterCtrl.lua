local UITradeCenterCtrl = BaseClass("UITradeCenterCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITradeCenter, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomShow
  })
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurResourceChangeByTotal(self, curNum, maxNum, isAdd)
  local changeNum = 0
  if maxNum < 1000 then
    if isAdd then
      changeNum = curNum + 1
    else
      changeNum = curNum - 1
    end
  elseif 1000 <= maxNum and maxNum < 10000 then
    if isAdd then
      changeNum = curNum + 10
    else
      changeNum = curNum - 10
    end
  elseif 10000 <= maxNum and maxNum < 100000 then
    if isAdd then
      changeNum = curNum + 1000
    else
      changeNum = curNum - 1000
    end
  elseif 100000 <= maxNum then
    if isAdd then
      changeNum = curNum + 10000
    else
      changeNum = curNum - 10000
    end
  end
  if changeNum < 0 then
    changeNum = 0
  end
  return changeNum
end

local function InitData(self)
  self.tradeArr = {
    ResourceType.Oil,
    ResourceType.Metal,
    ResourceType.Water,
    ResourceType.Electricity
  }
  self.curCnt = {}
  self.maxCnt = {}
end

local function GetResTypeArray(self)
  return self.tradeArr
end

local function RefreshData(self, isSell, isClear)
  if isClear then
    self.curCnt = {}
    self.maxCnt = {}
  end
  if isSell then
    table.walk(self.tradeArr, function(k, v)
      if isClear then
        self:SetCurNumByResType(v, 0)
      end
      local resCnt = LuaEntry.Resource:GetCntByResType(v)
      local resCnt1 = DataCenter.TradeCenterDataManager:GetLeftTotalMoney() * (1 + math.modf(DataCenter.TradeCenterDataManager:GetTotalTexRateByResType(v) / 1000))
      local tempResult = math.min(resCnt, resCnt1)
      self:SetMaxNumByResType(v, math.max(0, tempResult))
    end)
  else
    local resourceMax = DataCenter.TradeCenterDataManager:GetCurrentMaxCanBuy()
    table.walk(self.tradeArr, function(k, v)
      if isClear then
        self:SetCurNumByResType(v, 0)
      end
      if resourceMax[v] ~= nil then
        self:SetMaxNumByResType(v, resourceMax[v])
      else
        self:SetMaxNumByResType(v, 0)
      end
    end)
  end
end

local function SetCurNumByResType(self, type, num)
  self.curCnt[type] = num
end

local function GetCurNumByResType(self, type)
  local ret = 0
  if self.curCnt[type] ~= nil then
    ret = self.curCnt[type]
  end
  return ret
end

local function SetMaxNumByResType(self, type, num)
  self.maxCnt[type] = num
end

local function GetMaxNumByResType(self, type)
  local ret = 0
  if self.maxCnt[type] ~= nil then
    ret = self.maxCnt[type]
  end
  return ret
end

local function GetTopNum(self)
  local canExchange = DataCenter.TradeCenterDataManager:GetLeftTotalMoney()
  local num = canExchange
  local strFmt = ""
  local fmt = "  "
  for i = 7, 1, -1 do
    local temp = math.modf(num / Mathf.Pow(10, i - 1))
    if i == 1 then
      strFmt = strFmt .. tostring(temp)
    else
      strFmt = strFmt .. tostring(temp) .. fmt
    end
    num = num - temp * Mathf.Pow(10, i - 1)
  end
  return strFmt
end

local function GetBottomNum(self, isSell)
  local readyToExchange = DataCenter.TradeCenterDataManager:GetCurrentCanGetMoney(self.curCnt)
  local canExchange = DataCenter.TradeCenterDataManager:GetLeftTotalMoney()
  local num = 0
  if isSell then
    num = math.min(readyToExchange, canExchange)
  else
    num = DataCenter.TradeCenterDataManager:GetCurrentNeedMoney(self.curCnt)
  end
  local strFmt = ""
  local fmt = "  "
  for i = 7, 1, -1 do
    local temp = math.modf(num / Mathf.Pow(10, i - 1))
    if i == 1 then
      strFmt = strFmt .. tostring(temp)
    else
      strFmt = strFmt .. tostring(temp) .. fmt
    end
    num = num - temp * Mathf.Pow(10, i - 1)
  end
  return strFmt
end

local function OnClickSell(self)
  local isNull = true
  table.walk(self.curCnt, function(k, v)
    if 1 <= v then
      isNull = false
    end
  end)
  if isNull then
    UIUtil.ShowTipsId(120145)
  else
    SFSNetwork.SendMessage(MsgDefines.TradingSell, self.curCnt)
  end
end

local function OnClickBuy(self)
  local isNull = true
  table.walk(self.curCnt, function(k, v)
    if 1 <= v then
      isNull = false
    end
  end)
  if isNull then
    UIUtil.ShowTipsId(120145)
  else
    SFSNetwork.SendMessage(MsgDefines.TradingBuy, self.curCnt)
  end
end

UITradeCenterCtrl.CloseSelf = CloseSelf
UITradeCenterCtrl.Close = Close
UITradeCenterCtrl.GetCurResourceChangeByTotal = GetCurResourceChangeByTotal
UITradeCenterCtrl.InitData = InitData
UITradeCenterCtrl.GetResTypeArray = GetResTypeArray
UITradeCenterCtrl.RefreshData = RefreshData
UITradeCenterCtrl.SetCurNumByResType = SetCurNumByResType
UITradeCenterCtrl.GetCurNumByResType = GetCurNumByResType
UITradeCenterCtrl.SetMaxNumByResType = SetMaxNumByResType
UITradeCenterCtrl.GetMaxNumByResType = GetMaxNumByResType
UITradeCenterCtrl.GetTopNum = GetTopNum
UITradeCenterCtrl.GetBottomNum = GetBottomNum
UITradeCenterCtrl.OnClickSell = OnClickSell
UITradeCenterCtrl.OnClickBuy = OnClickBuy
return UITradeCenterCtrl
