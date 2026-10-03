local GetAllianceAlertMarchMessage = BaseClass("GetAllianceAlertMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uid, type, content, clicktype)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutInt("content", content)
  self.sfsObj:PutInt("clicktype", clicktype)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif next(t.marches) then
    if t.clicktype == 1 then
      UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      local worldPos = SceneUtils.TileIndexToWorld(t.targetPoint)
      worldPos.x = worldPos.x
      worldPos.z = worldPos.z
      local pos = SceneUtils.WorldToTileIndex(worldPos)
    elseif t.clicktype == 2 then
      DataCenter.AllianceAlertDataManager:UpdateMarchList(t)
    end
  end
end

GetAllianceAlertMarchMessage.OnCreate = OnCreate
GetAllianceAlertMarchMessage.HandleMessage = HandleMessage
return GetAllianceAlertMarchMessage
