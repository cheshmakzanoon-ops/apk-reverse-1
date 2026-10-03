local base = require("DataCenter.AllianceCityTip.AllianceCityTipBaseClass")
local ActivityCrossKingBattleResult = BaseClass("ActivityCrossKingBattleResult", base)

function ActivityCrossKingBattleResult:__init(gameObject)
  base.__init(self, gameObject)
  self.kingName = self.transform:Find("OtherServerKing/name"):GetComponent(typeof(CS.SuperTextMesh))
  self.kingIcon = self.transform:Find("OtherServerKing/icon"):GetComponent(typeof(CS.UIPlayerHead))
  self.kingFrame = self.transform:Find("OtherServerKing/frame"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.kingBtn = self.transform:Find("OtherServerKing/btn"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.kingBtn.onPointerClick()
    if self.playerUid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
    end
  end
  
  self.kingBtn.previewType = CS.WorldPreviewType.GUI
  self.kingOther = self.transform:Find("OtherServerKing").gameObject
  self.kingOther:SetActive(false)
end

function ActivityCrossKingBattleResult:__delete()
  self.kingBtn.onPointerClick = nil
  self.kingOther:SetActive(false)
  base.__delete(self)
end

function ActivityCrossKingBattleResult:TimerAction()
end

function ActivityCrossKingBattleResult:OnKingOccupyProgressRefresh()
end

function ActivityCrossKingBattleResult:OnPointDateUpdate()
  self:DoRefresh()
end

function ActivityCrossKingBattleResult:OnWorldAllianceCityDetail()
end

function ActivityCrossKingBattleResult:DoRefresh()
  local curPresident = DataCenter.GovernmentManager:GetDummyPresident(self.serverId)
  self.playerUid = nil
  if curPresident == nil or not self.isKingCity then
    self.kingOther:SetActive(false)
    return
  end
  local name = curPresident.name
  if string.IsNullOrEmpty(curPresident.allianceAbbr) then
    name = string.format("#%s %s", curPresident.serverId, curPresident.name)
  else
    name = string.format("#%s [%s]%s", curPresident.serverId, curPresident.allianceAbbr, curPresident.name)
  end
  self.kingName.text = name
  self.playerUid = curPresident.uid
  local textWidth = self.kingName:GetWidth()
  self.kingName.transform:Set_localPosition(-textWidth * 0.5, 0.555, 0)
  self.kingName.color32 = Color32.New(207, 42, 42, 255)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(curPresident.headSkinId, curPresident.headSkinET)
  if headBgImg then
    self.kingFrame:LoadSprite(headBgImg)
  end
  self.kingIcon:SetData(curPresident.uid, curPresident.pic, toInt(curPresident.picVer or 0), false)
  self.kingOther:SetActive(self.isKingCity and self.lodCache < 3 and self.playerUid)
end

function ActivityCrossKingBattleResult:SetLod(lod)
  base.SetLod(self, lod)
end

function ActivityCrossKingBattleResult:CheckLod(lod)
  base.CheckLod(self, lod)
  self.kingOther:SetActive(self.isKingCity and self.lodCache < 3 and self.playerUid)
end

function ActivityCrossKingBattleResult:ReInit(data)
  base.ReInit(self, data)
  self:DoRefresh()
end

return ActivityCrossKingBattleResult
