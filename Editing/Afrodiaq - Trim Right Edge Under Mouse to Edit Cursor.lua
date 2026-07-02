local item = reaper.BR_ItemAtMouseCursor()

if not item then return end

local oldStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
local oldLen = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
local oldEnd = oldStart + oldLen

reaper.Undo_BeginBlock()

reaper.Main_OnCommand(41310, 0)

local newStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
local newLen = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
local newEnd = newStart + newLen

local delta = newEnd - oldEnd

if math.abs(delta) > 0.0000001 then

    local retval, numMarkers, numRegions = reaper.CountProjectMarkers(0)

    for i = 0, numMarkers + numRegions - 1 do

        local _, isRegion, pos, rgnEnd, name, idx =
            reaper.EnumProjectMarkers(i)

        if isRegion then
            if oldEnd >= pos and oldEnd <= rgnEnd then
                reaper.SetProjectMarker(
                    idx,
                    true,
                    pos,
                    rgnEnd + delta,
                    name
                )
                break
            end
        end

    end
end

reaper.UpdateArrange()

reaper.Undo_EndBlock(
"Trim right edge + move region end",
-1)
