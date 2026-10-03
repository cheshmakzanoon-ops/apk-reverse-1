local base = UIBaseContainer
local FlowerTrainRewardBoxItemComponent = BaseClass("FlowerTrainRewardBoxItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function FlowerTrainRewardBoxItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function FlowerTrainRewardBoxItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function FlowerTrainRewardBoxItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnCoord = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnCoord:SetOnClick(function()
    self:OnBtnCoordClick()
  end)
  self.textCoord = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgTypePoint = self.viewSkin:AddComponent(self, UIImage, 6)
  self.compTypePoint = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.imgTypePoint:LoadSpriteAsync("Assets/Main/Sprites/UI/FlowerTrain_Sprite/FlowerTrainCommon/wxy_25shengdan_huache_lv.png")
end

function FlowerTrainRewardBoxItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.imgIcon = nil
  self.textDesc = nil
  self.btnCoord = nil
  self.textCoord = nil
  self.imgTypePoint = nil
  self.compTypePoint = nil
  self.btnClaim = nil
end

function FlowerTrainRewardBoxItemComponent:DataDefine()
  self.clickParam = nil
end

function FlowerTrainRewardBoxItemComponent:DataDestroy()
end

function FlowerTrainRewardBoxItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function FlowerTrainRewardBoxItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function FlowerTrainRewardBoxItemComponent:OnBtnCoordClick()
  if BattleFieldUtil.InBattleField() then
    UIUtil.ShowTips(Localization:GetString("activity_treasure_error_alert23"))
    return
  end
  if self.serverId and self.boxUid and self.worldId and self.objType then
    local data = {}
    data.objType = self.objType
    data.uuid = self.boxUid
    data.worldId = self.worldId
    data.serverId = self.serverId
    data.action = "Jump"
    data.pointId = toInt(self.pointId)
    GoToUtil.CloseAllWindows()
    GoToUtil.TryJumpToWorld(data, function()
    end)
    return
  end
  if CrossServerUtil:NeedIntercept(500019) then
    return
  end
  self:JumpToLocalServerPos()
end

function FlowerTrainRewardBoxItemComponent:JumpToLocalServerPos()
  if self.boxData then
    local data = {}
    data.action = "Jump"
    data.pointId = self.pointId
    GoToUtil.CloseAllWindows()
    GoToUtil.TryJumpToWorld(data, function()
      GoToUtil.OnClickWorldPoint(self.pointId)
    end)
  end
end

function FlowerTrainRewardBoxItemComponent:SetItem(index, boxData)
  self.boxData = boxData
  local contentParam = string.split(boxData.contentId, "|")
  local configId = contentParam[1]
  self.pointId = toInt(boxData.pointId)
  self.serverId = contentParam[2] and toInt(contentParam[2]) or nil
  self.boxUid = contentParam[3] or nil
  self.objType = CollectRewardType.ICE_SUPPLIES
  self.worldId = LuaEntry.Player:GetCurWorldId()
  local configData = configId and LocalController:instance():getLine(TableName.LWIceSupplies, configId)
  self.textTitle:SetLocalText(configData.name)
  self.textDesc:SetLocalText(configData.desc, LuaEntry.Player.name)
  self.imgIcon:LoadSpriteAsyncWithCallback(configData.icon, function(texture)
    self.imgIcon:SetNativeSize()
  end)
  local location = SceneUtils.IndexToTilePos(self.pointId, ForceChangeScene.World)
  location = string.format("<u>X:%s,Y:%s</u>", location.x, location.y)
  self.textCoord:SetText(location)
end

function FlowerTrainRewardBoxItemComponent:OnBtnClaimClick()
  SFSNetwork.SendMessage(MsgDefines.DetectEventClaimTreasure, self.boxUid)
end

return FlowerTrainRewardBoxItemComponent
