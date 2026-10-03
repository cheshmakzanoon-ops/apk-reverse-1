local AlShopBuyUsrMessage = BaseClass("AlShopBuyUsrMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, goodsId, num)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("goodsId", goodsId)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.point ~= nil then
      local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if data ~= nil then
        data.accPoint = t.point
      end
      DataCenter.AllianceShopDataManager:SetAccPoint(t.point)
    end
    if t.goods ~= nil then
      local tempMsg = {}
      tempMsg.reward = {}
      local tempReward = {
        type = RewardType.GOODS,
        value = {
          itemId = t.goods.itemId,
          count = t.goods.count
        }
      }
      table.insert(tempMsg.reward, tempReward)
      DataCenter.RewardManager:ShowCommonReward(tempMsg)
      DataCenter.ItemData:UpdateOneItem(t.goods)
    end
    SFSNetwork.SendMessage(MsgDefines.AlShopShow)
    UIUtil.ShowTipsId(120120)
  end
end

AlShopBuyUsrMessage.OnCreate = OnCreate
AlShopBuyUsrMessage.HandleMessage = HandleMessage
return AlShopBuyUsrMessage
