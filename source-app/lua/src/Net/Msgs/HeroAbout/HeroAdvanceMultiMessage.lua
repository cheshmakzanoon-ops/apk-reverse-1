local HeroAdvanceMultiMessage = BaseClass("HeroAdvanceMultiMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, quality, heroes)
  base.OnCreate(self)
  local oneArr = SFSArray.New()
  for k, v in pairs(heroes) do
    local one = SFSObject.New()
    oneArr:AddSFSObject(one)
    one:PutLong("upHeroUuid", k)
    local arr = SFSArray.New()
    for eat, _ in pairs(v) do
      arr:AddLong(eat)
    end
    one:PutSFSArray("costHeroArr", arr)
  end
  self.sfsObj:PutInt("quality", quality)
  self.sfsObj:PutSFSArray("heroUpArr", oneArr)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  HeroAdvanceController:GetInstance():OnHandleHeroOneKeyAdvance(message)
end

HeroAdvanceMultiMessage.OnCreate = OnCreate
HeroAdvanceMultiMessage.HandleMessage = HandleMessage
return HeroAdvanceMultiMessage
