local LFChampionBattleFightCtrl = BaseClass("LFChampionBattleFightCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LFChampionBattleFight)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function ShowPlayerInfo(self, userUid)
  if string.IsNullOrEmpty(userUid) then
    return ""
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, userUid)
end

local function SetHeadImg(self, userHead, guluFrame, userUid, pic, picvec, isGuluFrame)
  userHead:SetData(userUid, pic, picvec)
  guluFrame:SetActive(isGuluFrame == 1)
  if isGuluFrame == 1 then
    guluFrame:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_playerbg_golloes"))
  end
end

LFChampionBattleFightCtrl.CloseSelf = CloseSelf
LFChampionBattleFightCtrl.Close = Close
LFChampionBattleFightCtrl.SetHeadImg = SetHeadImg
LFChampionBattleFightCtrl.ShowPlayerInfo = ShowPlayerInfo
return LFChampionBattleFightCtrl
