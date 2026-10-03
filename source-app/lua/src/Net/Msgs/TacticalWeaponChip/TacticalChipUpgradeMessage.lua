local TacticalChipUpgradeMessage = BaseClass("TacticalChipUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, chips, goods)
  base.OnCreate(self)
  local chipArray = SFSArray.New()
  if not table.IsNullOrEmpty(chips) then
    table.walk(chips, function(k, v)
      if v then
        local obj = SFSObject.New()
        obj:PutLong("uuid", v.uuid)
        obj:PutInt("num", v.useCount)
        chipArray:AddSFSObject(obj)
      end
    end)
  end
  self.sfsObj:PutSFSArray("chips", chipArray)
  if not table.IsNullOrEmpty(goods) then
    local goodsArray = SFSArray.New()
    table.walk(goods, function(k, v)
      if v then
        local obj = SFSObject.New()
        obj:PutUtfString("itemUid", tostring(v.uuid))
        obj:PutInt("num", v.useCount)
        goodsArray:AddSFSObject(obj)
      end
    end)
    self.sfsObj:PutSFSArray("consumeItems", goodsArray)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.TacticalChipManager:OnMessageUpgrade(t)
  end
end

TacticalChipUpgradeMessage.OnCreate = OnCreate
TacticalChipUpgradeMessage.HandleMessage = HandleMessage
return TacticalChipUpgradeMessage
