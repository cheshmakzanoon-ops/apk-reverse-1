local HospitalCureMessage = BaseClass("HospitalCureMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    if param.arr ~= nil then
      local oneArr = SFSArray.New()
      for k, v in pairs(param.arr) do
        local one = SFSObject.New()
        one:PutUtfString("armyId", tostring(k))
        one:PutInt("healNum", v)
        oneArr:AddSFSObject(one)
      end
      self.sfsObj:PutSFSArray("armyArray", oneArr)
    end
    self.sfsObj:PutInt("gold", param.gold)
  end
  if param.itemIds then
    local itemIdStr = ""
    for i = 1, #param.itemIds do
      if string.IsNullOrEmpty(itemIdStr) then
        itemIdStr = param.itemIds[i].item.itemId .. ";" .. param.itemIds[i].item.count
      else
        itemIdStr = itemIdStr .. "|" .. param.itemIds[i].item.itemId .. ";" .. param.itemIds[i].item.count
      end
    end
    self.sfsObj:PutUtfString("itemId", itemIdStr)
  end
  if param.goldForTime then
    self.sfsObj:PutInt("goldForTime", param.goldForTime)
  end
  if param.goldForResource then
    self.sfsObj:PutInt("goldForResource", param.goldForResource)
  end
  self.sfsObj:PutInt("worldType", LuaEntry.Player:GetCurWorldType())
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  end
  EventManager:GetInstance():Broadcast(EventId.UnLockHospitalCureMsg)
  DataCenter.HospitalManager:HospitalCureHandle(t)
end

HospitalCureMessage.OnCreate = OnCreate
HospitalCureMessage.HandleMessage = HandleMessage
return HospitalCureMessage
