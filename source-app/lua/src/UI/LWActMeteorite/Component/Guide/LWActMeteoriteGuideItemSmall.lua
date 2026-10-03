local LWActMeteoriteGuideItemSmall = BaseClass("LWActMeteoriteGuideItemSmall", UIBaseContainer)
local base = UIBaseContainer
local PART_H = 15

function LWActMeteoriteGuideItemSmall:OnCreate()
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, "Img")
  self.right = self:AddComponent(UIBaseContainer, "Right")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "Right/Title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "Right/Desc")
end

function LWActMeteoriteGuideItemSmall:OnDestroy()
  self.img = nil
  self.right = nil
  self.title = nil
  self.desc = nil
  base.OnDestroy(self)
end

function LWActMeteoriteGuideItemSmall:SetData(data)
  self.title:SetLocalText(data.tittle)
  if not string.IsNullOrEmpty(data.pic) then
    self.img:LoadSpriteAuto(data.pic)
  end
  local desc = data.desc
  if data.page == 2 then
    local order = data.order
    if desc == "yuntieBattle_entity_desc_1001" or desc == "yuntieBattle_entity_desc_1002" or desc == "yuntieBattle_entity_desc_1003" then
      local configLineData = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(98 + order)
      local extra1 = configLineData ~= nil and configLineData:getIntValue("point_produce_per_second") or 0
      local extra2 = configLineData ~= nil and configLineData:getIntValue("point_last") or 0
      local extra3
      if desc ~= "yuntieBattle_entity_desc_1001" then
        extra3 = configLineData ~= nil and configLineData:getIntValue("point_produce_per_second_on_base") or 0
      end
      self.desc:SetLocalText(desc, extra1, extra2, extra3)
    else
      local extra = LuaEntry.DataConfig:TryGetNum("yunshi_para", "k11", 0)
      self.desc:SetLocalText(desc, extra)
    end
  elseif desc == "yuntieBattle_tips_1020" then
    local extrL = ""
    local extrS = ""
    local actMgr = DataCenter.ActMeteoriteBattleManager
    local timeMgr = UITimeManager:GetInstance()
    local stages = actMgr:GetStages()
    local tmpIdx = 0
    for i, v in ipairs(stages) do
      if v.stage == MeteoriteState.GRAB then
        local sTime, eTime = actMgr:GetStageTime(i)
        extrL = extrL .. (tmpIdx == 0 and "" or "\n") .. timeMgr:TimeStampToTimeForLocalMinute(sTime * 1000) .. "~" .. timeMgr:TimeStampToTimeForLocalMinute(eTime * 1000)
        extrS = extrS .. (tmpIdx == 0 and "" or "\n") .. timeMgr:TimeStampToTimeForServerMinute(sTime * 1000) .. "~" .. timeMgr:TimeStampToTimeForServerMinute(eTime * 1000)
        tmpIdx = tmpIdx + 1
      end
    end
    self.desc:SetLocalText(desc, extrL, extrS)
  else
    self.desc:SetLocalText(desc)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.right.transform)
  local imgSize = self.img:GetSizeDelta()
  local rightSize = self.right:GetSizeDelta()
  local mySize = self:GetSizeDelta()
  if rightSize.y > imgSize.y then
    mySize.y = rightSize.y + PART_H * 2
    self:SetSizeDelta(mySize)
  else
    mySize.y = imgSize.y + PART_H * 2
    self:SetSizeDelta(mySize)
  end
end

return LWActMeteoriteGuideItemSmall
