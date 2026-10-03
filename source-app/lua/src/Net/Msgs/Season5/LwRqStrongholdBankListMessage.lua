local LwRqStrongholdBankListMessage = BaseClass("LwRqStrongholdBankListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local BankItemData = require("DataCenter.SeasonManager.Bank.Data.BankItemData")

function LwRqStrongholdBankListMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function LwRqStrongholdBankListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if not t or not t.list then
    return
  end
  local depositBanksDic = {}
  if t.depositBanks then
    for _, v in ipairs(t.depositBanks) do
      depositBanksDic[v] = true
    end
  end
  if t.serverId == LuaEntry.Player:GetCurServerId() then
    local curServerBankData = DataCenter.SeasonBankManager.curServerBankData
    local dic = table.listToDic(t.list, "id")
    for k in pairs(curServerBankData) do
      if not dic[k] then
        curServerBankData[k] = nil
      end
    end
    for j, jV in ipairs(t.list) do
      local data = curServerBankData[jV.id]
      if not data then
        data = BankItemData.New()
        curServerBankData[jV.id] = data
      end
      data:ParseData(jV, t.serverId)
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateAllServerBankInfoWithServer, {
      serverId = t.serverId,
      list = curServerBankData,
      depositBanksDic = depositBanksDic
    })
    return
  end
  local list = {}
  for j, jV in ipairs(t.list) do
    local data = BankItemData.New()
    data:ParseData(jV, t.serverId)
    list[jV.id] = data
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateAllServerBankInfoWithServer, {
    serverId = t.serverId,
    list = list,
    depositBanksDic = depositBanksDic
  })
end

function LwRqStrongholdBankListMessage:GetTestData(serverId)
  local t = {}
  t.serverId = serverId or LuaEntry.Player:GetCurServerId()
  t.depositBanks = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10
  }
  t.list = {}
  local max = math.random(0, 20)
  for i = 1, max do
    t.list[i] = {
      id = math.random(1, 20),
      allianceId = tostring(math.random(1, 100) < 30 and LuaEntry.Player.allianceId or math.random(100000, 9999999999)),
      curDepositNum = math.random(0, 100),
      serviceScope = math.random(0, 2),
      curAsset = math.random(1000, 1000000),
      isConnect = 4 > math.random(1, 10),
      protectEndTime = UITimeManager:GetInstance():GetServerTime() + math.random(0, 3600000) - 1000000
    }
  end
  return t
end

return LwRqStrongholdBankListMessage
