local FetchSeasonMummySoldierMessage = BaseClass("FetchSeasonMummySoldierMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonMummySoldierMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonMummySoldierMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.leftCanRecArmy then
    DataCenter.SeasonMummyDataManager:UpdateRecArmy(t.leftCanRecArmy)
  end
  if t.soldier and table.count(t.soldier) > 0 then
    EventManager:GetInstance():Broadcast(EventId.FetchSeasonMummySoldierResult, t.soldier)
    UIUtil.ShowTipsId("320320")
    local seasonType = SeasonUtil.GetSeasonType()
    if not SeasonUtil.SeasonHasMummyYardBuild(seasonType) then
      return
    end
    if seasonType == SeasonMapType.Darkness then
      local mgr = DataCenter.BuildBubbleManager
      if mgr.lastClickBuildBubbleTipType == BuildBubbleType.BuildMummyYard and mgr.lastClickBuildBubbleTipPos then
        local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
        if view and view.View then
          view.View:InitSavePos()
        end
        local startPos = mgr.lastClickBuildBubbleTipPos
        local endPos = view.View:GetSavePos(UIMainSavePosType.Mummy)
        local iconPath = "Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_chuzheng_munaiyi.png"
        local effectCount = 1
        mgr.lastClickBuildBubbleTipPos = nil
        mgr.lastClickBuildBubbleTipType = nil
        for k, v in pairs(t.soldier) do
          effectCount = effectCount + v.num
          if 10 <= effectCount then
            break
          end
        end
        UIUtil.DoFlyCustom(iconPath, nil, math.min(10, effectCount), startPos, endPos)
      end
    end
  end
end

return FetchSeasonMummySoldierMessage
