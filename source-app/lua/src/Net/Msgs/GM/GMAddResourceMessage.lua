local GMAddResourceMessage = BaseClass("GMAddResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, type, num, resourceItemType, resourceItemNum, goodsType, goodsNum)
  base.OnCreate(self)
  if type ~= nil and num ~= nil then
    local resArr = SFSArray.New()
    if type > ResourceType.Max then
      local obj = SFSObject.New()
      obj:PutInt("id", type)
      obj:PutInt("num", num)
      resArr:AddSFSObject(obj)
      self.sfsObj:PutSFSArray("alliance_rss_list", resArr)
    else
      local obj = SFSObject.New()
      obj:PutInt("id", type)
      obj:PutInt("nums", num)
      resArr:AddSFSObject(obj)
      self.sfsObj:PutSFSArray("resource", resArr)
    end
  end
  if resourceItemType ~= nil and resourceItemNum ~= nil then
    local resItemArr = SFSArray.New()
    local obj1 = SFSObject.New()
    obj1:PutInt("id", resourceItemType)
    obj1:PutInt("nums", resourceItemNum)
    resItemArr:AddSFSObject(obj1)
    self.sfsObj:PutSFSArray("resource_item", resItemArr)
  end
  if goodsType ~= nil and goodsNum ~= nil then
    local goodsArr = SFSArray.New()
    local obj2 = SFSObject.New()
    obj2:PutUtfString("id", goodsType)
    obj2:PutInt("nums", goodsNum)
    goodsArr:AddSFSObject(obj2)
    self.sfsObj:PutSFSArray("goods", goodsArr)
  end
end

local function HandleMessage(self, message)
  if message and message.alliance_rss_ret then
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseData == nil then
      return
    end
    local resStone = allianceBaseData.resStone or 0
    local resCoal = allianceBaseData.resCoal or 0
    local resFarmerExp = allianceBaseData.resFarmerExp or 0
    for k, v in pairs(message.alliance_rss_ret) do
      if v ~= nil and v.id ~= nil then
        if v.id == ResourceType.AllianceStone then
          allianceBaseData.resStone = toInt(v.retNum)
        elseif v.id == ResourceType.AllianceCoal then
          allianceBaseData.resCoal = toInt(v.retNum)
        elseif v.id == ResourceType.AllianceFarmerExp then
          allianceBaseData.resFarmerExp = toInt(v.retNum)
        end
      end
    end
    if resStone ~= allianceBaseData.resStone or resCoal ~= allianceBaseData.resCoal or resFarmerExp ~= allianceBaseData.resFarmerExp then
      EventManager:GetInstance():Broadcast(EventId.AllianceResourceUpdate)
    end
  end
  if CommonUtil.IsDebug() and GMUtils.GetBool(GMConst.ShowBagMaster, false) and message.success then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshItems)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshBagItems)
  end
end

GMAddResourceMessage.OnCreate = OnCreate
GMAddResourceMessage.HandleMessage = HandleMessage
return GMAddResourceMessage
