local base = UIBaseContainer
local LWUIActRecycleReceiveGiftPlayerItemComponent = BaseClass("LWUIActRecycleReceiveGiftPlayerItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")

function LWUIActRecycleReceiveGiftPlayerItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.compExtraPlayer = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.imgExtraPlayerIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.compExtraPlayer = nil
  self.imgExtraPlayerIcon = nil
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:DataDefine()
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:DataDestroy()
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleReceiveGiftPlayerItemComponent:ReInit(data, activityId)
  if data == nil then
    return
  end
  self.compUIPlayerHead:SetActive(data.type == 1)
  self.compExtraPlayer:SetActive(data.type == 2)
  if data.type == 1 then
    self.compUIPlayerHead:SetData(data.playerInfo.uid, data.playerInfo.pic, data.playerInfo.picver)
  end
  if data.type == 2 then
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if activityInfo ~= nil then
      local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
      if mainTemplate ~= nil and not string.IsNullOrEmpty(mainTemplate.res_npcGiver) then
        self.imgExtraPlayerIcon:LoadSpriteAsync(mainTemplate.res_npcGiver)
      end
    end
  end
end

return LWUIActRecycleReceiveGiftPlayerItemComponent
