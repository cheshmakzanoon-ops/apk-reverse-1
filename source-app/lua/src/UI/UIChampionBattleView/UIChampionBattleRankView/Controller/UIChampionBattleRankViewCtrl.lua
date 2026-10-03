local UIChampionBattleRankViewCtrl = BaseClass("UIChampionBattleRankViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionBattleRankView)
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

local function GetPanelData(self, message)
end

local function ShowPlayerInfo(self, userUid)
  if string.IsNullOrEmpty(userUid) then
    return ""
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, userUid)
end

UIChampionBattleRankViewCtrl.CloseSelf = CloseSelf
UIChampionBattleRankViewCtrl.Close = Close
UIChampionBattleRankViewCtrl.SetHeadImg = SetHeadImg
UIChampionBattleRankViewCtrl.ShowPlayerInfo = ShowPlayerInfo
UIChampionBattleRankViewCtrl.GetPanelData = GetPanelData
UIChampionBattleRankViewCtrl.ShowPlayerInfo = ShowPlayerInfo
return UIChampionBattleRankViewCtrl
