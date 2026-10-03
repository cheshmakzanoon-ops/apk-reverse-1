local UIStorageShopCtrl = BaseClass("UIStorageShopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIStorageShop)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function GetMaxSlotNum(self)
  local unlockConf = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k1")
  if unlockConf and unlockConf ~= "" then
    local tempTb = string.split(unlockConf, "|")
    return #tempTb
  end
  return 0
end

local function SendAddBoxMessage(self, type, needGoldNum)
  if type == ResourceType.Gold then
    local gold = LuaEntry.Player.gold
    if needGoldNum ~= nil and needGoldNum <= gold then
      return true
    else
      UIUtil.ShowTipsId("E100001")
      return false
    end
  else
    local num = LuaEntry.Resource:GetCntByResType(type)
    if needGoldNum ~= nil and needGoldNum <= num then
      return true
    else
      local lackTab = {}
      local param = {}
      param.type = ResLackType.Res
      param.resType = type
      param.targetNum = needGoldNum
      table.insert(lackTab, param)
      GoToResLack.GoToItemResLackList(lackTab)
      return false
    end
  end
end

local function OnShareClick(self, pointId, itemsTb)
  local shareParam = {}
  shareParam.post = PostType.Text_StorageShopShare
  shareParam.sid = LuaEntry.Player:GetSelfServerId()
  shareParam.tradePoint = pointId
  shareParam.tradeName = LuaEntry.Player.name
  shareParam.itemIds = {}
  for i, v in ipairs(itemsTb) do
    if not table.hasvalue(shareParam.itemIds, v) then
      table.insert(shareParam.itemIds, v)
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

UIStorageShopCtrl.CloseSelf = CloseSelf
UIStorageShopCtrl.Close = Close
UIStorageShopCtrl.GetMaxSlotNum = GetMaxSlotNum
UIStorageShopCtrl.OnShareClick = OnShareClick
UIStorageShopCtrl.SendAddBoxMessage = SendAddBoxMessage
return UIStorageShopCtrl
