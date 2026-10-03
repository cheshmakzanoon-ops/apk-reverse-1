local PushItemUseMessage = BaseClass("PushItemUseMessage", SFSBaseMessage)
local base = SFSBaseMessage
local _useBtnPos

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uuid", param.uuid)
  self.sfsObj:PutInt("num", param.num)
  if param.para1 ~= nil and param.para1 ~= "" then
    self.sfsObj:PutUtfString("para1", param.para1)
  end
  if param.heroId ~= nil and param.heroId ~= "" then
    self.sfsObj:PutInt("heroId", param.heroId)
  end
  if param.prtUid ~= nil and param.prtUid ~= "" then
    self.sfsObj:PutUtfString("prtUid", param.prtUid)
  end
  if param.commentText ~= nil and param.commentText ~= "" then
    self.sfsObj:PutUtfString("commentText", param.commentText)
  end
  if param.style ~= nil and param.style ~= 0 then
    self.sfsObj:PutInt("style", param.style)
  end
  if param.pointId ~= nil and 0 < param.pointId then
    self.sfsObj:PutInt("pointId", param.pointId)
  end
  if param.useItemFromType ~= nil and 0 < param.useItemFromType then
    self.sfsObj:PutInt("useItemFromType", param.useItemFromType)
  end
  if param.useBtnPos ~= nil then
    _useBtnPos = param.useBtnPos
  else
    _useBtnPos = nil
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.ItemManager:ItemUseHandle(t)
  if t.errorCode == nil then
    if t.itemEffectObj ~= nil and t.itemEffectObj.accPoint then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.itemEffectObj.accPoint, _useBtnPos)
    end
    local itemId = t.itemId
    local item = DataCenter.ItemData:GetItemById(itemId)
    if item ~= nil then
      EventManager:GetInstance():Broadcast(EventId.CLICK_RESOURCE_ITEM)
    else
      EventManager:GetInstance():Broadcast(EventId.REFRESH_RESOURCE_BAG)
    end
  end
end

PushItemUseMessage.OnCreate = OnCreate
PushItemUseMessage.HandleMessage = HandleMessage
return PushItemUseMessage
