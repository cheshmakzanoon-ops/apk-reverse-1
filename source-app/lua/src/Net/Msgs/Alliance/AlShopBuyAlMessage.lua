local AlShopBuyAlMessage = BaseClass("AlShopBuyAlMessage", SFSBaseMessage)
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
    SFSNetwork.SendMessage(MsgDefines.AlShopShow)
    UIUtil.ShowTipsId(120120)
  end
end

AlShopBuyAlMessage.OnCreate = OnCreate
AlShopBuyAlMessage.HandleMessage = HandleMessage
return AlShopBuyAlMessage
