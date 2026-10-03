local base = UIBaseContainer
local LWUIActRecycleLotteryAnimShowComponent_2025christmas = BaseClass("LWUIActRecycleLotteryAnimShowComponent_2025christmas", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas = require("UI.LWUIActRecycle.LotteryAnimShow.Component.LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas")

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRootGift5 = self.viewSkin:AddComponent(self, LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas, 1)
  self.compRootGift4 = self.viewSkin:AddComponent(self, LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas, 2)
  self.compRootGift1 = self.viewSkin:AddComponent(self, LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas, 3)
  self.compRootGift2 = self.viewSkin:AddComponent(self, LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas, 4)
  self.compRootGift3 = self.viewSkin:AddComponent(self, LWUIActRecycleLotteryAnimShowBoxComponent_2025christmas, 5)
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:ComponentDestroy()
  self.viewSkin = nil
  self.compRootGift5 = nil
  self.compRootGift4 = nil
  self.compRootGift1 = nil
  self.compRootGift2 = nil
  self.compRootGift3 = nil
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:DataDefine()
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:DataDestroy()
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:OnAddListener()
  base.OnAddListener(self)
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:ReInit(msgData)
  if msgData == nil or msgData.qualityArr == nil then
    return
  end
  self.compRootGift1:ReInit(msgData.qualityArr[1])
  self.compRootGift2:ReInit(msgData.qualityArr[2])
  self.compRootGift3:ReInit(msgData.qualityArr[3])
  self.compRootGift4:ReInit(msgData.qualityArr[4])
  self.compRootGift5:ReInit(msgData.qualityArr[5])
  local isSingleLottery = not table.IsNullOrEmpty(msgData.qualityArr) and #msgData.qualityArr == 1
  if isSingleLottery then
    DataCenter.LWSoundManager:PlaySound(91129)
  else
    DataCenter.LWSoundManager:PlaySound(91130)
  end
end

function LWUIActRecycleLotteryAnimShowComponent_2025christmas:GetAnimLength()
  return 3.8
end

return LWUIActRecycleLotteryAnimShowComponent_2025christmas
